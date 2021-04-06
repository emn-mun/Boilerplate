import XCTest
import RxSwift
import Nimble
import RxBlocking
@testable import Boilerplate

class LoginPresenter_UnitTests: XCTestCase {
    private let disposeBag = DisposeBag()
    override func setUp() {
        super.setUp()
    }

    func testInputFieldsAreUsingValidation() {
        let presenter = LoginPresenter(service: MockLoginService(), router: MockRouter(), validator: MockFailingValidator())

        let emailObservable = Observable<String?>.just(nil)
        let passwordObservable = Observable<String?>.just(nil)
        let buttonActionObservable = Observable<Void>.just(())
        presenter.observe(email: emailObservable, password: passwordObservable, logInButton: buttonActionObservable)

        let ableToLogin = try! presenter.loginButtonActive?.toBlocking().first()!
        let emailValidation = try! presenter.emailValidation?.toBlocking().first()!
        let passwordValidation = try! presenter.passwordValidation?.toBlocking().first()!

        expect(emailValidation) == .invalid
        expect(passwordValidation) == .valid
        expect(ableToLogin).to(beFalse())
    }

    func testAuthentication() {
        let presenter = LoginPresenter(service: MockLoginService(), router: MockRouter(), validator: MockValidator())
        let emailObservable = Observable<String?>.just("email@")
        let passwordObservable = Observable<String?>.just("passw")
        let buttonActionObservable = Observable<Void>.just(())
        presenter.observe(email: emailObservable, password: passwordObservable, logInButton: buttonActionObservable)

        let authenticationData = try! presenter.authenticationData?.toBlocking().first()!

        expect(authenticationData?.token) == "token"
        expect(authenticationData?.message) == "You are logged in"
    }

    func testLoginButtonTextUpdatesDuringAuthentication() {
        let presenter = LoginPresenter(service: MockLoginService(), router: MockRouter(), validator: MockValidator())
        let emailObservable = Observable<String?>.just("email@")
        let passwordObservable = Observable<String?>.just("passw")
        let buttonActionObservable = Observable<Void>.just(())
        presenter.observe(email: emailObservable, password: passwordObservable, logInButton: buttonActionObservable)

        expect(try! presenter.loginButtonText!.toBlocking().first()) == "Cancel"
    }

    func testStatusTextUpdatesDuringAuthentication() {
        let presenter = LoginPresenter(service: MockLoginService(), router: MockRouter(), validator: MockValidator())
        let emailObservable = Observable<String?>.just("email@")
        let passwordObservable = Observable<String?>.just("passw")
        let buttonActionObservable = Observable<Void>.just(())
        presenter.observe(email: emailObservable, password: passwordObservable, logInButton: buttonActionObservable)

        expect(try! presenter.statusText!.toBlocking().first()) == "You are logged in"
    }

    func test_givenValiedEmailAndPassword_loginActionPossible() {}
    
}

private class MockLoginService: LoginServiceProtocol {
    func loginUser(with email: String, password: String) -> Single<AuthenticationData?> {
        return Single.just(AuthenticationData(token: "token", message: "You are logged in"))
    }
}

private class MockRouter: RouterContract {
    func presentLogin() {}
    func presentSuccess() {}
}

private class MockFailingValidator: ValidatorProtocol {
    func validateEmail(for text: String?) -> ValidationState {
        return .invalid
    }

    func validatePassword(for text: String?) -> ValidationState {
        return .valid
    }

    func isLoginButtonActive(validEmail: ValidationState, validPassword: ValidationState) -> Bool {
        return false
    }
}

private class MockValidator: ValidatorProtocol {
    func validateEmail(for text: String?) -> ValidationState {
        return .valid
    }

    func validatePassword(for text: String?) -> ValidationState {
        return .valid
    }

    func isLoginButtonActive(validEmail: ValidationState, validPassword: ValidationState) -> Bool {
        return true
    }
}
