import UIKit

final class AlertPresenter {
    // MARK: - Public Properties
    weak var viewController: UIViewController?
    
    // MARK: - Public Methods
    func didAlertModelCreated(model: AlertModel?) {
        let alert = UIAlertController(
            title: model?.title,
            message: model?.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Сыграть еще раз", style: .default,
                                   handler: {_ in
            model?.completion()
        })
        
        alert.addAction(action)
        
        DispatchQueue.main.async {
            self.viewController?.present(alert, animated: true, completion: nil)
        }
    }
}
