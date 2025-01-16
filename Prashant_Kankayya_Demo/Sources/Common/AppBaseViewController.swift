//
//  AppBaseViewController.swift
//  Prashant_Kankayya_Demo

import UIKit

protocol BasePrToViProtocol : AnyObject {
    func showNoInternetPopUp(completion: @escaping () -> Void)
}

extension BasePrToViProtocol {
    func showNoInternetPopUp(completion: @escaping () -> Void){}
}

class AppBaseViewController : UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func showNoInternetPopUp(completion: @escaping () -> Void){
        DispatchQueue.main.async {
            let noInternet = NoInternetPopUp(nibName:String(describing: NoInternetPopUp.self), bundle:Bundle(for: NoInternetPopUp.self))
            noInternet.initTryAgainBtEvent {
                completion()
            } onGoToSettingsCompletion: {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)")
                    })
                }
            }
            self.presentOnRoot(with: noInternet)
        }
        return
    }
}
