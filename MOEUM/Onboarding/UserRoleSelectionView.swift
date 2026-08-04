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

            UserRoleCard(
                title: "성인으로 시작",
                subtitle: "무슨말이든 적어야해",
                systemImage: "bubble.left.and.bubble.right.fill"
            ) {
                onSelect(.adult)
            }
        }
        .padding(.horizontal, 24)
        .background(Color.white)
    }
}

#Preview {
    UserRoleSelectionView(onSelect: { _ in })
}
