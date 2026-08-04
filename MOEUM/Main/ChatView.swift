import SwiftUI

struct ChatView: View {
    let theme: CharacterTheme
    let accessToken: String

    @Environment(\.dismiss) private var dismiss
    @State private var historyId: String?
    @State private var messages: [ChatMessage] = []
    @State private var input = ""
    @State private var isLoading = true
    @State private var isSending = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                topicBanner
                messageList
                messageComposer
            }
            .background(Color.white)
            .navigationTitle(theme.rawValue + "이")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                    }
                }
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image(theme.assetName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 38, height: 38)
                        Text(theme.rawValue + "이")
                            .font(MOEUMTypography.buttonMedium)
                    }
                }
            }
            .task { await startChat() }
        }
    }

    private var topicBanner: some View {
        VStack(spacing: 10) {
            Text("당신이 알고 있는 모든 것을 답하세요!")
                .font(MOEUMTypography.buttonSmallMedium)
                .foregroundStyle(.white)
                .padding(.horizontal, 26)
                .frame(height: 38)
                .background(theme.accentColor)
                .clipShape(Capsule())

            HStack(spacing: 10) {
                Rectangle().fill(Color.moeumGray200).frame(height: 1)
                Text(Date.now.formatted(.dateTime.month().day()))
                    .font(MOEUMTypography.buttonSmallMedium)
                    .foregroundStyle(Color.moeumGray200)
                Rectangle().fill(Color.moeumGray200).frame(height: 1)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
    }

    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 14) {
                    if isLoading {
                        ProgressView()
                            .tint(theme.accentColor)
                            .padding(.top, 40)
                    }

                    ForEach(messages) { message in
                        messageBubble(message)
                            .id(message.id)
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .font(MOEUMTypography.buttonSmallMedium)
                            .foregroundStyle(Color.moeumCharacterLightRed)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: messages.count) {
                guard let last = messages.last else { return }
                withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
            }
        }
    }

    private func messageBubble(_ message: ChatMessage) -> some View {
        HStack {
            if message.isMine { Spacer(minLength: 54) }
            FormulaText(source: message.text)
                .font(MOEUMTypography.buttonMedium)
                .foregroundStyle(message.isMine ? Color.white : Color.moeumGray900)
                .padding(.horizontal, 16)
                .padding(.vertical, 9)
                .background(message.isMine ? theme.accentColor : Color.moeumGray50)
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: message.isMine ? 25 : 10,
                        bottomLeadingRadius: message.isMine ? 25 : 0,
                        bottomTrailingRadius: 25,
                        topTrailingRadius: message.isMine ? 10 : 25
                    )
                )
            if !message.isMine { Spacer(minLength: 54) }
        }
        .frame(maxWidth: .infinity)
    }

    private var messageComposer: some View {
        HStack(spacing: 10) {
            TextField("메시지 입력 ...", text: $input, axis: .vertical)
                .font(MOEUMTypography.buttonSmallMedium)
                .lineLimit(1...4)
                .padding(.horizontal, 16)
                .frame(minHeight: 42)
                .background(Color.moeumAppBackground)
                .clipShape(Capsule())

            Button { Task { await sendMessage() } } label: {
                Image(systemName: "arrow.up")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(theme.accentColor)
                    .clipShape(Circle())
            }
            .disabled(input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSending || historyId == nil)
            .opacity(isSending ? 0.5 : 1)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .overlay(alignment: .top) { Divider() }
    }

    @MainActor
    private func startChat() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let response = try await APIClient.shared.startChat(accessToken: accessToken)
            historyId = response.historyId
            messages = [ChatMessage(text: response.question, isMine: false)]
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    private func sendMessage() async {
        guard let historyId else { return }
        let answer = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !answer.isEmpty else { return }

        input = ""
        messages.append(ChatMessage(text: answer, isMine: true))
        isSending = true
        errorMessage = nil
        defer { isSending = false }

        do {
            let response = try await APIClient.shared.answerChat(
                historyId: historyId,
                answer: answer,
                accessToken: accessToken
            )
            messages.append(ChatMessage(text: response.question, isMine: false))
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

private struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isMine: Bool
}

private struct FormulaText: View {
    let source: String

    var body: some View {
        Text(MathMarkup.formatted(source))
    }
}

private enum MathMarkup {
    static func formatted(_ source: String) -> AttributedString {
        var text = source
            .replacingOccurrences(of: "\\(", with: "")
            .replacingOccurrences(of: "\\)", with: "")
            .replacingOccurrences(of: "\\[", with: "")
            .replacingOccurrences(of: "\\]", with: "")
            .replacingOccurrences(of: "\\Omega", with: "Ω")
            .replacingOccurrences(of: "\\times", with: "×")
            .replacingOccurrences(of: "\\cdot", with: "·")
            .replacingOccurrences(of: "\\pm", with: "±")
            .replacingOccurrences(of: "\\leq", with: "≤")
            .replacingOccurrences(of: "\\geq", with: "≥")
            .replacingOccurrences(of: "\\neq", with: "≠")
            .replacingOccurrences(of: "\\rightarrow", with: "→")
            .replacingOccurrences(of: "\\degree", with: "°")

        text = replacingFractions(in: text)
        text = replacingCommand("sqrt", in: text, with: "√")
        text = text.replacingOccurrences(of: "\\text{", with: "")
            .replacingOccurrences(of: "}", with: "")

        // The API uses Markdown emphasis for important parts of a question.
        if let attributed = try? AttributedString(markdown: text) {
            return attributed
        }
        return AttributedString(text)
    }

    private static func replacingFractions(in text: String) -> String {
        var result = text
        let pattern = #"\\frac\{([^{}]+)\}\{([^{}]+)\}"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return result }
        while let match = regex.firstMatch(in: result, range: NSRange(result.startIndex..., in: result)) {
            guard let wholeRange = Range(match.range, in: result),
                  let numeratorRange = Range(match.range(at: 1), in: result),
                  let denominatorRange = Range(match.range(at: 2), in: result) else { break }
            let numerator = String(result[numeratorRange])
            let denominator = String(result[denominatorRange])
            result.replaceSubrange(wholeRange, with: "\(numerator)/\(denominator)")
        }
        return result
    }

    private static func replacingCommand(_ command: String, in text: String, with symbol: String) -> String {
        text.replacingOccurrences(of: "\\\(command){", with: "\(symbol)(")
            .replacingOccurrences(of: "}", with: ")")
    }
}

#Preview {
    ChatView(theme: .pink, accessToken: "preview")
}
