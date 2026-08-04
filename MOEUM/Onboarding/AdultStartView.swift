import SwiftUI

struct AdultStartView: View {
    let onBack: () -> Void
    let onContinue: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            OnboardingHeader(
                title: "성인으로 시작해요!\n일상 속 이야기를 편하게 들려주세요.",
                onBack: onBack
            )

            Label("일과 관계, 생활에 맞춘 질문을 제공해요.", systemImage: "person.2.fill")
                .font(MOEUMTypography.captionMedium)
                .foregroundStyle(Color.moeumGray600)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.moeumCharacterLightPink.opacity(0.35))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Spacer()

            MOEUMButton(title: "성인용 페이지 시작", action: onContinue)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 18)
        .background(Color.white)
    }
}

#Preview {
    AdultStartView(onBack: {}, onContinue: {})
}
