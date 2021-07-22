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
    func salutationViewTapped(title: String)
    func selectGroupTapped(_ textfield: UITextField)
    func textFieldText(_ textfield: UITextField)
    func endNicknameEditting()
    func shouldBeginNicknameEditting()
}

class EditProfileImageHeaderView: UIView {
    // MARK: - IB Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var selectGroupDownArrow: UIImageView!
    @IBOutlet weak var groupTextField: UITextField!
    
    @IBOutlet weak var genderTitleLabel: UILabel!
    @IBOutlet weak var selectGroupValueView: UIView!
//    @IBOutlet weak var selectGroupViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectGroupView: UIView!
    
    // Unicode Switch
    @IBOutlet weak var unicodeSwitch: ATUnicodeSwitch!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var verticalDividerView: UIView!
    @IBOutlet weak var switchParentContainerView: UIView!
    
    @IBOutlet weak var firstNameDividerView: ATDividerView!
    @IBOutlet weak var lastNameDividerView: ATDividerView!
    @IBOutlet weak var RelationOrNickNameView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var groupAndRelationStackView: UIStackView!
    @IBOutlet weak var relationshipOrNickNameLabel: UILabel!
    @IBOutlet weak var relationshipOrNickNameTextField: UITextField!
    
    
    
    // MARK: - Variables
    
    weak var delegate: EditProfileImageHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        editButton.setTitle(LocalizedString.Edit.rawValue.localizedLowercase, for: .normal)
        //        salutaionLabel.text = LocalizedString.Title.rawValue
        self.setUpUnicodeSwitch()
        firstNameTextField.setUpAttributedPlaceholder(placeholderString: LocalizedString.FirstName.localized, with: "")
        lastNameTextField.setUpAttributedPlaceholder(placeholderString: LocalizedString.LastName.localized,  with: "")
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        genderTitleLabel.text = LocalizedString.Gender.localized
        genderTitleLabel.font = AppFonts.Regular.withSize(17.0)
        genderTitleLabel.textColor = AppColors.themeBlack
        firstNameTextField.returnKeyType = .next
        lastNameTextField.returnKeyType = .done
        
        
        
        let selectGrouptap = UITapGestureRecognizer(target: self, action: #selector(selectGroupTapped(_:)))
        selectGroupView.isUserInteractionEnabled = true
        selectGroupValueView.addGestureRecognizer(selectGrouptap)
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.layer.borderColor = AppColors.profileImageBorderColor.cgColor
        profileImageView.layer.borderWidth = 2.0
        profileImageView.clipsToBounds = true
        
        groupTitleLabel.text = LocalizedString.Group.localized
        groupLabel.text = LocalizedString.Select.localized
        
        firstNameTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        
        firstNameTextField.addRightPaddingView(width: 16)
        lastNameTextField.addRightPaddingView(width: 16)

        relationshipOrNickNameLabel.text = "Relation or Nickname"
        relationshipOrNickNameLabel.font = AppFonts.Regular.withSize(14)
        relationshipOrNickNameLabel.textColor = AppColors.themeGray40
        
        relationshipOrNickNameTextField.placeholder = "Enter Relation or Nickname"
        relationshipOrNickNameTextField.font = AppFonts.Regular.withSize(18)
        relationshipOrNickNameTextField.textColor = AppColors.themeBlack
        relationshipOrNickNameTextField.delegate = self
        relationshipOrNickNameTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        self.setColorForAddTraveller()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.profileImageView.layer.borderColor = AppColors.profileImageBorderColor.cgColor
        profileImageView.layer.borderWidth = 2.0
    }
    
    // MARK: - Helper methods
    
    class func instanceFromNib() -> EditProfileImageHeaderView {
        return UINib(nibName: "EditProfileImageHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EditProfileImageHeaderView
    }
    
    func setUpUnicodeSwitch() {
        unicodeSwitch.titleLeft = "🙍🏻‍♂️"
        unicodeSwitch.titleRight =  "🙍🏻‍♀️"
        unicodeSwitch.backgroundColor = AppColors.clear
        containerView.backgroundColor = AppColors.unicodeBackgroundColor
        containerView.layer.cornerRadius = 20.0
        unicodeSwitch.sliderView.layer.cornerRadius = 18
        unicodeSwitch.sliderInset = 1.0
        verticalDividerView.backgroundColor = AppColors.unicodeSwitchLineColor
    }
    
    
    func setColorForAddTraveller(){
        [self, selectGroupValueView, RelationOrNickNameView].forEach{ view in
            view?.backgroundColor = AppColors.themeBlack26
        }
        self.emptyView.backgroundColor = AppColors.themeGray04
        self.groupLabel.textColor = AppColors.themeBlack
        self.firstNameTextField.textColor = AppColors.themeBlack
        self.lastNameTextField.textColor = AppColors.themeBlack
    }
    
    // MARK: - IB Actions
    
    @IBAction func editButtonTapped(_ sender: Any) {
        delegate?.editButtonTapped()
    }
    
    @objc func selectGroupTapped(_ sender: UITapGestureRecognizer) {
        delegate?.selectGroupTapped(groupTextField)
    }
    
    @IBAction func changeSelectedIndex(_ sender: ATUnicodeSwitch) {
        verticalDividerView.isHidden = true
        unicodeSwitch.sliderView.layer.borderColor = AppColors.themeBlack.withAlphaComponent(0.04).cgColor
        unicodeSwitch.sliderView.layer.borderWidth = 0.5
        self.containerView.layer.borderColor = AppColors.clear.cgColor
        unicodeSwitch.sliderView.dropShadowOnSwitch()
        if sender.selectedIndex == 1 {
            unicodeSwitch.titleLeft = "🙍🏻‍♂️"
            unicodeSwitch.titleRight = "🙋🏻‍♀️"
            delegate?.salutationViewTapped(title: "Female")
        } else {
            unicodeSwitch.titleRight = "🙍🏻‍♀️"
            unicodeSwitch.titleLeft = "🙋🏻‍♂️"
            delegate?.salutationViewTapped(title: "Male")
            
        }
        
    }
}

// MARK: - UITextField methods

extension EditProfileImageHeaderView: UITextFieldDelegate {
    @objc func textFieldDidChanged(_ textField: UITextField) {
        delegate?.textFieldText(textField)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let inputMode = textField.textInputMode else {
            return false
        }
        if inputMode.primaryLanguage == "emoji" || !(inputMode.primaryLanguage != nil) {
            return false
        }
        
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
        
        if textField === self.firstNameTextField {
            
            self.firstNameTextField.resignFirstResponder()
            self.lastNameTextField.becomeFirstResponder()
            
        } else if textField === self.lastNameTextField {
            self.lastNameTextField.resignFirstResponder()
            self.unicodeSwitch.becomeFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === self.firstNameTextField {
            self.firstNameDividerView.isSettingForErrorState = false
        } else if textField === self.lastNameTextField{
            self.lastNameDividerView.isSettingForErrorState = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === self.relationshipOrNickNameTextField{
            self.delegate?.endNicknameEditting()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.relationshipOrNickNameTextField{
            self.delegate?.shouldBeginNicknameEditting()
        }
        return true
    }
}
