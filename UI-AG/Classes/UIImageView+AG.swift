//
//  UIImageView+AG.swift
//  AG-UIExtensions
//
//  Created by islam Elshazly on 8/27/18.
//

import UIKit

//MARK: - properties

public extension UIImageView {
    
    public var widthPixel : Int {
        get {
            return Int(self.image!.scale * self.image!.size.width)
        }
    }
    public var hieghtPixel : Int {
        get {
            return Int(self.image!.scale * self.image!.size.height)
        }
    }
    @IBInspectable var imageTint: UIColor {
        get {
            return tintColor
        }
        set {
            self.image = self.image!.withRenderingMode(.alwaysTemplate)
            self.tintColor = newValue
        }
    }
}

//MARK: - Methods

public extension UIImageView {
    
    public func disable() {
        self.alpha = 0.5
    }
    
    public func enable() {
        self.alpha = 1
    }
    
    public func ShowLoadingOnImage (){
        self.kf.indicatorType = .activity
    }
    
    public func changeImageColorTint(_ color : UIColor) {
        self.image = self.image!.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
    
    public func imageFromURL( _ url : String , placeHolder : UIImage?) {
        self.kf.setImage(with: URL(string: url), placeholder: placeHolder , options: [.cacheOriginalImage], progressBlock: { (recivedSize,size) in
        }, completionHandler: nil)
    }
    
    public func imageFromURL( _ url : String , placeHolder : UIImage? , clouser : @escaping  ((_ error : Error?) -> ())) {
        self.kf.setImage(with: URL(string: url), placeholder: placeHolder , options: [.cacheOriginalImage], progressBlock: { (recivedSize,size) in
        }, completionHandler: {
            (image, error, cashType, url) in
            clouser(error)
        })
    }
    
    public func blur(withStyle style: UIBlurEffectStyle = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        addSubview(blurEffectView)
        clipsToBounds = true
    }
    
    public func blurred(withStyle style: UIBlurEffectStyle = .light) -> UIImageView {
        let imgView = self
        imgView.blur(withStyle: style)
        return imgView
    }
}
