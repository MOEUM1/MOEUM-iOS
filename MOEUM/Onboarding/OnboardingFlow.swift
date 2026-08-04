import SwiftUI

enum OnboardingStep: Hashable {
    case introduction
    case welcome
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
    var selectedStudyTopic: String?
    var selectedCharacterName: String?

    func move(to step: OnboardingStep) {
        path.append(step)
    }

    func back() {
        _ = path.popLast()
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
