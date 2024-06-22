import UIKit

final class MovieQuizViewController: UIViewController {
    private struct QuizStepViewModel {
        let image: UIImage?
        let question: String
        let questionNumber: String
    }
    
    private struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    private struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private let questions: [QuizQuestion] =
    [QuizQuestion(image: "The Godfather",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: true),
     QuizQuestion(image: "The Dark Knight",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: true),
     QuizQuestion(image: "Kill Bill",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: true),
     QuizQuestion(image: "The Avengers",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: true),
     QuizQuestion(image: "Deadpool",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: true),
     QuizQuestion(image: "The Green Knight",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: true),
     QuizQuestion(image: "Old",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: false),
     QuizQuestion(image: "The Ice Age Adventures of Buck Wild",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: false),
     QuizQuestion(image: "Tesla",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: false),
     QuizQuestion(image: "Vivarium",
                  text: "Рейтинг этого фильма больше чем 6?",
                  correctAnswer: false)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentQuestion = questions[currentQuestionIndex]
        let questionModel = convert(model: currentQuestion)
        show(view: questionModel)
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let checkResult = questions[currentQuestionIndex].correctAnswer
        showAnswerResult(isCorrect: checkResult)
        yesButton.isEnabled = false
        
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let checkResult = !questions[currentQuestionIndex].correctAnswer
        showAnswerResult(isCorrect: checkResult)
        noButton.isEnabled = false
    }
    
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let viewModelOfQuestion = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            show(quiz: QuizResultsViewModel(title: "Этот раунд окончен!",
                                            text: "Ваш результат: \(correctAnswers)/10",
                                            buttonText: "Сыграть еще раз"))
        } else {
            currentQuestionIndex += 1
            
            let currentQuestion = questions[currentQuestionIndex]
            show(view: convert(model: currentQuestion))
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let currentQuestion = self.questions[self.currentQuestionIndex]
            let questionModel = self.convert(model: currentQuestion)
            self.show(view: questionModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
}
