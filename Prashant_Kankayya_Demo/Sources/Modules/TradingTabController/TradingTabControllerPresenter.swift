//
//  TradingTabControllerPresenter.swift
//  Prashant_Kankayya_Demo
  
//

import Foundation

//Responsible for all logics related To Views.
class TradingTabControllerPresenter: ViToPrTradingTabControllerProtocol {

    // MARK: Properties
    weak var view: PrToViTradingTabControllerProtocol?
    var interactor: PrToInTradingTabControllerProtocol?
    var router: PrToRoTradingTabControllerProtocol?
    
}

extension TradingTabControllerPresenter : IrToPrTradingTabControllerProtocol {
    
}
