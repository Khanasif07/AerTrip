//
//  GroupTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 08/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol GroupTableViewCellDelegate: class {
    func deleteCellTapped(_ indexPath: IndexPath)
    func textField(_ textField: UITextField)
    func textFieldWhileEditing(_ textField: UITextField, _ indexPath: IndexPath)
}

class GroupTableViewCell: UITableViewCell {
    // MARK: - IB Outlets
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var groupCountLabel: UILabel!
    @IBOutlet weak var reorderButton: UIButton!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var deleteButtonWidthConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    
    weak var delegate: GroupTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        groupNameTextField.font = AppFonts.Regular.withSize(18.0)
        groupNameTextField.textColor = AppColors.themeBlack
        
        groupCountLabel.font = AppFonts.Regular.withSize(18.0)
        groupCountLabel.textColor = AppColors.themeGray40
        groupNameTextField.delegate = self
        groupNameTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
    }
    
    // MARK: - Helper methods
    
    func configureCell(_ groupName: String, _ totalContactsCount: Int) {
        
        groupNameTextField.isEnabled = true
        
        if groupName.lowercased() == LocalizedString.Others.localized.lowercased() {
             self.deleteButton.isHidden = true
        } else {
             self.deleteButton.isHidden = false
        }
        if groupName.removeAllWhitespaces.lowercased() ==  LocalizedString.Others.localized.removeAllWhitespaces.lowercased() {
            groupNameTextField.isEnabled = false
        }
        groupNameTextField.text = groupName
        
        groupCountLabel.text = "\(totalContactsCount)"
    }
    
    @IBAction func deleteCellTapped(_ sender: Any) {
        if let idxPath = indexPath {
            delegate?.deleteCellTapped(idxPath)
        }
    }
}

extension GroupTableViewCell: UITextFieldDelegate {
    @objc func textFieldDidChanged(_ textField: UITextField) {
        if let txtStr = textField.text, txtStr.count > AppConstants.kFirstLastNameTextLimit {
            textField.text = txtStr.substring(to: 30)
            return
        }
        
        if let idxPath = indexPath {
            delegate?.textFieldWhileEditing(textField, idxPath)
        }
    }
}
