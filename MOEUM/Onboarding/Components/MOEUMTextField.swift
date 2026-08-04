import SwiftUI

struct MOEUMTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(MOEUMTypography.buttonSmallMedium)
                .foregroundStyle(Color.moeumGray600)

            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(MOEUMTypography.captionMedium)
            .textInputAutocapitalization(.never)
            .padding(.horizontal, 14)
            .frame(height: 47)
            .background(Color.white)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.moeumGray200, lineWidth: 1)
            }
        }
    }
}
