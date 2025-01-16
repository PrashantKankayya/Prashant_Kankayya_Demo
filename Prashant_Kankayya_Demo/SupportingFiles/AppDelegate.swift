//
//  AppDelegate.swift
//  Prashant_Kankayya_Demo


import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let reachability = Reachability()!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        observeInternetConnectivity(application)
        initInternetFlag(nil)
        navigateToTradingTabController()
        return true
    }
    
    private func navigateToTradingTabController(){
        window = UIWindow()
        window?.backgroundColor = .white
        window?.rootViewController = TradingTabControllerRouter.createTradingTabControllerModule()
        window?.makeKeyAndVisible()
    }
    
    private func observeInternetConnectivity(_ application: UIApplication){
        do { try reachability.startNotifier() } catch { debugPrint("Reachability Notifier Did'nt Started") }
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                self.initInternetFlag(nil)
            } else {
                self.initInternetFlag(nil)
            }
        }
        reachability.whenUnreachable = { _ in
            AppData.shared.isInternetWorking = false
        }
    }
    
    @objc
    func initInternetFlag(_ notification: Notification?) {
        DispatchQueue.global(qos: .background).async {
            let scriptUrl = URL(string: "https://stackoverflow.com/")
            var data: Data? = nil
            if let anUrl = scriptUrl {
                data = try? Data(contentsOf: anUrl)
                if(data == nil){
                    if let scriptUrl = URL(string: "https://stackoverflow.com/"){
                        data = try? Data(contentsOf: scriptUrl)
                    }
                }
            }
            AppData.shared.isInternetWorking = data != nil
        }
    }
}

