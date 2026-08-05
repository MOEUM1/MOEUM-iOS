import SwiftUI

struct CardGameView: View {
    let theme: CharacterTheme
    let accessToken: String
    @Environment(\.dismiss) private var dismiss
    @State private var session: GameStartResponse?
    @State private var index = 0
    @State private var correct: [Int] = []
    @State private var wrong: [Int] = []
    @State private var result: CardResultResponse?
    @State private var isLoading = true
    @State private var error: String?

    var body: some View {
        NavigationStack {
            Group {
                if isLoading { ProgressView("문제를 만들고 있어요").tint(theme.accentColor) }
        else if let result { ExperienceGainView(levelUp: result.levelUp, theme: theme, onConfirm: dismiss.callAsFunction) }
                else if let session { game(session) }
                else { retryView }
            }
            .padding(24)
            .navigationTitle("플래시 카드")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .topBarLeading) { Button("닫기", action: dismiss.callAsFunction) } }
            .task { await start() }
        }
    }

    private func game(_ session: GameStartResponse) -> some View {
        VStack(spacing: 28) {
            Text(session.subject).font(MOEUMTypography.buttonBold).foregroundStyle(.white)
                .frame(maxWidth: .infinity).frame(height: 48).background(theme.accentColor).clipShape(RoundedRectangle(cornerRadius: 12))
            Text("\(index + 1) / \(session.questions.count)").font(MOEUMTypography.captionMedium).foregroundStyle(Color.moeumGray500)
            Text(session.questions[index].question).font(MOEUMTypography.bodyMedium).multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, maxHeight: .infinity).padding(28).background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12)).shadow(color: .black.opacity(0.15), radius: 18, y: 4)
            HStack(spacing: 56) {
                answerButton("O", symbol: "circle", isCorrect: true)
                answerButton("X", symbol: "xmark", isCorrect: false)
            }
        }
    }

    private func answerButton(_ label: String, symbol: String, isCorrect: Bool) -> some View {
        Button { choose(isCorrect) } label: {
            Image(systemName: symbol).font(.system(size: 52, weight: .medium)).foregroundStyle(theme.accentColor)
                .frame(width: 110, height: 110).background(.white).clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay { RoundedRectangle(cornerRadius: 12).stroke(Color.moeumGray200) }
        }.accessibilityLabel(label)
    }

    private var retryView: some View {
        ContentUnavailableView { Label("문제를 불러오지 못했어요", systemImage: "wifi.exclamationmark") }
        description: { Text(error ?? "잠시 후 다시 시도해주세요.") }
        actions: { Button("다시 시도") { Task { await start() } }.buttonStyle(.borderedProminent).tint(theme.accentColor) }
    }

    private func resultView(_ result: CardResultResponse) -> some View {
        VStack(spacing: 18) {
            Image(theme.assetName).resizable().scaledToFit().frame(width: 170, height: 180)
            Text("학습 완료!").font(MOEUMTypography.h1Bold)
            Text("\(result.correctCount)개 학습 · \(result.levelUp.gainedExp) exp 획득")
            Button("확인", action: dismiss.callAsFunction).buttonStyle(.borderedProminent).tint(theme.accentColor)
        }
    }

    private func choose(_ isCorrect: Bool) {
        guard let session else { return }
        let questionIndex = session.questions[index].index
        if isCorrect { correct.append(questionIndex) } else { wrong.append(questionIndex) }
        if index + 1 < session.questions.count { withAnimation { index += 1 } }
        else { Task { await submit() } }
    }

    @MainActor private func start() async {
        isLoading = true; error = nil
        do { session = try await APIClient.shared.startCardGame(accessToken: accessToken) }
        catch { self.error = error.localizedDescription }
        isLoading = false
    }

    @MainActor private func submit() async {
        guard let session else { return }; isLoading = true
        do { result = try await APIClient.shared.submitCardGame(historyId: session.historyId, correct: correct, wrong: wrong, accessToken: accessToken) }
        catch { self.error = error.localizedDescription; self.session = nil }
        isLoading = false
    }
}
