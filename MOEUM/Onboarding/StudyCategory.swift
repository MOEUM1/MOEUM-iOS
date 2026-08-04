struct StudyCategory: Identifiable, Hashable {
    let title: String
    let topics: [String]

    var id: String { title }

    static let onboarding: [StudyCategory] = [
        .init(title: "언어", topics: ["수학 I", "영어 독해 / 회화", "국어 문학 / 비문학 독해", "수능 실전 대비", "과학탐구(물리/화학 선택형)", "미적분", "내신 대비 문제풀이", "한국사 / 세계사", "정보과학 / 코딩 기초", "사회문화 / 정치와 법"]),
        .init(title: "수학", topics: ["수학 I", "수학 II", "미적분", "확률과 통계", "기하"]),
        .init(title: "영어", topics: ["영어 독해", "영어 회화", "문법", "듣기"]),
        .init(title: "과학", topics: ["물리", "화학", "생명과학", "지구과학"]),
        .init(title: "사회", topics: ["사회문화", "정치와 법", "생활과 윤리", "경제"]),
        .init(title: "역사", topics: ["한국사", "세계사", "동아시아사"]),
    ]
}
