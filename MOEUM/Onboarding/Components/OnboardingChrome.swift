import SwiftUI

struct MOEUMWordmark: View {
    var size: CGFloat = 30

    var body: some View {
        Text("MOEUM")
            .font(.custom("OwnglyphEuiyeonChae", size: size, relativeTo: .title))
            .foregroundStyle(Color.moeumGray900)
    }
}

struct OnboardingHeader: View {
    let title: String
    var progress: Int?
    let onBack: () -> Void

    init(title: String, progress: Int? = nil, onBack: @escaping () -> Void) {
        self.title = title
        self.progress = progress
        self.onBack = onBack
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color.moeumGray900)
                        .frame(width: 24, height: 24)
                }

                if let progress {
                    PageDots(selection: progress, count: 6)
                }
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
    var selectedColor = Color.moeumMain500

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .fill(index == selection ? selectedColor : Color.moeumGray200)
                    .frame(width: index == selection ? 22 : 7, height: 7)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: selection)
    }
}

struct ExistingAccountPrompt: View {
    var accentColor = Color.moeumMain500

    var body: some View {
        HStack(spacing: 4) {
            Text("만약 계정이 있으신가요?")
                .foregroundStyle(Color.moeumGray400)
            Text("로그인")
                .foregroundStyle(accentColor)
                .underline()
        }
        .font(MOEUMTypography.buttonMedium)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
