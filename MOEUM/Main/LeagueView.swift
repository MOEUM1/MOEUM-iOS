import SwiftUI

struct LeagueView: View {
    let theme: CharacterTheme
    let accessToken: String
    @State private var rankings: [LeagueRanking] = []
    @State private var myRank: MyLeagueRankResponse?
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                header

                if isLoading {
                    ProgressView().tint(theme.accentColor).padding(.top, 40)
                } else if rankings.isEmpty {
                    ContentUnavailableView("아직 리그 순위가 없어요", systemImage: "trophy")
                } else {
                    VStack(spacing: 10) {
                        ForEach(rankings) { ranking in
                            rankRow(ranking)
                        }
                    }
                }

                if let errorMessage {
                    Text(errorMessage)
                        .font(MOEUMTypography.buttonSmallMedium)
                        .foregroundStyle(Color.moeumCharacterLightRed)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 28)
        }
        .scrollIndicators(.hidden)
        .background(Color.moeumAppBackground)
        .task { await loadLeague() }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 14) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(Color.moeumGray900)

                Text("현재 \(myRank?.rank ?? 0)위에요!\n계속 성장해봐요")
                    .font(MOEUMTypography.bodyBold)
                    .foregroundStyle(Color.moeumGray900)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Spacer(minLength: 0)

            Image(theme.assetName)
                .resizable()
                .scaledToFit()
                .frame(width: 126, height: 140)
                .padding(.top, 24)
        }
        .frame(height: 226)
    }

    private func rankRow(_ ranking: LeagueRanking) -> some View {
        let isCurrentUser = ranking.rank == myRank?.rank
        let memberTheme = CharacterTheme(characterName: ranking.characterName)
        return HStack(spacing: 14) {
            Text("\(ranking.rank)위")
                .font(MOEUMTypography.bodyBold)
                .foregroundStyle(isCurrentUser ? theme.accentColor : Color.moeumGray700)
                .frame(width: 38, alignment: .leading)

            Image(memberTheme.assetName)
                .resizable()
                .scaledToFit()
                .frame(width: 42, height: 45)

            Text(ranking.nickname)
                .font(MOEUMTypography.buttonBold)
                .foregroundStyle(Color.moeumGray900)

            Spacer()

            Text("\(ranking.totalExp) exp")
                .font(MOEUMTypography.captionMedium)
                .foregroundStyle(Color.moeumGray500)
        }
        .padding(.horizontal, 16)
        .frame(height: 66)
        .background(Color.white)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(isCurrentUser ? theme.accentColor : Color.moeumGray100,
                        lineWidth: isCurrentUser ? 3 : 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    @MainActor
    private func loadLeague() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        async let rankingsRequest = APIClient.shared.league(accessToken: accessToken)
        async let myRankRequest = APIClient.shared.myLeagueRank(accessToken: accessToken)
        do {
            rankings = try await rankingsRequest.rankings
            myRank = try await myRankRequest
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    LeagueView(theme: .yellow, accessToken: "preview")
}
