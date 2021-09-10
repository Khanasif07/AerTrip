//
//  FareDetailTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FareDetailTableViewCell: UITableViewCell {
    // MARK: - IB Outlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var fareDetailTitleLabel: UILabel!
    @IBOutlet weak var numberOfRoomAndLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpText()
        self.setUpFont()
        self.setUpColor()
    }
    
    private func setUpText() {
        self.fareDetailTitleLabel.text = LocalizedString.FareDetails.localized
    }
    
    private func setUpFont() {
        self.fareDetailTitleLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.numberOfRoomAndLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    private func setUpColor() {
        self.fareDetailTitleLabel.textColor = AppColors.themeBlack
        self.numberOfRoomAndLabel.textColor = AppColors.themeBlack
        self.containerView.backgroundColor = AppColors.themeBlack26
    }
    
    internal func setupForFinalCheckOutScreen(text: String) {
        self.fareDetailTitleLabel.text = "\(LocalizedString.FareBreakup.localized) (\(text))"
        self.numberOfRoomAndLabel.isHidden = true
        self.dividerView.isHidden = false
    }
}
