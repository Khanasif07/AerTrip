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
    func selectGroupTapped()
    func textFieldText(_ textfield: UITextField)
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
    
    @IBOutlet weak var genderTitleLabel: UILabel!
    @IBOutlet weak var selectGroupViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectGroupView: UIView!
    
    // Unicode Switch
    @IBOutlet weak var unicodeSwitch: ATUnicodeSwitch!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var verticalDividerView: UIView!
    @IBOutlet weak var switchParentContainerView: UIView!
    
    // MARK: - Variables
    
    weak var delegate: EditProfileImageHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        editButton.setTitle(LocalizedString.Edit.rawValue.localizedLowercase, for: .normal)
//        salutaionLabel.text = LocalizedString.Title.rawValue
        self.setUpUnicodeSwitch()
        firstNameTextField.setUpAttributedPlaceholder(placeholderString: LocalizedString.FirstName.localized)
        lastNameTextField.setUpAttributedPlaceholder(placeholderString: LocalizedString.LastName.localized)
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        genderTitleLabel.text = LocalizedString.Gender.localized
        genderTitleLabel.font = AppFonts.Regular.withSize(17.0)
        genderTitleLabel.textColor = AppColors.themeBlack
        

        
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
    
    func setUpUnicodeSwitch() {
        unicodeSwitch.titleLeft = "🙍🏻‍♂️"
        unicodeSwitch.titleRight =  "🙍🏻‍♀️"
        unicodeSwitch.backgroundColor = AppColors.clear
        containerView.backgroundColor = AppColors.unicodeBackgroundColor
        containerView.layer.cornerRadius = 20.0
        unicodeSwitch.sliderView.layer.cornerRadius = 18
        unicodeSwitch.sliderInset = 1.0
        verticalDividerView.backgroundColor = AppColors.themeGray20
    }
    
    // MARK: - IB Actions
    
    @IBAction func editButtonTapped(_ sender: Any) {
        delegate?.editButtonTapped()
    }
    
    @objc func selectGroupTapped(_ sender: UITapGestureRecognizer) {
        delegate?.selectGroupTapped()
    }
    
    @IBAction func changeSelectedIndex(_ sender: ATUnicodeSwitch) {
        verticalDividerView.isHidden = true
        unicodeSwitch.sliderView.layer.borderColor = AppColors.themeBlack.withAlphaComponent(0.04).cgColor
        unicodeSwitch.sliderView.layer.borderWidth = 0.5
        self.containerView.layer.borderColor = AppColors.clear.cgColor
        unicodeSwitch.sliderView.dropShadowOnSwitch()
        if sender.selectedIndex == 1 {
            unicodeSwitch.titleLeft = "🙍🏻‍♂️"
            unicodeSwitch.titleRight = "🙋🏻"
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
        textField.resignFirstResponder()
        return true
    }
}
