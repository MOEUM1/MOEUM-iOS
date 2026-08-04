import SwiftUI

struct StudyCategoryRow: View {
    let category: StudyCategory
    let isExpanded: Bool
    @Binding var selectedTopic: String?
    let onToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Button(action: onToggle) {
                HStack {
                    Text(category.title)
                        .font(MOEUMTypography.buttonBold)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption.bold())
                }
                .foregroundStyle(Color.moeumGray900)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded {
                LazyVGrid(columns: [.init(.adaptive(minimum: 108), spacing: 8)], alignment: .leading, spacing: 8) {
                    ForEach(category.topics, id: \.self) { topic in
                        Button {
                            selectedTopic = topic
                        } label: {
                            Text(topic)
                                .font(MOEUMTypography.buttonSmallMedium)
                                .foregroundStyle(Color.moeumGray700)
                                .lineLimit(1)
                                .padding(.horizontal, 10)
                                .frame(height: 28)
                                .background(selectedTopic == topic ? Color.moeumMain50 : Color.white)
                                .overlay {
                                    Capsule().stroke(selectedTopic == topic ? Color.moeumMain500 : Color.moeumGray300)
                                }
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.moeumGray50)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.moeumGray200)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
    }
}
