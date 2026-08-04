import SwiftUI

struct UserRoleCard: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 12) {
                        Text(title)
                            .font(MOEUMTypography.h2Bold)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    Text(subtitle)
                        .font(MOEUMTypography.bodyMedium)
                        .foregroundStyle(Color.moeumGray600)
                }

                Spacer()

                Image(systemName: systemImage)
                    .font(.system(size: 34))
                    .foregroundStyle(Color.moeumMain500)
                    .frame(width: 72, height: 72)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            .foregroundStyle(Color.moeumGray900)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, minHeight: 132)
            .background(Color.moeumGray50)
            .clipShape(RoundedRectangle(cornerRadius: 22))
        }
        .buttonStyle(.plain)
    }
}
