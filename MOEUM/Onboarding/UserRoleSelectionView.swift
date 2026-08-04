import SwiftUI

struct UserRoleSelectionView: View {
    let onSelect: (UserRole) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            UserRoleCard(
                title: "학생으로 시작",
                subtitle: "뭐 적지",
                systemImage: "books.vertical.fill"
            ) {
                onSelect(.student)
            }
        }
        .padding(.horizontal, 24)
        .background(Color.white)
    }
}

#Preview {
    UserRoleSelectionView(onSelect: { _ in })
}
