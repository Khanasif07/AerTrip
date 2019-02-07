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
    @IBOutlet weak var editableTextField: UITextField!
    @IBOutlet weak var separatorView: ATDividerView!
    @IBOutlet weak var downArrowImageView: UIImageView!
    
    
    // MARK: - Variables
    weak var delegate : TextEditableTableViewCellDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Helper methods
    
    func configureCell(_ indexPath:IndexPath,_ title: String, _ text: String) {
        titleLabel.text = title
        editableTextField.text = text
        editableTextField.delegate = self
        self.indexPath = indexPath
    }
    
}


extension TextEditableTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSLog("text field text \(textField.text ?? " ")")
        if let indexPath = indexPath {
            if let textFieldString = textField.text, let swtRange = Range(range, in: textFieldString) {
                let fullString = textFieldString.replacingCharacters(in: swtRange, with: string)
                delegate?.textEditableTableViewCellTextFieldText(indexPath, fullString)
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   
}
