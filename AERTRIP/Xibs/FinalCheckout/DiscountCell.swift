//
//  DiscountCell.swift
//  AERTRIP
//
//  Created by apple on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class DiscountCell: UITableViewCell {
    // MARK: - IB Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var titleLabelBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabelLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpText()
        self.setUpFont()
        self.setUpColor()
    }
    
    private func setUpText() {
        self.titleLabel.text = LocalizedString.CouponDiscount.localized
        self.amountLabel.text = 500.0.amountInDelimeterWithSymbol
    }
    
    private func setUpFont() {
        self.titleLabel.font = AppFonts.Regular.withSize(14.0)
        self.amountLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    private func setUpColor() {
        self.titleLabel.textColor = AppColors.themeBlack
        self.amountLabel.textColor = AppColors.themeBlack
    }
    
    func configureCell(title: String, amount: String) {
        self.titleLabel.text = title
        self.amountLabel.text = amount
    }
}
