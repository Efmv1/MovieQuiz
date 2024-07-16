import Foundation

final class StatisticService: StatisticServiceProtocol {
    // MARK: - Types
    private enum Keys: String {
        case gamesPlayed
        case correctAnswers
        case totalAnswers
        case dateOfRecord
    }
    
    // MARK: - Public Properties
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesPlayed.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesPlayed.rawValue)
        }
    }
    var bestGame: GameResult {
        get {
            return GameResult(correct: storage.integer(forKey: Keys.correctAnswers.rawValue),
                              total: storage.integer(forKey: Keys.totalAnswers.rawValue),
                              date: storage.object(forKey: Keys.dateOfRecord.rawValue) as? Date ?? Date())
        }
        set {
            storage.set(newValue.correct, forKey: Keys.correctAnswers.rawValue)
            storage.set(newValue.total, forKey: Keys.totalAnswers.rawValue)
            storage.set(newValue.date, forKey: Keys.dateOfRecord.rawValue)
        }
    }
    var totalAccuracy: Double? {
        var accuracy: Double?
        if storage.integer(forKey: Keys.gamesPlayed.rawValue) != 0 {
            accuracy = storage.double(forKey: Keys.totalAnswers.rawValue) / (storage.double(forKey: Keys.gamesPlayed.rawValue) * 10) * 100
        }
        return accuracy
    }
        
    // MARK: - Private Properties
    private let storage: UserDefaults = .standard
    
    // MARK: - Public Methods
    func store(correct count: Int) {
        if bestGame.isRecord(count) {
            bestGame.correct = count
            bestGame.date = Date()
            bestGame.total += count
            gamesCount += 1
        } else {
            bestGame.total += count
            gamesCount += 1
        }
    }
}
