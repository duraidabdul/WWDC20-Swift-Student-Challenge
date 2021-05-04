// This controller is in charge of displaying the three SLPHomeButtons and SLPNavigationBar. It also handles certain components of the navigation system.

import SwiftUI

let kNavigationViewOffset: CGFloat = 236
let kContainerWidth: CGFloat = 328

public class SLPHomeViewController: UIViewController {
    
    private let aboutButton = SLPHomeButton()
    private lazy var aboutView = preparePushedView(SLPAboutView())
    
    private let healthButton = SLPHomeButton()
    private lazy var healthView = preparePushedView(SLPHealthView())
    
    private let discoveryButton = SLPHomeButton()
    private lazy var discoveryView = preparePushedView(SLPTrendView())
    
    private let navigationBar = SLPNavigationBar()
    
    private let sizeWarningView: UIView = {
        let hostingController = UIHostingController(rootView: SizeWarningView())
        hostingController.view.backgroundColor = .clear
        return hostingController.view
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .localBackground
        
        configureSubviews()
        prepareConstraints()
    }
    
    override public func viewDidLayoutSubviews() {
        sizeWarningView.isHidden = view.bounds.height > 500
    }
    
    // MARK: Observed Properties
    
    public enum ViewState {
        case visible, pushed
    }
    public var state: ViewState = .visible {
        didSet {
            guard oldValue != state else { return }
            
            // Use this array to simplify animation blocks.
            let buttons = [aboutButton, healthButton, discoveryButton]
            
            switch state {
                case .visible:
                    UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.8) {
                        buttons.forEach { $0.alpha = 1 }
                        buttons[1].offset(x: 0)
                    }.startAnimation()
                    
                    // Lag second small button's animation behind the first one to create a playful elastic catch-up effect.
                    UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.8) {
                        buttons[0].offset(x: 0)
                    }.startAnimation()
                
                    // Lag the large button's animation to convey the "weight" of the larger view.
                    UIViewPropertyAnimator(duration: 0.45, dampingRatio: 0.8) {
                        buttons[2].offset(x: 0)
                    }.startAnimation()
                case .pushed:
                    UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.8) {
                        buttons.forEach { $0.offset(x: -kContainerWidth); $0.alpha = -0.5 }
                    }.startAnimation()
            }
        }
    }
    
    // MARK: Instance Methods
    
    private func configureSubviews() {
        view.addSubview(aboutButton)
        view.addSubview(healthButton)
        view.addSubview(discoveryButton)
        view.addSubview(navigationBar)
        view.addSubview(sizeWarningView)
        
        aboutButton.title = "What happens during sleep?"
        aboutButton.symbol = "questionmark.circle.fill"
        aboutButton.tintColor = .systemIndigo
        aboutButton.addTarget(self, action: #selector(presentAboutView), for: .touchUpInside)
        
        healthButton.title = "Good Sleep Habits"
        healthButton.accessibilityHint = "Find more information how we should sleep to stay healthy"
        healthButton.symbol = "heart.fill"
        healthButton.tintColor = .systemPink
        healthButton.addTarget(self, action: #selector(presentHealthView), for: .touchUpInside)
        
        discoveryButton.title = "Sleep Trends"
        discoveryButton.symbol = "bed.double.fill"
        discoveryButton.contentText = "You slept more than 8 hours last night! Keep it up!"
        discoveryButton.tintColor = .systemOrange
        discoveryButton.addTarget(self, action: #selector(presentDiscoveryView), for: .touchUpInside)
        
        navigationBar.parentHomeViewController = self
    }
    
    private func prepareConstraints() {
        aboutButton.translatesAutoresizingMaskIntoConstraints = false
        healthButton.translatesAutoresizingMaskIntoConstraints = false
        discoveryButton.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        sizeWarningView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            aboutButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -8),
            aboutButton.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -8),
            aboutButton.heightAnchor.constraint(equalToConstant: 156),
            aboutButton.widthAnchor.constraint(equalTo: healthButton.heightAnchor),
            
            healthButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 8),
            healthButton.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -8),
            healthButton.heightAnchor.constraint(equalToConstant: 156),
            healthButton.widthAnchor.constraint(equalTo: healthButton.heightAnchor),
            
            discoveryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            discoveryButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: 8),
            discoveryButton.heightAnchor.constraint(equalToConstant: 156),
            discoveryButton.widthAnchor.constraint(equalTo: healthButton.heightAnchor, multiplier: 2, constant: 16),
            
            navigationBar.leadingAnchor.constraint(equalTo: aboutButton.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: healthButton.trailingAnchor),
            navigationBar.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -kNavigationViewOffset),
            navigationBar.heightAnchor.constraint(equalToConstant: 32),
            
            sizeWarningView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            sizeWarningView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sizeWarningView.heightAnchor.constraint(equalToConstant: 30),
            sizeWarningView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc private func presentAboutView() {
        presentView(aboutView)
    }
    
    @objc private func presentHealthView() {
        presentView(healthView)
    }
    
    @objc private func presentDiscoveryView() {
        presentView(discoveryView)
    }
    
    func presentView(_ view: SLPPushedView) {
        guard state == .visible else { return }
        
        state = .pushed
        
        view.pushView()
        navigationBar.currentlyPushedView = view
    }
}

extension SLPHomeViewController {
    /** Animate the views in! */
    public func welcomeToMyPlayground() {
        
        // Prepare views for animation.
        aboutButton.scale(1.1)
        healthButton.scale(1.125)
        discoveryButton.scale(1.15)
        
        aboutButton.alpha = 0
        healthButton.alpha = -0.2
        discoveryButton.alpha = -0.4
        navigationBar.alpha = -1
        
        // Use this set to simplify animation blocks.
        let buttons: Set = [aboutButton, healthButton, discoveryButton]
        
        // Animate views in.
        UIViewPropertyAnimator(duration: 1.1, dampingRatio: 0.5) {
            buttons.forEach { $0.scale(1) }
        }.startAnimation(afterDelay: 0.7)
        
        UIViewPropertyAnimator(duration: 1.25, dampingRatio: 1) { 
            buttons.forEach { $0.alpha = 1 }
            self.navigationBar.alpha = 1
        }.startAnimation(afterDelay: 0.7)
    }
}

extension SLPHomeViewController {
    
    // Prepare some generic information view before being displayed for the first time. This will typically be a subclass of SLPInformationView.
    private func preparePushedView(_ pushedView: SLPPushedView) -> SLPPushedView {
        view.insertSubview(pushedView, belowSubview: navigationBar)
        pushedView.navigationBar = navigationBar
        
        pushedView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pushedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pushedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pushedView.topAnchor.constraint(equalTo: view.topAnchor),
            pushedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return pushedView
    }
}
