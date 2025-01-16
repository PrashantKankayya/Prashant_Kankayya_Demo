//
//  PortfolioViewControllerInteractor.swift
//  Prashant_Kankayya_Demo
//

import Foundation

// All Business Logic, Flags & Variables Should Be Written Here.
class PortfolioViewControllerInteractor : PrToInPortfolioViewControllerProtocol{
    
    weak var presenter: IrToPrPortfolioViewControllerProtocol?
    
    var portfolioData: PortfolioDM?
    
    func getPortfolioData(){
        guard let url = URL(string: APIEndPoints.portfolioAPI) else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { [self] data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP Error: \(httpResponse.statusCode)")
                return
            }
            if let data = data {
                DispatchQueue.main.async { [self] in
                    portfolioData = try? JSONDecoder().decode(PortfolioDM.self, from: data)
                    calculatePortfolioSummary(portfolioData: portfolioData) { portfolioSummary in
                        presenter?.reloadDataOf(userHoldings: portfolioData?.data?.userHolding, portfolioSummary : portfolioSummary)
                    }
                }
            }
        }
        task.resume()
    }
    
    private func calculatePortfolioSummary(portfolioData: PortfolioDM?, completion: (PortfolioSummary) -> Void) {
        var currentValue: Double = 0
        var totalInvestment: Double = 0
        var todaysPNL: Double = 0

        if let userHoldings = portfolioData?.data?.userHolding {
            for holding in userHoldings {
                currentValue += (holding.ltp ?? 0) * Double(holding.quantity ?? 0)
                totalInvestment += (holding.avgPrice ?? 0) * Double(holding.quantity ?? 0)
                todaysPNL += ((holding.close ?? 0) - (holding.ltp ?? 0)) * Double(holding.quantity ?? 0)
            }
            
            let totalPNL = currentValue - totalInvestment
            
            // Calculate percentage
            let percentage = totalInvestment != 0 ? (totalPNL / totalInvestment) * 100 : 0
            
            let summary = PortfolioSummary(
                currentValue: currentValue,
                totalInvestment: totalInvestment,
                totalPNL: totalPNL,
                todaysPNL: todaysPNL,
                percentage: percentage
            )
            
            completion(summary)
        }
    }
}
