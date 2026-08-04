import SwiftUI

struct MOEUMButton: View {
    let title: String
    var isEnabled = true
    var enabledColor = Color.moeumMain500
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(MOEUMTypography.buttonBold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(isEnabled ? enabledColor : Color.moeumMain200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .disabled(!isEnabled)
    }
}
