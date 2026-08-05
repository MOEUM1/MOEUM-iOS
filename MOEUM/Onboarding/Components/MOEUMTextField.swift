import SwiftUI

struct MOEUMTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var isSecure = false
    @State private var isRevealed = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(MOEUMTypography.buttonSmallMedium)
                .foregroundStyle(Color.moeumGray600)

            Group {
                if isSecure && !isRevealed {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(MOEUMTypography.bodyMedium)
            .textInputAutocapitalization(.never)
            .padding(.leading, 18)
            .padding(.trailing, isSecure ? 48 : 18)
            .frame(height: 58)
            .background {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white)
                    .overlay { RoundedRectangle(cornerRadius: 14).stroke(Color.moeumGray300, lineWidth: 1.5) }
            }
            .overlay(alignment: .trailing) {
                if isSecure {
                    Button { isRevealed.toggle() } label: {
                        Image(systemName: isRevealed ? "eye" : "eye.slash")
                            .font(.system(size: 21, weight: .medium))
                            .foregroundStyle(Color.moeumGray300)
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
