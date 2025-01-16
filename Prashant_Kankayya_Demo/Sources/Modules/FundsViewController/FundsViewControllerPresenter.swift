//
//  FundsViewControllerPresenter.swift
//  Prashant_Kankayya_Demo
  
//

import Foundation

//Responsible for all logics related To Views.
class FundsViewControllerPresenter: ViToPrFundsViewControllerProtocol {
    func displayNoInternet() {
        debugPrint("")
    }
    

    // MARK: Properties
    weak var view: PrToViFundsViewControllerProtocol?
    var interactor: PrToInFundsViewControllerProtocol?
    var router: PrToRoFundsViewControllerProtocol?
    
}

extension FundsViewControllerPresenter:  IrToPrFundsViewControllerProtocol {
    
}
