import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPresenterDelegate {
    // MARK: - IBOutlet
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    
    // MARK: - Private Properties
    private let questionsAmount: Int = 10
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex = 0
    
    private var correctAnswers = 0
    
    private var alertPresenter: AlertPresenter?
    private var statistic: StatisticServiceProtocol?
    
    // MARK: - UIViewController(*)
    override func viewDidLoad() {
        super.viewDidLoad()
        statistic = StatisticService()
        
        alertPresenter = AlertPresenter()
        alertPresenter?.delegate = self
        
        questionFactory = QuestionFactory(delegate: self)
        questionFactory?.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?){
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(view: viewModel)
        }
    }
    
    
    // MARK: - QuestionFactoryDelegate
    func showAlert(_ alert: UIAlertController) {
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - IBAction
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard let currentQuestion else {
            return
        }
        
        let checkResult = currentQuestion.correctAnswer
        showAnswerResult(isCorrect: checkResult)
        yesButton.isEnabled = false
        
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard let currentQuestion else {
            return
        }
        
        let checkResult = !currentQuestion.correctAnswer
        showAnswerResult(isCorrect: checkResult)
        noButton.isEnabled = false
    }
    
    
    // MARK: - Private Methods
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let viewModelOfQuestion = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return viewModelOfQuestion
    }
    
    private func show(view model: QuizStepViewModel){
        imageView.image = model.image
        imageView.layer.cornerRadius = 20
        textLabel.text = model.question
        counterLabel.text = model.questionNumber
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        correctAnswers = isCorrect ? correctAnswers + 1 : correctAnswers
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionsAmount - 1 {
            statistic?.store(correct: self.correctAnswers)
            
            let alertModel = AlertModel(title: "Этот раунд окончен!",
                                        message: """
                                        Ваш результат: \(correctAnswers)/10
                                        Количество сыгранных квизов: \(statistic?.gamesCount ?? 0)
                                        Рекорд: \(statistic?.bestGame.correct ?? 0)/10 (\( statistic?.bestGame.date.dateTimeString ?? "Рекорда нет"))
                                        Средняя точность: \(String(format: "%.2f", statistic?.totalAccuracy ?? 0))%
                                        """,
                                        completion: { [weak self] in
                guard let self = self else { return }
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                
                questionFactory?.requestNextQuestion()})
            
            alertPresenter?.didAlertModelCreated(model: alertModel)
        } else {
            currentQuestionIndex += 1
            
            self.questionFactory?.requestNextQuestion()
        }
    }
}

