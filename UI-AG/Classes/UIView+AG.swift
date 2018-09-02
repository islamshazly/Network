import UIKit

extension UIView {
    
    public enum BorderSide {
        case top
        case left
        case bottom
        case right
    }
    
    public var endX : CGFloat {
        return frame.origin.x + frame.width
    }
    
    public var endY : CGFloat {
        return frame.origin.y + frame.height
    }
    
    public var startX : CGFloat {
        return frame.origin.x
    }
    
    public var startY : CGFloat {
        return frame.origin.y
    }
    
    public var width : CGFloat {
        get {
             return frame.width
        } set(value) {
            self.frame.size = CGSize(width: value, height: height)
        }
    }
    
    public var height : CGFloat {
        get {
            return frame.height
        } set(value) {
            self.frame.size = CGSize(width: width, height: value)
        }
    }
    
    public func setStartX(x : CGFloat) {
        self.frame.origin.x = x
    }
    
    public func setStartY( y : CGFloat) {
        self.frame.origin.y = y
    }
    
    public func setCenter(x : CGFloat, y : CGFloat) {
        self.center = CGPoint(x : x,y: y)
    }
    
    public func getCenter() -> CGPoint {
        return self.center
    }
    
    public func setCenterX(x: CGFloat) {
        self.center = CGPoint(x: x, y: self.getCenterY())
    }
    
    public func getCenterX() -> CGFloat {
        return self.center.x
    }
    
    public func setCenterY(y : CGFloat)  {
        self.center = CGPoint(x : self.getCenterX(), y : y)
    }
    
    public func getCenterY() -> CGFloat {
        return self.center.y
    }
    
    public func applyBorder(_ color: UIColor) {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = color.cgColor
    }
    
    public func applyCornerRadius(corenrRadius : CGFloat , mask : Bool) {
        self.layer.masksToBounds = mask
        self.layer.cornerRadius = corenrRadius
    }
    
    public func applyBottomBorder(_ color: UIColor) {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = color.cgColor
    }
    
    public func addBorder(forSide side: BorderSide, withColor color: UIColor, borderWidth: CGFloat = 1) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        switch side {
        case .top:
            border.frame = CGRect(x: 0,
                                  y: 0,
                                  width: self.width,
                                  height: borderWidth)
        case .left:
            border.frame = CGRect(x: 0,
                                  y: 0,
                                  width: borderWidth,
                                  height: self.height)
        case .bottom:
            border.frame = CGRect(x: 0,
                                  y: self.height - borderWidth,
                                  width: self.width,
                                  height: borderWidth)
        case .right:
            border.frame = CGRect(x: self.width - borderWidth,
                                  y: 0,
                                  width: borderWidth,
                                  height: self.height)
        }
        self.layer.addSublayer(border)
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    public func drawStroke(width: CGFloat, color: UIColor) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.width, height: self.width), cornerRadius: self.width/2)
        let shapeLayer = CAShapeLayer ()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        self.layer.addSublayer(shapeLayer)
    }
    
    public class func loadFromNib(named name: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
    
    public func removeSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }
}

// MARK: Transform Extensions

extension UIView {
    public func setRotationX(_ x: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, x.degreesToRadians, 1.0, 0.0, 0.0)
        self.layer.transform = transform
    }
    
    public func setRotationY(_ y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, y.degreesToRadians, 0.0, 1.0, 0.0)
        self.layer.transform = transform
    }
    
    public func setRotationZ(_ z: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, z.degreesToRadians, 0.0, 0.0, 1.0)
        self.layer.transform = transform
    }
    
    public func setRotation(x: CGFloat, y: CGFloat, z: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DRotate(transform, x.degreesToRadians, 1.0, 0.0, 0.0)
        transform = CATransform3DRotate(transform, y.degreesToRadians, 0.0, 1.0, 0.0)
        transform = CATransform3DRotate(transform, z.degreesToRadians, 0.0, 0.0, 1.0)
        self.layer.transform = transform
    }
    
    public func setScale(x: CGFloat, y: CGFloat) {
        var transform = CATransform3DIdentity
        transform.m34 = 1.0 / -1000.0
        transform = CATransform3DScale(transform, x, y, 1)
        self.layer.transform = transform
    }
}

//MARK: - Animations

private let UIViewAnimationDuration: TimeInterval = 1
private let UIViewAnimationSpringDamping: CGFloat = 0.5
private let UIViewAnimationSpringVelocity: CGFloat = 0.5

public extension UIView {
    
    public func spring(animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        spring(duration: UIViewAnimationDuration, animations: animations, completion: completion)
    }
    
    public func spring(duration: TimeInterval, animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        UIView.animate(
            withDuration: UIViewAnimationDuration,
            delay: 0,
            usingSpringWithDamping: UIViewAnimationSpringDamping,
            initialSpringVelocity: UIViewAnimationSpringVelocity,
            options: UIViewAnimationOptions.allowAnimatedContent,
            animations: animations,
            completion: completion
        )
    }
    
    public func fadeIn(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: completion)
    }
    
    public func fadeOut(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: completion)
    }
    
    public func pop() {
        setScale(x: 1.1, y: 1.1)
        spring(duration: 0.2, animations: { [unowned self] () -> Void in
            self.setScale(x: 1, y: 1)
        })
    }
    
    public func popBig() {
        setScale(x: 1.25, y: 1.25)
        spring(duration: 0.2, animations: { [unowned self] () -> Void in
            self.setScale(x: 1, y: 1)
        })
    }
    
    public func reversePop() {
        setScale(x: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.05, delay: 0, options: .allowUserInteraction, animations: {[weak self] in
            self?.setScale(x: 1, y: 1)
            }, completion: { (_) in })
    }
}

//MARK: - Gesture

public extension UIView {
    
    public func addTapGesture(tapNumber: Int = 1, action: ((UITapGestureRecognizer) -> Void)?) {
        let tap = TapGesture(tapCount: tapNumber, fingerCount: 1, action: action)
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    public func addSwipeGesture(direction: UISwipeGestureRecognizerDirection, fingerCount: Int = 1, action: ((UISwipeGestureRecognizer) -> Void)?) {
        let tap = SwipeGesture(direction: direction, fingerCount: fingerCount, action: action)
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
}
