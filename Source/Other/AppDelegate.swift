import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let window = UIWindow()
    private var router: RouterContract!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let rootViewController = UINavigationController()
        router = Router(rootViewController: rootViewController)

        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        window.backgroundColor = .white
        router.presentLogin()
        
        return true
    }
}
