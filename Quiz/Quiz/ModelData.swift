import Foundation

struct QuestionModel: Codable, Hashable, Identifiable {
    var id: String
    var question: String
    var correctAnswer: String
    var incorrectAnswers: [String]
    var difficulty: String
    var category: String
    
    var options: [String] {
        (incorrectAnswers + [correctAnswer]).shuffled()
    }
    
    init(id: String, question: String, correctAnswer: String, incorrectAnswers: [String], difficulty: String, category: String) {
        self.id = id
        self.question = question
        self.correctAnswer = correctAnswer
        self.incorrectAnswers = incorrectAnswers
        self.difficulty = difficulty
        self.category = category
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case question
        case correctAnswer
        case incorrectAnswers
        case difficulty
        case category
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        let questionContainer = try container.nestedContainer(keyedBy: QuestionCodingKeys.self, forKey: .question)
        question = try questionContainer.decode(String.self, forKey: .text)
        correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
        incorrectAnswers = try container.decode([String].self, forKey: .incorrectAnswers)
        difficulty = try container.decode(String.self, forKey: .difficulty)
        category = try container.decode(String.self, forKey: .category)
    }
    
    enum QuestionCodingKeys: String, CodingKey {
        case text
    }
}

@MainActor
class ModelData: ObservableObject {
    private let url: String = "https://the-trivia-api.com/v2/questions"
    @Published var questions: [QuestionModel] = []
    
    static let sampleQuestion = QuestionModel(
        id: "1",
        question: "What is the capital of France?",
        correctAnswer: "Paris",
        incorrectAnswers: ["London", "Berlin", "Madrid"],
        difficulty: "easy",
        category: "geography"
    )
    
    func fetchQuestions() async {
        guard let url = URL(string: self.url) else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedQuestions = try JSONDecoder().decode([QuestionModel].self, from: data)
            self.questions = decodedQuestions
        } catch {
            print("Error fetching or decoding data: \(error.localizedDescription)")
        }
    }
}
