import SwiftUI

struct MOEUMWordmark: View {
    var body: some View {
        Text("MOEUM")
            .font(.custom("OwnglyphEuiyeonChae", size: 30))
            .foregroundStyle(Color.moeumGray900)
    }
}

struct OnboardingHeader: View {
    let title: String
    let onBack: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.moeumGray900)
                    .frame(width: 24, height: 24)
            }

            Text(title)
                .font(MOEUMTypography.h2Bold)
                .foregroundStyle(Color.moeumGray900)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PageDots: View {
    let selection: Int
    let count: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<count, id: \.self) { index in
                Circle()
                    .fill(index == selection ? Color.moeumMain500 : Color.moeumGray200)
                    .frame(width: 6, height: 6)
            }
        }
    }
}
