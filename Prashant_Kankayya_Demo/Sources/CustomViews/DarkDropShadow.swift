//
//  DarkDropShadow.swift
//  Prashant_Kankayya_Demo


import UIKit

@IBDesignable
class DarkDropShadow : UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 1, height: -1)
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y:  layer.shadowRadius - 2, width: bounds.width, height: layer.shadowRadius)).cgPath
    }
}
