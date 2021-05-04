// The first of three pushed views. This view displays the Starry Night art view, and describes the phases of sleep.

import SwiftUI

class SLPAboutView: SLPInsightView {
    
    private let scrollView = UIScrollView()
    let separator = UIView()
    
    lazy var gradientMaskLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
        layer.mask = gradientLayer
        return gradientLayer
    }()
    
    let starryNightData = StarryNightData()
    private lazy var starryNightView: UIView = {
        let hostingController = UIHostingController(rootView: StarryNightView(data: starryNightData))
        hostingController.view.backgroundColor = .clear
        return hostingController.view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        title = "What happens during sleep?"
        symbol = "questionmark.circle.fill"
        tintColor = .systemIndigo
        
        configureSubviews()
        prepareConstraints()
        prepareScrollViewContent()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWasPushed() {
        scrollView.contentOffset.y = 0
        
        starryNightData.starsVisible = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring(response: 0.75, dampingFraction: 0.9)) {
                self.starryNightData.starsVisible = true
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
        contentView.addSubview(starryNightView)
        contentView.addSubview(scrollView)
        contentView.addSubview(separator)
        
        scrollView.delegate = self
        scrollView.contentInset.bottom = 48
        scrollView.scrollIndicatorInsets.bottom = 48
        
        separator.backgroundColor = .separator
        separator.alpha = 0
    }
    
    private func prepareConstraints() {
        
        starryNightView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            starryNightView.topAnchor.constraint(equalTo: _titleLabel.bottomAnchor, constant: 16),
            starryNightView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            starryNightView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            starryNightView.heightAnchor.constraint(equalToConstant: 116),
            
            scrollView.topAnchor.constraint(equalTo: starryNightView.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            separator.topAnchor.constraint(equalTo: starryNightView.bottomAnchor, constant: 16),
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale)
        ])
    }
    
    private func prepareScrollViewContent() {
        
        let introLabel = createIntroLabel()
        introLabel.text = "A healthy sleep schedule affects how you look, feel and perform throughout the day."
        scrollView.addSubview(introLabel)
        
        let n1Header = createSleepStageHeader(shortTitle: "N1", title: "Light Sleep")
        scrollView.addSubview(n1Header)
        
        let n1DescriptionLabel = createDescriptionLabel()
        n1DescriptionLabel.text = "During the first stage of sleep, your body transitions in and out of sleep. At this time, it is very easy to be woken up."
        scrollView.addSubview(n1DescriptionLabel)
        
        let n2Header = createSleepStageHeader(shortTitle: "N2", title: "Onset of Sleep")
        scrollView.addSubview(n2Header)
        
        let n2DescriptionLabel = createDescriptionLabel()
        n2DescriptionLabel.text = "During the second stage of sleep, you become disengaged from your surroundings, and your body temperature drops. Your metabolism is regulated and your memories and emotions are processed."
        scrollView.addSubview(n2DescriptionLabel)
        
        let n3Header = createSleepStageHeader(shortTitle: "N3", title: "Deep Sleep")
        scrollView.addSubview(n3Header)
        
        let n3DescriptionLabel = createDescriptionLabel()
        n3DescriptionLabel.text = "The third stage of sleep is the deepest and most physically restorative sleep stage. During this stage, your muscles are relaxed and your breathing slows down. Tissue growth and repair occurs, and energy is restored."
        scrollView.addSubview(n3DescriptionLabel)
        
        let remHeader = createSleepStageHeader(shortTitle: "REM", title: "Rapid Eye Movement")
        scrollView.addSubview(remHeader)
        
        let remDescriptionLabel = createDescriptionLabel()
        remDescriptionLabel.text = "REM sleep accounts for approximately 25% of sleep time and occurs in intervals throughout the night. During this stage, your eyes dart back and forth, your brain is active, and dreams occur. Your muscles shut down, causing immobility.  This is when energy is supplied to the brain and body, preparing you for daytime performance."
        scrollView.addSubview(remDescriptionLabel)
        
        introLabel.translatesAutoresizingMaskIntoConstraints = false
        n1Header.translatesAutoresizingMaskIntoConstraints = false
        n1DescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        n2Header.translatesAutoresizingMaskIntoConstraints = false
        n2DescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        n3Header.translatesAutoresizingMaskIntoConstraints = false
        n3DescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        remHeader.translatesAutoresizingMaskIntoConstraints = false
        remDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            introLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            introLabel.widthAnchor.constraint(equalToConstant: kContainerWidth - 12),
            introLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            
            n1Header.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            n1Header.widthAnchor.constraint(equalToConstant: kContainerWidth - 12),
            n1Header.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: 28),
            n1Header.heightAnchor.constraint(equalToConstant: 30),
            
            n1DescriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            n1DescriptionLabel.widthAnchor.constraint(equalToConstant: kContainerWidth - 12),
            n1DescriptionLabel.topAnchor.constraint(equalTo: n1Header.bottomAnchor, constant: 12),
            
            n2Header.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            n2Header.widthAnchor.constraint(equalToConstant: kContainerWidth - 12),
            n2Header.topAnchor.constraint(equalTo: n1DescriptionLabel.bottomAnchor, constant: 28),
            n2Header.heightAnchor.constraint(equalToConstant: 30),
            
            n2DescriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            n2DescriptionLabel.widthAnchor.constraint(equalToConstant: kContainerWidth - 12),
            n2DescriptionLabel.topAnchor.constraint(equalTo: n2Header.bottomAnchor, constant: 12),
            
            n3Header.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            n3Header.widthAnchor.constraint(equalToConstant: kContainerWidth - 12),
            n3Header.topAnchor.constraint(equalTo: n2DescriptionLabel.bottomAnchor, constant: 28),
            n3Header.heightAnchor.constraint(equalToConstant: 30),
            
            n3DescriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            n3DescriptionLabel.widthAnchor.constraint(equalToConstant: kContainerWidth - 12),
            n3DescriptionLabel.topAnchor.constraint(equalTo: n3Header.bottomAnchor, constant: 12),
            
            remHeader.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            remHeader.widthAnchor.constraint(equalToConstant: kContainerWidth - 12),
            remHeader.topAnchor.constraint(equalTo: n3DescriptionLabel.bottomAnchor, constant: 28),
            remHeader.heightAnchor.constraint(equalToConstant: 30),
            
            remDescriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            remDescriptionLabel.widthAnchor.constraint(equalToConstant: kContainerWidth - 12),
            remDescriptionLabel.topAnchor.constraint(equalTo: remHeader.bottomAnchor, constant: 12),
            
            scrollView.bottomAnchor.constraint(equalTo: remDescriptionLabel.bottomAnchor)
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
    
    func createSleepStageHeader(shortTitle: String, title: String) -> UIView {
        let hostingController = UIHostingController(rootView: SleepStageHeader(shortTitle: shortTitle, title: title))
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

fileprivate struct SleepStageHeader: View {
    let shortTitle: String
    let title: String
    
    var body: some View {
        
        HStack() {
            ZStack() {
                if shortTitle.count <= 2 {
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                } else {
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .frame(width: 48, height: 30)
                        .foregroundColor(.blue)
                }
                Text(shortTitle)
                    .font(Font.system(size: 15, design: .rounded).weight(.semibold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
            Text(title)
                .font(Font.system(size: fmin(UIFont.preferredFont(forTextStyle: .body).pointSize, 22)).weight(.medium))
            Spacer()
        }
    }
}

extension SLPAboutView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        separatorVisible = self.scrollView.contentOffset.y > 0
    }
}
