import SwiftUI

struct StudyCategorySelectionView: View {
    let onBack: () -> Void
    let onContinue: (String) -> Void
    @State private var expandedCategory: StudyCategory.ID?
    @State private var selectedTopic: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 14) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.moeumGray900)
                }

                PageDots(selection: 3, count: 6)
            }

            Text("사용자님이\n공부할 카테고리를 선택해보세요.")
                .font(MOEUMTypography.h2Bold)
                .foregroundStyle(Color.moeumGray900)

            ScrollView {
                LazyVStack(spacing: 14) {
                    ForEach(StudyCategory.onboarding) { category in
                        StudyCategoryRow(
                            category: category,
                            isExpanded: expandedCategory == category.id,
                            selectedTopic: $selectedTopic
                        ) {
                            withAnimation {
                                expandedCategory = expandedCategory == category.id ? nil : category.id
                            }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)

            HStack(spacing: 4) {
                Spacer()
                Text("만약 계정이 있으신가요?")
                    .foregroundStyle(Color.moeumGray400)
                Text("로그인")
                    .foregroundStyle(Color.moeumMain500)
                    .underline()
            }
            .font(MOEUMTypography.buttonSmallMedium)

            MOEUMButton(title: "다음", isEnabled: selectedTopic != nil) {
                if let selectedTopic {
                    onContinue(selectedTopic)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 18)
        .background(Color.white)
    }
}

#Preview {
    StudyCategorySelectionView(onBack: {}, onContinue: { _ in })
}
