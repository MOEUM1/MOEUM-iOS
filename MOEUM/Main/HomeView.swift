import SwiftUI

struct HomeView: View {
    let theme: CharacterTheme
    let accessToken: String
    @State private var selectedMode: LearningMode = .teaching
    @State private var isChatPresented = false
    private let weekdays = ["월", "화", "수", "목", "금", "토", "일"]

    var body: some View {
        ScrollView {
            VStack(spacing: 36) {
                streakCard
                learningCard
                levelCard
            }
            .padding(.horizontal, 20)
            .padding(.top, 11)
            .padding(.bottom, 36)
        }
        .scrollIndicators(.hidden)
        .background(Color.moeumAppBackground)
        .fullScreenCover(isPresented: $isChatPresented) {
            ChatView(theme: theme, accessToken: accessToken)
        }
    }

    private var streakCard: some View {
        HStack(spacing: 8) {
            Image("LearningFire")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)

            VStack(alignment: .leading, spacing: 9) {
                (Text("연속 학습 ") + Text("2").foregroundColor(theme.accentColor) + Text("일"))
                    .font(MOEUMTypography.buttonSmallMedium)

                HStack(spacing: 12) {
                    ForEach(Array(weekdays.enumerated()), id: \.offset) { index, day in
                        Text(day)
                            .font(MOEUMTypography.buttonSmallMedium)
                            .foregroundStyle(.white)
                            .frame(width: 26, height: 26)
                            .background(index < 2 ? theme.accentColor : Color.moeumGray50)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 84, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var learningCard: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(LearningMode.allCases) { mode in
                    modeButton(mode)
                }
            }
            .frame(height: 66)

            Spacer(minLength: 8)

            Image(theme.assetName)
                .resizable()
                .scaledToFit()
                .frame(width: 144, height: 156)
                .id(theme)

            Spacer(minLength: 8)

            Button(selectedMode.actionTitle(characterName: theme.rawValue), action: performSelectedMode)
                .font(MOEUMTypography.buttonBold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(theme.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
        }
        .frame(height: 335)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func performSelectedMode() {
        if selectedMode == .teaching {
            isChatPresented = true
        }
    }

    private func modeButton(_ mode: LearningMode) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedMode = mode
            }
        } label: {
            Text(mode.title)
                .font(MOEUMTypography.bodyBold)
                .foregroundStyle(selectedMode == mode ? theme.accentColor : Color.moeumGray700)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(selectedMode == mode ? Color.white : Color.moeumGray50)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }

    private var levelCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("다음 레벨까지 25exp")
                .font(MOEUMTypography.buttonSmallMedium)

            HStack {
                levelMascot(label: "Lv. 1", scale: 62)
                Spacer()
                Text("25exp")
                    .font(MOEUMTypography.h2Bold)
                    .foregroundStyle(theme.accentColor)
                Spacer()
                levelMascot(label: "Lv. 2", scale: 62)
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.moeumGray100)
                    Capsule().fill(theme.accentColor)
                        .frame(width: proxy.size.width * 0.67)
                }
            }
            .frame(height: 13)
        }
        .padding(12)
        .frame(height: 167)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func levelMascot(label: String, scale: CGFloat) -> some View {
        VStack(spacing: 0) {
            Image(theme.assetName)
                .resizable()
                .scaledToFit()
                .frame(width: scale, height: 70)
            Text(label)
                .font(MOEUMTypography.buttonSmallMedium)
                .foregroundStyle(label == "Lv. 1" ? theme.accentColor : Color.moeumGray500)
        }
    }
}

private enum LearningMode: String, CaseIterable, Identifiable {
    case teaching
    case card
    case test

    var id: Self { self }

    var title: String {
        switch self {
        case .teaching: "Teaching"
        case .card: "Card"
        case .test: "Test"
        }
    }

    func actionTitle(characterName: String) -> String {
        switch self {
        case .teaching: "\(characterName)이와 대화"
        case .card: "플래시 카드"
        case .test: "주관식 문제"
        }
    }
}

#Preview {
    HomeView(theme: .yellow, accessToken: "preview")
}
