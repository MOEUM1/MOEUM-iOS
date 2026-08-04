import SwiftUI

struct WrittenExamView: View {
    let theme: CharacterTheme
    let accessToken: String
    @Environment(\.dismiss) private var dismiss
    @State private var session: GameStartResponse?
    @State private var answers: [Int: String] = [:]
    @State private var page = 0
    @State private var result: QuizResultResponse?
    @State private var isLoading = true
    @State private var error: String?
    @State private var confirmSubmit = false

    var body: some View {
        NavigationStack {
            Group {
                if isLoading { ProgressView("시험지를 만들고 있어요").tint(theme.accentColor) }
                else if let result { resultView(result) }
                else if let session { exam(session) }
                else { retryView }
            }
            .navigationTitle("주관식 시험")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .topBarLeading) { Button("닫기", action: dismiss.callAsFunction) } }
            .task { await start() }
            .confirmationDialog("답안지를 제출할까요?", isPresented: $confirmSubmit) {
                Button("제출", role: .destructive) { Task { await submit() } }
            }
        }
    }

    private func exam(_ session: GameStartResponse) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack { Text(session.subject).font(MOEUMTypography.h2Bold); Spacer(); Text("\(page + 1) / \(session.questions.count)") }
            Divider()
            Text("문제 \(session.questions[page].index)").font(MOEUMTypography.buttonBold).foregroundStyle(theme.accentColor)
            Text(session.questions[page].question).font(MOEUMTypography.bodyMedium).lineSpacing(5)
            Text("답안").font(MOEUMTypography.buttonBold)
            TextEditor(text: answerBinding(for: session.questions[page].index))
                .font(MOEUMTypography.bodyMedium).padding(12).frame(maxHeight: .infinity)
                .background(Color.moeumAppBackground).clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay { RoundedRectangle(cornerRadius: 10).stroke(Color.moeumGray200) }
            HStack {
                Button("이전") { page -= 1 }.disabled(page == 0)
                Spacer()
                if page + 1 == session.questions.count {
                    Button("답안지 제출") { confirmSubmit = true }.buttonStyle(.borderedProminent).tint(theme.accentColor)
                } else { Button("다음") { page += 1 }.buttonStyle(.borderedProminent).tint(theme.accentColor) }
            }
        }.padding(24)
    }

    private var retryView: some View {
        ContentUnavailableView { Label("시험지를 불러오지 못했어요", systemImage: "doc.text.magnifyingglass") }
        description: { Text(error ?? "잠시 후 다시 시도해주세요.") }
        actions: { Button("다시 시도") { Task { await start() } }.buttonStyle(.borderedProminent).tint(theme.accentColor) }
    }

    private func resultView(_ result: QuizResultResponse) -> some View {
        ScrollView { VStack(spacing: 16) {
            Image(theme.assetName).resizable().scaledToFit().frame(width: 150, height: 160)
            Text("채점 완료").font(MOEUMTypography.h1Bold)
            Text("\(result.correctCount) / \(result.totalCount) 정답 · \(result.levelUp.gainedExp) exp 획득")
            ForEach(result.grade, id: \.index) { grade in
                VStack(alignment: .leading, spacing: 6) { Text("\(grade.index)번 \(grade.isCorrect ? "정답" : "오답")").font(MOEUMTypography.buttonBold); Text(grade.explaination) }
                    .padding().frame(maxWidth: .infinity, alignment: .leading).background(Color.moeumAppBackground).clipShape(RoundedRectangle(cornerRadius: 10))
            }
            Button("확인", action: dismiss.callAsFunction).buttonStyle(.borderedProminent).tint(theme.accentColor)
        }.padding(24) }
    }

    private func answerBinding(for index: Int) -> Binding<String> { Binding(get: { answers[index, default: ""] }, set: { answers[index] = $0 }) }
    @MainActor private func start() async { isLoading = true; error = nil; do { session = try await APIClient.shared.startQuizGame(accessToken: accessToken) } catch { self.error = error.localizedDescription }; isLoading = false }
    @MainActor private func submit() async {
        guard let session else { return }; isLoading = true
        let input = session.questions.map { QuizAnswer(index: $0.index, answer: answers[$0.index, default: ""]) }
        do { result = try await APIClient.shared.submitQuizGame(historyId: session.historyId, answers: input, accessToken: accessToken) }
        catch { self.error = error.localizedDescription; self.session = nil }; isLoading = false
    }
}
