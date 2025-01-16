//
//  WatchListViewControllerProtocol.swift
//  Prashant_Kankayya_Demo
  
//

import UIKit
// MARK: View Output (Presenter -> View)
protocol PrToViWatchListViewControllerProtocol: AnyObject{
    
}

// MARK: View Input (View -> Presenter)
protocol ViToPrWatchListViewControllerProtocol: AnyObject {
    var view: PrToViWatchListViewControllerProtocol? { get set }
    var interactor: PrToInWatchListViewControllerProtocol? { get set }
    var router: PrToRoWatchListViewControllerProtocol? { get set }
    
}

// MARK: Router Input (Presenter -> Router)
protocol PrToRoWatchListViewControllerProtocol: AnyObject {
    static func createWatchListViewControllerModule() -> UIViewController
    
}



// MARK: Interactor Input (Presenter -> Interactor)
protocol PrToInWatchListViewControllerProtocol : AnyObject {
    var presenter: IrToPrWatchListViewControllerProtocol? { get set }
    
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol IrToPrWatchListViewControllerProtocol: AnyObject {
    
}

