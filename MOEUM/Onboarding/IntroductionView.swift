import SwiftUI

struct IntroductionView: View {
    let onFinished: () -> Void
    @State private var page = 0

    var body: some View {
        VStack {
            MOEUMWordmark(size: 64)
                .padding(.top, 85)

            Spacer()

            TabView(selection: $page) {
                ForEach(0..<3, id: \.self) { index in
                    introductionMessage(index)
                        .font(MOEUMTypography.buttonMedium)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 80)

            PageDots(selection: page, count: messages.count)
                .padding(.bottom, 18)

            MOEUMButton(title: page == 2 ? "시작하기" : "다음") {
                if page < 2 {
                    withAnimation { page += 1 }
                } else {
                    onFinished()
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 18)
        .background(Color.white)
    }

    @ViewBuilder
    private func introductionMessage(_ index: Int) -> some View {
        switch index {
        case 0:
            (Text("당신의 ").foregroundStyle(Color.moeumGray400)
             + Text("AI").foregroundStyle(Color.moeumMain500)
             + Text("를 선택해 ").foregroundStyle(Color.moeumGray400)
             + Text("함께").foregroundStyle(Color.moeumMain500)
             + Text(" 성장해보세요.").foregroundStyle(Color.moeumGray400))
        case 1:
            (Text("질의응답 형태로\n").foregroundStyle(Color.moeumGray400)
             + Text("당신의 지식").foregroundStyle(Color.moeumMain500)
             + Text("을 습득해 성장할 거예요.").foregroundStyle(Color.moeumGray400))
        default:
            (Text("플래시 카드, 주관식 문제 등\n").foregroundStyle(Color.moeumGray400)
             + Text("다양한 형태").foregroundStyle(Color.moeumMain500)
             + Text("로 학습할 수 있어요.").foregroundStyle(Color.moeumGray400))
        }
    }
}

#Preview {
    IntroductionView(onFinished: {})
}
