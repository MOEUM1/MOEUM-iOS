import SwiftUI

struct UserRoleCard: View {
    let title: String
    let subtitle: String
    let systemImage: String
    var emoji: String? = nil
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(title)
                            .font(MOEUMTypography.buttonBold)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    Text(subtitle)
                        .font(MOEUMTypography.captionMedium)
                        .foregroundStyle(Color.moeumGray600)
                }

                Spacer()

                Group {
                    if let emoji {
                        Text(emoji)
                    } else {
                        Image(systemName: systemImage)
                            .foregroundStyle(Color.moeumMain500)
                    }
                }
                    .font(.system(size: 34))
                    .frame(width: 72, height: 72)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            .foregroundStyle(Color.moeumGray900)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, minHeight: 82)
            .background(Color.moeumGray50)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}
