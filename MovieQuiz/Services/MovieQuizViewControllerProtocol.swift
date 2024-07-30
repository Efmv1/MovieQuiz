import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject, AlertPresenterDelegate {
    func show(view model: QuizStepViewModel)
    
    func highlightImageBorder(inCorrectColor: Bool)
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
}
