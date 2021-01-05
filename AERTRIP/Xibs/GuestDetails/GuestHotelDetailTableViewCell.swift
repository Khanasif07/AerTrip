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
    func textFieldEndEditing(_ textField: UITextField)

}

class GuestHotelDetailTableViewCell: UITableViewCell {
    // MARK: - IB Outlets
    
    @IBOutlet weak var titleBottomConst: NSLayoutConstraint!
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
    var canShowSalutationError = false
    
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
        canShowSalutationError = false
    }
    
    // MARK: - Helper methods
    
    private func doInitalSetup() {
        self.firstNameTextField.titleYPadding = 12.0
        self.firstNameTextField.hintYPadding = 12.0
        self.lastNameTextField.titleYPadding = 12.0
        self.lastNameTextField.hintYPadding = 12.0
        //        self.firstNameTextField.titleYPadding = -10.0
        //        self.lastNameTextField.titleYPadding = -10.0
        //        self.firstNameTextField.lineViewBottomSpace = 0.5
        //        self.lastNameTextField.lineViewBottomSpace = 0.5
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
        firstNameTextField.setUpAttributedPlaceholder(placeholderString: LocalizedString.FirstName.localized,with: "", foregroundColor: AppColors.themeGray20)
        lastNameTextField.setUpAttributedPlaceholder(placeholderString: LocalizedString.LastName.localized,with: "", foregroundColor: AppColors.themeGray20)
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
        }else {
            configureSalutationSwicth(type: .none)
        }
        if canShowSalutationError, let salutaion = self.guestDetail?.salutation,salutaion.isEmpty {
            self.containerView.layer.borderColor = AppColors.themeRed.cgColor
            self.containerView.layer.borderWidth = 1.0
        }
        
        if let type = self.guestDetail?.passengerType, let number = self.guestDetail?.numberInRoom, number >= 0 {
            let ageText = "(\(self.guestDetail?.age ?? 0)y)"
            let adultText = "\(LocalizedString.Adult.localized) \(number)"
            let childText = "\(LocalizedString.Child.localized) \(number) \(ageText)"
            
            self.guestTitleLabel.text = (type == PassengersType.Adult) ? adultText : childText
            self.guestTitleLabel.AttributedFontColorForText(text: ageText, textColor: AppColors.themeGray40)
        }        
        showErrorForFirstLastName()
    }
    
    func showErrorForFirstLastName() {
        guard  self.canShowSalutationError else {return}
        let isValidFirstName = !((self.firstNameTextField.text ?? "").count < 1)
        self.firstNameTextField.isError = !isValidFirstName
        let firstName = self.firstNameTextField.placeholder ?? ""
        self.firstNameTextField.attributedPlaceholder = NSAttributedString(string: firstName, attributes: [NSAttributedString.Key.foregroundColor: isValidFirstName ? AppColors.themeGray40 :  AppColors.themeRed])
        
        let isValidLastName = !((self.lastNameTextField.text ?? "").count < 1)
        self.lastNameTextField.isError = !isValidLastName
        let lastName = self.lastNameTextField.placeholder ?? ""
        self.lastNameTextField.attributedPlaceholder = NSAttributedString(string: lastName, attributes: [NSAttributedString.Key.foregroundColor: isValidLastName ? AppColors.themeGray40 :  AppColors.themeRed])
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
            unicodeSwitch.titleRight = "🙋🏻‍♀️"
            verticalDividerView.isHidden = true
            unicodeSwitch.sliderView.layer.borderColor = AppColors.themeBlack.withAlphaComponent(0.04).cgColor
            unicodeSwitch.sliderView.layer.borderWidth = 0.5
            unicodeSwitch.sliderView.dropShadowOnSwitch()
            unicodeSwitch.setSelectedIndex(index: 1, animated: true)
            self.containerView.layer.borderColor = AppColors.clear.cgColor
            self.containerView.layer.borderWidth = 0.0
        case .male:
            unicodeSwitch.titleRight = "🙍🏻‍♀️"
            unicodeSwitch.titleLeft = "🙋🏻‍♂️"
            verticalDividerView.isHidden = true
            unicodeSwitch.sliderView.layer.borderColor = AppColors.themeBlack.withAlphaComponent(0.04).cgColor
            unicodeSwitch.sliderView.layer.borderWidth = 0.5
            unicodeSwitch.sliderView.dropShadowOnSwitch()
            unicodeSwitch.setSelectedIndex(index: 0, animated: true)
            self.containerView.layer.borderColor = AppColors.clear.cgColor
            self.containerView.layer.borderWidth = 0.0
        default:
            verticalDividerView.isHidden = false
            unicodeSwitch.titleLeft = "🙍🏻‍♂️"
            unicodeSwitch.titleRight =  "🙍🏻‍♀️"
            unicodeSwitch.sliderView.layer.borderColor = AppColors.clear.cgColor
            unicodeSwitch.sliderView.layer.borderWidth = 0
            unicodeSwitch.sliderView.removeCardShadowLayer()
            unicodeSwitch.setSelectedIndex(index: -1, animated: true)
            self.containerView.layer.borderColor = AppColors.clear.cgColor
            self.containerView.layer.borderWidth = 0.0
        }
    }
    
    //MARK:- IBAction
    //MARK:-
    @IBAction func changeSelectedIndex(_ sender: ATUnicodeSwitch) {
        var salutation = ""
        if sender.selectedIndex == 1 {
            configureSalutationSwicth(type: .female)
            salutation = AppGlobals.shared.getSalutationAsPerGenderAndAge(gender: AppConstants.kmRS, dob: self.guestDetail?.dob ?? "", dateFormatter: Date.DateFormat.yyyy_MM_dd.rawValue)
            
        } else if sender.selectedIndex == 0{
            configureSalutationSwicth(type: .male)
            salutation = AppGlobals.shared.getSalutationAsPerGenderAndAge(gender: AppConstants.kmR, dob: self.guestDetail?.dob ?? "", dateFormatter: Date.DateFormat.yyyy_MM_dd.rawValue)
        }
        if sender.selectedIndex == 0 || sender.selectedIndex == 1 {
            if let indexPath = (self.superview as? UITableView)?.indexPath(for: self) {
                GuestDetailsVM.shared.guests[indexPath.section][indexPath.row].salutation = salutation
            }
        }
    }
}

extension GuestHotelDetailTableViewCell: UITextFieldDelegate {
    
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
        
        let txtStr = textField.text ?? ""
        if  txtStr.count > AppConstants.kFirstLastNameTextLimit {
            let text = txtStr.removeSpaceAsSentence
            textField.text = text.substring(to: 30)
            return
        } else {
            
            textField.text = txtStr.removeSpaceAsSentence
        }
        switch textField {
        case self.firstNameTextField:
            //self.firstNameTextField.isHiddenBottomLine = false
            self.delegate?.textFieldWhileEditing(firstNameTextField)
        case self.lastNameTextField:
            // self.lastNameTextField.isHiddenBottomLine = false
            self.delegate?.textFieldWhileEditing(lastNameTextField)
        default:
            break
        }
        showErrorForFirstLastName()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.textFieldEndEditing(textField)
    }
}


