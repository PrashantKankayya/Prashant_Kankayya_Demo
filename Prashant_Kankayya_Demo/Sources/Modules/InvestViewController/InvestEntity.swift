//
//  InvestEntity.swift
//  Prashant_Kankayya_Demo


import Foundation

struct PortfolioDM: Codable {
    let data: PortfolioData?
}

struct PortfolioData: Codable {
    let userHolding: [UserHolding]?
}

// MARK: - UserHolding
struct UserHolding: Codable {
    let symbol: String?
    let quantity: Int?
    let ltp, avgPrice, close: Double?
    let pNdL: Double?

    enum CodingKeys: String, CodingKey {
        case symbol, quantity, ltp, avgPrice, close
    }

    // Standard Codable initializer
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        symbol = try container.decodeIfPresent(String.self, forKey: .symbol)
        quantity = try container.decodeIfPresent(Int.self, forKey: .quantity)
        ltp = try container.decodeIfPresent(Double.self, forKey: .ltp)
        avgPrice = try container.decodeIfPresent(Double.self, forKey: .avgPrice)
        close = try container.decodeIfPresent(Double.self, forKey: .close)
        pNdL = ((ltp ?? 0) - (avgPrice ?? 0)) * Double(quantity ?? 0)
    }

    // Custom initializer for testing purposes
    init(symbol: String?, quantity: Int?, ltp: Double?, avgPrice: Double?, close: Double?) {
        self.symbol = symbol
        self.quantity = quantity
        self.ltp = ltp
        self.avgPrice = avgPrice
        self.close = close
        self.pNdL = ((ltp ?? 0) - (avgPrice ?? 0)) * Double(quantity ?? 0)
    }
}


struct PortfolioSummary {
    let currentValue: Double
    let totalInvestment: Double
    let totalPNL: Double
    let todaysPNL: Double
    let percentage : Double
}
