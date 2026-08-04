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
    var email = ""
    var password = ""
    var nickname = ""
    var accessToken: String?
    var isSubmitting = false
    var errorMessage: String?

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

    func saveAccount(email: String, password: String) {
        self.email = email
        self.password = password
        move(to: .email)
    }

    func saveNickname(_ nickname: String) {
        self.nickname = nickname
        move(to: .studentStart)
    }

    func selectCharacter(_ name: String) {
        selectedCharacterName = name
        move(to: .characterConfirmation)
    }

    @MainActor
    func register() async -> Bool {
        guard let category = selectedStudyTopic,
              let character = selectedCharacterName else {
            errorMessage = "회원가입 정보를 다시 확인해주세요."
            return false
        }

        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }

        do {
            let response = try await APIClient.shared.signUp(
                SignUpRequest(
                    nickname: nickname,
                    email: email,
                    password: password,
                    category: category,
                    choosed: character
                )
            )
            accessToken = response.accessToken
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
