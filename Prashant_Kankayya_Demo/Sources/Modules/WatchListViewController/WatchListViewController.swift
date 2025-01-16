//
//  WatchListViewController.swift
//  Prashant_Kankayya_Demo
  
//

import UIKit

class WatchListViewController : UIViewController {
    
    var presenter: ViToPrWatchListViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension WatchListViewController : PrToViWatchListViewControllerProtocol{
    
}

