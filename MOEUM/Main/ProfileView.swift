import SwiftUI

struct ProfileView: View {
    let theme: CharacterTheme
    @State private var expandedCategory: ProfileCategory?

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                profileHeader
                categorySection
                mySection
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 32)
        }
        .scrollIndicators(.hidden)
        .background(Color.moeumAppBackground)
    }

    private var profileHeader: some View {
        HStack(spacing: 16) {
            Image(theme.assetName)
                .resizable()
                .scaledToFit()
                .frame(width: 74, height: 80)
                .frame(width: 92, height: 92)
                .background(Color.white)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 7) {
                Text("사용자")
                    .font(MOEUMTypography.h2Bold)
                    .foregroundStyle(Color.moeumGray900)

                Text("LV.3")
                    .font(MOEUMTypography.buttonBold)
                    .foregroundStyle(theme.accentColor)
            }

            Spacer()

            Image(systemName: "gearshape")
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(Color.moeumGray600)
        }
        .padding(18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("관심 카테고리")
                .font(MOEUMTypography.bodyBold)
                .foregroundStyle(Color.moeumGray900)

            VStack(spacing: 10) {
                ForEach(ProfileCategory.allCases) { category in
                    categoryRow(category)
                }
            }
        }
    }

    private func categoryRow(_ category: ProfileCategory) -> some View {
        VStack(spacing: 0) {
            Button {
                expandedCategory = expandedCategory == category ? nil : category
            } label: {
                HStack {
                    Text(category.title)
                        .font(MOEUMTypography.buttonBold)
                        .foregroundStyle(Color.moeumGray900)
                    Spacer()
                    Image(systemName: expandedCategory == category ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.moeumGray600)
                }
                .padding(.horizontal, 16)
                .frame(height: 54)
            }
            .buttonStyle(.plain)

            if expandedCategory == category {
                Divider().padding(.horizontal, 16)

                FlowLayout(spacing: 8) {
                    ForEach(category.subjects, id: \.self) { subject in
                        Text(subject)
                            .font(MOEUMTypography.buttonSmallMedium)
                            .foregroundStyle(Color.moeumGray700)
                            .padding(.horizontal, 10)
                            .frame(height: 30)
                            .background(Color.moeumGray50)
                            .clipShape(Capsule())
                            .overlay { Capsule().stroke(Color.moeumGray200, lineWidth: 1) }
                    }
                }
                .padding(16)
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var mySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("MY")
                .font(MOEUMTypography.bodyBold)
                .foregroundStyle(Color.moeumGray900)

            VStack(spacing: 1) {
                myRow("내 학습 기록")
                myRow("공지사항")
                myRow("문의하기")
                myRow("로그아웃")
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    private func myRow(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(MOEUMTypography.buttonMedium)
                .foregroundStyle(Color.moeumGray900)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(Color.moeumGray400)
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
        .background(Color.white)
    }
}

private enum ProfileCategory: String, CaseIterable, Identifiable {
    case language
    case society

    var id: String { rawValue }

    var title: String {
        switch self {
        case .language: "언어"
        case .society: "사회 · 경제"
        }
    }

    var subjects: [String] {
        switch self {
        case .language: ["수학 I", "영어 독해 / 회화", "국어 문학 / 비문학 독해"]
        case .society: ["한국사 / 세계사", "사회문화", "정치와 법"]
        }
    }
}

private struct FlowLayout: Layout {
    let spacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        layout(proposal: proposal, subviews: subviews).size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(proposal: proposal, subviews: subviews)
        for (index, point) in result.points.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + point.x, y: bounds.minY + point.y), proposal: .unspecified)
        }
    }

    private func layout(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, points: [CGPoint]) {
        let width = proposal.width ?? 0
        var points: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var lineHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > width, x > 0 {
                x = 0
                y += lineHeight + spacing
                lineHeight = 0
            }
            points.append(CGPoint(x: x, y: y))
            x += size.width + spacing
            lineHeight = max(lineHeight, size.height)
        }
        return (CGSize(width: width, height: y + lineHeight), points)
    }
}

#Preview {
    ProfileView(theme: .yellow)
}
