//
//  WallletAmountCellTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class WallletAmountCellTableViewCell: UITableViewCell {
    @IBOutlet var aertripWalletTitleLabel: UILabel!
    @IBOutlet var walletAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpText()
        self.setUpFont()
        self.setUpColor()
    }
    
    private func setUpText() {
        self.aertripWalletTitleLabel.text = LocalizedString.AertripWallet.localized
    }
    
    private func setUpFont() {
        self.aertripWalletTitleLabel.font = AppFonts.Regular.withSize(16.0)
        self.walletAmountLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    private func setUpColor() {
        self.aertripWalletTitleLabel.textColor = AppColors.themeGreen
        self.walletAmountLabel.textColor = AppColors.themeGreen
    }
}
