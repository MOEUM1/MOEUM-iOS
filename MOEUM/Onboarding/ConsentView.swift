import SwiftUI

struct ConsentView: View {
    let onContinue: () -> Void
    @State private var serviceAccepted = false
    @State private var privacyAccepted = false

    var body: some View {
        VStack {
            MOEUMWordmark()
                .padding(.top, 52)

            Spacer()

            VStack(spacing: 8) {
                ConsentRow(
                    title: "이용약관 동의",
                    isRequired: false,
                    isSelected: $serviceAccepted
                )
                ConsentRow(
                    title: "개인정보 수집",
                    isRequired: true,
                    isSelected: $privacyAccepted
                )

                Button("나중에 가입할게요") {}
                    .font(MOEUMTypography.buttonSmallMedium)
                    .foregroundStyle(Color.moeumGray400)
                    .padding(.top, 8)
            }

            MOEUMButton(
                title: "시작하기",
                isEnabled: serviceAccepted && privacyAccepted,
                action: onContinue
            )
            .padding(.top, 18)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 18)
        .background(Color.white)
    }
}

private struct ConsentRow: View {
    let title: String
    let isRequired: Bool
    @Binding var isSelected: Bool

    var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(MOEUMTypography.captionBold)
                        .foregroundStyle(Color.moeumGray900)
                    Text(isRequired ? "서비스 이용을 위해 필요해요" : "더 나은 서비스를 제공해요")
                        .font(MOEUMTypography.buttonSmallMedium)
                        .foregroundStyle(Color.moeumGray500)
                }
                Spacer()
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? Color.moeumMain500 : Color.moeumGray300)
            }
            .padding(.horizontal, 14)
            .frame(height: 64)
            .background(Color.moeumGray50)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#Preview {
    ConsentView(onContinue: {})
}
