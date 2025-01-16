//
//  PortfolioViewControllerPresenter.swift
//  Prashant_Kankayya_Demo

//

import Foundation

//Responsible for all logics related To Views.
class PortfolioViewControllerPresenter: ViToPrPortfolioViewControllerProtocol {
    
    // MARK: Properties
    weak var view: PrToViPortfolioViewControllerProtocol?
    var interactor: PrToInPortfolioViewControllerProtocol?
    var router: PrToRoPortfolioViewControllerProtocol?
    
    func getPortfolioData(){
        if(AppData.shared.isInternetWorking){
            interactor?.getPortfolioData()
        }else{
            view?.showNoInternetPopUp(completion: { [self] in
                getPortfolioData()
            })
        }
    }
}

extension PortfolioViewControllerPresenter: IrToPrPortfolioViewControllerProtocol {
    func reloadDataOf(userHoldings: [UserHolding]?, portfolioSummary: PortfolioSummary?) {
        view?.reloadDataOf(userHoldings: userHoldings, portfolioSummary: portfolioSummary)
    }
}
