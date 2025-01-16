//
//  MyCustomView.swift
//  Prashant_Kankayya_Demo



import UIKit

@IBDesignable
class MyCustomView: UIView {
    lazy var shapeLayer: CAShapeLayer = self.layer as! CAShapeLayer
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    @IBInspectable var cornerRadius: CGFloat = 10.0 {
        didSet {
            setNeedsLayout()
        }
    }

   var borderWidth: CGFloat = 1.0 {
        didSet {
            setNeedsLayout()
        }
    }

    var borderColor: UIColor = .gray.withAlphaComponent(0.8) {
        didSet {
            setNeedsLayout()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = borderColor.cgColor
        shapeLayer.lineWidth = borderWidth
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: [.topLeft, .topRight],
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        shapeLayer.path = path.cgPath
        shapeLayer.cornerRadius = cornerRadius
        shapeLayer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
