//
//  PortfolioViewController.swift
//  Prashant_Kankayya_Demo

//

import UIKit

class PortfolioViewController : AppBaseViewController {
    
    var presenter: ViToPrPortfolioViewControllerProtocol?
    
    @IBOutlet weak var portfolioTabMenuCollectionView: UICollectionView!
    @IBOutlet weak var portfolioSectionCollectionView: UICollectionView!
    @IBOutlet weak var menuBar: UIView!
    @IBOutlet weak var menuIndicatorLeadingConstraint: NSLayoutConstraint!
    let menuBarTitles : [String] = ["POSITIONS","HOLDINGS"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionViewCells()
        menuBar.addDropShadow()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            portfolioTabMenuCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
        }
    }
    
    func registerCollectionViewCells(){
        portfolioSectionCollectionView.register(cellType: HoldingsCollectionViewCell.self)
        portfolioSectionCollectionView.register(cellType: PostionsCollectionViewCell.self)
        portfolioTabMenuCollectionView.register(cellType: TabMenuCollectionViewCell.self)
    }
}

extension PortfolioViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(scrollView == portfolioSectionCollectionView){
            menuIndicatorLeadingConstraint?.constant = scrollView.contentOffset.x / CGFloat(menuBarTitles.count)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(scrollView == portfolioSectionCollectionView){
            let index = Int(targetContentOffset.pointee.x / view.frame.width)
            let indexPath = IndexPath(item: index, section: 0)
            portfolioTabMenuCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuBarTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView == portfolioTabMenuCollectionView){
            let indexPath = IndexPath(item: indexPath.item, section: 0)
            portfolioSectionCollectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (collectionView == portfolioSectionCollectionView){
            if(indexPath.row == 1){
                if presenter?.interactor?.portfolioData == nil {
                    presenter?.getPortfolioData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var displayCell : UICollectionViewCell?
        if(collectionView == portfolioTabMenuCollectionView){
            let cell = portfolioTabMenuCollectionView.dequeueReusableCell(with: TabMenuCollectionViewCell.self, for: indexPath)
            cell.titleLabel.text = menuBarTitles[indexPath.row]
            displayCell = cell
        }else if (collectionView == portfolioSectionCollectionView){
            if(indexPath.row == 0){
                let cell = portfolioSectionCollectionView.dequeueReusableCell(with: PostionsCollectionViewCell.self, for: indexPath)
                displayCell = cell
            }else if(indexPath.row == 1){
                let cell = portfolioSectionCollectionView.dequeueReusableCell(with: HoldingsCollectionViewCell.self, for: indexPath)
                cell.holdingsCollectionViewDelegate = self
                cell.reloadTableView(withHoldingsData: nil, withPortfolioSummary: nil)
                displayCell = cell
            }
        }
        return displayCell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView == portfolioTabMenuCollectionView){
            let size = CGSize(width: (portfolioTabMenuCollectionView.bounds.width / CGFloat(menuBarTitles.count)), height: portfolioTabMenuCollectionView.frame.height)
            return size
        }else{
            let size = CGSize(width: (portfolioSectionCollectionView.frame.width), height: (portfolioSectionCollectionView.frame.height))
            return size
        }
    }
}

extension PortfolioViewController : HoldingsCollectionViewDelegate {
    func requestToRefreshData() {
        presenter?.getPortfolioData()
    }
}


extension PortfolioViewController : PrToViPortfolioViewControllerProtocol {
    
    func reloadDataOf(userHoldings: [UserHolding]?, portfolioSummary: PortfolioSummary?) {
        if let cell = portfolioSectionCollectionView.cellForItem(at: IndexPath(row: 1, section: 0)) as? HoldingsCollectionViewCell {
            cell.reloadTableView(withHoldingsData: userHoldings, withPortfolioSummary: portfolioSummary)
        }
    }
}
