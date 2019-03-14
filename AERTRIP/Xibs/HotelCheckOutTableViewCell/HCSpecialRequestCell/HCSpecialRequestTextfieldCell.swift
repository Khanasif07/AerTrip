//
//  HCSpecialRequestTableFooterView.swift
//  AERTRIP
//
//  Created by Admin on 14/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol SpecialReqAndAirLineInfoDelegate: class {
    func passingSpecialRequestAndAirLineInfo(infoText: String)
}

class HCSpecialRequestTextfieldCell: UITableViewCell {
    
    //Mark:- Variables
    weak var delegate: SpecialReqAndAirLineInfoDelegate?
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var topDividerView: ATDividerView!
    @IBOutlet weak var topDividerViewTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var infoTextField: UITextField! {
        didSet {
            self.infoTextField.delegate = self
        }
    }
    @IBOutlet weak var bottomDividerView: ATDividerView!
    
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
        self.infoTextField.setAttributedPlaceHolder(placeHolderText: "")
        //        self.infoTextField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: AppColors.themeGray20,NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0)])
        //        self.specialRequestTextField.attributedPlaceholder = NSAttributedString(string: LocalizedString.SpecialRequestIfAny.localized, attributes: [NSAttributedString.Key.foregroundColor: AppColors.themeGray20,NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0)])
        
    }
    
    internal func configCell(placeHolderText: String) {
        self.infoTextField.placeholder = placeHolderText
    }
}

extension HCSpecialRequestTextfieldCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return false }
        let finalText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if !finalText.isEmpty {
            self.delegate?.passingSpecialRequestAndAirLineInfo(infoText: finalText)
        }
        return true
    }
}
