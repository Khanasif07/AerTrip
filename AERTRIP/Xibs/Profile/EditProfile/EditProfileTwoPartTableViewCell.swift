//
//  EditProfileTwoPartTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 22/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol EditProfileTwoPartTableViewCellDelegate: class {
    func deleteCellTapped(_ indexPath: IndexPath)
    func leftViewTap(_ indexPath: IndexPath, _ gesture: UITapGestureRecognizer)
    func textFieldText(_ indexPath: IndexPath, _ text: String)
    func textFieldEndEditing(_ indexPath: IndexPath, _ text: String)
}

class EditProfileTwoPartTableViewCell: UITableViewCell {
    // MARK: - IB Outlets
    
    @IBOutlet var leftView: UIView!
    @IBOutlet var leftTitleLabel: UILabel!
    @IBOutlet var blackDownImageView: UIImageView!
    @IBOutlet var leftSeparatorView: UIView!
    @IBOutlet var rightViewTextField: UITextField!
    @IBOutlet var rightSeparatorView: ATDividerView!
    @IBOutlet var deleteButton: UIButton!
    
    // MARK: - Variables
    
    weak var editProfilTwoPartTableViewCelldelegate: EditProfileTwoPartTableViewCellDelegate?
    var indexPath: IndexPath?
    var email: Email? {
        didSet {
            configureCell()
        }
    }
    
    var social: Social? {
        didSet {
            configureCell()
        }
    }
    
    
    // MARK: - View Life cycle methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        addGesture()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        deleteButton.isHidden = false
        rightViewTextField.isEnabled = true
        leftView.isUserInteractionEnabled = true
        leftTitleLabel.textColor = AppColors.textFieldTextColor
        rightViewTextField.textColor = AppColors.textFieldTextColor
        blackDownImageView.isHidden = false
        
       
    }
    
    // MARK: - Helper methods
    
    private func configureCell() {
        rightViewTextField.delegate = self
        if let email = self.email {
            leftTitleLabel.text = email.label
            rightViewTextField.text = email.value
          
        } else if let social = self.social {
            leftTitleLabel.text = social.label
            rightViewTextField.text = social.value
        }
    }
    
    private func addGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(leftViewTap(gesture:)))
        gesture.numberOfTapsRequired = 1
        leftView.isUserInteractionEnabled = true
        leftView.addGestureRecognizer(gesture)
        deleteButton.isHidden = false
    }
    
    @objc func leftViewTap(gesture: UITapGestureRecognizer) {
        if let indexPath = indexPath {
            editProfilTwoPartTableViewCelldelegate?.leftViewTap(indexPath, gesture)
        }
    }
    
    // MARK: - IB Actions
    
    @IBAction func deleteCellButtonTapped(_ sender: Any) {
        if let indexPath = indexPath {
            editProfilTwoPartTableViewCelldelegate?.deleteCellTapped(indexPath)
        }
    }
}

extension EditProfileTwoPartTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        NSLog("text field text \(textField.text ?? " ")")
        if let indexPath = indexPath {
            if let textFieldString = textField.text, let swtRange = Range(range, in: textFieldString) {
                let fullString = textFieldString.replacingCharacters(in: swtRange, with: string)
                editProfilTwoPartTableViewCelldelegate?.textFieldText(indexPath, fullString)
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let indexPath = indexPath {
            editProfilTwoPartTableViewCelldelegate?.textFieldEndEditing(indexPath, textField.text!)
        }
        return true
    }
}
