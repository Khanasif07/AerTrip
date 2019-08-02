//
//  DownloadInvoiceTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 20/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class DownloadInvoiceTableViewCell: ATTableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topDividerView: UIView!
    @IBOutlet weak var bottomDividerView: UIView!
    
    override func setupFonts() {
        self.titleLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupTexts() {
        self.titleLabel.text = LocalizedString.DownloadInvoice.localized
    }
    
    override func setupColors() {
        self.titleLabel.textColor = AppColors.themeGreen
    }
}
