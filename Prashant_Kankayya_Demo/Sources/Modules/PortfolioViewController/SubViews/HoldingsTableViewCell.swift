//
//  HoldingsTableViewCell.swift
//  Prashant_Kankayya_Demo


import UIKit

class HoldingsTableViewCell: UITableViewCell, SkeletonLoadable {
    
    @IBOutlet weak var hondingSymbolLabel: UILabel!
    @IBOutlet weak var tOneHoldingLabel: UILabel!
    @IBOutlet weak var netQtyLabel: EFCountingLabel!
    @IBOutlet weak var pNdLLabel: EFCountingLabel!
    @IBOutlet weak var ltpLabel: EFCountingLabel!
    
    private var hasAnimated = false
    
    let hondingSymbolLayer = CAGradientLayer()
    let netQtyLayer = CAGradientLayer()
    
    let pNdLLayer = CAGradientLayer()
    let ltpLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initGradientLayers()
        [netQtyLabel, pNdLLabel, ltpLabel].forEach {
            $0.counter.timingFunction = EFTimingFunction.easeOut(easingRate: 1)
        }
        setLabelUpdateBlock(netQtyLabel)
        setLabelUpdateBlock(pNdLLabel, greenOrRed: true)
        setLabelUpdateBlock(ltpLabel, greenOrRed: false)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hondingSymbolLabel.text = ""
        netQtyLabel.text = ""
        pNdLLabel.text = ""
        ltpLabel.text = ""
        removeShimmer()
        applyShimmerEffect()
    }
    
    func applyShimmerEffect() {
        let animationGroup = makeAnimationGroup()
        animationGroup.beginTime = 0.0
        hondingSymbolLayer.addTo(animationGr: animationGroup)
        
        let netQtyAnimationGroup = makeAnimationGroup(previousGroup: animationGroup)
        netQtyLayer.addTo(animationGr: netQtyAnimationGroup)
        
        let pNdLAnimationGroup = makeAnimationGroup(previousGroup: netQtyAnimationGroup)
        pNdLLayer.addTo(animationGr: pNdLAnimationGroup)
        
        let ltpAnimationGroup = makeAnimationGroup(previousGroup: pNdLAnimationGroup)
        ltpLayer.addTo(animationGr: ltpAnimationGroup)
    }
    
    func initGradientLayers(){
        hondingSymbolLayer.calculatePoints(for: 90)
        hondingSymbolLabel.layer.addSublayer(hondingSymbolLayer)
        
        netQtyLayer.calculatePoints(for: 90)
        netQtyLabel.layer.addSublayer(netQtyLayer)
        
        pNdLLayer.calculatePoints(for: 90)
        pNdLLabel.layer.addSublayer(pNdLLayer)
        
        ltpLayer.calculatePoints(for: 90)
        ltpLabel.layer.addSublayer(ltpLayer)
        
        applyShimmerEffect()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        hondingSymbolLayer.frame = hondingSymbolLabel.bounds
        hondingSymbolLayer.cornerRadius = 8
        
        netQtyLayer.frame = netQtyLabel.bounds
        netQtyLayer.cornerRadius = 8
        
        pNdLLayer.frame = pNdLLabel.bounds
        pNdLLayer.cornerRadius = 8
        
        ltpLayer.frame = ltpLabel.bounds
        ltpLayer.cornerRadius = 8
        
    }
    
    func removeShimmer(){
        hondingSymbolLabel.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
        netQtyLabel.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
        pNdLLabel.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
        ltpLabel.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
    }
    
    func setLabelUpdateBlock(_ label: EFCountingLabel!, greenOrRed: Bool? = nil) {
        label.setUpdateBlock { value, label in
            let formattedValue: String
            if value.truncatingRemainder(dividingBy: 1) == 0 {
                formattedValue = String(format: "%.0f", value)
            } else {
                formattedValue = String(format: "%.2f", value)
            }
            
            if let greenOrRed = greenOrRed {
                label.setValueAsRupee(amount: formattedValue, greenOrRed: greenOrRed, reduceDecimalFont: true)
            } else {
                label.text = formattedValue
            }
        }
    }
    
    
    func initUserHolding(data: UserHolding?) {
        guard let data = data else { return }
        removeShimmer()
        tOneHoldingLabel.isHidden = true
        hondingSymbolLabel.text = data.symbol
        
        let quantity = CGFloat(data.quantity ?? 0)
        let ltp = CGFloat(data.ltp ?? 0)
        let pNdL = CGFloat(data.pNdL ?? 0)
        
        if !hasAnimated {
            netQtyLabel.countFrom(0, to: quantity, withDuration: 0.5)
            ltpLabel.countFrom(0, to: ltp, withDuration: 0.5)
            pNdLLabel.countFrom(0, to: pNdL, withDuration: 0.5)
            hasAnimated = true
        } else {
            netQtyLabel.text = String(data.quantity ?? 0)
            
            ltpLabel.setValueAsRupee(
                amount: formatAmount(data.ltp),
                greenOrRed: false
            )
            
            pNdLLabel.setValueAsRupee(
                amount: formatAmount(data.pNdL),
                greenOrRed: true
            )
        }
    }
    
    private func formatAmount(_ value: Double?) -> String {
        guard let value = value else { return "0" }
        return value.truncatingRemainder(dividingBy: 1) == 0
        ? String(format: "%.0f", value)
        : String(format: "%.2f", value)
    }
}
