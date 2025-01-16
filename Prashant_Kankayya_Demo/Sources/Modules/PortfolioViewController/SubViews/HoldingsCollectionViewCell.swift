//
//  HoldingsCollectionViewCell.swift
//  Prashant_Kankayya_Demo


import UIKit

protocol HoldingsCollectionViewDelegate: AnyObject {
    func requestToRefreshData()
}

class HoldingsCollectionViewCell: UICollectionViewCell {
    
    weak var holdingsCollectionViewDelegate : HoldingsCollectionViewDelegate?
    
    @IBOutlet weak var holdingsListTableView: UITableView!
    @IBOutlet weak var profitNdLossTitleLabel: UILabel!
    @IBOutlet weak var bottomDetailsDrawerView: UIView!
    @IBOutlet weak var holdingDetailsStackView: UIStackView!
    @IBOutlet weak var profitNdLossStackView: UIStackView!
    
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var totalInvestmentLabel: UILabel!
    @IBOutlet weak var todaysProfitNdLossLabel: UILabel!
    @IBOutlet weak var profitNdLossValueLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    var refreshControl = UIRefreshControl()
    
    var userHoldingList : [UserHolding]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        holdingsListTableView.register(cellType: HoldingsTableViewCell.self)
        holdingsListTableView.delegate = self
        holdingsListTableView.dataSource = self
        holdingsListTableView.reloadData()
        
        
        let returnsCallViewTap = MyTapGesture(target: self, action: #selector(self.handleTap(_:)))
        profitNdLossStackView.addGestureRecognizer(returnsCallViewTap)
        returnsCallViewTap.expandableView = holdingDetailsStackView
        returnsCallViewTap.isExpanded = false
        returnsCallViewTap.arrowImg = arrowImageView
        handleTap(returnsCallViewTap)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        holdingsListTableView.refreshControl = refreshControl
    }
    
    @objc func refreshData() {
        holdingsCollectionViewDelegate?.requestToRefreshData()
    }
    
    func reloadTableView(withHoldingsData userHoldingList : [UserHolding]?, withPortfolioSummary portfolioSummary : PortfolioSummary?){
        refreshControl.endRefreshing()
        currentValueLabel.setValueAsRupee(amount: "\(portfolioSummary?.currentValue ?? 0)")
        totalInvestmentLabel.setValueAsRupee(amount: "\(portfolioSummary?.totalInvestment ?? 0)")
        todaysProfitNdLossLabel.setValueAsRupee(amount: "\(portfolioSummary?.todaysPNL ?? 0)", greenOrRed: true)
        
        let totalPNL = portfolioSummary?.totalPNL ?? 0
        let percentage = portfolioSummary?.percentage ?? 0.0
        let formattedPercentage = String(format: "%.2f", percentage)
            .trimmingCharacters(in: CharacterSet(charactersIn: "0"))
            .trimmingCharacters(in: CharacterSet(charactersIn: "."))
        let endingString = NSMutableAttributedString(string: " (\(formattedPercentage)%)")
        let reducedFontSize = profitNdLossValueLabel.font.pointSize - 6
        endingString.addAttribute(
            .font,
            value: UIFont.systemFont(ofSize: reducedFontSize),
            range: NSRange(location: 0, length: endingString.length)
        )
        profitNdLossValueLabel.setValueAsRupee(
            amount: "\(totalPNL)",
            greenOrRed: true,
            reduceDecimalFont: true,
            endingStr: endingString
        )
        
        self.userHoldingList = userHoldingList
        holdingsListTableView.reloadData()
    }
    
    @objc func handleTap(_ sender: MyTapGesture) {
        sender.isExpanded = !sender.isExpanded
        UIView.animate(withDuration: 0.3) {
            sender.expandableView.isHidden = sender.isExpanded
            sender.expandableView.alpha = sender.isExpanded ? 0 : 1
            sender.arrowImg.transform = sender.isExpanded ? CGAffineTransform.identity :  CGAffineTransform(rotationAngle: .pi)
        } completion: {_ in
            debugPrint("Expandable Animation Completed")
        }
    }
}

extension HoldingsCollectionViewCell : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userHoldingList?.count ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let holdingsTableViewCell = tableView.dequeueReusableCell(with: HoldingsTableViewCell.self, for: indexPath)
        holdingsTableViewCell.initUserHolding(data: userHoldingList?[indexPath.row])
        return holdingsTableViewCell
    }
}



