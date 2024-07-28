import UIKit

final class AlertPresenter {
    // MARK: - Public Properties
    weak var delegate: AlertPresenterDelegate?
    
    
    // MARK: - Initializers
    init(delegate: AlertPresenterDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Public Methods
    func setup(delegate: AlertPresenterDelegate) {
        self.delegate = delegate
    }
    
    func didAlertModelCreated(model: AlertModel?) {
        let alert = UIAlertController(
            title: model?.title,
            message: model?.message,
            preferredStyle: .alert)
        
        guard let action = model?.action else {return}
        
        alert.addAction(action)
        
        alert.view.accessibilityIdentifier = "Alert"
        
        delegate?.showAlert(alert)
    }
}
