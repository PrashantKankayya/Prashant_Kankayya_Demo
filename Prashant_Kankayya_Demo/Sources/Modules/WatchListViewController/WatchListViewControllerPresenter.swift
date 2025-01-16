//
//  WatchListViewControllerPresenter.swift
//  Prashant_Kankayya_Demo
  
//

import Foundation

//Responsible for all logics related To Views.
class WatchListViewControllerPresenter: ViToPrWatchListViewControllerProtocol {

    // MARK: Properties
    weak var view: PrToViWatchListViewControllerProtocol?
    var interactor: PrToInWatchListViewControllerProtocol?
    var router: PrToRoWatchListViewControllerProtocol?
    
}

extension WatchListViewControllerPresenter:  IrToPrWatchListViewControllerProtocol {
    
}
