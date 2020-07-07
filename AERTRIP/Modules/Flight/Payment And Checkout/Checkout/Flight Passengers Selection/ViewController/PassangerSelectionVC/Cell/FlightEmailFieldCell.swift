//
//  FlightEmailFieldCell.swift
//  Aertrip
//
//  Created by Apple  on 04.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit


protocol FlightEmailTextFieldCellDelegate: class {
      func textEditableTableViewCellTextFieldText(_ indexPath: IndexPath, _ text: String)
}

class FlightEmailFieldCell: UITableViewCell {
    
    // MARK: - IB Outlets
    
    
    @IBOutlet weak var editableTextField: PKFloatLabelTextField! {
        didSet {
            editableTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: UIControl.Event.editingChanged)
            editableTextField.delegate = self
        }
    }
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var textFiledBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldTopConstraint: NSLayoutConstraint!
    
    
    // MARK: - Variables
    weak var delegate : FlightEmailTextFieldCellDelegate?
    var idxPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.doInitialSetup()
        self.setUpColor()
        self.setUpFont()
        
    }
    
    
    private func doInitialSetup() {
        self.editableTextField.titleYPadding = 12.0
        self.editableTextField.hintYPadding = 12.0
        self.editableTextField.isHiddenBottomLine = false
        self.editableTextField.lineView.isHidden = true
        self.editableTextField.lineColor = AppColors.clear
        self.separatorView.backgroundColor = AppColors.divider.color
    }
    
    
    private func setUpColor() {
        self.editableTextField.titleActiveTextColour = AppColors.themeGreen
        self.editableTextField.textColor = AppColors.textFieldTextColor51
        self.editableTextField.setUpAttributedPlaceholder(placeholderString: "Email ID",with: "")
    }
    
    private func setUpFont() {
        self.editableTextField.font = AppFonts.Regular.withSize(18.0)
    }

    
    func configureCell(with email:String, isLoggedIn:Bool){
        self.editableTextField.autocorrectionType = .no
        self.editableTextField.autocapitalizationType = .none
        self.editableTextField.text = email
        self.editableTextField.isUserInteractionEnabled = !isLoggedIn
        if !isLoggedIn{
            self.editableTextField.textColor =  AppColors.textFieldTextColor51
        }else{
            self.editableTextField.textColor =  AppColors.themeGray40
        }
    }
    
}


extension FlightEmailFieldCell: UITextFieldDelegate {
    @objc func textFieldDidChanged(_ textField: UITextField) {
//        printDebug("text field text \(textField.text ?? " ")")
        self.editableTextField.lineView.backgroundColor = AppColors.clear
        let finalTxt = (textField.text ?? "").removeAllWhitespaces
        if let idxPath = indexPath, !finalTxt.isEmpty {
            delegate?.textEditableTableViewCellTextFieldText(idxPath, finalTxt)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //for verify the data
        self.editableTextField.lineView.backgroundColor = AppColors.clear
        let finalTxt = textField.text?.replacingOccurrences(of: " ", with: "")
        textField.text = finalTxt
        delegate?.textEditableTableViewCellTextFieldText(idxPath, finalTxt!)
        self.editableTextField.isError = finalTxt?.checkInvalidity(.Email) ?? false
    }
}


extension UITextField{
    
    func setUpAttributedPlaceholder(placeholderString: String,with symbol: String = "*",foregroundColor: UIColor = AppColors.themeGray40,isChnagePlacehoder:Bool = false) {
        let attriburedString = NSMutableAttributedString(string: placeholderString)
        if isChnagePlacehoder{
            let range = NSString(string: placeholderString).range(of: placeholderString)
            attriburedString.addAttribute(.foregroundColor, value: foregroundColor, range: range)
        }
        let asterix = NSAttributedString(string: symbol, attributes: [.foregroundColor: foregroundColor])
        attriburedString.append(asterix)
        
        self.attributedPlaceholder = attriburedString
    }
    
}
