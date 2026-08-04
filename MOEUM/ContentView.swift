import SwiftUI

struct ContentView: View {
    private enum RootStage {
        case splash
        case introduction
        case consent
        case welcome
    }

    @State private var stage: RootStage = .splash
    @State private var flow = OnboardingFlow()

    var body: some View {
        Group {
            switch stage {
            case .splash:
                SplashView { stage = .introduction }
            case .introduction:
                IntroductionView { stage = .consent }
            case .consent:
                ConsentView { stage = .welcome }
            case .welcome:
                signUpFlow
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
        case .account:
            AccountSetupView(onBack: flow.back) {
                flow.move(to: .email)
            }
        case .email:
            ProfileNameView(onBack: flow.back) {
                flow.move(to: .character)
            }
        case .character:
            CharacterSelectionView(onBack: flow.back) {
                flow.move(to: .terms)
            }
        case .terms:
            TermsSelectionView(onBack: flow.back) {
                flow.move(to: .story)
            }
        case .story:
            StoryView(onBack: flow.back) {
                flow.path.removeAll()
            }
        }
    }
}

#Preview {
    ContentView()
}
