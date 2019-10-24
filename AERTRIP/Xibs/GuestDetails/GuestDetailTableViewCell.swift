//
//  GuestDetailTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 13/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol GuestDetailTableViewCellDelegate: class {
    func textField(_ textField: UITextField)
    func textFieldWhileEditing(_ textField: UITextField)
}

class GuestDetailTableViewCell: UITableViewCell {
    // MARK: - IB Outlets
    
    @IBOutlet weak var guestTitleLabel: UILabel!
    @IBOutlet weak var firstNameTextField: PKFloatLabelTextField!
    @IBOutlet weak var lastNameTextField: PKFloatLabelTextField!
    
    // Unicode Switch
    @IBOutlet weak var unicodeSwitch: ATUnicodeSwitch!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var verticalDividerView: UIView!
    @IBOutlet weak var switchParentContainerView: UIView!
    
    // MARK: - Properties
    weak var delegate: GuestDetailTableViewCellDelegate?
    
    var guestDetail: ATContact? {
        didSet {
            configureCell()
        }
    }
    
    enum SalutationTypes {
        case male, female, none
    }
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpFont()
        self.setUpColor()
        self.doInitalSetup()
        setUpUnicodeSwitch()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureSalutationSwicth(type: .none)
    }
    
    // MARK: - Helper methods
    
    private func doInitalSetup() {
        self.firstNameTextField.titleYPadding = -10.0
        self.lastNameTextField.titleYPadding = -10.0
        self.firstNameTextField.lineViewBottomSpace = 0.5
        self.lastNameTextField.lineViewBottomSpace = 0.5
        self.firstNameTextField.isSingleTextField = false
        self.lastNameTextField.isSingleTextField = false
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        
        self.firstNameTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        self.lastNameTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
    }
    
    
    
    private func setUpFont() {
        self.guestTitleLabel.font = AppFonts.SemiBold.withSize(16.0)
        //let attributes = [NSAttributedString.Key.foregroundColor: AppColors.themeGray20, .font: AppFonts.Regular.withSize(18.0)]
        //  firstNameTextField.attributedPlaceholder = NSAttributedString(string: LocalizedString.FirstName.localized, attributes: attributes)
        // lastNameTextField.attributedPlaceholder = NSAttributedString(string: LocalizedString.LastName.localized, attributes: attributes)
        firstNameTextField.setUpAttributedPlaceholder(placeholderString: LocalizedString.FirstName.localized, foregroundColor: AppColors.themeGray20)
        lastNameTextField.setUpAttributedPlaceholder(placeholderString: LocalizedString.LastName.localized, foregroundColor: AppColors.themeGray20)
        self.firstNameTextField.font = AppFonts.Regular.withSize(18.0)
        self.lastNameTextField.font = AppFonts.Regular.withSize(18.0)
    }
    
    private func setUpColor() {
        self.guestTitleLabel.textColor = AppColors.themeBlack
        self.firstNameTextField.textColor = AppColors.textFieldTextColor51
        
        self.lastNameTextField.textColor = AppColors.textFieldTextColor51
        self.firstNameTextField.titleActiveTextColour = AppColors.themeGreen
        self.lastNameTextField.titleActiveTextColour = AppColors.themeGreen
    }
    
    private func configureCell() {
        self.firstNameTextField.text = ""
        if let fName = self.guestDetail?.firstName, !fName.isEmpty {
            self.firstNameTextField.text = fName
        }
        
        self.lastNameTextField.text = ""
        
        if let lName = self.guestDetail?.lastName, !lName.isEmpty {
            self.lastNameTextField.text = lName
        }
        
        if let salutaion = self.guestDetail?.salutation, !salutaion.isEmpty {
            if AppConstants.kFemaleSalutaion.contains(salutaion) {
                configureSalutationSwicth(type: .female)
            } else if AppConstants.kMaleSalutaion.contains(salutaion){
                configureSalutationSwicth(type: .male)
            } else {
                configureSalutationSwicth(type: .none)
            }
        }
        
        if let type = self.guestDetail?.passengerType, let number = self.guestDetail?.numberInRoom, number >= 0 {
            self.guestTitleLabel.text = (type == PassengersType.Adult) ? "\(LocalizedString.Adult.localized) \(number)" : "\(LocalizedString.Child.localized) \(number)(\(self.guestDetail?.age ?? 0))"
        }        
        
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
        configureSalutationSwicth(type: .none)
    }
    
    private func configureSalutationSwicth(type: SalutationTypes) {
        switch type {
        case .female:
            unicodeSwitch.titleLeft = "🙍🏻‍♂️"
            unicodeSwitch.titleRight = "🙋🏻"
            verticalDividerView.isHidden = true
            unicodeSwitch.sliderView.layer.borderColor = AppColors.themeBlack.withAlphaComponent(0.04).cgColor
            unicodeSwitch.sliderView.layer.borderWidth = 0.5
            unicodeSwitch.sliderView.dropShadowOnSwitch()
            unicodeSwitch.setSelectedIndex(index: 1, animated: true)
        case .male:
            unicodeSwitch.titleRight = "🙍🏻‍♀️"
            unicodeSwitch.titleLeft = "🙋🏻‍♂️"
            verticalDividerView.isHidden = true
            unicodeSwitch.sliderView.layer.borderColor = AppColors.themeBlack.withAlphaComponent(0.04).cgColor
            unicodeSwitch.sliderView.layer.borderWidth = 0.5
            unicodeSwitch.sliderView.dropShadowOnSwitch()
            unicodeSwitch.setSelectedIndex(index: 0, animated: true)
        default:
            verticalDividerView.isHidden = false
            unicodeSwitch.titleLeft = "🙍🏻‍♂️"
            unicodeSwitch.titleRight =  "🙍🏻‍♀️"
            unicodeSwitch.sliderView.layer.borderColor = AppColors.clear.cgColor
            unicodeSwitch.sliderView.layer.borderWidth = 0
            unicodeSwitch.sliderView.removeCardShadowLayer()
            unicodeSwitch.setSelectedIndex(index: -1, animated: true)
        }
    }
    
    //MARK:- IBAction
    //MARK:-
    @IBAction func changeSelectedIndex(_ sender: ATUnicodeSwitch) {
        var salutation = ""
        if sender.selectedIndex == 1 {
            configureSalutationSwicth(type: .female)
            salutation = AppGlobals.shared.getSalutationAsPerGenderAndAge(gender: AppConstants.kmRS, dob: self.guestDetail?.dob ?? "", dateFormatter: Date.DateFormat.yyyy_MM_dd.rawValue)
            
        } else {
            configureSalutationSwicth(type: .male)
            salutation = AppGlobals.shared.getSalutationAsPerGenderAndAge(gender: AppConstants.kmR, dob: self.guestDetail?.dob ?? "", dateFormatter: Date.DateFormat.yyyy_MM_dd.rawValue)
        }
        if let indexPath = (self.superview as? UITableView)?.indexPath(for: self) {
            GuestDetailsVM.shared.guests[indexPath.section][indexPath.row].salutation = salutation
        }
    }
}

extension GuestDetailTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.firstNameTextField:
            self.delegate?.textField(self.firstNameTextField)
        case self.lastNameTextField:
            self.delegate?.textField(self.lastNameTextField)
        default:
            break
        }
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        
        
        if let txtStr = textField.text, txtStr.count > AppConstants.kFirstLastNameTextLimit {
            let text = txtStr.removeSpaceAsSentence
            textField.text = text.substring(to: 30)
            return
        } else {
            let txtStr = textField.text ?? ""
            textField.text = txtStr.removeSpaceAsSentence
        }
        switch textField {
        case self.firstNameTextField:
            self.firstNameTextField.isHiddenBottomLine = false
            self.delegate?.textFieldWhileEditing(firstNameTextField)
        case self.lastNameTextField:
            self.lastNameTextField.isHiddenBottomLine = false
            self.delegate?.textFieldWhileEditing(lastNameTextField)
        default:
            break
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


