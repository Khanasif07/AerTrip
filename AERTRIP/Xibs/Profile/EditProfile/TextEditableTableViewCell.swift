//
//  TextEditableTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 26/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol TextEditableTableViewCellDelegate: class {
      func textEditableTableViewCellTextFieldText(_ indexPath: IndexPath, _ text: String)
}

class TextEditableTableViewCell: UITableViewCell {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editableTextField: PKFloatLabelTextField! {
        didSet {
            editableTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: UIControl.Event.editingChanged)
        }
    }
    @IBOutlet weak var separatorView: ATDividerView!
    @IBOutlet weak var downArrowImageView: UIImageView!
    
    
    // MARK: - Variables
    weak var delegate : TextEditableTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//         editableTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Helper methods
    
    func configureCell(_ title: String, _ text: String) {
        titleLabel.text = title
        editableTextField.text = text
       
    }
    
}


extension TextEditableTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        printDebug("text field text \(textField.text ?? " ")")
        guard let inputMode = textField.textInputMode else {
            return false
        }
        if inputMode.primaryLanguage == "emoji" || !(inputMode.primaryLanguage != nil) {
            return false
        }
        return true
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        printDebug("text field text \(textField.text ?? " ")")
        if let idxPath = indexPath, let textFieldString = textField.text {
            delegate?.textEditableTableViewCellTextFieldText(idxPath, textFieldString)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   
}
