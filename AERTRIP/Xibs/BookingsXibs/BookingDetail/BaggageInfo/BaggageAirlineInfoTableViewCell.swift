//
//  BaggageAirlineInfoTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 09/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol BaggageAirlineInfoTableViewCellDelegate: class {
    func dimensionButtonTapped(_ dimensionButton: UIButton)
}

class BaggageAirlineInfoTableViewCell: UITableViewCell {

    
    //MARK: - IB Outlets
    @IBOutlet weak var airlineImageView: UIImageView!
    @IBOutlet weak var airlineNameLabel: UILabel!
    @IBOutlet weak var airlineCodeLabel: UILabel!
    @IBOutlet weak var dimensionButton: UIButton!
    
    // MARK: - Variables
    weak var delegate: BaggageAirlineInfoTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFont()
        self.setUpTextColor()
        self.setUpText()
    }

    // Helper methods
    
    private func setUpFont() {
        self.airlineNameLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.airlineCodeLabel.font = AppFonts.Regular.withSize(14.0)
        self.dimensionButton.titleLabel?.font = AppFonts.SemiBold.withSize(16.0)
        
    }
    
    private func setUpTextColor() {
        self.airlineNameLabel.textColor = AppColors.themeBlack
        self.airlineCodeLabel.textColor = AppColors.themeGray40
        self.dimensionButton.setTitleColor(AppColors.themeGreen, for: .normal)
    }
    
    private func setUpText() {
       self.dimensionButton.setTitle(LocalizedString.Dimensions.localized, for: .normal)
    }
    
    
    @IBAction func dimensionButtonTapped(_ sender: Any) {
        self.delegate?.dimensionButtonTapped(self.dimensionButton)
    }
    
    
}
