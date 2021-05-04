// This view handles the layout of given symbols and text as a title header. It adopts the behaviour of an SLPPushedView.

import UIKit

class SLPInsightView: SLPPushedView {
    
    // Colored views describing the button's purpose.
    private let _symbolImageView = UIImageView()
    /// This property should not be used from outside the class - it is exclusively used in subclasses.
    let _titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSubviews()
        prepareConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Observed Properties
    
    /** An SF Symbol descriptor for a symbol describing the button's purpose. */
    var symbol: String? {
        didSet { _symbolImageView.image = symbol != nil ? UIImage(systemName: symbol!)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 24)) : nil }
    }
    
    /** A title describing the button's purpose. */
    var title: String? {
        didSet { _titleLabel.text = title }
    }
    
    override var tintColor: UIColor! {
        didSet {
            _titleLabel.textColor = tintColor
            _symbolImageView.tintColor = tintColor
        }
    }
    
    // MARK: Instance Methods
    
    private func configureSubviews() {
        contentView.addSubview(_symbolImageView)
        contentView.addSubview(_titleLabel)
        
        _titleLabel.numberOfLines = 0
        
        // Use font metrics to keep this custom text style accessible.
        let font = UIFont.systemFont(ofSize: 19, weight: .semibold)
        let fontMetrics = UIFontMetrics(forTextStyle: .body)
        _titleLabel.font = fontMetrics.scaledFont(for: font, maximumPointSize: 24)
    }
    
    private func prepareConstraints() {
        _symbolImageView.translatesAutoresizingMaskIntoConstraints = false
        _titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            _symbolImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            _symbolImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            
            _titleLabel.leadingAnchor.constraint(equalTo: _symbolImageView.trailingAnchor, constant: 8),
            _titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: 20),
            _titleLabel.centerYAnchor.constraint(equalTo: _symbolImageView.centerYAnchor),
            
            ])
    }
}
