import SwiftUI

struct StudyDetailView: View {
    let topic: String
    let onBack: () -> Void
    let onComplete: (String) -> Void
    @State private var detail = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 14) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.moeumGray900)
                }
                PageDots(selection: 4, count: 6)
            }

            Text("더 자세히 알려주세요!")
                .font(MOEUMTypography.h2Bold)
                .foregroundStyle(Color.moeumGray900)

            Text(topic)
                .font(MOEUMTypography.buttonSmallMedium)
                .foregroundStyle(Color.moeumGray700)
                .padding(.horizontal, 10)
                .frame(height: 28)
                .background(Color.white)
                .overlay { Capsule().stroke(Color.moeumGray300) }
                .clipShape(Capsule())

            ZStack(alignment: .topLeading) {
                if detail.isEmpty {
                    Text("공부하고 싶은 분야를 적어주세요.")
                        .font(MOEUMTypography.captionMedium)
                        .foregroundStyle(Color.moeumGray400)
                        .padding(14)
                }

                TextEditor(text: $detail)
                    .font(MOEUMTypography.captionMedium)
                    .scrollContentBackground(.hidden)
                    .padding(8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.moeumGray50)
            .overlay { RoundedRectangle(cornerRadius: 4).stroke(Color.moeumGray200) }

            HStack(spacing: 4) {
                Spacer()
                Text("만약 계정이 있으신가요?")
                    .foregroundStyle(Color.moeumGray400)
                Text("로그인")
                    .foregroundStyle(Color.moeumMain500)
                    .underline()
            }
            .font(MOEUMTypography.buttonSmallMedium)

            MOEUMButton(title: "완료", isEnabled: !detail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
                onComplete(detail)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 18)
        .background(Color.white)
    }
}

#Preview {
    StudyDetailView(topic: "수학 I", onBack: {}, onComplete: { _ in })
}
