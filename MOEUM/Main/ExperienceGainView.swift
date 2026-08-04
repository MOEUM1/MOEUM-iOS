import SwiftUI

struct ExperienceGainView: View {
    let levelUp: LevelUpResult
    let theme: CharacterTheme
    let onConfirm: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: onConfirm) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundStyle(Color.moeumGray900)
                }
                .accessibilityLabel("뒤로")
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)

            Spacer()

            Circle()
                .fill(theme.accentColor.opacity(0.82))
                .overlay {
                    Circle()
                        .stroke(theme.accentColor.opacity(0.28), lineWidth: 6)
                }
                .overlay {
                    Text("XP")
                        .font(.system(size: 64, weight: .medium))
                        .foregroundStyle(.white.opacity(0.82))
                }
                .frame(width: 184, height: 184)

            VStack(spacing: 4) {
                Text("경험치 상승!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(theme.accentColor)
                Text("+\(levelUp.gainedExp) exp를 얻었어요!")
                    .font(.system(size: 31, weight: .bold))
                    .foregroundStyle(Color.moeumGray900)
            }
            .multilineTextAlignment(.center)
            .padding(.top, 118)

            if levelUp.leveledUp {
                Text("Lv. \(levelUp.after.level)로 레벨업했어요")
                    .font(MOEUMTypography.buttonMedium)
                    .foregroundStyle(theme.accentColor)
                    .padding(.top, 14)
            }

            Spacer()

            Button("확인", action: onConfirm)
                .font(MOEUMTypography.buttonBold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .background(theme.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 32)
                .padding(.bottom, 24)
        }
        .background(Color.white.ignoresSafeArea())
    }
}

#Preview {
    ExperienceGainView(
        levelUp: LevelUpResult(
            gainedExp: 50,
            leveledUp: false,
            before: LevelSnapshot(level: 1, exp: 10, totalExp: 10),
            after: LevelSnapshot(level: 1, exp: 60, totalExp: 60),
            expToNextLevel: 40
        ),
        theme: .yellow,
        onConfirm: {}
    )
}
