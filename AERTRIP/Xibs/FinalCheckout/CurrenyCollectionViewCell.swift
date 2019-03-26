//
//  CurrenyCollectionViewCell.swift
//  AERTRIP
//
//  Created by apple on 26/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class CurrenyCollectionViewCell: UICollectionViewCell {
    // MARK: - IB Outlets
    
    @IBOutlet var currencyNameLabel: UILabel!
    @IBOutlet var currencyConversionValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.doInitialSetUp()
        self.setUpFont()
        self.setUpTextColor()
    }
    
    private func doInitialSetUp() {
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = AppColors.themeGray10.cgColor
        self.backgroundColor = AppColors.themeWhite
    }
    
    private func setUpFont() {
        self.currencyNameLabel.font = AppFonts.SemiBold.withSize(19.0)
        self.currencyConversionValueLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    private func setUpTextColor() {
        self.currencyNameLabel.textColor = AppColors.themeGray60
        self.currencyConversionValueLabel.textColor = AppColors.themeGray60
        self.backgroundColor = AppColors.themeWhite
    }
    
    // set  theme Green color for selectedState
    
    func setSelectedState() {
        self.currencyNameLabel.textColor = AppColors.themeGreen
        self.currencyConversionValueLabel.textColor = AppColors.themeGreen
        self.backgroundColor = AppColors.iceGreen
        self.layer.borderColor = AppColors.themeGreen.cgColor
        self.layer.borderWidth = 1.0
    }
    
    // set  default color for Deselected state
    func setDeselectedState() {
        self.setUpTextColor()
        self.doInitialSetUp()
    }
}
