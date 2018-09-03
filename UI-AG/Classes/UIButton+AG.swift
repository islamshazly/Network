//
//  UIButtonExtension.swift
//  
//
//  Created by Islam Elshazly on 5/24/18.
//  Copyright © 2018 krashless.com. All rights reserved.
//

import UIKit

// MARK: - Methods

public extension UIButton {
    
    private var states: [UIControlState] {
        return [.normal, .selected, .highlighted, .disabled]
    }
    
    func loadingIndicator(_ show: Bool) {
        let tag = 808404
        if show {
            self.imageView?.isHidden = true
            self.isEnabled = false
            self.alpha = 0.5
            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.tag = tag
            indicator.color = .black
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            self.imageView?.isHidden = false
            self.isEnabled = true
            self.alpha = 1.0
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
    
    func imageWith(color:UIColor, for: UIControlState) {
        if let imageForState = self.image(for: state) {
            self.image(for: .normal)?.withRenderingMode(.alwaysTemplate)
            let colorizedImage = imageForState.image(withTintColor: color)
            self.setImage(colorizedImage, for: state)
            self.tintColor = color
        }
    }
    
    public func setImageForAllStates(_ image: UIImage) {
        states.forEach { self.setImage(image, for: $0) }
    }

    public func setTitleColorForAllStates(_ color: UIColor) {
        states.forEach { self.setTitleColor(color, for: $0) }
    }
    
    public func setTitleForAllStates(_ title: String) {
        states.forEach { self.setTitle(title, for: $0) }
    }
    
    public func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
    
}

