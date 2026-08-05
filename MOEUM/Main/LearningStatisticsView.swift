import Charts
import SwiftUI

struct LearningStatisticsView: View {
    let theme: CharacterTheme
    let accessToken: String
    @State private var animateWeeklyBars = false
    @State private var studyCounts: [String: Int] = [:]
    private let firstMonths = ["SEP", "OCT", "NOV", "DEC", "JAN", "FEB"]
    private let secondMonths = ["MAR", "APR", "MAY", "JUN", "JUL", "AUG"]
    private var weeklyData: [StudyDay] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let symbols = ["월", "화", "수", "목", "금", "토", "일"]
        return symbols.enumerated().map { index, day in
            let weekday = index + 2
            let delta = (calendar.component(.weekday, from: today) - weekday + 7) % 7
            let date = calendar.date(byAdding: .day, value: -delta, to: today) ?? today
            return StudyDay(day: day, minutes: (studyCounts[dateKey(date)] ?? 0) * 15)
        }
    }

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
        .task { await loadStudyHistory() }
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
                        .font(.custom("Pretendard-Medium", size: 8))
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
        let date = Calendar.current.date(byAdding: .day, value: -(index % 168), to: Calendar.current.startOfDay(for: .now)) ?? .now
        return switch studyCounts[dateKey(date)] ?? 0 {
        case 0: Color.moeumGray100
        case 1: theme.accentColor.opacity(0.35)
        case 2: theme.accentColor.opacity(0.6)
        default: theme.accentColor
        }
    }

    private func dateKey(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    @MainActor
    private func loadStudyHistory() async {
        let to = Date()
        let from = Calendar.current.date(byAdding: .day, value: -365, to: to) ?? to
        guard let response = try? await APIClient.shared.histories(from: from, to: to, accessToken: accessToken) else { return }
        var counts: [String: Int] = [:]
        for history in response.histories {
            counts[dateKey(history.createdAt), default: 0] += 1
        }
        withAnimation(.easeOut(duration: 0.35)) {
            studyCounts = counts
        }
    }

    private var weeklyCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("주간 학습")
                .font(MOEUMTypography.captionMedium)

            Chart(weeklyData) { item in
                BarMark(
                    x: .value("요일", item.day),
                    y: .value("학습 시간", animateWeeklyBars ? item.minutes : 0)
                )
                .foregroundStyle(item.day == "수" ? theme.accentColor : Color.moeumGray300)
                .cornerRadius(4)
            }
            .chartYAxis(.hidden)
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let day = value.as(String.self) {
                            Text(day)
                                .font(MOEUMTypography.captionMedium)
                                .foregroundStyle(day == "수" ? theme.accentColor : Color.moeumGray900)
                        }
                    }
                }
            }
            .frame(height: 210)
            .animation(.interpolatingSpring(stiffness: 170, damping: 10), value: animateWeeklyBars)
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: 278, alignment: .topLeading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onAppear {
            animateWeeklyBars = false
            withAnimation(.interpolatingSpring(stiffness: 170, damping: 10).delay(0.08)) {
                animateWeeklyBars = true
            }
        }
    }
}

private struct StudyDay: Identifiable {
    let day: String
    let minutes: Int
    var id: String { day }
}

#Preview {
    LearningStatisticsView(theme: .yellow, accessToken: "preview")
}
