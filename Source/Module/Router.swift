import UIKit

protocol RouterContract {
    func presentLogin()
    func presentSuccess()
}

class Router: RouterContract {
    let rootViewController: UINavigationController

    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }

    func presentLogin() {
        let presenter = LoginPresenter(service: LoginService(), router: self)
        let viewController = LoginViewController(presenter: presenter)
        rootViewController.pushViewController(viewController, animated: false)
    }

    func presentSuccess() {
        let viewController = SuccessViewController()
        rootViewController.pushViewController(viewController, animated: true)
    }
}
