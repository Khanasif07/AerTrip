//
//  UpdateAccountDropdownCell.swift
//  AERTRIP
//
//  Created by Appinventiv  on 12/01/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import UIKit

class UpdateAccountDropdownCell: UITableViewCell {
    @IBOutlet weak var updateTextField: PKFloatLabelTextField!
    @IBOutlet weak var deviderView: ATDividerView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.hideSeparator()
        self.setUpTextField()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
    private func setUpTextField(){
        
        updateTextField.titleYPadding = 12.0
        updateTextField.hintYPadding = 12.0
        updateTextField.addTarget(self, action: #selector(self.textFieldDidChanged(_:)), for: .editingChanged)
//        updateTextField.delegate = self
        updateTextField.titleFont = AppFonts.Regular.withSize(14)
        updateTextField.font = AppFonts.Regular.withSize(18.0)
        updateTextField.textColor = AppColors.themeBlack
        updateTextField.titleTextColour = AppColors.themeGray40
        updateTextField.isHiddenBottomLine = false
        updateTextField.lineView.isHidden = true
        updateTextField.titleActiveTextColour = AppColors.themeGreen
        updateTextField.selectedLineColor = AppColors.clear
        updateTextField.editingBottom = 0.0
        updateTextField.lineColor = AppColors.clear//divider.color
        updateTextField.lineErrorColor = AppColors.clear
        updateTextField.autocorrectionType = .no
        addressLabel.font = AppFonts.Regular.withSize(14)
        addressLabel.textColor = AppColors.themeGray40
    }
    
    func setPlaceHolderAndDelegate(with txt: String, textFieldDelegate: UITextFieldDelegate){
        updateTextField.setUpAttributedPlaceholder(placeholderString: txt, foregroundColor: AppColors.themeGray40)
        self.updateTextField.delegate = textFieldDelegate
    }
    
}

extension UpdateAccountDropdownCell{
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        
    }
    
}
