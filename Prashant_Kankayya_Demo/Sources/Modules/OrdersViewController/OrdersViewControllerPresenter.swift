//
//  OrdersViewControllerPresenter.swift
//  Prashant_Kankayya_Demo
  
//

import Foundation

//Responsible for all logics related To Views.
class OrdersViewControllerPresenter: ViToPrOrdersViewControllerProtocol {

    // MARK: Properties
    weak var view: PrToViOrdersViewControllerProtocol?
    var interactor: PrToInOrdersViewControllerProtocol?
    var router: PrToRoOrdersViewControllerProtocol?
    
}

extension OrdersViewControllerPresenter:  IrToPrOrdersViewControllerProtocol {
    
}
