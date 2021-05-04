// The last of three pushed views. This view displays a graph of randomly generated sleep data, and a control allowing the user to set a personal sleep goal.

import SwiftUI

class SLPTrendView: SLPInsightView {
    
    lazy var goalAdjustmentView = SLPTrendGoalAdjustmentView()
    
    private lazy var graphView: UIView = {
        let hostingController = UIHostingController(rootView: GraphView(data: UserData.shared.graphData))
        hostingController.view.backgroundColor = .clear
        return hostingController.view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        title = "Sleep Trends"
        symbol = "bed.double.fill"
        tintColor = .systemOrange
        
        configureSubviews()
        prepareConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWasPushed() {

        // Re-animate the art view.
        UserData.shared.graphData.active = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 1.25)) {
                UserData.shared.graphData.active = false
            }
        }
        
        goalAdjustmentView.mode = .button
    }
    
    // MARK: Instance Methods
    
    private func configureSubviews() {
        contentView.addSubview(graphView)
        contentView.addSubview(goalAdjustmentView)
    }
    
    private func prepareConstraints() {
        graphView.translatesAutoresizingMaskIntoConstraints = false
        goalAdjustmentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            graphView.topAnchor.constraint(equalTo: _titleLabel.bottomAnchor, constant: 16),
            graphView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            graphView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            graphView.heightAnchor.constraint(equalToConstant: 156),
            
            goalAdjustmentView.topAnchor.constraint(equalTo: graphView.bottomAnchor, constant: 20),
            goalAdjustmentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            goalAdjustmentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            goalAdjustmentView.heightAnchor.constraint(equalToConstant: 84)
        ])
    }
}
