//
//  HCEmailTextFieldCell
//  AERTRIP
//
//  Created by apple on 26/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HCEmailTextFieldCellDelegate: class {
      func textEditableTableViewCellTextFieldText(_ indexPath: IndexPath, _ text: String)
}

class HCEmailTextFieldCell: UITableViewCell {
    
    // MARK: - IB Outlets
    
    
    @IBOutlet weak var editableTextField: PKFloatLabelTextField! {
        didSet {
            editableTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: UIControl.Event.editingChanged)
            editableTextField.delegate = self
        }
    }
    @IBOutlet weak var separatorView: ATDividerView!
    @IBOutlet weak var textFiledBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textFieldTopConstraint: NSLayoutConstraint!
    
    
    // MARK: - Variables
    weak var delegate : HCEmailTextFieldCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.doInitialSetup()
        self.setUpColor()
        self.setUpFont()
        
    }
    
    
    private func doInitialSetup() {
        self.editableTextField.isHiddenBottomLine = false
        self.separatorView.isHidden = true
        self.editableTextField.titleYPadding = 12.0
        self.editableTextField.hintYPadding = 12.0
    }
    
    
    private func setUpColor() {
        self.editableTextField.titleActiveTextColour = AppColors.themeGreen
        self.editableTextField.textColor =  AppColors.textFieldTextColor51
    }
    
    private func setUpFont() {
        self.editableTextField.font = AppFonts.Regular.withSize(18.0)
    }

}


extension HCEmailTextFieldCell: UITextFieldDelegate {
    @objc func textFieldDidChanged(_ textField: UITextField) {
        printDebug("text field text \(textField.text ?? " ")")
        
        let finalTxt = (textField.text ?? "").removeAllWhitespaces
        if let idxPath = indexPath, !finalTxt.isEmpty {
            delegate?.textEditableTableViewCellTextFieldText(idxPath, finalTxt)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //for verify the data
        let finalTxt = (textField.text ?? "").removeAllWhitespaces
        self.editableTextField.isError = finalTxt.checkInvalidity(.Email)
    }
}
