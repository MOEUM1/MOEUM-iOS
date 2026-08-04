import SwiftUI

struct TermsSelectionView: View {
    let onBack: () -> Void
    let onContinue: () -> Void
    @State private var service = false
    @State private var privacy = false

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            OnboardingHeader(title: "사용자님이\n공감한 개인 약관을 선택해보세요.", onBack: onBack)

            Toggle("서비스 이용약관 (필수)", isOn: $service)
                .tint(Color.moeumMain500)
            Divider()
            Toggle("개인정보 처리방침 (필수)", isOn: $privacy)
                .tint(Color.moeumMain500)

            Spacer()

            HStack(spacing: 4) {
                Spacer()
                Text("이미 계정이 있으신가요?")
                    .foregroundStyle(Color.moeumGray500)
                Text("로그인")
                    .foregroundStyle(Color.moeumMain500)
            }
            .font(MOEUMTypography.buttonSmallMedium)

            MOEUMButton(title: "다음", isEnabled: service && privacy, action: onContinue)
        }
        .font(MOEUMTypography.captionMedium)
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 18)
        .background(Color.white)
    }
}

#Preview {
    TermsSelectionView(onBack: {}, onContinue: {})
}
