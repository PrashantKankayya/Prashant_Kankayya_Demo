//
//  FundsViewController.swift
//  Prashant_Kankayya_Demo
  
//

import UIKit

class FundsViewController : UIViewController {
    
    var presenter: ViToPrFundsViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension FundsViewController : PrToViFundsViewControllerProtocol{
    
}

