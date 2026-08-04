import SwiftUI

struct UserRoleSelectionView: View {
    let onSelect: (UserRole) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
        }
        .padding(.horizontal, 24)
        .background(Color.white)
    }
}

#Preview {
    UserRoleSelectionView(onSelect: { _ in })
}
