//
//  SingleTextFieldCell.swift
//  Aertrip
//
//  Created by Apple  on 14.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class SingleTextFieldCell: UITableViewCell {

    @IBOutlet weak var textField: PKFloatLabelTextField!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var separatorViewLeading: NSLayoutConstraint!
    @IBOutlet weak var separatorViewTrailing: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupFont()
        self.selectionStyle = .none
    }

    func setupFont(){
        textField.titleYPadding = 8.0
        textField.hintYPadding = 4.0
        textField.font = AppFonts.Regular.withSize(18.0)
        textField.titleFont = AppFonts.Regular.withSize(14.0)
        textField.textColor = AppColors.textFieldTextColor51
        textField.titleActiveTextColour = AppColors.themeGreen
        textField.lineViewBottomSpace = 0
        textField.lineColor = AppColors.clear
        textField.selectedLineColor = AppColors.clear
    }
    

    func configureCellForGST(at indexPath:IndexPath, with gst:GSTINModel){
        separatorViewLeading.constant = 16
        separatorViewTrailing.constant = 16
        switch indexPath.row {
        case 0:
            textField.setUpAttributedPlaceholder(placeholderString: "Billing Name",with: "", foregroundColor: AppColors.themeGray20)
            textField.text = gst.billingName
        case 1:
            textField.setUpAttributedPlaceholder(placeholderString: "Company Name",with: "", foregroundColor: AppColors.themeGray20)
            
            textField.text = gst.companyName
        case 2:
            textField.setUpAttributedPlaceholder(placeholderString: "GSTIN Registration Number",with: "", foregroundColor: AppColors.themeGray20)
            separatorViewLeading.constant = 0
            separatorViewTrailing.constant = 0
            textField.text = gst.GSTInNo
        default:
            break
        }
    }
}


