import UIKit

final class AlertPresenter: MovieQuizViewController, AlertPresenterDelegate {
    
    
    // MARK: - AlertPresenterDelegate
    func didAlertModelCreated(model: AlertModel?) {
        let alert = UIAlertController(
            title: model?.title,
            message: model?.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Сыграть еще раз", style: .default)
        
        alert.addAction(action)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
