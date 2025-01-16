//
//  TabMenuCollectionViewCell.swift
//  Prashant_Kankayya_Demo


import UIKit

class TabMenuCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!

    override var isHighlighted: Bool {
        didSet {
            titleLabel.textColor = isHighlighted ? #colorLiteral(red: 0.6087209582, green: 0.6037558317, blue: 0.6081500649, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.6087209582, green: 0.6037558317, blue: 0.6081500649, alpha: 1)
        }
    }
}
