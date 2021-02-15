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
    func leftViewTap(_ indexPath: IndexPath, _ gesture: UITapGestureRecognizer, textField: UITextField)
    func textFieldText(_ indexPath: IndexPath, _ text: String)
    func textFieldEndEditing(_ indexPath: IndexPath, _ text: String)
}

class EditProfileTwoPartTableViewCell: UITableViewCell {
    // MARK: - IB Outlets
    
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var blackDownImageView: UIImageView!
    @IBOutlet weak var leftSeparatorView: ATDividerView!
    @IBOutlet weak var rightViewTextField: UITextField!
    @IBOutlet weak var rightSeparatorView: ATDividerView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var leftViewTextField: UITextField!
    @IBOutlet weak var leftSeparatorLeading: NSLayoutConstraint!
    @IBOutlet weak var rightSeparatorLeading: NSLayoutConstraint!
    
    // MARK: - Variables
    
    weak var editProfilTwoPartTableViewCelldelegate: EditProfileTwoPartTableViewCellDelegate?

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
    
    var isSettingForEdit:Bool = false{
        didSet{
            if isSettingForEdit{
                self.deleteButton.setImage(#imageLiteral(resourceName: "editPencel"), for: .normal)
            }else{
                self.deleteButton.setImage(#imageLiteral(resourceName: "redMinusButton"), for: .normal)
            }
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
        leftTitleLabel.textColor = AppColors.textFieldTextColor51
        rightViewTextField.textColor = AppColors.textFieldTextColor51
        blackDownImageView.isHidden = false
        
       
    }
    
    // MARK: - Helper methods
    
    private func configureCell() {
        rightViewTextField.delegate = self
        if let email = self.email {
            leftTitleLabel.text = email.label.capitalizedFirst()
            rightViewTextField.text = email.value
          
        } else if let social = self.social {
            leftTitleLabel.text = social.label.capitalizedFirst()
            rightViewTextField.text = social.value
        }
    }
    
    func setSeparator(isNeeded:Bool, isError:Bool, isLast:Bool){
        self.leftSeparatorView.isHidden = !isNeeded
        self.rightSeparatorView.isHidden = !isNeeded
        self.leftSeparatorLeading.constant = (isLast && isNeeded) ? 0.0 : 16.0
        self.rightSeparatorLeading.constant = (isLast && isNeeded) ? 0.0 : 16.0
        if let email = self.email, isError{
            if isLast{
                self.leftSeparatorView.isSettingForErrorState = ((!email.value.isEmail) || email.isDuplicate)
            }
            self.rightSeparatorView.isSettingForErrorState = ((!email.value.isEmail) || email.isDuplicate)
        }else{
            self.leftSeparatorView.isSettingForErrorState = false
            self.rightSeparatorView.isSettingForErrorState = false
        }
        
    }
    
    
    func setSeparatorForSocial(isNeeded:Bool, isError:Bool, isLast:Bool){
        self.leftSeparatorView.isHidden = !isNeeded
        self.rightSeparatorView.isHidden = !isNeeded
        self.leftSeparatorLeading.constant = (isLast && isNeeded) ? 0.0 : 16.0
        self.rightSeparatorLeading.constant = (isLast && isNeeded) ? 0.0 : 16.0
        if let social = self.social, isError{
            if isLast{
                self.leftSeparatorView.isSettingForErrorState = ((social.value.isEmpty) || social.isDuplicate)
            }
            self.rightSeparatorView.isSettingForErrorState = ((social.value.isEmpty) || social.isDuplicate)
        }else{
            self.leftSeparatorView.isSettingForErrorState = false
            self.rightSeparatorView.isSettingForErrorState = false
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
        if let idxPath = indexPath {
            editProfilTwoPartTableViewCelldelegate?.leftViewTap(idxPath, gesture, textField: self.leftViewTextField)
        }
    }
    
    // MARK: - IB Actions
    
    @IBAction func deleteCellButtonTapped(_ sender: Any) {
        if let idxPath = indexPath {
            editProfilTwoPartTableViewCelldelegate?.deleteCellTapped(idxPath)
        }
    }
}

extension EditProfileTwoPartTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        printDebug("text field text \(textField.text ?? " ")")
        guard let inputMode = textField.textInputMode else {
            return false
        }
        if inputMode.primaryLanguage == "emoji" || !(inputMode.primaryLanguage != nil) {
            return false
        }
            if let idxPath = indexPath {
                if let textFieldString = textField.text, let swtRange = Range(range, in: textFieldString) {
                    if  string == " " {
                        return false
                    }
                    let fullString = textFieldString.replacingCharacters(in: swtRange, with: string)
                    editProfilTwoPartTableViewCelldelegate?.textFieldText(idxPath, fullString)
                }
            }
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.leftSeparatorView.isSettingForErrorState = false
        self.rightSeparatorView.isSettingForErrorState = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let idxPath = indexPath {
            editProfilTwoPartTableViewCelldelegate?.textFieldEndEditing(idxPath, textField.text!)
        }
        return true
    }
}
