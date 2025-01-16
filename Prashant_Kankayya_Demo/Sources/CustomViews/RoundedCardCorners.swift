//
//  RoundedCardCorners.swift
//  Prashant_Kankayya_Demo


import UIKit

class RoundedCardCorners : DarkDropShadow {
    
    @IBInspectable var shadowOpacity: Float = 0.2{
        didSet{
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.maskedCorners = [.layerMinXMinYCorner,
                               .layerMaxXMinYCorner]
        layer.cornerRadius = 16
        layer.shadowOffset = CGSize(width: 1, height: -1)
        layer.shadowRadius = 8
    }
}
