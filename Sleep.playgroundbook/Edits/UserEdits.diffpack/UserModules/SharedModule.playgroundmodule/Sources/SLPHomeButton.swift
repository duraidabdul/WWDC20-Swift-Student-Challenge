// This view handles the layout of given symbols and text into a rounded rectangle to be displayed on the home screen.

import UIKit

class SLPHomeButton: UIButton {
    
    // Colored views describing the button's purpose.
    private let _symbolImageView = UIImageView()
    private let _titleLabel = UILabel()
    
    // Optional view that can display a body of text at the bottom of the view. Only initialized if needed.
    private lazy var _contentLabel: UILabel = configureContentLabel()
    
    // Reference for all constraints associated with the title label, as they may need to be removed later on.
    private var _titleLabelConstraints: [NSLayoutConstraint]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .localElevated
        
        // Apply rounded corners with smooth tangency to this view.
        layer.cornerRadius = 16
        layer.cornerCurve = .continuous
        
        configureActions()
        configureSubviews()
        prepareConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Hide the glyph image if text is too large.
        if _titleLabel.bounds.height > 90 {
            _symbolImageView.alpha = 0
        }
    }
    
    // MARK: Observed Properties
    
    /** An SF Symbol descriptor for a symbol describing the button's purpose. */
    var symbol: String? {
        didSet { _symbolImageView.image = symbol != nil ? UIImage(systemName: symbol!)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24)) : nil }
    }
    
    /** A title describing the button's purpose. */
    var title: String? {
        didSet {
            _titleLabel.text = title
            accessibilityLabel = title
        }
    }
    
    /** This optional text will display at the bottom of the view. */
    var contentText: String? {
        didSet { _contentLabel.text = contentText }
    }
    
    override var tintColor: UIColor! {
        didSet {
            _titleLabel.textColor = tintColor
            _symbolImageView.tintColor = tintColor
        }
    }
    
    // MARK: Instance Methods
    
    private func configureSubviews() {
        addSubview(_symbolImageView)
        addSubview(_titleLabel)
        
        _titleLabel.numberOfLines = 0
        
        // Use font metrics to keep this custom text style accessible.
        let font = UIFont.systemFont(ofSize: 17, weight: .medium)
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        _titleLabel.font = fontMetrics.scaledFont(for: font, maximumPointSize: 24)
    }
    
    private func prepareConstraints() {
        _symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        _titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        _titleLabelConstraints = [
            _titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            _titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            _titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate([
            _symbolImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            _symbolImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16)
        ] + _titleLabelConstraints!)
    }
    
    private func configureActions() {
        // Our helper function defined in "Extensions.swift" is used to easily add button highlight actions to the view.
        addTarget(self, highlightAction: #selector(highlight), unhighlightAction: #selector(unhighlight))
    }
    
    @objc private func highlight() {
        // Note: A faster animation is used for the highlight action to convey responsiveness.
        UIViewPropertyAnimator(duration: 0.1, dampingRatio: 1) { 
            self.backgroundColor = .localElevatedHighlighted
        }.startAnimation()
        
        UIViewPropertyAnimator(duration: 0.25, dampingRatio: 1) { 
            self.scale(0.985)
        }.startAnimation()
    }
    
    @objc private func unhighlight() {
        // Note: A slower animation is used for the unhighlight action because fast responsiveness is not needed when unhighlighting a view.
        UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1) { 
            self.backgroundColor = .localElevated
        }.startAnimation()
        
        UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.75) {
            self.scale(1)
        }.startAnimation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Extend SLPHomeButton to allow for organized initializtion of the content label, if it is needed.
extension SLPHomeButton {
    private func configureContentLabel() -> UILabel {
        let _contentLabel = UILabel()
        
        // Color that is slightly darker than systemGray and secondaryLabel to improve legibility.
        _contentLabel.textColor = UIColor.label.withAlphaComponent(0.58)
        _contentLabel.numberOfLines = 0
        
        // Use font metrics to keep this custom text style accessible.
        let font = UIFont.systemFont(ofSize: 17, weight: .medium, design: .rounded)
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        _contentLabel.font = fontMetrics.scaledFont(for: font, maximumPointSize: 24)
        
        addSubview(_contentLabel)
        
        // Using the content label will trigger a new layout for this view. Here, we reconfigure the title label constraints assiciated with the default layout. Note: This could be done upon initialization, however, we may want this new view mode to appear dynamically, so rather than splitting SLPHomeButton up into multiple classes, we will provide this dynamic implementation as an option.
        if let _titleLabelConstraints = _titleLabelConstraints {
            NSLayoutConstraint.deactivate(_titleLabelConstraints)
            self._titleLabelConstraints = nil
        }
        _titleLabel.numberOfLines = 1
        
        _contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            _titleLabel.leadingAnchor.constraint(equalTo: _symbolImageView.trailingAnchor, constant: 8),
            _titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
            _titleLabel.centerYAnchor.constraint(equalTo: _symbolImageView.centerYAnchor),
            
            _contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            _contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            _contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
        
        return _contentLabel
    }
}
