//
//  BookingFFMealTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 22/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingFFMealTableViewCell: ATTableViewCell {

    // MARK: - IBOutlet
    
    @IBOutlet weak var mealPreferenceLabel: UILabel!
    @IBOutlet weak var selectedMealPreferenceLabel: UILabel!
    
    @IBOutlet weak var downImageView: UIImageView!
    
    
    override func setupTexts() {
        self.mealPreferenceLabel.text = LocalizedString.mealPreference.localized
        self.selectedMealPreferenceLabel.text = LocalizedString.Select.localized
    }
    
    override func setupFonts() {
       self.mealPreferenceLabel.font = AppFonts.Regular.withSize(14.0)
         self.selectedMealPreferenceLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupColors() {
        self.mealPreferenceLabel.textColor = AppColors.themeGray40
    self.selectedMealPreferenceLabel.textColor = AppColors.textFieldTextColor51
    }
    
    
    
   
    
}
