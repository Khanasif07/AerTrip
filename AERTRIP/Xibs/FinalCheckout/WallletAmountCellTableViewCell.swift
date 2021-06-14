//
//  WallletAmountCellTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class WallletAmountCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var aertripWalletTitleLabel: UILabel!
    @IBOutlet weak var walletAmountLabel: UILabel!
    @IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.callForReuse()
    }
    
    func callForReuse(){
        self.setUpText()
        self.setUpFont()
        self.setUpColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.walletAmountLabel.attributedText = nil
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
        self.contentView.backgroundColor = AppColors.themeWhiteDashboard
    }
    
    func setForConvenienceFee(){
        let atText = NSMutableAttributedString(string: LocalizedString.ConvenienceFeeNonRefundables.localized, attributes: [.foregroundColor: AppColors.themeBlack, .font: AppFonts.Regular.withSize(16)])
        let rang = NSString(string: LocalizedString.ConvenienceFeeNonRefundables.localized).range(of: LocalizedString.non_Refundable.localized)
        atText.addAttribute(.font, value: AppFonts.Regular.withSize(14), range: rang)
        self.aertripWalletTitleLabel.attributedText = atText
    }
}
