import Foundation

struct SignUpRequest: Encodable {
    let nickname: String
    let email: String
    let password: String
    let category: String
    let choosed: String
}

struct SignInRequest: Encodable {
    let email: String
    let password: String
}

struct AuthResponse: Decodable {
    let user: APIUser
    let character: AuthCharacter
    let accessToken: String
}

struct APIUser: Decodable {
    let id: String
    let email: String
    let nickname: String
    let createdAt: Date
}

struct MyUserResponse: Decodable { let user: APIUser }
struct CategoriesResponse: Decodable { let category: [String] }

struct AuthCharacter: Decodable {
    let id: String
    let level: Int
    let exp: Int
}

struct CharacterResponse: Decodable {
    let character: CharacterDetail
}

struct CharacterDetail: Decodable {
    let id: String
    let name: String
    let description: String
    let level: Int
    let exp: Int
    let totalExp: Int
    let expToNextLevel: Int
    let createdAt: Date
}

struct StreakResponse: Decodable {
    let count: Int
    let lastDate: Date?
    let studiedToday: Bool
}

struct LeagueResponse: Decodable {
    let totalUsers: Int
    let rankings: [LeagueRanking]
}

struct LeagueRanking: Decodable, Identifiable {
    let rank: Int
    let userId: String
    let nickname: String
    let characterName: String
    let level: Int
    let exp: Int
    let totalExp: Int

    var id: String { userId }
}

struct MyLeagueRankResponse: Decodable {
    let totalUsers: Int
    let rank: Int
    let characterName: String
    let level: Int
    let exp: Int
    let totalExp: Int
}

struct ChatStartResponse: Decodable {
    let historyId: String
    let subject: String
    let question: String
    let createdAt: Date
}

struct ChatAnswerRequest: Encodable {
    let answer: String
}

struct ChatAnswerResponse: Decodable {
    let historyId: String
    let question: String
}

struct GameQuestion: Decodable, Identifiable {
    let index: Int
    let question: String
    var id: Int { index }
}

struct GameStartResponse: Decodable {
    let historyId: String
    let subject: String
    let questions: [GameQuestion]
    let createdAt: Date
}

struct CardResultRequest: Encodable {
    let endTime: Date
    let correctIndex: [Int]
    let wrongIndex: [Int]
}

struct CardResultResponse: Decodable {
    let historyId: String
    let correctCount: Int
    let wrongCount: Int
    let totalCount: Int
}

struct QuizAnswer: Encodable { let index: Int; let answer: String }
struct QuizResultRequest: Encodable { let historyId: String; let input: [QuizAnswer]; let endAt: Date }
struct QuizGrade: Decodable { let index: Int; let answer: String; let isCorrect: Bool; let correctAnswer: String; let explaination: String }
struct QuizResultResponse: Decodable { let historyId: String; let correctCount: Int; let wrongCount: Int; let grade: [QuizGrade]; let endTime: Date }

extension APIClient {
    func signUp(_ request: SignUpRequest) async throws -> AuthResponse {
        try await send("auth/signup", method: .post, body: request)
    }

    func signIn(_ request: SignInRequest) async throws -> AuthResponse {
        try await send("auth/signin", method: .post, body: request)
    }

    func myCharacter(accessToken: String) async throws -> CharacterResponse {
        try await send("characters/me", accessToken: accessToken)
    }

    func myStreak(accessToken: String) async throws -> StreakResponse {
        try await send("users/me/streak", accessToken: accessToken)
    }

    func myUser(accessToken: String) async throws -> MyUserResponse {
        try await send("users/me", accessToken: accessToken)
    }

    func myCategories(accessToken: String) async throws -> CategoriesResponse {
        try await send("users/me/categories", accessToken: accessToken)
    }

    func league(accessToken: String, limit: Int = 10) async throws -> LeagueResponse {
        try await send("leagues/top?limit=\(limit)", accessToken: accessToken)
    }

    func myLeagueRank(accessToken: String) async throws -> MyLeagueRankResponse {
        try await send("leagues/me", accessToken: accessToken)
    }

    func startChat(accessToken: String) async throws -> ChatStartResponse {
        try await send("games/chat", method: .post, accessToken: accessToken)
    }

    func answerChat(historyId: String, answer: String, accessToken: String) async throws -> ChatAnswerResponse {
        try await send(
            "games/chat/\(historyId)/answer",
            method: .post,
            body: ChatAnswerRequest(answer: answer),
            accessToken: accessToken
        )
    }

    func startCardGame(accessToken: String) async throws -> GameStartResponse {
        try await send("games/card", method: .post, accessToken: accessToken)
    }

    func submitCardGame(historyId: String, correct: [Int], wrong: [Int], accessToken: String) async throws -> CardResultResponse {
        try await send("games/card/\(historyId)/result", method: .post, body: CardResultRequest(endTime: .now, correctIndex: correct, wrongIndex: wrong), accessToken: accessToken)
    }

    func startQuizGame(accessToken: String) async throws -> GameStartResponse {
        try await send("games/quiz", method: .post, accessToken: accessToken)
    }

    func submitQuizGame(historyId: String, answers: [QuizAnswer], accessToken: String) async throws -> QuizResultResponse {
        try await send("games/quiz/result", method: .post, body: QuizResultRequest(historyId: historyId, input: answers, endAt: .now), accessToken: accessToken)
    }
}
