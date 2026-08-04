import SwiftUI

struct MOEUMButton: View {
    let title: String
    var isEnabled = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(MOEUMTypography.buttonBold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(isEnabled ? Color.moeumMain500 : Color.moeumGray200)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .disabled(!isEnabled)
    }
}
