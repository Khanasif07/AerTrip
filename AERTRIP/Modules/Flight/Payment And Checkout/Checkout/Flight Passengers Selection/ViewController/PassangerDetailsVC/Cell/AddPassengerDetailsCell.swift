//
//  AddPassengerDetailsCell.swift
//  Aertrip
//
//  Created by Apple  on 07.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

protocol  UpdatePassengerDetailsDelegate: NSObjectProtocol {
    func tapOptionalDetailsBtn(at indexPath:IndexPath)
}

class AddPassengerDetailsCell: UITableViewCell {
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
    @IBOutlet weak var nameAndGenderStack: UIStackView!
    @IBOutlet weak var dobAndNationalityStack: UIStackView!
     @IBOutlet weak var passportStack: UIStackView!
    @IBOutlet weak var dobTextField: PKFloatLabelTextField!
    
    @IBOutlet weak var nataionalityView: UIView!
    @IBOutlet weak var nationalityTextField: PKFloatLabelTextField!
    
    @IBOutlet weak var passportNumberTextField: PKFloatLabelTextField!
    @IBOutlet weak var passportExpiryTextField: PKFloatLabelTextField!
    
    @IBOutlet weak var optionalDetailsView: UIView!
    @IBOutlet weak var optionalDetailsButton: UIButton!
    
    // MARK: - Properties
//    weak var delegate: GuestDetailTableViewCellDelegate?
    var canShowSalutationError = false
    
//    var passenger = ATContact()
    var countryList = [String]()
    weak var delegate: UpdatePassengerDetailsDelegate?
    weak var txtFldEditDelegate:GuestDetailTableViewCellDelegate?
    var cellIndexPath = IndexPath()
    var journeyType: JourneyType = .domestic
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
        self.setupInitialUI()
        setUpUnicodeSwitch()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureSalutationSwicth(type: .none)
        canShowSalutationError = false
    }
    
    // MARK: - Helper methods
    
    private func setupInitialUI(){
        self.guestTitleLabel.font = AppFonts.SemiBold.withSize(16.0)
        self.optionalDetailsButton.setTitle("Optional Details", for: .normal)
        self.optionalDetailsButton.titleLabel?.font = AppFonts.Regular.withSize(14.0)
        self.guestTitleLabel.textColor = AppColors.themeBlack
        let titleArray = ["First Name", "Last Name", "Date of Birth", "Nationality", "Passport Number", "Passport Expiry"]
        for (index, txtFld) in [firstNameTextField, lastNameTextField, dobTextField, nationalityTextField,passportNumberTextField, passportExpiryTextField].enumerated(){
            txtFld?.titleYPadding = 12.0
            txtFld?.hintYPadding = 12.0
            txtFld?.addTarget(self, action: #selector(self.textFieldDidChanged(_:)), for: .editingChanged)
            txtFld?.isSingleTextField = false
            txtFld?.delegate = self
            txtFld?.setUpAttributedPlaceholder(placeholderString: titleArray[index],with: "", foregroundColor: AppColors.themeGray20)
            txtFld?.font = AppFonts.Regular.withSize(18.0)
            txtFld?.textColor = AppColors.textFieldTextColor51
            txtFld?.titleActiveTextColour = AppColors.themeGreen
        }
    }
    
    
    @IBAction func tapOptionalDetailsBtn(_ sender: UIButton) {
        
        self.delegate?.tapOptionalDetailsBtn(at: self.cellIndexPath)
        
    }

    
    
    private  func configureCell() {
        self.optionalDetailsView.isHidden = (self.guestDetail?.isMoreOptionTapped ?? true)
        self.dobTextField.text = self.guestDetail?.displayDob
        self.nationalityTextField.text = self.guestDetail?.nationality
        self.passportNumberTextField.text = self.guestDetail?.passportNumber
        self.passportExpiryTextField.text = self.guestDetail?.displayPsprtExpDate
        self.firstNameTextField.text = ""
        if let fName = self.guestDetail?.firstName, !fName.isEmpty {
            self.firstNameTextField.text = fName
        }
        if journeyType == .domestic{
            self.setupforDomestic()
        }else{
            if (self.guestDetail?.isMoreOptionTapped ?? true){
                self.passportExpiryTextField.lineViewBottomSpace = 0
                self.passportNumberTextField.lineViewBottomSpace = 0
            }else{
                self.passportExpiryTextField.lineViewBottomSpace = -3
                self.passportNumberTextField.lineViewBottomSpace = -3
            }
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
        self.guestTitleLabel.text = ""
        if let type = self.guestDetail?.passengerType, let number = self.guestDetail?.numberInRoom, number >= 0 {
            let ageText = "(\(self.guestDetail?.age ?? 0)y)"
            switch type{
            case .Adult:
                self.guestTitleLabel.text = "\(LocalizedString.Adult.localized) \(number)"
            case .child:
                self.guestTitleLabel.text = "\(LocalizedString.Child.localized) \(number) \(ageText)"
            case .infant:
                self.guestTitleLabel.text = "\(LocalizedString.Infant.localized) \(number) \(ageText)"
            }
            self.guestTitleLabel.AttributedFontColorForText(text: ageText, textColor: AppColors.themeGray40)
        }
        showErrorForFirstLastName()
    }
    
    private func setupforDomestic(){
        self.passportStack.isHidden = true
        guard let passenger = self.guestDetail else {return}
        switch passenger.passengerType{
        case .Adult, .child:
            self.dobAndNationalityStack.isHidden = true
            if passenger.isMoreOptionTapped{
                self.firstNameTextField.lineViewBottomSpace = 0
                self.lastNameTextField.lineViewBottomSpace = 0
            }else{
                self.firstNameTextField.lineViewBottomSpace = -3
                self.lastNameTextField.lineViewBottomSpace = -3
            }
//        case .child:
//            self.dobAndNationalityStack.isHidden = false
//            self.nataionalityView.isHidden = true
//            if self.passenger.isMoreOptionTapped{
//                self.dobTextField.lineViewBottomSpace = 0
//            }else{
//                self.dobTextField.lineViewBottomSpace = -3
//            }
        case .infant:
            self.dobAndNationalityStack.isHidden = false
            self.nataionalityView.isHidden = true
            if passenger.isMoreOptionTapped{
                self.dobTextField.lineViewBottomSpace = 0
            }else{
                self.dobTextField.lineViewBottomSpace = -3
            }
        }
    }
    
    
    func showErrorForFirstLastName() {
        guard  self.canShowSalutationError else {return}
        let isValidFirstName = !((self.firstNameTextField.text ?? "").count < 3)
        self.firstNameTextField.isError = !isValidFirstName
        let firstName = self.firstNameTextField.placeholder ?? ""
        self.firstNameTextField.attributedPlaceholder = NSAttributedString(string: firstName, attributes: [NSAttributedString.Key.foregroundColor: isValidFirstName ? AppColors.themeGray40 :  AppColors.themeRed])
        
        let isValidLastName = !((self.lastNameTextField.text ?? "").count < 3)
        self.lastNameTextField.isError = !isValidLastName
        let lastName = self.lastNameTextField.placeholder ?? ""
        self.lastNameTextField.attributedPlaceholder = NSAttributedString(string: lastName, attributes: [NSAttributedString.Key.foregroundColor: isValidLastName ? AppColors.themeGray40 :  AppColors.themeRed])
        
        if self.journeyType == .domestic{
            self.domesticValidations()
        }else{
            self.internationalValidations()
        }
        
    }
    
    func domesticValidations(){
        guard let type = self.guestDetail?.passengerType else {return}
        switch type {
        case .Adult,.child:
            break;
        case .infant:
            let isValidDob = !((self.dobTextField.text ?? "").isEmpty)
            self.dobTextField.isError = !isValidDob
            let dob = self.dobTextField.placeholder ?? ""
            self.dobTextField.attributedPlaceholder = NSAttributedString(string: dob, attributes: [NSAttributedString.Key.foregroundColor: isValidDob ? AppColors.themeGray40 :  AppColors.themeRed])
        }
    }
    
    func internationalValidations(){
//        guard let type = self.guestDetail?.passengerType  else {return}
        let txtFlds = [dobTextField, nationalityTextField, passportNumberTextField, passportExpiryTextField]
            ///Uncomment if infant dont required passport details and nationality.
//        switch type {
//        case .Adult, .child:
//            txtFlds = [dobTextField, nationalityTextField, passportNumberTextField, passportExpiryTextField]
//        case .infant:
//            txtFlds = [dobTextField]
//        }
        txtFlds.forEach { txt in
            guard let txt = txt else {return}
            let isValid = !((txt.text ?? "").isEmpty)
            txt.isError = !isValid
            let placeholder = txt.placeholder ?? ""
            txt.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: isValid ? AppColors.themeGray40 :  AppColors.themeRed])
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
extension AddPassengerDetailsCell: UITextFieldDelegate {
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case self.dobTextField:
            let selected = (textField.text ?? "").toDate(dateFormat: "dd MMM YYYY")
            var minimumDate:Date? = Date()
            if let passenger = self.guestDetail{
                switch passenger.passengerType {
                case .Adult,.child:
                    minimumDate = nil
//                case .child:
//                    minimumDate = Date().add(years: -12)
                case .infant:
                    minimumDate = Date().add(years: -2)
                    
                }
            }
            PKDatePicker.openDatePickerIn(textField, outPutFormate: "dd MMM YYYY", mode: .date, minimumDate: minimumDate, maximumDate: Date(), selectedDate: selected, appearance: .light, toolBarTint: AppColors.themeGreen) { (dateStr) in
                textField.text = dateStr
                if let date = dateStr.toDate(dateFormat: "dd MMM yyyy"){
                    GuestDetailsVM.shared.guests[0][self.cellIndexPath.section].dob = date.toString(dateFormat: "yyyy-MM-dd")
                }
            }
            textField.tintColor = AppColors.clear
        case self.nationalityTextField:
            PKMultiPicker.noOfComponent = 1
            PKMultiPicker.openMultiPickerIn(textField, firstComponentArray: self.countryList, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { (firstSelect, secondSelect) in
                GuestDetailsVM.shared.guests[0][self.cellIndexPath.section].nationality = firstSelect
                textField.text = firstSelect
            }
            textField.tintColor = AppColors.clear
        case self.passportExpiryTextField:
            let selected = (textField.text ?? "").toDate(dateFormat: "dd MMM YYYY")
            PKDatePicker.openDatePickerIn(textField, outPutFormate: "dd MMM YYYY", mode: .date, minimumDate: Date(), maximumDate: nil, selectedDate: selected, appearance: .light, toolBarTint: AppColors.themeGreen) { (dateStr) in
                textField.text = dateStr
                if let date = dateStr.toDate(dateFormat: "dd MMM yyyy"){
                    GuestDetailsVM.shared.guests[0][self.cellIndexPath.section].passportExpiryDate = date.toString(dateFormat: "yyyy-MM-dd")
                }
            }
            textField.tintColor = AppColors.clear
        default:
            return true
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case self.firstNameTextField:
            self.txtFldEditDelegate?.textField(self.firstNameTextField)
            break
        case self.lastNameTextField:
            self.txtFldEditDelegate?.textField(self.lastNameTextField)
            break
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
            self.txtFldEditDelegate?.textFieldWhileEditing(firstNameTextField)
        case self.lastNameTextField:
            self.txtFldEditDelegate?.textFieldWhileEditing(lastNameTextField)
        case self.passportNumberTextField:
            GuestDetailsVM.shared.guests[0][self.cellIndexPath.section].passportNumber = (textField.text ?? "").removeAllWhitespaces
        default:
            break
        }
        showErrorForFirstLastName()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
