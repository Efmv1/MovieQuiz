import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func showAlert(_ alert: UIAlertController)
}
