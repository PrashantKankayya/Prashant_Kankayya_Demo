//
//  FundsViewControllerProtocol.swift
//  Prashant_Kankayya_Demo
  
//

import UIKit
// MARK: View Output (Presenter -> View)
protocol PrToViFundsViewControllerProtocol: AnyObject{
    
}

// MARK: View Input (View -> Presenter)
protocol ViToPrFundsViewControllerProtocol: AnyObject {
    var view: PrToViFundsViewControllerProtocol? { get set }
    var interactor: PrToInFundsViewControllerProtocol? { get set }
    var router: PrToRoFundsViewControllerProtocol? { get set }
    func displayNoInternet()
}

// MARK: Router Input (Presenter -> Router)
protocol PrToRoFundsViewControllerProtocol: AnyObject {
    static func createFundsViewControllerModule() -> UIViewController
    func presentNoInternet(on view: PrToViFundsViewControllerProtocol)
}



// MARK: Interactor Input (Presenter -> Interactor)
protocol PrToInFundsViewControllerProtocol : AnyObject {
    var presenter: IrToPrFundsViewControllerProtocol? { get set }
    
}

// MARK: Interactor Output (Interactor -> Presenter)
protocol IrToPrFundsViewControllerProtocol: AnyObject {
    
}



extension UIViewController {
    func presentOnRoot(`with` viewController : UIViewController){
        DispatchQueue.main.async {
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            navigationController.setNavigationBarHidden(true, animated: false)
            self.present(navigationController, animated: false, completion: nil)
        }
    }
}
