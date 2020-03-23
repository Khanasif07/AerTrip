//
//  BookingPaymentMoneyTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 17/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class PaymentInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var paymentInfoLabel: UILabel!
    @IBOutlet weak var nextScreenImageView: UIImageView!
    @IBOutlet weak var paymentInfoTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }

    private func configUI() {
        self.paymentInfoLabel.text = LocalizedString.PaymentInfo.localized
        self.paymentInfoLabel.font = AppFonts.Regular.withSize(14.0)
        self.paymentInfoLabel.textColor = AppColors.themeGray40
        self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMinYCorner ,.layerMinXMinYCorner], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
    }
}
