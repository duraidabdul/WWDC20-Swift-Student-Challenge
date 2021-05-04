import UIKit

extension UIControl {
    
    /** Allows for easy addition of highlight and unhighlight actions for a UIControl. */
    func addTarget(_ target: Any, highlightAction: Selector, unhighlightAction: Selector) {
        addTarget(target, action: highlightAction, for: .touchDown)
        addTarget(target, action: highlightAction, for: .touchDragEnter)
        
        addTarget(target, action: unhighlightAction, for: .touchUpInside)
        addTarget(target, action: unhighlightAction, for: .touchDragExit)
        addTarget(target, action: unhighlightAction, for: .touchCancel)
    }
}

// Custom dynamic colors to be used throughout the Playground.
extension UIColor {
    static let localBackground = UIColor(dynamicProvider: { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            return UIColor(white: 0.94, alpha: 1)
        case .dark:
            return .black
        }
    })
    
    static let localElevated = UIColor(dynamicProvider: { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            return .white
        case .dark:
            return .tertiarySystemFill
        }
    })
    
    static let localElevatedHighlighted = UIColor(dynamicProvider: { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            return UIColor(white: 1, alpha: 0.5)
        case .dark:
            return .systemFill
        }
    })
}

extension UIFont {
    class func systemFont(ofSize size: CGFloat, weight: UIFont.Weight = .regular, design: UIFontDescriptor.SystemDesign) -> UIFont {
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .body)
            .addingAttributes([
                UIFontDescriptor.AttributeName.traits : [UIFontDescriptor.TraitKey.weight : weight],
            ])
            .withDesign(design)
        
        return UIFont(descriptor: descriptor!, size: size)
    }
}

extension UIView {
    /**
     Easily apply a scale transform to the view.
     
     SwiftUI style scale method, allowing for quick reactive scaling of a UIView.
     */
    func scale(_ magnitude: CGFloat) {
        transform = CGAffineTransform(scaleX: magnitude, y: magnitude)
    }
    
    /**
     Easily apply an offset transform to the view.
     
     SwiftUI style offset method, allowing for quick reactive offset of a UIView.
     */
    func offset(x: CGFloat = 0, y: CGFloat = 0) {
        transform = CGAffineTransform(translationX: x, y: y)
    }
}
