import UIKit

final class AlertPresenter {
    // MARK: - Public Properties
    weak var delegate: AlertPresenterDelegate?
    
    // MARK: - Public Methods
    func didAlertModelCreated(model: AlertModel?) {
        let alert = UIAlertController(
            title: model?.title,
            message: model?.message,
            preferredStyle: .alert)
        
        guard let action = model?.action else {return}
        
        alert.addAction(action)
        
        delegate?.showAlert(alert)
    }
}
