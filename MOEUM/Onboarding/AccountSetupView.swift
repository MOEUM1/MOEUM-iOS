import SwiftUI

struct AccountSetupView: View {
    let onBack: () -> Void
    let onContinue: () -> Void
    @State private var email = ""
    @State private var password = ""
    @State private var passwordConfirmation = ""

    private var isValid: Bool {
        email.contains("@") && password.count >= 8 && password == passwordConfirmation
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            OnboardingHeader(title: "지금 가입하고,\n시우와 함께 성장해보세요.", progress: 0, onBack: onBack)

            MOEUMTextField(title: "이메일", placeholder: "이메일 입력", text: $email)
                .keyboardType(.emailAddress)
            MOEUMTextField(title: "비밀번호", placeholder: "8자 이상 입력", text: $password, isSecure: true)
            MOEUMTextField(
                title: "비밀번호 확인",
                placeholder: "비밀번호 다시 입력",
                text: $passwordConfirmation,
                isSecure: true
            )

            Spacer()

            MOEUMButton(title: "다음", isEnabled: isValid, action: onContinue)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 18)
        .background(Color.white)
    }
}

#Preview {
    AccountSetupView(onBack: {}, onContinue: {})
}
