import SwiftUI

struct HomeView: View {
    let theme: CharacterTheme
    let accessToken: String
    @State private var selectedMode: LearningMode = .teaching
    @State private var isChatPresented = false
    @State private var isCardPresented = false
    @State private var isExamPresented = false
    @State private var character: CharacterDetail?
    @State private var streak: StreakResponse?
    @State private var isSadMascotAnimating = false
    @State private var isHappyMascotAnimating = false
    @State private var isLearningMascotAnimating = false
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
        .fullScreenCover(isPresented: $isCardPresented) { CardGameView(theme: theme, accessToken: accessToken) }
        .fullScreenCover(isPresented: $isExamPresented) { WrittenExamView(theme: theme, accessToken: accessToken) }
        .task { await loadDashboard() }
        .onChange(of: isCardPresented) { _, isPresented in
            if !isPresented { Task { await loadDashboard() } }
        }
        .onChange(of: isExamPresented) { _, isPresented in
            if !isPresented { Task { await loadDashboard() } }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                isSadMascotAnimating = true
            }
            withAnimation(.easeInOut(duration: 0.42).repeatForever(autoreverses: true)) {
                isHappyMascotAnimating = true
            }
            withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) {
                isLearningMascotAnimating = true
            }
        }
    }

    private var streakCard: some View {
        HStack(spacing: 8) {
            Image("LearningFire")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)

            VStack(alignment: .leading, spacing: 9) {
                (Text("연속 학습 ") + Text("\(streak?.count ?? 0)").foregroundColor(theme.accentColor) + Text("일"))
                    .font(MOEUMTypography.buttonSmallMedium)

                HStack(spacing: 12) {
                    ForEach(Array(weekdays.enumerated()), id: \.offset) { index, day in
                        Text(day)
                            .font(MOEUMTypography.buttonSmallMedium)
                            .foregroundStyle(.white)
                            .frame(width: 26, height: 26)
                            .background(index < min(streak?.count ?? 0, weekdays.count) ? theme.accentColor : Color.moeumGray50)
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
                .offset(y: isLearningMascotAnimating ? -6 : 0)
                .rotationEffect(.degrees(isLearningMascotAnimating ? 2 : -2), anchor: .bottom)
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
        switch selectedMode {
        case .teaching: isChatPresented = true
        case .card: isCardPresented = true
        case .test: isExamPresented = true
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
            Text("다음 레벨까지 \(character?.expToNextLevel ?? 0)exp")
                .font(MOEUMTypography.buttonSmallMedium)

            HStack {
                levelMascot(label: "Lv. \(character?.level ?? 1)", scale: 62, isCurrent: true)
                Spacer()
                Text("\(character?.exp ?? 0)exp")
                    .font(MOEUMTypography.h2Bold)
                    .foregroundStyle(theme.accentColor)
                Spacer()
                levelMascot(label: "Lv. \((character?.level ?? 1) + 1)", scale: 62, isCurrent: false)
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.moeumGray100)
                    Capsule().fill(theme.accentColor)
                        .frame(width: proxy.size.width * levelProgress)
                }
            }
            .frame(height: 13)
        }
        .padding(12)
        .frame(height: 167)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var levelProgress: CGFloat {
        guard let character else { return 0 }
        let target = character.exp + character.expToNextLevel
        guard target > 0 else { return 0 }
        return min(max(CGFloat(character.exp) / CGFloat(target), 0), 1)
    }

    private func levelMascot(label: String, scale: CGFloat, isCurrent: Bool) -> some View {
        VStack(spacing: 0) {
            ZStack(alignment: .topTrailing) {
                Image(theme.assetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: scale, height: 70)
                    .offset(y: isCurrent && isSadMascotAnimating ? 2 : 0)
                    .rotationEffect(.degrees(!isCurrent && isHappyMascotAnimating ? 4 : 0), anchor: .bottom)

            }
            Text(label)
                .font(MOEUMTypography.buttonSmallMedium)
                .foregroundStyle(isCurrent ? theme.accentColor : Color.moeumGray500)
        }
    }

    @MainActor
    private func loadDashboard() async {
        async let characterRequest = APIClient.shared.myCharacter(accessToken: accessToken)
        async let streakRequest = APIClient.shared.myStreak(accessToken: accessToken)
        character = (try? await characterRequest)?.character
        streak = try? await streakRequest
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
