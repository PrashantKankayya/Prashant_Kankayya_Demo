//
//  Double+Extensions.swift
//  Prashant_Kankayya_Demo



import Foundation

extension Double {
    var asLocaleCurrency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_IN")
        let formattedString = formatter.string(from: self as NSNumber)
        return formattedString?.replacingOccurrences(of: "₹ ", with: "₹") ?? ""
    }
}
