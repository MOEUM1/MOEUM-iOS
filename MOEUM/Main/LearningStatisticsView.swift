import Charts
import SwiftUI

struct LearningStatisticsView: View {
    private let firstMonths = ["SEP", "OCT", "NOV", "DEC", "JAN", "FEB"]
    private let secondMonths = ["MAR", "APR", "MAY", "JUN", "JUL", "AUG"]
    private let weeklyData = [
        StudyDay(day: "월", minutes: 82),
        StudyDay(day: "화", minutes: 18),
        StudyDay(day: "수", minutes: 58),
        StudyDay(day: "목", minutes: 3),
        StudyDay(day: "금", minutes: 3),
        StudyDay(day: "토", minutes: 3),
        StudyDay(day: "일", minutes: 3),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("기간별 학습 정보")
                    .font(MOEUMTypography.buttonMedium)
                    .padding(.leading, 9)

                annualCard
                weeklyCard
            }
            .padding(.horizontal, 20)
            .padding(.top, 19)
            .padding(.bottom, 32)
        }
        .scrollIndicators(.hidden)
        .background(Color.moeumAppBackground)
    }

    private var annualCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("연간 학습")
                .font(MOEUMTypography.captionMedium)

            contributionSection(months: firstMonths, seed: 0)
            contributionSection(months: secondMonths, seed: 11)
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: 315, alignment: .topLeading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func contributionSection(months: [String], seed: Int) -> some View {
        VStack(spacing: 6) {
            HStack {
                ForEach(months, id: \.self) { month in
                    Text(month)
                        .font(.custom("Pretendard-Medium", size: 8, relativeTo: .caption2))
                        .frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 3), count: 24), spacing: 3) {
                ForEach(0..<168, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(contributionColor(for: index + seed))
                        .aspectRatio(1, contentMode: .fit)
                }
            }
        }
    }

    private func contributionColor(for index: Int) -> Color {
        switch (index * 7 + index / 9) % 6 {
        case 0: Color.moeumCharacterDarkYellow
        case 1: Color.moeumCharacterLightYellow.opacity(0.8)
        case 2: Color.moeumGray300
        case 3: Color.moeumGray200
        default: Color.moeumGray100
        }
    }

    private var weeklyCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("주간 학습")
                .font(MOEUMTypography.captionMedium)

            Chart(weeklyData) { item in
                BarMark(
                    x: .value("요일", item.day),
                    y: .value("학습 시간", item.minutes)
                )
                .foregroundStyle(item.day == "수" ? Color.moeumCharacterDarkYellow : Color.moeumGray300)
                .cornerRadius(4)
            }
            .chartYAxis(.hidden)
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let day = value.as(String.self) {
                            Text(day)
                                .font(MOEUMTypography.captionMedium)
                                .foregroundStyle(day == "수" ? Color.moeumCharacterDarkYellow : Color.moeumGray900)
                        }
                    }
                }
            }
            .frame(height: 210)
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: 278, alignment: .topLeading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private struct StudyDay: Identifiable {
    let day: String
    let minutes: Int
    var id: String { day }
}

#Preview {
    LearningStatisticsView()
}
