//
//  UILabel+Extensions.swift
//  Prashant_Kankayya_Demo


import UIKit

extension UILabel {
    func setValueAsRupee(
        amount: String,
        greenOrRed: Bool? = nil,
        reduceDecimalFont : Bool = true,
        endingStr : NSMutableAttributedString? = nil
    ) {
        guard let doubleAmount = Double(amount) else { return }

        var defaultColorOfLb: UIColor = self.textColor
        if greenOrRed == true {
            defaultColorOfLb = doubleAmount == 0
                ? defaultColorOfLb
                : (doubleAmount > 0 ? #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1) : #colorLiteral(red: 1, green: 0.03742904276, blue: 0, alpha: 1))
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "₹"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0

        let formattedAmount = formatter.string(from: NSNumber(value: doubleAmount)) ?? "\(doubleAmount)"
        let attributedString = NSMutableAttributedString(string: formattedAmount)

        let baseFont = UIFont.systemFont(ofSize: self.font.pointSize)
        let decimalFont = baseFont.withSize( reduceDecimalFont ? (baseFont.pointSize - 4) : baseFont.pointSize) // Reduce decimal font size by 4 points

        if let decimalSeparator = formatter.decimalSeparator,
           let rangeOfDecimal = formattedAmount.range(of: "\(decimalSeparator)"),
           formattedAmount.contains(decimalSeparator) {
            let integerPartLength = formattedAmount.distance(from: formattedAmount.startIndex, to: rangeOfDecimal.lowerBound)
            let decimalPartLength = formattedAmount.count - integerPartLength
            attributedString.addAttributes([.font: baseFont], range: NSRange(location: 0, length: integerPartLength))
            attributedString.addAttributes([.font: decimalFont], range: NSRange(location: integerPartLength, length: decimalPartLength))
        } else {
            attributedString.addAttributes([.font: baseFont], range: NSRange(location: 0, length: formattedAmount.count))
        }
        
        if let endStr = endingStr {
            attributedString.append(endStr)
        }

        self.textColor = defaultColorOfLb
        self.attributedText = attributedString
    }
}
