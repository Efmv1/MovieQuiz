import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    // MARK: - Private Properties
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questionsAmount: Int = 10
    
    private var questionFactory: QuestionFactoryProtocol?
    private var statistic: StatisticServiceProtocol!
    private var alertPresenter: AlertPresenter?
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    
    // MARK: - Initializers
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        self.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        self.questionFactory?.loadData()
        viewController.showLoadingIndicator()
        
        self.statistic = StatisticService()
        self.alertPresenter = AlertPresenter(delegate: viewController)
    }
    
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?){
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(view: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    
    // MARK: - Public Methods    
    func yesButtonClicked() {
        didAnswer(isCorrectAnswer: true)
    }
    
    func noButtonClicked() {
        didAnswer(isCorrectAnswer: false)
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let viewModelOfQuestion = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return viewModelOfQuestion
    }
    
    
    // MARK: - Private Methods
    private func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    private func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    private func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }
    
    private func proceedToNextQuestionOrResults() {
        if isLastQuestion() {
            statistic?.store(correct: correctAnswers)
            
            let alertModel = AlertModel(title: "Этот раунд окончен!",
                                        message: """
                                        Ваш результат: \(correctAnswers)/10
                                        Количество сыгранных квизов: \(statistic?.gamesCount ?? 0)
                                        Рекорд: \(statistic?.bestGame.correct ?? 0)/10 (\( statistic?.bestGame.date.dateTimeString ?? "Рекорда нет"))
                                        Средняя точность: \(String(format: "%.2f", statistic?.totalAccuracy ?? 0))%
                                        """,
                                        action: UIAlertAction(title: "Сыграть еще раз", style: .default, handler: { [weak self] _ in
                guard let self = self else { return }
                
                self.restartGame()
                self.questionFactory?.requestNextQuestion()}))
            
            alertPresenter?.didAlertModelCreated(model: alertModel)
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func proceed(with answer: Bool) {
        viewController?.highlightImageBorder(inCorrectColor: answer)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.proceedToNextQuestionOrResults()
        }
    }
    
    private func showNetworkError(message: String) {
        viewController?.hideLoadingIndicator()
        
        let alertModel = AlertModel(title: "Ошибка",
                                    message: message,
                                    action: UIAlertAction(title: "Попробовать еще раз", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            
            self.restartGame()
            self.questionFactory?.loadData()
            self.viewController?.showLoadingIndicator()}))
        
        alertPresenter?.didAlertModelCreated(model: alertModel)
    }
    
    private func didAnswer(isCorrectAnswer: Bool) {
        guard let currentQuestion = currentQuestion else {return}
        
        let givenAnswer = isCorrectAnswer == currentQuestion.correctAnswer
        correctAnswers = givenAnswer ? correctAnswers + 1 : correctAnswers
        
        proceed(with: givenAnswer)
    }
}
