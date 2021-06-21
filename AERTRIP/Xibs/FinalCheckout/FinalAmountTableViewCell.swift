//
//  FinalAmountTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FinalAmountTableViewCell: UITableViewCell {
    // MARK: - IB Outlets
    
    @IBOutlet weak var payableWalletMessageLabel: UILabel!
    @IBOutlet weak var netEffectiveFareLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpText()
        self.setUpFont()
        self.setUpColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        payableWalletMessageLabel.attributedText = nil
        netEffectiveFareLabel.attributedText = nil
    }
    
    // MARK: - Helper Methods
    
    private func setUpText() {
        //self.payableWalletMessageLabel.text = LocalizedString.PayableWalletMessage.localized
        self.netEffectiveFareLabel.text = LocalizedString.NetEffectiveFare.localized + "\(Double(67000).delimiterWithSymbolTill2Places)"
    }
    
    private func setUpFont() {
        self.payableWalletMessageLabel.font = AppFonts.Regular.withSize(14.0)
        self.netEffectiveFareLabel.font = AppFonts.SemiBold.withSize(14.0)
    }
    
    private func setUpColor() {
        self.payableWalletMessageLabel.textColor = AppColors.themeBlack
        self.netEffectiveFareLabel.textColor = AppColors.themeBlack
        self.contentView.backgroundColor = AppColors.themeBlack26
    }
    
}
