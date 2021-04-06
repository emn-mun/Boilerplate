import Foundation
import RxSwift

enum LoginButtonText {
    static let login = "Login"
    static let tryAgain = "Try Again"
    static let cancel = "Cancel"
}

final class LoginPresenter: LoginPresenterContract {
    private let service: LoginServiceProtocol
    private let router: RouterContract
    private let validator: ValidatorProtocol

    private let disposeBag = DisposeBag()
    
    var emailValidation: Observable<ValidationState>?
    var passwordValidation: Observable<ValidationState>?
    var loginButtonActive: Observable<Bool>?
    var authenticationData: Observable<AuthenticationData?>?
    var statusText: Observable<String>?
    var loginButtonText: Observable<String>?

    private let loginButtonTextSubject = BehaviorSubject<String>(value: LoginButtonText.login)
    
    init(service: LoginServiceProtocol, router: RouterContract, validator: ValidatorProtocol = Validator()) {
        self.service = service
        self.router = router
        self.validator = validator
    }
    
    func observe(email: Observable<String?>, password: Observable<String?>, logInButton: Observable<Void>) {
        weak var weakValidatorReference = validator
        guard let localValidatorReference = weakValidatorReference
            else { return }

        emailValidation = email.map { state in
            localValidatorReference.validateEmail(for: state)
        }
        passwordValidation = password.map { localValidatorReference.validatePassword(for: $0) }
        
        guard let emailValidation = emailValidation, let passwordValidation = passwordValidation
            else { return }
        
        loginButtonActive = Observable.combineLatest(emailValidation, passwordValidation) { (validEmail, validPassword) -> Bool in
            return localValidatorReference.isLoginButtonActive(validEmail: validEmail, validPassword: validPassword)
        }
        
        authenticationData = logInButton
            .withLatestFrom(email.ignoreNil(), password.ignoreNil()) { ($0, $1, $2)}
            .flatMapLatest({ (args) -> Observable<AuthenticationData?> in
                return self.service.loginUser(with: args.1, password: args.2).asObservable()
            })
            .observeOn(MainScheduler.instance)
            .share(replay: 1, scope: .whileConnected)

        authenticationData?
            .subscribe(onNext: { [weak self] authData in
                if let token = authData?.token, !token.isEmpty {
                    self?.router.presentSuccess()
                    self?.loginButtonTextSubject.onNext(LoginButtonText.login)
                } else {
                    self?.loginButtonTextSubject.onNext(LoginButtonText.tryAgain)
                }
                })
            .disposed(by: disposeBag)

        loginButtonText = loginButtonTextSubject.asObservable()

        logInButton.subscribe({ [weak loginButtonTextSubject] _ in
            loginButtonTextSubject?.onNext(LoginButtonText.cancel)
        }).disposed(by: disposeBag)
        
        statusText = authenticationData?
            .map { ($0?.message ?? "") }
    }
}
