//
//  SSPaddingLabel.swift
//  Prashant_Kankayya_Demo



import UIKit

class SSPaddingLabel: UILabel {
    
    var padding: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    @IBInspectable
    var topPadding: CGFloat {
        get {
            return padding.top
        }
        set {
            self.padding = UIEdgeInsets(top: newValue,
                                        left: self.padding.left,
                                        bottom: self.padding.bottom,
                                        right: self.padding.right)
        }
    }
    
    @IBInspectable
    var bottomPadding: CGFloat {
        get {
            return padding.bottom
        }
        set {
            self.padding = UIEdgeInsets(top: self.padding.top,
                                        left: self.padding.left,
                                        bottom: newValue,
                                        right: self.padding.right)
        }
    }
    
    @IBInspectable
    var leftPadding: CGFloat {
        get {
            return padding.left
        }
        set {
            self.padding = UIEdgeInsets(top: self.padding.top,
                                        left: newValue,
                                        bottom: self.padding.bottom,
                                        right: self.padding.right)
        }
    }
    
    @IBInspectable
    var rightPadding: CGFloat {
        get {
            return padding.right
        }
        set {
            self.padding = UIEdgeInsets(top: self.padding.top,
                                        left: self.padding.left,
                                        bottom: self.padding.bottom,
                                        right: newValue)
        }
    }
    
    // New cornerRadius property
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = cornerRadius > 0
        }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    // Override `intrinsicContentSize` property for Auto layout code
    override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let height = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: height)
    }
    
    // Override `sizeThatFits(_:)` method for Springs & Struts code
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let width = superSizeThatFits.width + padding.left + padding.right
        let height = superSizeThatFits.height + padding.top + padding.bottom
        return CGSize(width: width, height: height)
    }
}
