import UIKit

extension UITextField {
    func set(validationStatus: ValidationState) {
        switch validationStatus {
        case .pendingInput:
            layer.borderColor = UIColor.black.cgColor
        case .invalid:
            layer.borderColor = UIColor.red.cgColor
        case .valid:
            layer.borderColor = UIColor.blue.cgColor
        }
    }
}
