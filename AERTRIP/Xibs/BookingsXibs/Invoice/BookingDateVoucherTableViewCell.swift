//
//  BookingDateVoucherTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 20/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingDateVoucherTableViewCell: ATTableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var voucherLabel: UILabel!
    
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var dateValueLabel: UILabel!
    @IBOutlet weak var voucherValueLabel: UILabel!
    
    override func doInitialSetup() {
        self.dateLabel.font = AppFonts.Regular.withSize(16.0)
        self.voucherLabel.font = AppFonts.Regular.withSize(16.0)
        self.dateValueLabel.font = AppFonts.Regular.withSize(16.0)
        self.voucherValueLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func setupTexts() {
        self.dateLabel.text = LocalizedString.Date.localized
        self.voucherLabel.text = LocalizedString.VoucherNo.localized
        self.dividerView.isHidden = true
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
        self.dateValueLabel.textColor = AppColors.themeBlack
        self.voucherValueLabel.textColor = AppColors.themeBlack
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.dividerView.isHidden = true
    }
    
    func configureCell(date: String, voucher: String) {
        self.dateValueLabel.text = date
        self.voucherValueLabel.text = voucher
    }
}
