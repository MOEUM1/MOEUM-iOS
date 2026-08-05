import SwiftUI

struct WelcomeView: View {
    let onSignUp: () -> Void
    var onSignedIn: (AuthResponse) -> Void = { _ in }
    @State private var email = ""
    @State private var password = ""
    @State private var isSigningIn = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("환영해요!\n오늘부터 함께 성장해볼까요?")
                // Keep the Figma scale fixed; relative Dynamic Type scaling made this
                // headline render substantially larger in the simulator.
                .font(.custom("Pretendard-Bold", size: 24))
                .foregroundStyle(Color.moeumGray900)

            MOEUMTextField(title: "이메일", placeholder: "이메일 입력", text: $email)
                .keyboardType(.emailAddress)
            MOEUMTextField(title: "비밀번호", placeholder: "비밀번호 입력", text: $password, isSecure: true)

            Spacer()

            if let errorMessage {
                Text(errorMessage)
                    .font(MOEUMTypography.buttonSmallMedium)
                    .foregroundStyle(Color.moeumCharacterLightRed)
                    .frame(maxWidth: .infinity, alignment: .center)
            }

            HStack(spacing: 4) {
                Spacer()
                Text("만약 계정이 없으신가요?")
                    .foregroundStyle(Color.moeumGray500)
                Button("회원가입", action: onSignUp)
                    .foregroundStyle(Color.moeumMain500)
                Spacer()
            }
            .font(MOEUMTypography.buttonMedium)
            .frame(maxWidth: .infinity)

            MOEUMButton(
                title: isSigningIn ? "로그인 중..." : "로그인",
                isEnabled: !email.isEmpty && !password.isEmpty && !isSigningIn
            ) {
                Task { await signIn() }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 34)
        .padding(.bottom, 18)
        .background(Color.white)
    }

    @MainActor
    private func signIn() async {
        isSigningIn = true
        errorMessage = nil
        defer { isSigningIn = false }

        do {
            let response = try await APIClient.shared.signIn(
                SignInRequest(email: email, password: password)
            )
            onSignedIn(response)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    WelcomeView(onSignUp: {})
}
