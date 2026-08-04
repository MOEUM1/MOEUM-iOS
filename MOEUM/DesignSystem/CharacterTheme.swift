import SwiftUI

enum CharacterTheme: String, CaseIterable, Sendable {
    case yellow = "대훈"
    case red = "우린"
    case blue = "시우"
    case pink = "유하"

    init(characterName: String) {
        self = CharacterTheme(rawValue: characterName) ?? .yellow
    }

    var accentColor: Color {
        switch self {
        case .yellow: .moeumCharacterDarkYellow
        case .red: .moeumCharacterLightRed
        case .blue: .moeumCharacterLightBlue
        case .pink: .moeumCharacterLightPink
        }
    }

    var assetName: String {
        switch self {
        case .yellow: "MoeumMascot"
        case .red: "MoeumCharacterRed"
        case .blue: "MoeumCharacterBlue"
        case .pink: "MoeumCharacterPink"
        }
    }
}
