//
//  TradingTabControllerRouter.swift
//  Prashant_Kankayya_Demo
  
//


import UIKit

class TradingTabControllerRouter : PrToRoTradingTabControllerProtocol{
    
    static func createTradingTabControllerModule() -> UIViewController {
        let tradingTabController = TradingTabController()
        let presenter: ViToPrTradingTabControllerProtocol & IrToPrTradingTabControllerProtocol = TradingTabControllerPresenter()
        tradingTabController.presenter = presenter
        tradingTabController.presenter?.router = TradingTabControllerRouter()
        tradingTabController.presenter?.view = tradingTabController
        tradingTabController.presenter?.interactor = TradingTabControllerInteractor()
        tradingTabController.presenter?.interactor?.presenter = presenter
        return tradingTabController
    }
}
