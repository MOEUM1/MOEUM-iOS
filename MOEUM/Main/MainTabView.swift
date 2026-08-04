import SwiftUI

struct MainTabView: View {
    let theme: CharacterTheme
    let accessToken: String
    let onLogout: () -> Void
    @State private var selection: MainTab = .home

    var body: some View {
        VStack(spacing: 0) {
            Group {
                switch selection {
                case .home:
                    HomeView(theme: theme, accessToken: accessToken)
                case .statistics:
                    LearningStatisticsView()
                case .league:
                    LeagueView(theme: theme, accessToken: accessToken)
                case .profile:
                    ProfileView(theme: theme, accessToken: accessToken, onLogout: onLogout)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            HStack(spacing: 0) {
                ForEach(MainTab.allCases) { tab in
                    Button {
                        selection = tab
                    } label: {
                        VStack(spacing: 4) {
                            Image(tab.assetName)
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .frame(width: 34, height: 34)
                            Text(tab.title)
                                .font(MOEUMTypography.captionMedium)
                        }
                        .foregroundStyle(selection == tab ? theme.accentColor : Color.moeumGray500)
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(height: 91)
            .background(Color.white)
        }
        .background(Color.moeumAppBackground)
    }
}

private enum MainTab: String, CaseIterable, Identifiable {
    case home
    case statistics
    case league
    case profile

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home: "홈"
        case .statistics: "학습 통계"
        case .league: "리그"
        case .profile: "마이"
        }
    }

    var assetName: String {
        switch self {
        case .home: "MainTabHome"
        case .statistics: "MainTabStatistics"
        case .league: "MainTabLeague"
        case .profile: "MainTabProfile"
        }
    }
}

#Preview {
    MainTabView(theme: .yellow, accessToken: "preview", onLogout: {})
}
