// This view displays a custom control that allows the user to change their desired sleep goal.

import SwiftUI

class SLPTrendGoalAdjustmentView: UIView {
    
    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .label
        button.setTitle("Adjust Goal", for: .normal)
        let font = UIFont.systemFont(ofSize: 17, weight: .medium)
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        button.titleLabel?.font = fontMetrics.scaledFont(for: font, maximumPointSize: 22)
        button.setTitleColor(.systemBackground, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.cornerCurve = .continuous
        button.addTarget(self,
                         highlightAction: #selector(buttonHighlightAction),
                         unhighlightAction: #selector(buttonUnhighlightAction))
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    let buttonFooter: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = "If you find it difficult to achieve your sleep goal, you can adjust it here."
        let font = UIFont.systemFont(ofSize: 15)
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        label.font = fontMetrics.scaledFont(for: font, maximumPointSize: 22)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var goalAdjustmentControl: UIView = {
        let hostingController = UIHostingController(rootView: GoalAdjustmentControl(data: UserData.shared.graphData))
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
    enum Mode {
        case button, stepper
    }
    var mode = Mode.button {
        didSet {
            guard oldValue != mode else { return }
            
            if mode == .stepper {
                
                goalAdjustmentControl.scale(0.9)
                
                UIViewPropertyAnimator(duration: 0.75, dampingRatio: 1) {
                    self.button.alpha = -1
                    self.goalAdjustmentControl.alpha = 1
                    self.goalAdjustmentControl.scale(1)
                }.startAnimation()
            } else {
                button.alpha = 1
                goalAdjustmentControl.alpha = -1
            }
        }
    }
    
    // MARK: Instance Methods
    
    private func configureSubviews() {
        addSubview(button)
        addSubview(buttonFooter)
        addSubview(goalAdjustmentControl)
        
        goalAdjustmentControl.alpha = 0
    }
    
    private func prepareConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        buttonFooter.translatesAutoresizingMaskIntoConstraints = false
        goalAdjustmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.heightAnchor.constraint(equalToConstant: 44),
            
            buttonFooter.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonFooter.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonFooter.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10),
            
            goalAdjustmentControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            goalAdjustmentControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            goalAdjustmentControl.topAnchor.constraint(equalTo: topAnchor),
            goalAdjustmentControl.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    @objc func buttonHighlightAction() {
        UIViewPropertyAnimator(duration: 0.2, dampingRatio: 1) {
            self.button.alpha = 0.5
        }.startAnimation()
    }
    
    @objc func buttonUnhighlightAction() {
        UIViewPropertyAnimator(duration: 1, dampingRatio: 1) {
            self.button.alpha = 1
        }.startAnimation()
    }
    
    @objc func buttonAction() {
        mode = .stepper
    }
}

fileprivate struct GoalAdjustmentControl: View {
    @ObservedObject var data: GraphData
    
    var body: some View {
        VStack() {
            HStack() {
                Text("Sleep Goal")
                    .font(.system(size: fmin(UIFont.preferredFont(forTextStyle: .body).pointSize, 19)))
                Spacer()
                Text("\(data.sleepGoal) h")
                    .font(.system(size: fmin(UIFont.preferredFont(forTextStyle: .body).pointSize, 19), design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Stepper(value: $data.sleepGoal, in: 6...9) {
                    Text("")
                }
                .accessibility(label: Text("Sleep Goal"))
            }
            
        }
    }
}
