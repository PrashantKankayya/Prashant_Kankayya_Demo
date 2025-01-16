//
//  InvestViewControllerRouter.swift
//  Prashant_Kankayya_Demo
  
//


import UIKit

class InvestViewControllerRouter : PrToRoInvestViewControllerProtocol{
    
    static func createInvestViewControllerModule() -> UIViewController {
        let investViewController = InvestViewController()
        let presenter: ViToPrInvestViewControllerProtocol & IrToPrInvestViewControllerProtocol = InvestViewControllerPresenter()
        investViewController.presenter = presenter
        investViewController.presenter?.router = InvestViewControllerRouter()
        investViewController.presenter?.view = investViewController
        investViewController.presenter?.interactor = InvestViewControllerInteractor()
        investViewController.presenter?.interactor?.presenter = presenter
        return investViewController
    }
}
