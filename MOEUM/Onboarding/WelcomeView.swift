import SwiftUI

struct WelcomeView: View {
    let onSignUp: () -> Void
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("환영해요!\n오늘 어떤 감정과 생각했나요?")
                .font(MOEUMTypography.h2Bold)
                .foregroundStyle(Color.moeumGray900)

            MOEUMTextField(title: "이메일", placeholder: "이메일 입력", text: $email)
                .keyboardType(.emailAddress)
            MOEUMTextField(title: "비밀번호", placeholder: "비밀번호 입력", text: $password, isSecure: true)

            Spacer()

            HStack(spacing: 4) {
                Spacer()
                Text("아직 계정이 없으신가요?")
                    .foregroundStyle(Color.moeumGray500)
                Button("회원가입", action: onSignUp)
                    .foregroundStyle(Color.moeumMain500)
            }
            .font(MOEUMTypography.buttonSmallMedium)

            MOEUMButton(title: "로그인", isEnabled: !email.isEmpty && !password.isEmpty) {}
        }
        .padding(.horizontal, 20)
        .padding(.top, 34)
        .padding(.bottom, 18)
        .background(Color.white)
    }
}

#Preview {
    WelcomeView(onSignUp: {})
}
