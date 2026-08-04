import SwiftUI

struct SplashView: View {
    let onFinished: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Spacer()

            Text("모음")
                .font(.custom("OwnglyphEuiyeonChae", size: 56.364, relativeTo: .largeTitle))
                .foregroundStyle(Color.moeumGray900)

            Text("폭 넓은 경험,")
                .font(.custom("OwnglyphEuiyeonChae", size: 24, relativeTo: .title2))
                .foregroundStyle(Color.moeumGray900)

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
