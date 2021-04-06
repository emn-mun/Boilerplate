import UIKit

class SuccessViewController: UIViewController {
    private let greetingLabel = UILabel(frame: .zero)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        setupGreetingLabel()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupGreetingLabel() {
        greetingLabel.text = "hello."
        view.addSubview(greetingLabel)
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            greetingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
