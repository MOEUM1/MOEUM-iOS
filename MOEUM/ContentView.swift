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

    var body: some View {
        Group {
            switch stage {
            case .splash:
                SplashView { stage = .introduction }
            case .introduction:
                IntroductionView { stage = .welcome }
            case .welcome:
                signUpFlow
            case .main:
                MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.22), value: stage)
    }

    private var signUpFlow: some View {
        NavigationStack(path: $flow.path) {
            WelcomeView {
                flow.move(to: .account)
            }
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
            WelcomeView { flow.move(to: .account) }
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
            AccountSetupView(onBack: flow.back) {
                flow.move(to: .email)
            }
        case .email:
            ProfileNameView(onBack: flow.back) {
                flow.move(to: .studentStart)
            }
        case .character:
            CharacterSelectionView(
                onBack: flow.back,
                onContinue: flow.selectCharacter
            )
        case .characterConfirmation:
            CharacterConfirmationView(
                characterName: flow.selectedCharacterName ?? "대훈",
                onBack: flow.back
            ) {
                flow.move(to: .completion)
            }
        case .completion:
            SignUpCompletionView {
                stage = .main
            }
        }
    }
}

#Preview {
    ContentView()
}
