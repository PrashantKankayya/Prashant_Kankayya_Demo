//
//  OrdersViewControllerProtocol.swift
//  Prashant_Kankayya_Demo
  
//

import UIKit
// MARK: View Output (Presenter -> View)
protocol PrToViOrdersViewControllerProtocol: AnyObject{
    
}

// MARK: View Input (View -> Presenter)
protocol ViToPrOrdersViewControllerProtocol: AnyObject {
    var view: PrToViOrdersViewControllerProtocol? { get set }
    var interactor: PrToInOrdersViewControllerProtocol? { get set }
    var router: PrToRoOrdersViewControllerProtocol? { get set }
    
}

// MARK: Router Input (Presenter -> Router)
protocol PrToRoOrdersViewControllerProtocol: AnyObject {
    static func createOrdersViewControllerModule() -> UIViewController
    
}



// MARK: Interactor Input (Presenter -> Interactor)
protocol PrToInOrdersViewControllerProtocol : AnyObject {
    var presenter: IrToPrOrdersViewControllerProtocol? { get set }
    
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol IrToPrOrdersViewControllerProtocol: AnyObject {
    
}

