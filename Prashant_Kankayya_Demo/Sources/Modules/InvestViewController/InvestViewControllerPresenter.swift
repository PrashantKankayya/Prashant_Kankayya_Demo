//
//  InvestViewControllerPresenter.swift
//  Prashant_Kankayya_Demo
  
//

import Foundation

//Responsible for all logics related To Views.
class InvestViewControllerPresenter: ViToPrInvestViewControllerProtocol {

    // MARK: Properties
    weak var view: PrToViInvestViewControllerProtocol?
    var interactor: PrToInInvestViewControllerProtocol?
    var router: PrToRoInvestViewControllerProtocol?
    
}

extension InvestViewControllerPresenter: IrToPrInvestViewControllerProtocol {
    
}
