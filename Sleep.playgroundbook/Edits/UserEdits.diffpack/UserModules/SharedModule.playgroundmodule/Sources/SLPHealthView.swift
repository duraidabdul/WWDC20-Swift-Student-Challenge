// The second of three pushed views. This view displays the Illumination art view, and presents tips for maintaining a healthy sleep schedule.

import SwiftUI

class SLPHealthView: SLPInsightView {
    
    private let scrollView = UIScrollView()
    let separator = UIView()
    
    lazy var gradientMaskLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        layer.mask = gradientLayer
        return gradientLayer
    }()
    
    let illuminationData = IlluminationData()
    private lazy var illuminationView: UIView = {
        let hostingController = UIHostingController(rootView: IlluminationView(data: illuminationData))
        hostingController.view.backgroundColor = .clear
        return hostingController.view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        title = "Good Sleep Habits"
        symbol = "heart.fill"
        tintColor = .systemPink
        
        configureSubviews()
        prepareConstraints()
        prepareScrollViewContent()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWasPushed() {
        // Reset the scroll view.
        scrollView.contentOffset.y = 0
        
        // Re-animate the art view.
        illuminationData.illuminated = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 1.25)) {
                self.illuminationData.illuminated = false
            }
        }
    }
    
    override func layoutSubviews() {
        gradientMaskLayer.frame = bounds
        let fractionalOffset = Float(1 - 48 / bounds.height)
        gradientMaskLayer.locations = [0, NSNumber(value: fractionalOffset), 1]
    }
    
    // MARK: Observed Properties
    
    private var separatorVisible = false {
        willSet {
            guard separatorVisible != newValue else { return }
            
            UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1) {
                self.separator.alpha = newValue ? 1 : 0
            }.startAnimation()
        }
    }
    
    // MARK: Instance Methods
    
    private func configureSubviews() {
        contentView.addSubview(illuminationView)
        contentView.addSubview(scrollView)
        contentView.addSubview(separator)
        
        scrollView.delegate = self
        scrollView.contentInset.bottom = 48
        scrollView.scrollIndicatorInsets.bottom = 48
        
        separator.backgroundColor = .separator
        separator.alpha = 0
    }
    
    private func prepareConstraints() {
        illuminationView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            illuminationView.topAnchor.constraint(equalTo: _titleLabel.bottomAnchor, constant: 16),
            illuminationView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            illuminationView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            illuminationView.heightAnchor.constraint(equalToConstant: 116),
            
            scrollView.topAnchor.constraint(equalTo: illuminationView.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            separator.topAnchor.constraint(equalTo: illuminationView.bottomAnchor, constant: 16),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])
    }
    
    private func prepareScrollViewContent() {
        let introLabel = createIntroLabel()
        introLabel.text = "If you often find it difficult to maintain a good sleep schedule, here are some tips that can help you get on track."
        scrollView.addSubview(introLabel)
        
        let header1 = createHealthHeader(symbol: "bed.double.fill", color: .orange, title: "Commit to a regular bedtime")
        scrollView.addSubview(header1)
        
        let description1 = createDescriptionLabel()
        description1.text = "To help regulate your body's internal clock, or circadian rhythm, it is important to sleep and wake up at the same time every night."
        scrollView.addSubview(description1)
        
        let header2 = createHealthHeader(symbol: "lightbulb.slash.fill", color: .gray, title: "Lights out! Even your phone.")
        scrollView.addSubview(header2)
        
        let description2 = createDescriptionLabel()
        description2.text = "Too much light before sleep prevents your body from releasing melatonin, the hormone that makes you feel tired. This makes it harder to fall asleep, and also reduces your total amount of REM sleep overnight."
        scrollView.addSubview(description2)
        
        let header3 = createHealthHeader(symbol: "bolt.slash.fill", color: Color(.systemTeal), title: "Avoid Power Naps")
        scrollView.addSubview(header3)
        
        let description3 = createDescriptionLabel()
        description3.text = "Taking too many naps during the day, especially in the afternoon, can make it difficult to fall asleep at night."
        scrollView.addSubview(description3)
        
        introLabel.translatesAutoresizingMaskIntoConstraints = false
        header1.translatesAutoresizingMaskIntoConstraints = false
        description1.translatesAutoresizingMaskIntoConstraints = false
        header2.translatesAutoresizingMaskIntoConstraints = false
        description2.translatesAutoresizingMaskIntoConstraints = false
        header3.translatesAutoresizingMaskIntoConstraints = false
        description3.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            introLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            introLabel.widthAnchor.constraint(equalToConstant: kContainerWidth - 12),
            introLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            
            header1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            header1.widthAnchor.constraint(equalToConstant: kContainerWidth - 12),
            header1.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: 28),
            header1.heightAnchor.constraint(equalToConstant: 30),
            
            description1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            description1.widthAnchor.constraint(equalToConstant: kContainerWidth - 12),
            description1.topAnchor.constraint(equalTo: header1.bottomAnchor, constant: 12),
            
            header2.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            header2.widthAnchor.constraint(equalToConstant: kContainerWidth - 12),
            header2.topAnchor.constraint(equalTo: description1.bottomAnchor, constant: 28),
            header2.heightAnchor.constraint(equalToConstant: 30),
            
            description2.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            description2.widthAnchor.constraint(equalToConstant: kContainerWidth - 12),
            description2.topAnchor.constraint(equalTo: header2.bottomAnchor, constant: 12),
            
            header3.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            header3.widthAnchor.constraint(equalToConstant: kContainerWidth - 12),
            header3.topAnchor.constraint(equalTo: description2.bottomAnchor, constant: 28),
            header3.heightAnchor.constraint(equalToConstant: 30),
            
            description3.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            description3.widthAnchor.constraint(equalToConstant: kContainerWidth - 12),
            description3.topAnchor.constraint(equalTo: header3.bottomAnchor, constant: 12),
            
            scrollView.bottomAnchor.constraint(equalTo: description3.bottomAnchor)
        ])
    }
    
    func createIntroLabel() -> UILabel {
        let label = UILabel()
        let font = UIFont.systemFont(ofSize: 17, weight: .medium)
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        label.font = fontMetrics.scaledFont(for: font, maximumPointSize: 24)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }
    
    func createHealthHeader(symbol: String, color: Color, title: String) -> UIView {
        let hostingController = UIHostingController(rootView: HealthHeader(symbol: symbol, color: color, title: title))
        hostingController.view.backgroundColor = .clear
        return hostingController.view
    }
    
    func createDescriptionLabel() -> UILabel {
        let label = UILabel()
        let font = UIFont.systemFont(ofSize: 17, weight: .regular)
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        label.font = fontMetrics.scaledFont(for: font, maximumPointSize: 24)
        label.numberOfLines = 0
        return label
    }
}

fileprivate struct HealthHeader: View {
    let symbol: String
    let color: Color
    let title: String
    
    var body: some View {
        
        HStack() {
            ZStack() {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(color)
                Image(systemName: symbol)
                    .font(Font.system(size: 15, design: .rounded).weight(.regular))
                    .foregroundColor(.white)
                    // Fix the lightbulb.slash.fill symbol's deviation from teh center.
                    .offset(x: symbol == "lightbulb.slash.fill" ? -1 : 0)
            }
            Text(title)
                .font(Font.system(size: fmin(UIFont.preferredFont(forTextStyle: .body).pointSize, 22)).weight(.medium))
            Spacer()
        }
    }
}

extension SLPHealthView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        separatorVisible = self.scrollView.contentOffset.y > 0
    }
}
