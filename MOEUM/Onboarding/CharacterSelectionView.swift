import SwiftUI

struct CharacterSelectionView: View {
  let onBack: () -> Void
  let onContinue: (String) -> Void
  @Environment(\.accessibilityReduceMotion) private var reduceMotion
  @State private var selection: CharacterOption?
  @State private var transitioningCharacter: CharacterOption?
  @State private var transitionScale = 0.65

  private let characters = [
    CharacterOption(name: "대훈", assetName: "MoeumMascot"),
    CharacterOption(name: "우린", assetName: "MoeumCharacterRed"),
    CharacterOption(name: "시우", assetName: "MoeumCharacterBlue"),
    CharacterOption(name: "유하", assetName: "MoeumCharacterPink"),
  ]

  var body: some View {
    ZStack {
      VStack(alignment: .leading, spacing: 0) {
        HStack(spacing: 14) {
          Button(action: onBack) {
            Image(systemName: "chevron.left")
              .font(.system(size: 18, weight: .semibold))
              .foregroundStyle(Color.moeumGray900)
          }
          PageDots(selection: 4, count: 6)
        }

        Text("사용자님과 함께\n성장할 AI를 골라주세요!")
          .font(MOEUMTypography.h1Bold)
          .foregroundStyle(Color.moeumGray900)
          .padding(.top, 38)

        LazyVGrid(
          columns: [
            GridItem(.flexible(), spacing: 28),
            GridItem(.flexible()),
          ],
          spacing: 42
        ) {
          ForEach(characters) { character in
            Button {
              selection = character
            } label: {
              ZStack(alignment: .bottom) {
                Image(character.assetName)
                  .resizable()
                  .scaledToFit()
                  .frame(width: 142, height: 154)

                Text(character.name)
                  .font(MOEUMTypography.bodyBold)
                  .foregroundStyle(Color.moeumGray900)
                  .offset(y: 5)
              }
              .frame(height: 158)
            }
            .buttonStyle(.plain)
          }
        }
        .padding(.top, 66)

        Spacer()

        HStack(spacing: 4) {
          Spacer()
          Text("이미 계정이 있으신가요?")
            .foregroundStyle(Color.moeumGray500)
          Text("로그인")
            .foregroundStyle(Color.moeumMain500)
        }
        .font(MOEUMTypography.buttonSmallMedium)

        MOEUMButton(
          title: "다음",
          isEnabled: selection != nil && transitioningCharacter == nil,
          enabledColor: selection?.buttonColor ?? .moeumMain500
        ) {
          beginTransition()
        }
      }
      .padding(.horizontal, 24)
      .padding(.top, 18)
      .padding(.bottom, 10)

      if let transitioningCharacter {
        Color.white
          .ignoresSafeArea()

        Image(transitioningCharacter.assetName)
          .resizable()
          .scaledToFit()
          .frame(width: 170, height: 170)
          .scaleEffect(transitionScale)
      }
    }
    .background(Color.white)
  }

  private func beginTransition() {
    guard let selection else { return }
    guard !reduceMotion else {
      onContinue(selection.name)
      return
    }

    transitioningCharacter = selection
    transitionScale = 0.65

    withAnimation(.easeInOut(duration: 0.58)) {
      transitionScale = 3.6
    }

    Task { @MainActor in
      try? await Task.sleep(for: .milliseconds(540))
      onContinue(selection.name)
      transitioningCharacter = nil
      transitionScale = 0.65
    }
  }
}

#Preview {
  CharacterSelectionView(onBack: {}, onContinue: { _ in })
}

private struct CharacterOption: Identifiable, Equatable {
  let name: String
  let assetName: String
  var id: String { name }

  var buttonColor: Color {
    switch name {
    case "우린": .moeumCharacterLightRed
    case "시우": .moeumCharacterLightBlue
    case "유하": .moeumCharacterLightPink
    default: .moeumCharacterLightYellow
    }
  }
}
