import SwiftUI

struct CharacterConfirmationView: View {
    let characterName: String
    let onBack: () -> Void
    let onConfirm: () -> Void

    private var assetName: String {
        switch characterName {
        case "우린": "MoeumCharacterRed"
        case "시우": "MoeumCharacterBlue"
        case "유하": "MoeumCharacterPink"
        default: "MoeumMascot"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 14) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.moeumGray900)
                }
                PageDots(selection: 5, count: 6)
            }

            Text("\(characterName)이와 함께 하시겠어요?")
                .font(MOEUMTypography.h2Bold)
                .foregroundStyle(Color.moeumGray900)

            Spacer()

            VStack(spacing: 12) {
                Image(assetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 190, height: 205)

                Text("아호 \(characterName)")
                    .font(MOEUMTypography.captionBold)
                    .foregroundStyle(Color.moeumGray900)
            }
            .frame(maxWidth: .infinity)

            Spacer()

            HStack(spacing: 4) {
                Spacer()
                Text("만약 계정이 있으신가요?")
                    .foregroundStyle(Color.moeumGray400)
                Text("로그인")
                    .foregroundStyle(Color.moeumMain500)
                    .underline()
            }
            .font(MOEUMTypography.buttonSmallMedium)

            MOEUMButton(title: "다음", action: onConfirm)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 18)
        .background(Color.white)
    }
}

#Preview {
    CharacterConfirmationView(characterName: "대훈", onBack: {}, onConfirm: {})
}
