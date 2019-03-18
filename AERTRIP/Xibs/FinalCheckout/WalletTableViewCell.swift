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
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
       
        //self.setUpFonts()
//        self.setUpColors()
//        self.setUpText()
    }

   
    // Mark: - Helper methods
    
    private func setUpFonts() {
        walletTitleLabel.font = AppFonts.Regular.withSize(18.0)
        balanceLabel.font = AppFonts.Regular.withSize(16.0)
        amountLabel.font = AppFonts.SemiBold.withSize(16.0)
        
        
    }
    
//    private func setUpColors() {
//        walletTitleLabel.textColor = AppColors.textFieldTextColor51
//        balanceLabel.textColor = AppColors.themeGray40
//        amountLabel.textColor = AppColors.textFieldTextColor51
//
//    }
    
//    private func setUpText() {
//
//    }
    
}
