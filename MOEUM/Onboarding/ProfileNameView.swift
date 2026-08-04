import SwiftUI

struct ProfileNameView: View {
    let onBack: () -> Void
    let onContinue: () -> Void
    @State private var name = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            OnboardingHeader(title: "시작하기 전\n이름을 알려주세요!", onBack: onBack)

            MOEUMTextField(title: "닉네임", placeholder: "닉네임 입력", text: $name)

            Spacer()

            HStack(spacing: 4) {
                Spacer()
                Text("이미 계정이 있으신가요?")
                    .foregroundStyle(Color.moeumGray500)
                Text("로그인")
                    .foregroundStyle(Color.moeumMain500)
            }
            .font(MOEUMTypography.buttonSmallMedium)

            MOEUMButton(title: "다음", isEnabled: !name.trimmingCharacters(in: .whitespaces).isEmpty, action: onContinue)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 18)
        .background(Color.white)
    }
}

#Preview {
    ProfileNameView(onBack: {}, onContinue: {})
}
