//
//  EditProfileImageHeaderView.swift
//  AERTRIP
//
//  Created by apple on 21/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol EditProfileImageHeaderViewDelegate: class {
    func editButtonTapped()
    func salutationViewTapped()
    func selectGroupTapped()
    func textFieldText(_ textfield: UITextField)
}

class EditProfileImageHeaderView: UIView {
    // MARK: - IB Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var salutationView: UIView!
    @IBOutlet weak var salutaionLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var selectGroupDownArrow: UIImageView!
    
    @IBOutlet weak var selectGroupViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectGroupView: UIView!
    
    // MARK: - Variables
    
    weak var delegate: EditProfileImageHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        editButton.setTitle(LocalizedString.Edit.rawValue.localizedLowercase, for: .normal)
        salutaionLabel.text = LocalizedString.Title.rawValue
        firstNameTextField.placeholder = LocalizedString.FirstName.localized
        lastNameTextField.placeholder = LocalizedString.LastName.localized
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(salutationView(_:)))
        salutationView.isUserInteractionEnabled = true
        salutationView.addGestureRecognizer(tap)
        
        let selectGrouptap = UITapGestureRecognizer(target: self, action: #selector(selectGroupTapped(_:)))
        selectGroupView.isUserInteractionEnabled = true
        selectGroupView.addGestureRecognizer(selectGrouptap)
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.layer.borderColor = AppColors.themeGray10.cgColor
        profileImageView.layer.borderWidth = 2.0
        profileImageView.clipsToBounds = true
        
        groupTitleLabel.text = LocalizedString.Group.localized
        groupLabel.text = LocalizedString.Select.localized
        
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
    }
    
    // MARK: - Helper methods
    
    class func instanceFromNib() -> EditProfileImageHeaderView {
        return UINib(nibName: "EditProfileImageHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EditProfileImageHeaderView
    }
    
    // MARK: - IB Actions
    
    @IBAction func editButtonTapped(_ sender: Any) {
        delegate?.editButtonTapped()
    }
    
    @objc func salutationView(_ sender: UITapGestureRecognizer) {
        delegate?.salutationViewTapped()
    }
    
    @objc func selectGroupTapped(_ sender: UITapGestureRecognizer) {
        delegate?.selectGroupTapped()
    }
}

// MARK: - UITextField methods

extension EditProfileImageHeaderView: UITextFieldDelegate {
    @objc func textFieldDidChanged(_ textField: UITextField) {
        delegate?.textFieldText(textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        if textField === self.firstNameTextField {
            return newString.length <= AppConstants.kNameTextLimit
        }
        else if textField === self.lastNameTextField {
            return newString.length <= AppConstants.kNameTextLimit
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
