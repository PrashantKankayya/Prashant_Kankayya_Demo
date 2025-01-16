//
//  TradingTabController.swift
//  Prashant_Kankayya_Demo


import UIKit

class TradingTabController: UITabBarController {
    
    var presenter: ViToPrTradingTabControllerProtocol?
    
    private let movingSubview = UIView()
    private let heightOfIndicator: CGFloat = 2
    private var isSubviewLayoutDone = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setupViewControllers()
        setupTabBarUI()
    }
    
    @objc private func changeIndicatorOfTab(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let tabIndex = userInfo["tabIndex"] as? Int else { return }
        
        let itemWidth = tabBar.frame.width / CGFloat(tabBar.items?.count ?? 1)
        let targetX = CGFloat(tabIndex) * itemWidth
        moveMovingSubview(to: targetX)
    }
    
    private func setupTabBarUI() {
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 6)
        tabBar.layer.applyShadow(color: .darkGray, offset: CGSize(width: 1, height: 1), radius: 2, opacity: 0.9)
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.9231141427)
        tabBar.tintColor = #colorLiteral(red: 0.0003248849243, green: 0.2752200663, blue: 0.7329499722, alpha: 1)
        additionalSafeAreaInsets.bottom = 8
    }
    
    private func setupViewControllers() {
        viewControllers = [
            createController(for: WatchListViewControllerRouter.createWatchListViewControllerModule(),
                             title: "WatchList",
                             defaultImg: UIImage(systemName: "list.bullet") ?? UIImage()),
            createController(for: OrdersViewControllerRouter.createOrdersViewControllerModule(),
                             title: "Orders",
                             defaultImg: UIImage(systemName: "clock.arrow.circlepath") ?? UIImage()),
            createController(for: PortfolioViewControllerRouter.createPortfolioViewControllerModule(),
                             title: "Portfolio",
                             defaultImg: UIImage(systemName: "briefcase") ?? UIImage()),
            createController(for: FundsViewControllerRouter.createFundsViewControllerModule(),
                             title: "Funds",
                             defaultImg: UIImage(systemName: "indianrupeesign") ?? UIImage()),
            createController(for: InvestViewControllerRouter.createInvestViewControllerModule(),
                             title: "Invest",
                             defaultImg: .investTabIcon)
        ]
        tabBar.itemPositioning = .automatic
        delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard !isSubviewLayoutDone else { return }
        var insets = additionalSafeAreaInsets
        insets.bottom = 12
        
        movingSubview.backgroundColor = #colorLiteral(red: 0.3294117647, green: 0.3176470588, blue: 0.9411764706, alpha: 1)
        movingSubview.frame = CGRect(x: 0,
                                     y: tabBar.frame.inset(by: insets).minY,
                                     width: tabBar.frame.width / CGFloat(viewControllers?.count ?? 1),
                                     height: heightOfIndicator)
        view.addSubview(movingSubview)
        isSubviewLayoutDone = true
    }
    
    private func createController(for rootViewController: UIViewController,
                                   title: String,
                                   defaultImg: UIImage) -> UIViewController {
        rootViewController.tabBarItem.title = title
        rootViewController.tabBarItem.image = defaultImg
        rootViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        rootViewController.tabBarItem.selectedImage = defaultImg
        return rootViewController
    }
}

extension TradingTabController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        updateIndicatorPosition(for: tabBarController.selectedIndex)
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        updateIndicatorPosition(for: tabBarController.selectedIndex)
    }
    
    private func updateIndicatorPosition(for index: Int) {
        let itemWidth = tabBar.frame.width / CGFloat(tabBar.items?.count ?? 1)
        let targetX = CGFloat(index) * itemWidth
        moveMovingSubview(to: targetX)
    }
    
    private func moveMovingSubview(to x: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.movingSubview.frame.origin.x = x
        }
    }
}

extension TradingTabController: PrToViTradingTabControllerProtocol { }

private extension CALayer {
    func applyShadow(color: UIColor, offset: CGSize, radius: CGFloat, opacity: Float) {
        shadowColor = color.cgColor
        shadowOffset = offset
        shadowRadius = radius
        shadowOpacity = opacity
    }
}
