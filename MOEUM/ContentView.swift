import SwiftUI

struct ContentView: View {
    private enum RootStage {
        case splash
        case introduction
        case welcome
        case main
    }

    @State private var stage: RootStage = .splash
    @State private var flow = OnboardingFlow()
    @State private var accessToken: String?
    @State private var characterTheme: CharacterTheme = .yellow

    var body: some View {
        Group {
            switch stage {
            case .splash:
                SplashView {
                    Task { await restoreSession() }
                }
            case .introduction:
                IntroductionView { stage = .welcome }
            case .welcome:
                signUpFlow
            case .main:
                MainTabView(theme: characterTheme)
            }
        }
        .animation(.easeInOut(duration: 0.22), value: stage)
    }

    private var signUpFlow: some View {
        NavigationStack(path: $flow.path) {
            WelcomeView(
                onSignUp: { flow.move(to: .account) },
                onSignedIn: completeSignIn
            )
            .navigationDestination(for: OnboardingStep.self) { step in
                destination(for: step)
                    .navigationBarBackButtonHidden()
            }
        }
    }

    @ViewBuilder
    private func destination(for step: OnboardingStep) -> some View {
        switch step {
        case .introduction, .welcome:
            WelcomeView(
                onSignUp: { flow.move(to: .account) },
                onSignedIn: completeSignIn
            )
        case .studentStart:
            StudyCategorySelectionView(
                onBack: flow.back,
                onContinue: flow.selectStudyTopic
            )
        case .studyDetail:
            StudyDetailView(
                topic: flow.selectedStudyTopic ?? "선택한 분야",
                onBack: flow.back
            ) { _ in
                flow.move(to: .character)
            }
        case .account:
            AccountSetupView(onBack: flow.back, onContinue: flow.saveAccount)
        case .email:
            ProfileNameView(onBack: flow.back, onContinue: flow.saveNickname)
        case .character:
            CharacterSelectionView(
                onBack: flow.back,
                onContinue: flow.selectCharacter
            )
        case .characterConfirmation:
            CharacterConfirmationView(
                characterName: flow.selectedCharacterName ?? "대훈",
                isLoading: flow.isSubmitting,
                errorMessage: flow.errorMessage,
                onBack: flow.back
            ) {
                Task {
                    if await flow.register() {
                        flow.move(to: .completion)
                    }
                }
            }
        case .completion:
            SignUpCompletionView(theme: flow.characterTheme) {
                if let token = flow.accessToken {
                    accessToken = token
                    try? AuthTokenStore.shared.save(token)
                }
                characterTheme = flow.characterTheme
                stage = .main
            }
        }
    }

    private func completeSignIn(_ response: AuthResponse) {
        accessToken = response.accessToken
        try? AuthTokenStore.shared.save(response.accessToken)
        Task {
            if let character = try? await APIClient.shared.myCharacter(accessToken: response.accessToken) {
                characterTheme = CharacterTheme(characterName: character.character.name)
            }
            stage = .main
        }
    }

    @MainActor
    private func restoreSession() async {
        guard let token = try? AuthTokenStore.shared.load() else {
            stage = .introduction
            return
        }

        do {
            let response = try await APIClient.shared.myCharacter(accessToken: token)
            accessToken = token
            characterTheme = CharacterTheme(characterName: response.character.name)
            stage = .main
        } catch {
            try? AuthTokenStore.shared.delete()
            accessToken = nil
            stage = .introduction
        }
    }
}

#Preview {
    ContentView()
}
