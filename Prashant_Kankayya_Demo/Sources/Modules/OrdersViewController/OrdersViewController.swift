//
//  OrdersViewController.swift
//  Prashant_Kankayya_Demo
  
//

import UIKit

class OrdersViewController : UIViewController {
    
    var presenter: ViToPrOrdersViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension OrdersViewController : PrToViOrdersViewControllerProtocol{
    
}

