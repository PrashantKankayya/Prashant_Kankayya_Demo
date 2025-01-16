//
//  InvestViewController.swift
//  Prashant_Kankayya_Demo
  
//

import UIKit

class InvestViewController : UIViewController {
    
    var presenter: ViToPrInvestViewControllerProtocol?
    
}

extension InvestViewController : PrToViInvestViewControllerProtocol {
    
}

import Foundation

class HoldingsViewModel {
    private let apiService: APIServiceProtocol
    private var holdings: [UserHolding] = []
    private var expandedSections: Set<Int> = []

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    func fetchHoldings(completion: @escaping (Result<[UserHolding], Error>) -> Void) {
        apiService.fetchHoldings { result in
            switch result {
            case .success(let portfolioData):
                self.holdings = portfolioData.data?.userHolding ?? []
                completion(.success(self.holdings))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func calculateCurrentValue(holdings: [UserHolding]) -> Double {
        return holdings.reduce(0) { total, holding in
            total + ((holding.ltp ?? 0) * Double(holding.quantity ?? 0))
        }
    }

    func calculateTotalInvestment(holdings: [UserHolding]) -> Double {
        return holdings.reduce(0) { total, holding in
            total + ((holding.avgPrice ?? 0) * Double(holding.quantity ?? 0))
        }
    }

    func calculateTotalPNL(currentValue: Double, totalInvestment: Double) -> Double {
        return currentValue - totalInvestment
    }

    func calculateTodaysPNL(holdings: [UserHolding]) -> Double {
        return holdings.reduce(0) { total, holding in
            total + (((holding.close ?? 0) - (holding.ltp ?? 0)) * Double(holding.quantity ?? 0))
        }
    }

    func toggleSection(section: Int) {
        if expandedSections.contains(section) {
            expandedSections.remove(section)
        } else {
            expandedSections.insert(section)
        }
    }

    func isSectionExpanded(section: Int) -> Bool {
        return expandedSections.contains(section)
    }
}

import Foundation

protocol APIServiceProtocol {
    func fetchHoldings(completion: @escaping (Result<PortfolioDM, Error>) -> Void)
}

class MockAPIService: APIServiceProtocol {
    func fetchHoldings(completion: @escaping (Result<PortfolioDM, Error>) -> Void) {
        // Simulated API response
        let mockJSON = """
        {
          "data": {
            "userHolding": [
              {
                "symbol": "MAHABANK",
                "quantity": 990,
                "ltp": 38.05,
                "avgPrice": 35,
                "close": 40
              },
              {
                "symbol": "ICICI",
                "quantity": 100,
                "ltp": 118.25,
                "avgPrice": 110,
                "close": 105
              }
            ]
          }
        }
        """
        let jsonData = mockJSON.data(using: .utf8)!
        do {
            let portfolioData = try JSONDecoder().decode(PortfolioDM.self, from: jsonData)
            completion(.success(portfolioData))
        } catch {
            completion(.failure(error))
        }
    }
}
