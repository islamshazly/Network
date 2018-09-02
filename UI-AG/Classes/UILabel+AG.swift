//
//  UILabel+AG.swift
//  
//
//  Created by islam Elshazly on 8/29/18.
//

import Foundation

public extension UILabel {
    
    public convenience init(font: UIFont, color: UIColor, alignment: NSTextAlignment) {
        self.init()
        self.font = font
        self.textColor = color
        self.textAlignment = alignment
    }
    
    public func getEstimatedSize(_ width: CGFloat = CGFloat.greatestFiniteMagnitude, height: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        return sizeThatFits(CGSize(width: width, height: height))
    }
    
    public func getEstimatedHeight() -> CGFloat {
        return sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
    }
    
    public func getEstimatedWidth() -> CGFloat {
        return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)).width
    }
    
    public func fitHeight() {
        self.height = getEstimatedHeight()
    }
    
    public func fitWidth() {
        self.width = getEstimatedWidth()
    }
    
    public func fitSize() {
        self.fitWidth()
        self.fitHeight()
        sizeToFit()
    }
}
