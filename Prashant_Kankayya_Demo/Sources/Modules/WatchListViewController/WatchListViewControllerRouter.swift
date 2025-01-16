//
//  WatchListViewControllerRouter.swift
//  Prashant_Kankayya_Demo
  
//


import UIKit

class WatchListViewControllerRouter : PrToRoWatchListViewControllerProtocol{
    
    static func createWatchListViewControllerModule() -> UIViewController {
        let watchListViewController = WatchListViewController()
        let presenter: ViToPrWatchListViewControllerProtocol & IrToPrWatchListViewControllerProtocol = WatchListViewControllerPresenter()
        watchListViewController.presenter = presenter
        watchListViewController.presenter?.router = WatchListViewControllerRouter()
        watchListViewController.presenter?.view = watchListViewController
        watchListViewController.presenter?.interactor = WatchListViewControllerInteractor()
        watchListViewController.presenter?.interactor?.presenter = presenter
        return watchListViewController
    }
}

