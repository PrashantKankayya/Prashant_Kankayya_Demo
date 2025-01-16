//
//  PortfolioViewControllerRouter.swift
//  Prashant_Kankayya_Demo
  
//


import UIKit

class PortfolioViewControllerRouter : PrToRoPortfolioViewControllerProtocol{
    
    static func createPortfolioViewControllerModule() -> UIViewController {
        let portfolioViewController = PortfolioViewController()
        let presenter: ViToPrPortfolioViewControllerProtocol & IrToPrPortfolioViewControllerProtocol = PortfolioViewControllerPresenter()
        portfolioViewController.presenter = presenter
        portfolioViewController.presenter?.router = PortfolioViewControllerRouter()
        portfolioViewController.presenter?.view = portfolioViewController
        portfolioViewController.presenter?.interactor = PortfolioViewControllerInteractor()
        portfolioViewController.presenter?.interactor?.presenter = presenter
        return portfolioViewController
    }
}

