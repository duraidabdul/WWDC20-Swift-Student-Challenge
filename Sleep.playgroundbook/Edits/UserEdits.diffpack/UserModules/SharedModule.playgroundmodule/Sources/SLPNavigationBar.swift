// This view displays the navigation bar contents, which include a back button and a profile view.

import SwiftUI

class SLPNavigationBar: UIView {
    
    // Weak reference to the parent home view controller to allow for quick, direct communication to the controller.
    weak var parentHomeViewController: SLPHomeViewController?
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(UIImage(systemName: "chevron.left")!.withConfiguration(UIImage.SymbolConfiguration(weight: .semibold)), for: .normal)
        button.setTitle(" Back", for: .normal)
        
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        button.titleLabel?.font = fontMetrics.scaledFont(for: .systemFont(ofSize: 17), maximumPointSize: 24)
        
        button.addTarget(self, action: #selector(requestBackAction), for: .touchUpInside)
        
        return button
    }()
    
    private let profileView: UIView = {
        let hostingController = UIHostingController(rootView: ProfileView(userData: UserData.shared))
        hostingController.view.backgroundColor = .clear
        return hostingController.view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSubviews()
        prepareConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Observed Properties
    weak var currentlyPushedView: SLPPushedView? {
        didSet {
            guard oldValue != currentlyPushedView else { return }
            
            if currentlyPushedView != nil {
                backButton.titleLabel!.offset(x: 30)
            }
            
            UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1) {
                self.backButton.alpha = (self.currentlyPushedView != nil) ? 1 : 0
                self.backButton.offset(x: (self.currentlyPushedView != nil) ? 0 : 40)
                self.backButton.titleLabel!.offset(x: 0)
            }.startAnimation()
        }
    }
    
    // MARK: Instance Methods
    
    private func configureSubviews() {
        addSubview(profileView)
        addSubview(backButton)
        
        backButton.offset(x: 40)
        backButton.alpha = 0
    }
    
    private func prepareConstraints() {
        backButton.translatesAutoresizingMaskIntoConstraints = false
        profileView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            profileView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc public func requestBackAction() {
        guard let viewToDismiss = currentlyPushedView else { return }
        
        currentlyPushedView?.dismissView()
        currentlyPushedView = nil
        parentHomeViewController?.state = .visible
    }
}
