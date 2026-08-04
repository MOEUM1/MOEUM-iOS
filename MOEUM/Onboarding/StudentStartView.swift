import SwiftUI

struct StudentStartView: View {
    let onBack: () -> Void
    let onContinue: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            OnboardingHeader(
                title: "학생으로 시작해요!\n학교에서의 이야기를 들려주세요.",
                onBack: onBack
            )

            Label("학교생활과 친구 관계에 맞춘 질문을 제공해요.", systemImage: "graduationcap.fill")
                .font(MOEUMTypography.captionMedium)
                .foregroundStyle(Color.moeumGray600)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.moeumMain50)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            Spacer()

            MOEUMButton(title: "학생용 페이지 시작", action: onContinue)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 18)
        .background(Color.white)
    }
}

#Preview {
    StudentStartView(onBack: {}, onContinue: {})
}
