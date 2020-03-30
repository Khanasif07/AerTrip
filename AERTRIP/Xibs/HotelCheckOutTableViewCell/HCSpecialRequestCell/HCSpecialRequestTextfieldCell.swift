//
//  HCSpecialRequestTableFooterView.swift
//  AERTRIP
//
//  Created by Admin on 14/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HCSpecialRequestTextfieldCellDelegate: class {
    func didPassSpecialRequestAndAirLineText(infoText: String, textField: UITextField)
}

class HCSpecialRequestTextfieldCell: UITableViewCell {
    
    //Mark:- Variables
  public  weak var delegate: HCSpecialRequestTextfieldCellDelegate?
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var topDividerView: ATDividerView!
    @IBOutlet weak var topDividerViewTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var infoTextField: PKFloatLabelTextField! {
        didSet {
            self.infoTextField.delegate = self
            self.infoTextField.rightViewMode = .whileEditing
            self.infoTextField.textFieldClearBtnSetUp()
        }
    }
    @IBOutlet weak var bottomDividerView: ATDividerView!
    @IBOutlet weak var topDividerViewLeadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var bottomDividerViewTrailingConstraints: NSLayoutConstraint!
    @IBOutlet weak var bottomDividerViewLeadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topDividerTopConstraint: NSLayoutConstraint!
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Functions
    //================
    private func configUI() {
        //Text Color
        self.infoTextField.textColor = AppColors.textFieldTextColor51
        
        //Text Font
        self.infoTextField.font = AppFonts.Regular.withSize(18.0)
        
        //Text
        //self.infoTextField.setAttributedPlaceHolder(placeHolderText: "")
        
        self.infoTextField.titleYPadding = 11.0
        self.infoTextField.hintYPadding = 11.0

    }
    
    internal func configCell(placeHolderText: String) {
//        self.infoTextField.placeholder = placeHolderText
        self.infoTextField.setupTextField(placehoder: placeHolderText,with: "", keyboardType: .default, returnType: .default, isSecureText: false)
        self.bottomDividerView.isHidden = true
    }
}

//Mark:- UITextField Delegate
//===========================
extension HCSpecialRequestTextfieldCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return false }
        let finalText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        self.delegate?.didPassSpecialRequestAndAirLineText(infoText: finalText,textField: textField)

        return true
    }
}
