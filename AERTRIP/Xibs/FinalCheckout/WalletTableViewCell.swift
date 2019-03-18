//
//  WalletTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class WalletTableViewCell: UITableViewCell {
    
    @IBOutlet weak var walletTitleLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var walletSwitch: UISwitch!
    @IBOutlet weak var infoButton: UIButton!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.setUpFonts()
        self.setUpColors()
        self.setUpText()
    }

   
    // Mark: - Helper methods
    
    private func setUpFonts() {
        self.walletTitleLabel.font = AppFonts.Regular.withSize(18.0)
        self.balanceLabel.font = AppFonts.Regular.withSize(16.0)
        self.amountLabel.font = AppFonts.SemiBold.withSize(16.0)
        
        
    }
    
    private func setUpColors() {
        self.walletTitleLabel.textColor = AppColors.textFieldTextColor51
        self.balanceLabel.textColor = AppColors.themeGray40
        self.amountLabel.textColor = AppColors.textFieldTextColor51

    }
    
    private func setUpText() {
        self.walletTitleLabel.text = LocalizedString.PayByAertripWallet.localized
        self.balanceLabel.text = LocalizedString.Balance.localized
        
    }
    
}
