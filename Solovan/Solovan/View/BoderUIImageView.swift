

import Foundation
import UIKit

@IBDesignable
class BoderUIImageView: UIImageView {
    @IBInspectable var radius: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
            setNeedsLayout()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
            setNeedsLayout()
        }
    }
    
    @IBInspectable var boderTopLeft: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var boderTopRight: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var boderBottomLeft: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable var boderBottomRight: Bool = false {
        didSet {
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var cornerMask: CACornerMask = []
        
        if boderTopLeft {
            cornerMask.insert(.layerMinXMinYCorner)
        }
        
        if boderTopRight {
            cornerMask.insert(.layerMaxXMinYCorner)
        }
        
        if boderBottomLeft {
            cornerMask.insert(.layerMinXMaxYCorner)
        }
        
        if boderBottomRight {
            cornerMask.insert(.layerMaxXMaxYCorner)
        }
        
        layer.cornerRadius = radius
        layer.maskedCorners = cornerMask
        layer.masksToBounds = true
    }
}
