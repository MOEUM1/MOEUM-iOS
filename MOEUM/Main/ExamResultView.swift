import SwiftUI

struct ExamResultView: View {
    let result: QuizResultResponse
    let theme: CharacterTheme
    let onRetry: () -> Void
    let onNext: () -> Void
    @State private var celebrate = false

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 26) {
                    ZStack {
                        ForEach(0..<18, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 2)
                                .fill([theme.accentColor, .blue, .yellow, .mint, .orange][index % 5])
                                .frame(width: 8, height: 8)
                                .offset(x: celebrate ? CGFloat((index % 6) * 34 - 85) : 0,
                                        y: celebrate ? CGFloat((index / 6) * 30 - 45) : 0)
                                .rotationEffect(.degrees(Double(index * 23)))
                                .opacity(celebrate ? 1 : 0)
                                .animation(.easeOut(duration: 0.8).delay(Double(index) * 0.02), value: celebrate)
                        }
                        Image(theme.assetName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 190, height: 190)
                            .scaleEffect(celebrate ? 1 : 0.82)
                            .animation(.spring(response: 0.55, dampingFraction: 0.65), value: celebrate)
                    }
                    .frame(height: 220)

                    VStack(spacing: 8) {
                        Text("모든 문제를 다 풀었어요!")
                            .font(.custom("Pretendard-Bold", size: 30))
                        Text("정말 잘했어요! 다음에도 이어나가봐요")
                            .font(.custom("Pretendard-Medium", size: 20))
                            .foregroundStyle(Color.moeumGray700)
                    }

                    scoreCard

                    Button(action: onRetry) {
                        Label("틀린 문제 다시 보기", systemImage: "arrow.counterclockwise")
                            .font(.custom("Pretendard-Medium", size: 22))
                            .foregroundStyle(theme.accentColor)
                            .frame(maxWidth: .infinity)
                            .frame(height: 82)
                            .overlay { RoundedRectangle(cornerRadius: 12).stroke(theme.accentColor, lineWidth: 1.5) }
                    }

                    Button("다음", action: onNext)
                        .font(.custom("Pretendard-Bold", size: 22))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 82)
                        .background(theme.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
        }
        .background(Color.white)
        .onAppear { celebrate = true }
    }

    private var scoreCard: some View {
        VStack(spacing: 22) {
            Text("총 점수").font(.custom("Pretendard-Medium", size: 22)).foregroundStyle(Color.moeumGray700)
            HStack(alignment: .lastTextBaseline, spacing: 10) {
                Text(String(format: "%02d", result.correctCount))
                    .font(.custom("Pretendard-Bold", size: 76)).foregroundStyle(theme.accentColor)
                Text("점").font(.custom("Pretendard-Bold", size: 32))
                Text("/ \(String(format: "%02d", result.totalCount))점")
                    .font(.custom("Pretendard-Medium", size: 28)).foregroundStyle(Color.moeumGray500)
            }
            Divider()
            HStack {
                stat(title: "정답", value: result.correctCount, symbol: "checkmark.circle.fill", color: theme.accentColor)
                Divider().frame(height: 70)
                stat(title: "오답", value: result.wrongCount, symbol: "xmark.circle.fill", color: Color.moeumGray500)
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .shadow(color: .black.opacity(0.08), radius: 14, y: 5)
    }

    private func stat(title: String, value: Int, symbol: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Label(title, systemImage: symbol).font(.custom("Pretendard-Medium", size: 20)).foregroundStyle(color)
            Text("\(value)개").font(.custom("Pretendard-Bold", size: 38))
        }.frame(maxWidth: .infinity)
    }
}
