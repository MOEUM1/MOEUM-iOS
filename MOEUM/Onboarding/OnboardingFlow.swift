import SwiftUI

enum OnboardingStep: Hashable {
    case introduction
    case welcome
    case roleSelection
    case studentStart
    case adultStart
    case account
    case email
    case character
    case terms
    case story
}

@Observable
final class OnboardingFlow {
    var path: [OnboardingStep] = []
    var selectedRole: UserRole?

    func move(to step: OnboardingStep) {
        path.append(step)
    }

    func back() {
        _ = path.popLast()
    }

    func select(_ role: UserRole) {
        selectedRole = role
        move(to: role == .student ? .studentStart : .adultStart)
    }
}
