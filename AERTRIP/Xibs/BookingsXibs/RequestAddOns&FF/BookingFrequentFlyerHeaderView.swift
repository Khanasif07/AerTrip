//
//  BookingFrequestFlyerHeaderView.swift
//  AERTRIP
//
//  Created by apple on 22/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingFrequentFlyerHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var passengerNameLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var frequentFlyerLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFont()
        self.setUpText()
        self.setUpTextColor()
    }

    
    // MARK: - Variables
    
    func setUpFont() {
        self.passengerNameLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.frequentFlyerLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    func setUpText() {
    self.frequentFlyerLabel.text = LocalizedString.FrequentFlyer.localized
    }
    
    func setUpTextColor() {
    self.frequentFlyerLabel.textColor = AppColors.themeGray40
    }
    
    
    

}
