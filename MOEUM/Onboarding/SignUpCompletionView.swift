import SwiftUI

struct SignUpCompletionView: View {
    let role: UserRole
    let onComplete: () -> Void

    var body: some View {
        VStack {
            Spacer()

            Text("회원가입이\n완료되었어요!")
                .font(MOEUMTypography.h2Bold)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.moeumGray900)

            Spacer()

            Button(action: onComplete) {
                Text("완료")
                    .font(MOEUMTypography.buttonBold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(role == .student ? Color.moeumMain500 : Color.moeumCharacterDarkYellow)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 18)
        .background(Color.white)
    }
}

#Preview {
    SignUpCompletionView(role: .student, onComplete: {})
}
