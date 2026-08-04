import SwiftUI

struct CharacterSelectionView: View {
    let onBack: () -> Void
    let onContinue: () -> Void
    @State private var selection: String?

    private let characters = ["시우", "우린", "대훈", "유하"]

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            OnboardingHeader(title: "사용자님과 함께\n성장할 시우를 골라주세요!", onBack: onBack)

            LazyVGrid(columns: [.init(), .init()], spacing: 24) {
                ForEach(characters, id: \.self) { character in
                    Button {
                        selection = character
                    } label: {
                        VStack(spacing: 6) {
                            Image("MoeumMascot")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 94, height: 94)
                                .padding(8)
                                .background(selection == character ? Color.moeumMain50 : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            Text(character)
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

            MOEUMButton(title: "다음", isEnabled: selection != nil, action: onContinue)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 18)
        .background(Color.white)
    }
}

#Preview {
    CharacterSelectionView(onBack: {}, onContinue: {})
}
