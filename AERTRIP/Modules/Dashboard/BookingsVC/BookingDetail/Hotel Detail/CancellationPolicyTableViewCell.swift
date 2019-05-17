//
//  CancellationPolicyTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 15/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

enum CancellationType {
    case freeCancellation
    case cancellationFree
    case nonRefundable
    
    var title: String {
        switch self {
        case .freeCancellation:
            return LocalizedString.FreeCancellation.localized
        case .cancellationFree:
            return LocalizedString.CancellationFee.localized
        case .nonRefundable:
            return LocalizedString.NonRefundable.localized
        }
    }
}

class CancellationPolicyTableViewCell: ATTableViewCell {
    @IBOutlet var titleLabelLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - IBOultet
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var titleValueLabel: UILabel!
    
    // Override methods
    
    override func setupFonts() {
        self.titleLabel.font = AppFonts.Regular.withSize(14.0)
        self.titleValueLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func setupColors() {
        self.titleLabel.textColor = AppColors.themeGray60
        self.titleValueLabel.textColor = AppColors.themeGray60
    }
    
    func configureCell(cancellationTimePeriod: String, cancellationAmount: String, cancellationType: CancellationType) {
        self.titleLabelLeadingConstraint.constant = 16
        switch cancellationType {
        case .freeCancellation:
            self.titleLabelLeadingConstraint.constant = 12
            self.titleLabel.textColor = AppColors.themeGreen
            self.titleLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "", image: (UIImage(named: "greenBgIcon"))!, endText: cancellationType.title, font: AppFonts.SemiBold.withSize(18.0))
        case .cancellationFree:
            self.titleLabel.attributedText = self.getAttributedText(text: "\(cancellationAmount) " + cancellationType.title, amountText: cancellationAmount)
        case .nonRefundable:
            self.titleLabel.textColor = AppColors.themeRed
            self.titleLabel.font = AppFonts.Regular.withSize(18.0)
            self.titleLabel.text = cancellationType.title
        }
        self.titleValueLabel.text = cancellationTimePeriod
    }
    
    private func getAttributedText(text: String, amountText: String) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(14.0), .foregroundColor: AppColors.themeGray60])
        attString.addAttributes([
            .font: AppFonts.Regular.withSize(18.0),
            .foregroundColor: AppColors.themeRed
        ], range: (text as NSString).range(of: amountText))
        return attString
    }
}
