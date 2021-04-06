import Foundation
import RxSwift

final class SuccessPresenter {
    private let router: RouterContract
    
    init(router: RouterContract) {
        self.router = router
    }
}

extension SuccessPresenter: SuccessPresenterContract {
    
    func viewDidLoad() {
        // do something
    }
    
    func viewWillAppear() {
        // do something
    }
}
