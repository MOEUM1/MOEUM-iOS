import SwiftUI

enum OnboardingStep: Hashable {
    case introduction
    case welcome
    case roleSelection
    case studentStart
    case studyDetail
    case account
    case email
    case character
    case characterConfirmation
    case completion
}

@Observable
final class OnboardingFlow {
    var path: [OnboardingStep] = []
    var selectedRole: UserRole?
    var selectedStudyTopic: String?
    var selectedCharacterName: String?

    func move(to step: OnboardingStep) {
        path.append(step)
    }

    func back() {
        _ = path.popLast()
    }

    func select(_ role: UserRole) {
        selectedRole = role
        move(to: .account)
    }

    func selectStudyTopic(_ topic: String) {
        selectedStudyTopic = topic
        move(to: .studyDetail)
    }

    func selectCharacter(_ name: String) {
        selectedCharacterName = name
        move(to: .characterConfirmation)
    }
}
