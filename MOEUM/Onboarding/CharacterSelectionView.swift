import SwiftUI

struct CharacterSelectionView: View {
    let onBack: () -> Void
    let onContinue: (String) -> Void
    @State private var selection: CharacterOption?

    private let characters = [
        CharacterOption(name: "대훈", assetName: "MoeumMascot"),
        CharacterOption(name: "우린", assetName: "MoeumCharacterRed"),
        CharacterOption(name: "시우", assetName: "MoeumCharacterBlue"),
        CharacterOption(name: "유하", assetName: "MoeumCharacterPink"),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 14) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.moeumGray900)
                }
                PageDots(selection: 4, count: 6)
            }

            Text("사용자님과 함께\n성장할 시우를 골라주세요!")
                .font(MOEUMTypography.h2Bold)
                .foregroundStyle(Color.moeumGray900)

            LazyVGrid(columns: [.init(), .init()], spacing: 24) {
                ForEach(characters) { character in
                    Button {
                        selection = character
                    } label: {
                        VStack(spacing: 6) {
                            Image(character.assetName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 94, height: 94)
                                .padding(8)
                                .background(selection == character ? Color.moeumMain50 : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            Text(character.name)
                                .font(MOEUMTypography.captionBold)
                                .foregroundStyle(Color.moeumGray900)
                        }
                    }
                }
            }
            .padding(.top, 18)

            Spacer()

            HStack(spacing: 4) {
                Spacer()
                Text("이미 계정이 있으신가요?")
                    .foregroundStyle(Color.moeumGray500)
                Text("로그인")
                    .foregroundStyle(Color.moeumMain500)
            }
            .font(MOEUMTypography.buttonSmallMedium)

            MOEUMButton(title: "다음", isEnabled: selection != nil) {
                if let selection {
                    onContinue(selection.name)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 18)
        .background(Color.white)
    }
}

#Preview {
    CharacterSelectionView(onBack: {}, onContinue: { _ in })
}

private struct CharacterOption: Identifiable, Equatable {
    let name: String
    let assetName: String
    var id: String { name }
}
