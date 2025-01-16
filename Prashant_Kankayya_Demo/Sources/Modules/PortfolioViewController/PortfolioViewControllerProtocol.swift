//
//  PortfolioViewControllerProtocol.swift
//  Prashant_Kankayya_Demo
  
//



import UIKit
// MARK: View Output (Presenter -> View)
protocol PrToViPortfolioViewControllerProtocol: BasePrToViProtocol {
    func reloadDataOf(userHoldings: [UserHolding]?, portfolioSummary: PortfolioSummary?)
}

// MARK: View Input (View -> Presenter)
protocol ViToPrPortfolioViewControllerProtocol: AnyObject {
    var view: PrToViPortfolioViewControllerProtocol? { get set }
    var interactor: PrToInPortfolioViewControllerProtocol? { get set }
    var router: PrToRoPortfolioViewControllerProtocol? { get set }
    func getPortfolioData()
    
}

// MARK: Router Input (Presenter -> Router)
protocol PrToRoPortfolioViewControllerProtocol: AnyObject {
    static func createPortfolioViewControllerModule() -> UIViewController
    
}



// MARK: Interactor Input (Presenter -> Interactor)
protocol PrToInPortfolioViewControllerProtocol : AnyObject {
    var presenter: IrToPrPortfolioViewControllerProtocol? { get set }
    var portfolioData: PortfolioDM? { get set }
    func getPortfolioData()
    
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol IrToPrPortfolioViewControllerProtocol: AnyObject {
    func reloadDataOf(userHoldings: [UserHolding]?, portfolioSummary: PortfolioSummary?)
}

