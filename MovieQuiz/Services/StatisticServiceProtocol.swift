import Foundation

protocol StatisticServiceProtocol{
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double? { get }
    
    func store(correct count: Int)
}

struct GameResult {
    var correct: Int
    var total: Int
    var date: Date

    func isRecord(_ another: Int) -> Bool {
        UserDefaults.standard.integer(forKey: "correctAnswers") < another
    }
}
