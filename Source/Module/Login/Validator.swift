import Foundation

protocol ValidatorProtocol: class {
    func validateEmail(for text: String?) -> ValidationState
    func validatePassword(for text: String?) -> ValidationState
    func isLoginButtonActive(validEmail: ValidationState, validPassword: ValidationState) -> Bool
}

final class Validator: ValidatorProtocol {
    func validateEmail(for text: String?) -> ValidationState {
        guard let text = text else { return .pendingInput }
        if text.isEmpty {
            return .pendingInput
        }
        if text.contains("@") {
            return .valid
        } else {
            return .invalid
        }
    }

    func validatePassword(for text: String?) -> ValidationState {
        guard let text = text else { return .pendingInput }
        if text.isEmpty {
            return .invalid
        } else {
            return .valid
        }
    }

    func isLoginButtonActive(validEmail: ValidationState, validPassword: ValidationState) -> Bool {
        if case .valid = validEmail, case .valid = validPassword {
            return true
        }
        return false
    }
}
