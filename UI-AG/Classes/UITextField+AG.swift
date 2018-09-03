//
//  UITextFieldExtension.swift

import UIKit

// MARK: - properties

public extension UITextField {
    
    @IBInspectable var placeHolderColor: UIColor {
        set {
            self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [.foregroundColor: newValue])
        } get {
            return self.placeHolderColor
        }
    }
    @IBInspectable var borderColor: CGColor {
        set {
            layer.borderColor = newValue
        } get {
            return layer.borderColor ?? UIColor.clear.cgColor
        }
    }
    
    public var isEmpty: Bool {
        return text?.isEmpty == true
    }
}

// MARK: - Methods

public extension UITextField {
    
    enum Direction {
        case left
        case right
    }
    
    public func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }
    
    public func setPlaceHolderTextColor(_ color: UIColor) {
        guard let holder = placeholder, !holder.isEmpty else { return }
        self.attributedPlaceholder = NSAttributedString(string: holder, attributes: [.foregroundColor: color])
    }
    
    public func addPaddingBy(value padding: CGFloat, for direction: Direction) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        switch direction {
        case .left:
            leftView = paddingView
            leftViewMode = .always
        case .right:
            rightView = paddingView
            rightViewMode = .always
        }
    }
    
    public func addPaddingIcon(_ image: UIImage, padding: CGFloat, for direction: Direction) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        switch direction {
        case .left:
            leftView = imageView
            leftView?.frame.size = CGSize(width: image.size.width + padding, height: image.size.height)
            leftViewMode = .always
        case .right:
            rightView = imageView
            rightView?.frame.size = CGSize(width: image.size.width + padding, height: image.size.height)
            rightViewMode = .always
        }
    }
    
}
