import SwiftUI

struct StoryView: View {
    let onBack: () -> Void
    let onComplete: () -> Void
    @State private var story = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            OnboardingHeader(title: "더 자세히 알려주세요!", onBack: onBack)

            ZStack(alignment: .topLeading) {
                if story.isEmpty {
                    Text("공감하고 싶은 이야기를 적어주세요.")
                        .font(MOEUMTypography.buttonSmallMedium)
                        .foregroundStyle(Color.moeumGray400)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 16)
                }

                TextEditor(text: $story)
                    .font(MOEUMTypography.captionMedium)
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .background(Color.clear)
            }
            .frame(maxWidth: .infinity, minHeight: 300)
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.moeumGray200, lineWidth: 1)
            }

            Spacer()

            MOEUMButton(title: "완료", isEnabled: !story.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, action: onComplete)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 18)
        .background(Color.white)
    }
}

#Preview {
    StoryView(onBack: {}, onComplete: {})
}
