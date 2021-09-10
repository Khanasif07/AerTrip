//
//  BookingFFMealTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 22/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol BookingFFMealTableViewCellDelegate: class {
    func textFieldEditing(textfield: UITextField)
}

class BookingFFMealTableViewCell: ATTableViewCell {
    // MARK: - IBOutlet
    
    @IBOutlet weak var mealPreferenceLabel: UILabel!
    @IBOutlet weak var selectedMealPreferenceTextField: ATTextField!
    
    @IBOutlet weak var downImageView: UIImageView!
    @IBOutlet weak var dividerView: ATDividerView!
    
    // MARK: - Variables
    
    weak var delegate: BookingFFMealTableViewCellDelegate?
    
    override func doInitialSetup() {
        self.selectedMealPreferenceTextField.delegate = self
       
    }
    
    override func setupTexts() {
        self.mealPreferenceLabel.text = LocalizedString.mealPreference.localized
        self.selectedMealPreferenceTextField.text = LocalizedString.Select.localized
    }
    
    override func setupFonts() {
        self.mealPreferenceLabel.font = AppFonts.Regular.withSize(14.0)
        self.selectedMealPreferenceTextField.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupColors() {
        self.mealPreferenceLabel.textColor = AppColors.themeGray153
        self.selectedMealPreferenceTextField.textColor = AppColors.textFieldTextColor51
    }
    
    func configureCell(title: String, text: String) {
        self.selectedMealPreferenceTextField.tintColor = AppColors.themeWhite.withAlphaComponent(0.01)
        self.mealPreferenceLabel.text = title
        self.selectedMealPreferenceTextField.text = text.isEmpty ? LocalizedString.Select.localized : text
    }
}

extension BookingFFMealTableViewCell: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.delegate?.textFieldEditing(textfield: textField)
        return true
    }
}
