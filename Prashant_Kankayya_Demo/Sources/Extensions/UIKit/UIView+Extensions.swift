//
//  UIView+Extensions.swift
//  Prashant_Kankayya_Demo


import UIKit

extension UIView {
    func addDropShadow(color: UIColor = .black,
                       opacity: Float = 0.2,
                       offset: CGSize = CGSize(width: 0, height: 4),
                       radius: CGFloat = 4) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
}
