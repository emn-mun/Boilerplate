import UIKit
import RxSwift
import RxCocoa

private enum Constants {
    static let defaultMargin: CGFloat = 8
    static let largeMargin: CGFloat = 40
}

class LoginViewController: UIViewController {
    
    private let emailLabel = UILabel()
    private let emailTextField = UITextField()
    
    private let passwordLabel = UILabel()
    private let passwordTextField = UITextField()
    
    private lazy var inputFieldsStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField, passwordLabel, passwordTextField])
    private let loginButton = UIButton(frame: .zero)
    private let activityIndicator = UIActivityIndicatorView()
    private let errorLabel = UILabel()
    
    private let presenter: LoginPresenterContract
    private let disposeBag = DisposeBag()
    
    init(presenter: LoginPresenterContract) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        
        setupViews()
        setupConstraints()
        bindLoginState(presenter: presenter)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LoginViewController {
    func bindLoginState(presenter: LoginPresenterContract) {
        
        let emailObservable = emailTextField.rx.text.distinctUntilChanged().asObservable()
        let passwordObservable = passwordTextField.rx.text.distinctUntilChanged().asObservable()
        let buttonObservable = loginButton.rx.tap.asObservable()
        
        presenter.observe(email: emailObservable, password: passwordObservable, logInButton: buttonObservable)

        presenter.loginButtonText?
            .bind(to: loginButton.rx.title())
            .disposed(by: disposeBag)
        
        presenter.emailValidation?.subscribe(onNext: { [weak self] validationStatus in
            self?.emailTextField.set(validationStatus: validationStatus)
        }).disposed(by: disposeBag)
        
        presenter.passwordValidation?.subscribe(onNext: { [weak self] validationStatus in
            self?.passwordTextField.set(validationStatus: validationStatus)
        }).disposed(by: disposeBag)
        
        presenter.loginButtonActive?
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        presenter.statusText?
            .bind(to: errorLabel.rx.text)
            .disposed(by: disposeBag)

        buttonObservable
            .map { return true }
            .bind(to: activityIndicator.rx.isAnimating)
        .disposed(by: disposeBag)

        presenter.statusText?
            .map { _ in return false }
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}

// MARK: - Setup Views
private extension LoginViewController {
    func setupViews() {
        let subviews = [inputFieldsStackView, loginButton, activityIndicator, errorLabel]
        view.addSubviews(subviews)
        subviews.removeAutoresizingMaskConstraints()

        errorLabel.numberOfLines = 0
        
        inputFieldsStackView.axis = .vertical
        inputFieldsStackView.spacing = Constants.defaultMargin
        
        loginButton.setTitleColor(.systemBlue, for: .normal)
        loginButton.setTitleColor(.lightGray, for: .disabled)
        
        emailLabel.text = "Enter email"
        passwordLabel.text = "Enter password"
        
        emailTextField.layer.borderWidth = 2
        passwordTextField.layer.borderWidth = 2
        
        emailTextField.textColor = .darkGray
        passwordTextField.textColor = .darkGray
        
        emailTextField.borderStyle = .roundedRect
        passwordTextField.borderStyle = .roundedRect
        
        emailTextField.textAlignment = .center
        passwordTextField.textAlignment = .center
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            inputFieldsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultMargin),
            inputFieldsStackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: Constants.largeMargin),
            inputFieldsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultMargin),
            
            loginButton.topAnchor.constraint(equalTo: inputFieldsStackView.bottomAnchor, constant: Constants.largeMargin),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            activityIndicator.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: Constants.largeMargin),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.defaultMargin),
            errorLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: Constants.defaultMargin),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.defaultMargin),
        ])
    }
}
