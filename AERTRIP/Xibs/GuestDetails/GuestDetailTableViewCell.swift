//
//  GuestDetailTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 13/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol GuestDetailTableViewCellDelegate: class {
    func textField(_ textField: UITextField)
}

class GuestDetailTableViewCell: UITableViewCell {
    
    //MARK: - IB Outlets
  
    @IBOutlet weak var guestTitleLabel: UILabel!
    @IBOutlet weak var salutationTextField: PKFloatLabelTextField!
    @IBOutlet weak var firstNameTextField : PKFloatLabelTextField!
    @IBOutlet weak var lastNameTextField:PKFloatLabelTextField!
    
    // MARK: - Properties
    weak var delegate : GuestDetailTableViewCellDelegate?
    
    
    // MARK:- View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.setUpFont()
        self.setUpColor()
        self.doInitalSetup()
    }

   
    
    // MARK: - Helper methods
    
    
    private func doInitalSetup() {
         self.salutationTextField.titleYPadding = -10.0
         self.firstNameTextField.titleYPadding = -10.0
         self.lastNameTextField.titleYPadding = -10.0
         self.salutationTextField.delegate = self
         self.firstNameTextField.delegate = self
         self.lastNameTextField.delegate = self
    }
    
    private func setUpFont() {
        self.guestTitleLabel.font = AppFonts.SemiBold.withSize(16.0)
        let attributes = [NSAttributedString.Key.foregroundColor: AppColors.themeGray20,
                          .font : AppFonts.Regular.withSize(18.0)]
        salutationTextField.attributedPlaceholder = NSAttributedString(string: LocalizedString.Title.localized, attributes:attributes)
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: LocalizedString.FirstName.localized, attributes:attributes)
        lastNameTextField.attributedPlaceholder =  NSAttributedString(string: LocalizedString.LastName.localized, attributes:attributes)
        self.salutationTextField.font = AppFonts.Regular.withSize(18.0)
        self.firstNameTextField.font = AppFonts.Regular.withSize(18.0)
        self.lastNameTextField.font = AppFonts.Regular.withSize(18.0)
    }
    
    private func setUpColor() {
        self.guestTitleLabel.textColor = AppColors.themeBlack
        self.salutationTextField.textColor = AppColors.textFieldTextColor51
        self.firstNameTextField.textColor = AppColors.textFieldTextColor51
        
        self.lastNameTextField.textColor = AppColors.textFieldTextColor51
        self.salutationTextField.titleActiveTextColour = AppColors.themeGreen
        self.firstNameTextField.titleActiveTextColour = AppColors.themeGreen
        self.lastNameTextField.titleActiveTextColour = AppColors.themeGreen
    }
    
    
}

extension GuestDetailTableViewCell : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case salutationTextField :
            delegate?.textField(salutationTextField)
        case firstNameTextField:
            delegate?.textField(firstNameTextField)
        case lastNameTextField:
            delegate?.textField(lastNameTextField)
        default:
            break
        
        }
    }
}
