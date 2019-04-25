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
        }
    }
    @IBOutlet weak var separatorView: ATDividerView!
    
    
    // MARK: - Variables
    weak var delegate : HCEmailTextFieldCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.doInitialSetup()
        self.setUpColor()
        self.setUpFont()
        
    }
    
    
    private func doInitialSetup() {
        self.editableTextField.titleYPadding = 4
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
        if let idxPath = indexPath, let textFieldString = textField.text {
            delegate?.textEditableTableViewCellTextFieldText(idxPath, textFieldString)
        }
    }
    
  
    
   
}
