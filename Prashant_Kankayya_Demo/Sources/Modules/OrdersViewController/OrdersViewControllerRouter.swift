//
//  OrdersViewControllerRouter.swift
//  Prashant_Kankayya_Demo
  
//


import UIKit

class OrdersViewControllerRouter : PrToRoOrdersViewControllerProtocol{
    
    static func createOrdersViewControllerModule() -> UIViewController {
        let ordersViewController = OrdersViewController()
        let presenter: ViToPrOrdersViewControllerProtocol & IrToPrOrdersViewControllerProtocol = OrdersViewControllerPresenter()
        ordersViewController.presenter = presenter
        ordersViewController.presenter?.router = OrdersViewControllerRouter()
        ordersViewController.presenter?.view = ordersViewController
        ordersViewController.presenter?.interactor = OrdersViewControllerInteractor()
        ordersViewController.presenter?.interactor?.presenter = presenter
        return ordersViewController
    }
}

