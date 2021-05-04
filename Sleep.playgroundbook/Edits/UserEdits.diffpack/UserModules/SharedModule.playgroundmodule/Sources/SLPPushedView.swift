// This view handles interactive navigation, allowing the user to swipe back to the previous view.

import UIKit

/// This view works with an SLPNavigationBar, allowing for an interactive back-swipe gesture. To handle a completed back gesture, see SLPNavigationBar.
class SLPPushedView: UIView {
    
    /// Weak reference to the navigation bar to allow for quick, direct communication to the view.
    weak var navigationBar: SLPNavigationBar?
    
    private let possibleEndpoints: [CGPoint] = [CGPoint(x: 0, y: 0), CGPoint(x: kContainerWidth, y: 0)]
    
    /// The view where content should be placed, and is sized based on the given constant container size.
    let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        alpha = 0
        
        let interactivePopGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleInteractivePop(recognizer:)))
        addGestureRecognizer(interactivePopGestureRecognizer)
        
        offset(x: kContainerWidth)
        
        configureSubviews()
        prepareConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Instance Methods
    
    private func configureSubviews() {
        addSubview(contentView)
    }
    
    private func prepareConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.widthAnchor.constraint(equalToConstant: kContainerWidth),
            contentView.topAnchor.constraint(equalTo: centerYAnchor, constant: -kNavigationViewOffset + 32),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func pushView() {
        UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1) {
            self.offset(x: 0)
            self.alpha = 1
        }.startAnimation()
        
        viewWasPushed()
    }
    
    /// This view was pushed, and is now visible.
    func viewWasPushed() { /* To be overriden in a subclass */ }
    
    func dismissView() {
        UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1) {
            self.offset(x: kContainerWidth)
        }.startAnimation()
        
        UIViewPropertyAnimator(duration: 0.25, dampingRatio: 1) {
            self.alpha = 0
        }.startAnimation()
        
        viewWasDismissed()
    }
    
    /// This view was pushed, and is now visible.
    func viewWasDismissed() { /* To be overriden in a subclass */ }
    
    // MARK: Pan Gesture Handler
    
    // Recognizer handler in charge of moving the view when panned, predicting and targeting the correct animation endpoints and animating the view.
    @objc private func handleInteractivePop(recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self)
        
        switch recognizer.state {
        case .began, .possible:
            offset(x: translation.x)
            if translation.x > 0 {
                navigationBar?.backButton.offset(x: translation.x / 20)
            } else {
                navigationBar?.backButton.offset(x: 0)
            }
        case .changed:
            offset(x: translation.x)
            if translation.x > 0 {
                navigationBar?.backButton.offset(x: translation.x / 20)
            } else {
                navigationBar?.backButton.offset(x: 0)
            }
        case .cancelled, .failed, .ended:
            
            let velocity = recognizer.velocity(in: self)
            
            // After the object is thrown, determine the best endpoint and target the view there.
            let decelerationRate = UIScrollView.DecelerationRate.normal.rawValue
            
            // This is the predicted endpoint of the gesture. If this was an endless scroll view, this point is where that scroll view would naturally come to a stop.
            let projectedPosition = CGPoint(
                x: translation.x + project(initialVelocity: velocity.x,
                                           decelerationRate: decelerationRate),
                y: 0)
            
            let nearestTargetPosition = nearestTargetTo(projectedPosition,
                                                        possibleEndpoints: possibleEndpoints)
            
            // Perform initial velocity animation for main view.
            let initialVelocity = initialAnimationVelocity(for: velocity,
                                                           from: CGPoint(x: translation.x,y: 0),
                                                           to: nearestTargetPosition)
            
            let timingParameters = UISpringTimingParameters(damping: 1,
                                                            response: 0.4,
                                                            initialVelocity: initialVelocity)
            
            let positionAnimator = UIViewPropertyAnimator(duration: 0,
                                                          timingParameters: timingParameters)
            positionAnimator.addAnimations {
                self.offset(x: nearestTargetPosition.x, y: 0)
            }
            positionAnimator.startAnimation()
            
            if nearestTargetPosition == possibleEndpoints[1] {
                navigationBar?.requestBackAction()
            } else {
                UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.8) {
                    self.navigationBar?.backButton.offset(x: 0)
                }.startAnimation()
            }
        @unknown default:
            break
        }
    }
    
    
}
