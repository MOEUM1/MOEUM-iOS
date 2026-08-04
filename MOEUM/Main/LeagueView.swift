import SwiftUI

struct LeagueView: View {
    private let members = [
        LeagueMember(rank: 1, name: "당신", experience: "850 exp", isCurrentUser: true),
        LeagueMember(rank: 2, name: "민수", experience: "790 exp"),
        LeagueMember(rank: 3, name: "지우", experience: "720 exp"),
        LeagueMember(rank: 4, name: "서연", experience: "680 exp"),
        LeagueMember(rank: 5, name: "유진", experience: "630 exp"),
        LeagueMember(rank: 6, name: "하준", experience: "590 exp")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {
                header

                VStack(spacing: 10) {
                    ForEach(members) { member in
                        rankRow(member)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 28)
        }
        .scrollIndicators(.hidden)
        .background(Color.moeumAppBackground)
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 14) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(Color.moeumGray900)

                Text("현재 1위에요!\n계속 유지해봐요")
                    .font(MOEUMTypography.bodyBold)
                    .foregroundStyle(Color.moeumGray900)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Spacer(minLength: 0)

            Image("MoeumMascot")
                .resizable()
                .scaledToFit()
                .frame(width: 126, height: 140)
                .padding(.top, 24)
        }
        .frame(height: 226)
    }

    private func rankRow(_ member: LeagueMember) -> some View {
        HStack(spacing: 14) {
            Text("\(member.rank)위")
                .font(MOEUMTypography.bodyBold)
                .foregroundStyle(member.isCurrentUser ? Color.moeumCharacterDarkYellow : Color.moeumGray700)
                .frame(width: 38, alignment: .leading)

            Image("MoeumMascot")
                .resizable()
                .scaledToFit()
                .frame(width: 42, height: 45)

            Text(member.name)
                .font(MOEUMTypography.buttonBold)
                .foregroundStyle(Color.moeumGray900)

            Spacer()

            Text(member.experience)
                .font(MOEUMTypography.captionMedium)
                .foregroundStyle(Color.moeumGray500)
        }
        .padding(.horizontal, 16)
        .frame(height: 66)
        .background(Color.white)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(member.isCurrentUser ? Color.moeumCharacterDarkYellow : Color.moeumGray100,
                        lineWidth: member.isCurrentUser ? 3 : 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct LeagueMember: Identifiable {
    let rank: Int
    let name: String
    let experience: String
    var isCurrentUser = false

    var id: Int { rank }
}

#Preview {
    LeagueView()
}
