//
//  FareInfoHeaderView.swift
//  AERTRIP
//
//  Created by apple on 10/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol FareInfoHeaderViewDelegate: class {
    func fareButtonTapped(_ sender: UIButton)
}

class FareInfoHeaderView: UITableViewHeaderFooterView {
    
    
    // MARK: - IB Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var refundPolicyLabel: UILabel!
    @IBOutlet weak var fareRulesButton: UIButton!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var infoLabel: UILabel!
    
    
    // MARK: - Variables
    weak var delegate: FareInfoHeaderViewDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFont()
        self.setUpColor()
    }
    
    
    private func setUpFont() {
        self.titleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.refundPolicyLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.infoLabel.font = AppFonts.Regular.withSize(16.0)
        self.fareRulesButton.titleLabel?.font = AppFonts.SemiBold.withSize(16.0)
        
    }
    
    private func setUpColor() {
        self.titleLabel.textColor = AppColors.themeBlack
        self.refundPolicyLabel.textColor = AppColors.themeBlack
        self.infoLabel.textColor = AppColors.themeGray40
        self.fareRulesButton.setTitleColor(AppColors.themeGreen, for: .normal)
    }
    
    
    // MARK: - IBAction
    
    @IBAction func fareRulesButtonTapped(_ sender: UIButton) {
        delegate?.fareButtonTapped(sender)
    }
}
