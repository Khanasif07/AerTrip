//
//  TotalPayableNowWithIconCell.swift
//  AERTRIP
//
//  Created by Apple  on 20.03.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class TotalPayableNowWithIconCell: UITableViewCell {
    
    enum UsingFor {
        case totalPayableAmout
        case normal
    }
    
    // MARK: - IB Outlets
    @IBOutlet weak var totalPayableNowLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var topDeviderView: ATDividerView!
    @IBOutlet weak var bottomDeviderView: ATDividerView!
    @IBOutlet weak var paymentImageView: UIImageView!
    @IBOutlet weak var totalPayableTextBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalPayableTextTopConstraint: NSLayoutConstraint!

    var currentUsingFor = UsingFor.totalPayableAmout {
        didSet {
            self.setUpText()
            self.setUpFont()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpText()
        self.setUpFont()
        self.setUpColor()
        
        self.topDeviderView.isHidden = true
        self.bottomDeviderView.isHidden = true
    }
    
    private func setUpText() {
        self.totalPayableNowLabel.text = LocalizedString.TotalPayableNow.localized
        
        self.totalPayableTextTopConstraint.constant = (currentUsingFor == .totalPayableAmout) ? 9.0 : 0.0
        self.totalPayableTextBottomConstraint.constant = (currentUsingFor == .totalPayableAmout) ? 14.5 : 0.0
    }
    
    private func setUpFont() {
        self.totalPayableNowLabel.font = AppFonts.Regular.withSize(((currentUsingFor == .totalPayableAmout) ? 18.0 : 16.0))
        self.totalPriceLabel.font = AppFonts.SemiBold.withSize(((currentUsingFor == .totalPayableAmout) ? 20.0 : 16.0))
    }
    
    private func setUpColor() {
        self.totalPayableNowLabel.textColor = AppColors.themeBlack
        self.totalPriceLabel.textColor = AppColors.themeBlack
    }
}
