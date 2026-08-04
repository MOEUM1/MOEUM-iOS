import SwiftUI

struct SignUpCompletionView: View {
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 138)

            Image("MoeumMascot")
                .resizable()
                .scaledToFit()
                .frame(width: 298, height: 321)

            Text("회원가입이\n완료되었어요!")
                .font(.custom("Pretendard-Bold", size: 28, relativeTo: .title))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.moeumGray900)
                .padding(.top, 16)

            Spacer()

            MOEUMButton(
                title: "완료",
                enabledColor: Color.moeumCharacterDarkYellow,
                action: onComplete
            )
            .padding(.bottom, 18)
            }
        .padding(.horizontal, 24)
        .background(Color.white)
    }
}

#Preview {
    SignUpCompletionView(onComplete: {})
}
