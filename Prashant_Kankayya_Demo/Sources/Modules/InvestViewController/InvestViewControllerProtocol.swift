//
//  InvestViewControllerProtocol.swift
//  Prashant_Kankayya_Demo
  
//

import UIKit
// MARK: View Output (Presenter -> View)
protocol PrToViInvestViewControllerProtocol: AnyObject{
    
}

// MARK: View Input (View -> Presenter)
protocol ViToPrInvestViewControllerProtocol: AnyObject {
    var view: PrToViInvestViewControllerProtocol? { get set }
    var interactor: PrToInInvestViewControllerProtocol? { get set }
    var router: PrToRoInvestViewControllerProtocol? { get set }
    
}

// MARK: Router Input (Presenter -> Router)
protocol PrToRoInvestViewControllerProtocol: AnyObject {
    static func createInvestViewControllerModule() -> UIViewController
    
}



// MARK: Interactor Input (Presenter -> Interactor)
protocol PrToInInvestViewControllerProtocol : AnyObject {
    var presenter: IrToPrInvestViewControllerProtocol? { get set }
    
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol IrToPrInvestViewControllerProtocol: AnyObject {
    
}
