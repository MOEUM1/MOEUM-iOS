import SwiftUI

struct ProfileNameView: View {
    let onBack: () -> Void
    let onContinue: (String) -> Void
    @State private var name = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            OnboardingHeader(title: "시작하기 전\n이름을 알려주세요!", progress: 1, onBack: onBack)

            MOEUMTextField(title: "닉네임", placeholder: "닉네임 입력", text: $name)

            Spacer()

            ExistingAccountPrompt()

            MOEUMButton(title: "다음", isEnabled: !name.trimmingCharacters(in: .whitespaces).isEmpty) {
                onContinue(name.trimmingCharacters(in: .whitespaces))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 18)
        .background(Color.white)
    }
}

#Preview {
    ProfileNameView(onBack: {}, onContinue: { _ in })
}
