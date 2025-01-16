//
//  TradingTabControllerProtocol.swift
//  Prashant_Kankayya_Demo
  
//

import UIKit
// MARK: View Output (Presenter -> View)
protocol PrToViTradingTabControllerProtocol: AnyObject{
    
}

// MARK: View Input (View -> Presenter)
protocol ViToPrTradingTabControllerProtocol: AnyObject {
    var view: PrToViTradingTabControllerProtocol? { get set }
    var interactor: PrToInTradingTabControllerProtocol? { get set }
    var router: PrToRoTradingTabControllerProtocol? { get set }
    
}

// MARK: Router Input (Presenter -> Router)
protocol PrToRoTradingTabControllerProtocol: AnyObject {
    static func createTradingTabControllerModule() -> UIViewController
    
}



// MARK: Interactor Input (Presenter -> Interactor)
protocol PrToInTradingTabControllerProtocol : AnyObject {
    var presenter: IrToPrTradingTabControllerProtocol? { get set }
    
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol IrToPrTradingTabControllerProtocol: AnyObject {
    
}

