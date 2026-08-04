import SwiftUI

struct SplashView: View {
    let onFinished: () -> Void

    var body: some View {
        VStack(spacing: 6) {
            Spacer()

            Text("모음")
                .font(MOEUMTypography.h1Bold)
                .foregroundStyle(Color.moeumGray900)

            Text("투표, 보상")
                .font(MOEUMTypography.buttonSmallMedium)
                .foregroundStyle(Color.moeumGray700)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .task {
            try? await Task.sleep(for: .seconds(1.2))
            onFinished()
        }
    }
}

#Preview {
    SplashView(onFinished: {})
}
