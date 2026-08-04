import SwiftUI

enum OnboardingStep: Hashable {
    case introduction
    case welcome
    case account
    case email
    case character
    case terms
    case story
}

@Observable
final class OnboardingFlow {
    var path: [OnboardingStep] = []

    func move(to step: OnboardingStep) {
        path.append(step)
    }

    func back() {
        _ = path.popLast()
    }
}
