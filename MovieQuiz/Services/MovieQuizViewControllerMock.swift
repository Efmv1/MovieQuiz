import Foundation
import UIKit

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func showAlert(_ alert: UIAlertController) {
    }
    func show(view step: QuizStepViewModel) {
    }
    func highlightImageBorder(inCorrectColor isCorrectAnswer: Bool) {
    }
    func showLoadingIndicator() {
    }
    func hideLoadingIndicator() {
    }
}
