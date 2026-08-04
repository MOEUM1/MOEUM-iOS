import SwiftUI

struct IntroductionView: View {
    let onFinished: () -> Void
    @State private var page = 0

    private let messages = [
        "여러 이야기를 발견해요",
        "여러 이야기를 나눠요",
        "무슨 사연을 나눌까요",
    ]

    var body: some View {
        VStack {
            MOEUMWordmark()
                .padding(.top, 52)

            Spacer()

            TabView(selection: $page) {
                ForEach(messages.indices, id: \.self) { index in
                    Text(messages[index])
                        .font(MOEUMTypography.captionMedium)
                        .foregroundStyle(Color.moeumGray500)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 80)

            PageDots(selection: page, count: messages.count)
                .padding(.bottom, 18)

            MOEUMButton(title: page == messages.count - 1 ? "시작하기" : "다음") {
                if page < messages.count - 1 {
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
}

#Preview {
    IntroductionView(onFinished: {})
}
