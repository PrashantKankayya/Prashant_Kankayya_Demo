//
//  FundsViewControllerRouter.swift
//  Prashant_Kankayya_Demo
  
//


import UIKit

class FundsViewControllerRouter : PrToRoFundsViewControllerProtocol{
    
    static func createFundsViewControllerModule() -> UIViewController {
        let fundsViewController = FundsViewController()
        let presenter: ViToPrFundsViewControllerProtocol & IrToPrFundsViewControllerProtocol = FundsViewControllerPresenter()
        fundsViewController.presenter = presenter
        fundsViewController.presenter?.router = FundsViewControllerRouter()
        fundsViewController.presenter?.view = fundsViewController
        fundsViewController.presenter?.interactor = FundsViewControllerInteractor()
        fundsViewController.presenter?.interactor?.presenter = presenter
        return fundsViewController
    }
    
    func presentNoInternet(on view: any PrToViFundsViewControllerProtocol) {
//        let noInternet = NoInternet(nibName:"NoInternet", bundle:nil)
//        self.presentOnRoot(with: noInternet)
    }
}
