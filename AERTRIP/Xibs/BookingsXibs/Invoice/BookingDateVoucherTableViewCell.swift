//
//  BookingDateVoucherTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 20/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingDateVoucherTableViewCell: ATTableViewCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var voucherLabel: UILabel!
    
    @IBOutlet var dateValueLabel: UILabel!
    @IBOutlet var voucherValueLabel: UILabel!
    
    override func doInitialSetup() {
        self.dateLabel.font = AppFonts.Regular.withSize(16.0)
        self.voucherLabel.font = AppFonts.Regular.withSize(16.0)
        self.dateValueLabel.font = AppFonts.Regular.withSize(16.0)
        self.voucherValueLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func setupTexts() {
        self.dateLabel.text = LocalizedString.Date.localized
        self.voucherLabel.text = LocalizedString.VoucherNo.localized
    }
    
    override func setupFonts() {
        self.dateLabel.font = AppFonts.Regular.withSize(16.0)
        self.voucherLabel.font = AppFonts.Regular.withSize(16.0)
        self.dateValueLabel.font = AppFonts.Regular.withSize(16.0)
        self.voucherValueLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func setupColors() {
        self.dateLabel.textColor = AppColors.themeBlack
        self.voucherLabel.textColor = AppColors.themeBlack
        self.dateValueLabel.textColor = AppColors.textFieldTextColor51
        self.voucherValueLabel.textColor = AppColors.textFieldTextColor51
    }
    
    func configureCell(date: String, voucher: String) {
        self.dateValueLabel.text = date
        self.voucherValueLabel.text = voucher
    }
}
