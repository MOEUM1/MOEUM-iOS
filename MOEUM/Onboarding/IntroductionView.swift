import SwiftUI

struct IntroductionView: View {
    let onFinished: () -> Void
    @State private var page = 0

    private let messages = [
        "어떤 이야기를 넣을까",
        "어떤 이야기를 넣지",
        "무슨 얘기를 넣을까",
    ]

    var body: some View {
        VStack {
            MOEUMWordmark(size: 64)
                .padding(.top, 85)

            Spacer()

            TabView(selection: $page) {
                ForEach(messages.indices, id: \.self) { index in
                    Text(messages[index])
                        .font(MOEUMTypography.buttonMedium)
                        .fontWeight(index == messages.count - 1 ? .bold : .medium)
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
