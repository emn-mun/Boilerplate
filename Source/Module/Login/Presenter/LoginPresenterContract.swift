import Foundation
import RxSwift

protocol LoginPresenterContract: class {
    var emailValidation: Observable<ValidationState>? { get }
    var passwordValidation: Observable<ValidationState>? { get }
    var loginButtonActive: Observable<Bool>? { get }
    var authenticationData: Observable<AuthenticationData?>? { get }
    var statusText: Observable<String>? { get }
    var loginButtonText: Observable<String>? { get }

    func observe(email: Observable<String?>, password: Observable<String?>, logInButton: Observable<Void>)
}
