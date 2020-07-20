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
    func shouldSetupBottom(isNeedToSetUp:Bool)
    func countryCodeBtnTapped(_ sender: UIButton)
}

extension UpdatePassengerDetailsDelegate {
    func countryCodeBtnTapped(_ sender: UIButton) { }
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
    @IBOutlet weak var mobileAndIsdStack: UIStackView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var isdLabel: UILabel!
    @IBOutlet weak var isdButton: UIButton!
    @IBOutlet weak var deviderView: ATDividerView!
    @IBOutlet weak var mobileTextField: PKFloatLabelTextField!
    @IBOutlet weak var emailStack: UIStackView!
    @IBOutlet weak var emailTextField: PKFloatLabelTextField!
    @IBOutlet weak var optionalDetailsView: UIView!
    @IBOutlet weak var optionalDetailsButton: UIButton!
    
    //Divider view points:---
    
    @IBOutlet weak var fNameDivider: ATDividerView!
    @IBOutlet weak var lNameDivider: ATDividerView!
    @IBOutlet weak var emailDivider: ATDividerView!
    @IBOutlet weak var dobDivider: ATDividerView!
    @IBOutlet weak var nationalityDivider: ATDividerView!
    @IBOutlet weak var pNumberDivider: ATDividerView!
    @IBOutlet weak var pDateDivider: ATDividerView!
    
    
    // MARK: - Properties
//    weak var delegate: GuestDetailTableViewCellDelegate?
    var canShowSalutationError = false
    
//    var passenger = ATContact()
    weak var delegate: UpdatePassengerDetailsDelegate?
    weak var txtFldEditDelegate:GuestDetailTableViewCellDelegate?
    var cellIndexPath = IndexPath()
    var journeyType: JourneyType = .domestic
    private var preSelectedCountry: PKCountryModel?
    var lastJourneyDate:Date = Date()
    var journeyEndDate = Date()
    var allPaxInfoRequired = true
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
        self.isdLabel.font = AppFonts.Regular.withSize(18.0)
        self.isdLabel.textColor = AppColors.themeBlack
        let titleArray = ["First Name", "Last Name", "Mobile", "Email", "Date of Birth", "Nationality", "Passport Number", "Passport Expiry"]
        for (index, txtFld) in [firstNameTextField, lastNameTextField, mobileTextField, emailTextField, dobTextField, nationalityTextField,passportNumberTextField, passportExpiryTextField].enumerated(){
            txtFld?.titleYPadding = 12.0
            txtFld?.hintYPadding = 12.0
            txtFld?.addTarget(self, action: #selector(self.textFieldDidChanged(_:)), for: .editingChanged)
            txtFld?.delegate = self
            txtFld?.titleFont = AppFonts.Regular.withSize(14)
            txtFld?.setUpAttributedPlaceholder(placeholderString: titleArray[index],with: "", foregroundColor: AppColors.themeGray40)
            txtFld?.font = AppFonts.Regular.withSize(18.0)
            txtFld?.textColor = AppColors.themeBlack
            txtFld?.titleTextColour = AppColors.themeGray40
            txtFld?.isHiddenBottomLine = false
            txtFld?.lineView.isHidden = true
            txtFld?.titleActiveTextColour = AppColors.themeGreen
            txtFld?.selectedLineColor = AppColors.clear
            txtFld?.lineColor = AppColors.clear
            txtFld?.lineErrorColor = AppColors.clear
            txtFld?.autocorrectionType = .no
        }
        deviderView.backgroundColor = AppColors.divider.color
        countryLabel.font = AppFonts.Regular.withSize(14.0)
        countryLabel.textColor = AppColors.themeGray40
        countryLabel.text = "Country"
        
        [fNameDivider,lNameDivider, emailDivider, dobDivider, nationalityDivider, pNumberDivider, pDateDivider].forEach { dView in
            dView?.backgroundColor = AppColors.divider.color
        }
        
        
    }

    @IBAction func tapOptionalDetailsBtn(_ sender: UIButton) {
        
        self.delegate?.tapOptionalDetailsBtn(at: self.cellIndexPath)
        
    }

    @IBAction func tappedISDButton(_ sender: UIButton) {
        delegate?.countryCodeBtnTapped(sender)
        if let vc = self.viewContainingController {
            let prevSectdContry = preSelectedCountry
            PKCountryPicker.default.chooseCountry(onViewController: vc, preSelectedCountry: prevSectdContry) { [weak self] (selectedCountry,closePicker) in
                guard let self = self else {return}
                self.preSelectedCountry = selectedCountry
                self.flagImage.image = selectedCountry.flagImage
                self.isdLabel.text = selectedCountry.countryCode
                GuestDetailsVM.shared.guests[0][self.cellIndexPath.section].maxContactLimit = selectedCountry.maxNSN
                GuestDetailsVM.shared.guests[0][self.cellIndexPath.section].minContactLimit = selectedCountry.minNSN
                GuestDetailsVM.shared.guests[0][self.cellIndexPath.section].isd = selectedCountry.countryCode
            }
        }
    }
    
    
    private  func configureCell() {
        if ((self.guestDetail?.mealPreference.count ?? 0) + (self.guestDetail?.frequentFlyer.count ?? 0) == 0){
            self.optionalDetailsView.isHidden = true
        }else{
            self.optionalDetailsView.isHidden = (self.guestDetail?.isMoreOptionTapped ?? true)
        }
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
        } else {
            self.setupForInternational()
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
                self.guestTitleLabel.text = "\(LocalizedString.Child.localized) \(number)"// \(ageText)"
            case .infant:
                self.guestTitleLabel.text = "\(LocalizedString.Infant.localized) \(number)"// \(ageText)"
            }
            self.guestTitleLabel.AttributedFontColorForText(text: ageText, textColor: AppColors.themeGray40)
        }
        self.showEmailAndContact()
        showErrorForFirstLastName()
    }
    
    private func setupforDomestic(){
        self.passportStack.isHidden = true
        guard let passenger = self.guestDetail else {return}
        let isNoOption = ((self.guestDetail?.mealPreference.count ?? 0) + (self.guestDetail?.frequentFlyer.count ?? 0) == 0)
        switch passenger.passengerType{
        case .Adult:
            self.dobAndNationalityStack.isHidden = true
            if isNoOption{
                if self.allPaxInfoRequired{
                    self.emailDivider.isHidden = true
                    self.fNameDivider.isHidden = false
                    self.lNameDivider.isHidden = false
                }else{
                    self.fNameDivider.isHidden = true
                    self.lNameDivider.isHidden = true
                    self.emailDivider.isHidden = false
                }
            }else{
                self.fNameDivider.isHidden = false
                self.lNameDivider.isHidden = false
                self.emailDivider.isHidden = false
            }
        case .child, .infant:
            self.dobAndNationalityStack.isHidden = false
            self.nataionalityView.isHidden = true
            self.dobDivider.isHidden = isNoOption
        }
    }
    
    func setupForInternational(){
        
        let isNoOption = ((self.guestDetail?.mealPreference.count ?? 0) + (self.guestDetail?.frequentFlyer.count ?? 0) == 0)
        self.pNumberDivider.isHidden = isNoOption
        self.pDateDivider.isHidden = isNoOption
        
    }
    
    private func showEmailAndContact(){
        if allPaxInfoRequired && ((self.guestDetail?.passengerType ?? .Adult) == .Adult){
            self.mobileAndIsdStack.isHidden = false
            self.emailStack.isHidden = false
            self.mobileTextField.lineColor = AppColors.clear
            mobileTextField.selectedLineColor = AppColors.clear
            mobileTextField.lineErrorColor = AppColors.clear
            self.mobileTextField.keyboardType = .phonePad
            self.setDataForCountryCode()
            self.mobileTextField.text = self.guestDetail?.contact
            self.emailTextField.text = self.guestDetail?.emailLabel
        }else{
            self.mobileAndIsdStack.isHidden = true
            self.emailStack.isHidden = true
        }
    }
    
    private func setDataForCountryCode(){
        var isd = GuestDetailsVM.shared.guests[0][self.cellIndexPath.section].isd
        if isd.isEmpty{
            GuestDetailsVM.shared.guests[0][self.cellIndexPath.section].isd = "+91"
            isd = "+91"
        }
        if let current = PKCountryPicker.default.getCountryData(forISDCode: isd) {
            preSelectedCountry = current
            flagImage.image = current.flagImage
            isdLabel.text = current.countryCode
            GuestDetailsVM.shared.guests[0][self.cellIndexPath.section].maxContactLimit = current.maxNSN
            GuestDetailsVM.shared.guests[0][self.cellIndexPath.section].minContactLimit = current.minNSN
            
        }
         self.mobileTextField.text = GuestDetailsVM.shared.guests[0][self.cellIndexPath.section].contact
    }
    
    
    func showErrorForFirstLastName() {
        guard  self.canShowSalutationError else {return}
        if ((self.firstNameTextField.text ?? "").count < 3){
            self.firstNameTextField.isError = true
            let firstName = "First Name"
            self.firstNameTextField.attributedPlaceholder = NSAttributedString(string: firstName, attributes: [NSAttributedString.Key.foregroundColor: AppColors.themeRed])
        }else if !(self.firstNameTextField.text ?? "").isName{
            self.firstNameTextField.isError = true
            let firstName = "First Name"
            self.firstNameTextField.attributedPlaceholder = NSAttributedString(string: firstName, attributes: [NSAttributedString.Key.foregroundColor: AppColors.themeRed])
        }else{
            self.firstNameTextField.isError = false
            let firstName = "First Name"
            self.firstNameTextField.attributedPlaceholder = NSAttributedString(string: firstName, attributes: [NSAttributedString.Key.foregroundColor: AppColors.themeGray40])
        }
        
        if ((self.lastNameTextField.text ?? "").count < 3){
            self.lastNameTextField.isError = true
            let lastName = "Last Name"
            self.lastNameTextField.attributedPlaceholder = NSAttributedString(string: lastName, attributes: [NSAttributedString.Key.foregroundColor: AppColors.themeRed])
        }else if !(self.lastNameTextField.text ?? "").isName{
            self.lastNameTextField.isError = true
            let lastName = "Last Name"
            self.lastNameTextField.attributedPlaceholder = NSAttributedString(string: lastName, attributes: [NSAttributedString.Key.foregroundColor: AppColors.themeRed])
        }
        else{
            self.lastNameTextField.isError = false
            let last = "Last Name"
            self.lastNameTextField.attributedPlaceholder = NSAttributedString(string: last, attributes: [NSAttributedString.Key.foregroundColor: AppColors.themeGray40])
        }
        
        
//
//        let firstName = self.firstNameTextField.placeholder ?? ""
//        self.firstNameTextField.attributedPlaceholder = NSAttributedString(string: firstName, attributes: [NSAttributedString.Key.foregroundColor: isValidFirstName ? AppColors.themeGray40 :  AppColors.themeRed])
        
//        let isValidLastName = !((self.lastNameTextField.text ?? "").count < 3)
//        self.lastNameTextField.isError = !isValidLastName
//        let lastName = self.lastNameTextField.placeholder ?? ""
//        self.lastNameTextField.attributedPlaceholder = NSAttributedString(string: lastName, attributes: [NSAttributedString.Key.foregroundColor: isValidLastName ? AppColors.themeGray40 :  AppColors.themeRed])
        
        if self.journeyType == .domestic{
            self.domesticValidations()
        }else{
            self.internationalValidations()
        }
        
        if (self.guestDetail?.passengerType ?? .Adult == .Adult){
            self.validatationForEmailAndMobile()
        }
        
    }
    
    func domesticValidations(){
        guard let type = self.guestDetail?.passengerType else {return}
        switch type {
        case .Adult:
            break;
        case .child:
            let isValidDob = !((self.dobTextField.text ?? "").isEmpty)
            self.dobTextField.isError = !isValidDob
            let dob = self.dobTextField.placeholder ?? ""
            self.dobTextField.attributedPlaceholder = NSAttributedString(string: dob, attributes: [NSAttributedString.Key.foregroundColor: isValidDob ? AppColors.themeGray40 :  AppColors.themeRed])
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
    
    func validatationForEmailAndMobile(){
        if self.allPaxInfoRequired{
            let minNumb = self.preSelectedCountry?.minNSN ?? 0
            let maxNumb = self.preSelectedCountry?.maxNSN ?? 0
            let mobileText = self.mobileTextField.text ?? ""
            let isValidMobile = (!(mobileText.isEmpty) && (self.getOnlyIntiger(mobileText).count >= minNumb)  && (self.getOnlyIntiger(mobileText).count <= maxNumb))
            let isValidMail = self.emailTextField.text?.isEmail ?? true
            mobileTextField.attributedPlaceholder = NSAttributedString(string: "Mobile", attributes: [NSAttributedString.Key.foregroundColor: isValidMobile ? AppColors.themeGray40 :  AppColors.themeRed])
            self.mobileTextField.isError = !isValidMobile
            emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: isValidMail ? AppColors.themeGray40 :  AppColors.themeRed])
            self.emailTextField.isError = !isValidMail
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
                GuestDetailsVM.shared.guests[0][indexPath.section].salutation = salutation
            }
        }
    }
}
extension AddPassengerDetailsCell: UITextFieldDelegate {
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        PKCountryPicker.default.closePicker()
        switch textField {
        case self.dobTextField:
            self.delegate?.shouldSetupBottom(isNeedToSetUp: true)
            let selected = (textField.text ?? "").toDate(dateFormat: "dd MMM YYYY")
            var minimumDate:Date? = Date()
            if let passenger = self.guestDetail{
                switch passenger.passengerType {
                case .Adult:
                    minimumDate = nil
                case .child:
                    minimumDate = self.lastJourneyDate.add(years: -12, days: 1)
                case .infant:
                    minimumDate = self.lastJourneyDate.add(years: -2, days: 1)
                    
                }
            }
            PKDatePicker.openDatePickerIn(textField, outPutFormate: "dd MMM YYYY", mode: .date, minimumDate: minimumDate, maximumDate: Date(), selectedDate: selected, appearance: .light, toolBarTint: AppColors.themeGreen) { [unowned self] (dateStr) in
                textField.text = dateStr
                if let date = dateStr.toDate(dateFormat: "dd MMM yyyy"){
                    GuestDetailsVM.shared.guests[0][self.cellIndexPath.section].dob = date.toString(dateFormat: "yyyy-MM-dd")
                }
            }
            textField.tintColor = AppColors.clear
        case self.nationalityTextField:
            self.delegate?.shouldSetupBottom(isNeedToSetUp: true)
            var countries = [String]()
            if let country = GuestDetailsVM.shared.countries{
                countries = Array(country.values).sorted()
            }
            PKMultiPicker.noOfComponent = 1
            PKMultiPicker.openMultiPickerIn(textField, firstComponentArray: countries, secondComponentArray: [], firstComponent: textField.text, secondComponent: nil, titles: nil, toolBarTint: AppColors.themeGreen) { [unowned self]  (firstSelect, secondSelect) in
                GuestDetailsVM.shared.guests[0][self.cellIndexPath.section].nationality = firstSelect
                GuestDetailsVM.shared.guests[0][self.cellIndexPath.section].countryCode = GuestDetailsVM.shared.countries?.someKey(forValue: firstSelect) ?? ""
                textField.text = firstSelect
            }
            textField.tintColor = AppColors.clear
        case self.passportExpiryTextField:
            self.delegate?.shouldSetupBottom(isNeedToSetUp: true)
            let selected = (textField.text ?? "").toDate(dateFormat: "dd MMM YYYY")
            let minDate = self.journeyEndDate//.add(days: 1)
            PKDatePicker.openDatePickerIn(textField, outPutFormate: "dd MMM YYYY", mode: .date, minimumDate: minDate, maximumDate: nil, selectedDate: selected, appearance: .light, toolBarTint: AppColors.themeGreen) { [unowned self] (dateStr) in
                textField.text = dateStr
                if let date = dateStr.toDate(dateFormat: "dd MMM yyyy"){
                    GuestDetailsVM.shared.guests[0][self.cellIndexPath.section].passportExpiryDate = date.toString(dateFormat: "yyyy-MM-dd")
                }
            }
            textField.tintColor = AppColors.clear
        case self.passportNumberTextField, self.mobileTextField, self.emailTextField:
            self.delegate?.shouldSetupBottom(isNeedToSetUp: true)
        default:
            self.delegate?.shouldSetupBottom(isNeedToSetUp: false)
            return true
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        switch textField {
//        case self.firstNameTextField:
//            self.txtFldEditDelegate?.textField(self.firstNameTextField)
//            break
//        case self.lastNameTextField:
//            self.txtFldEditDelegate?.textField(self.lastNameTextField)
//            break
//        default:
//            break
//        }
        self.txtFldEditDelegate?.textField(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case self.firstNameTextField:
            self.txtFldEditDelegate?.textFieldEndEditing(self.firstNameTextField)
            break
        case self.lastNameTextField:
            self.txtFldEditDelegate?.textFieldEndEditing(self.lastNameTextField)
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
        case self.mobileTextField:
            GuestDetailsVM.shared.guests[0][self.cellIndexPath.section].contact = getOnlyIntiger(textField.text ?? "").removeAllWhitespaces
        case self.emailTextField:
            GuestDetailsVM.shared.guests[0][self.cellIndexPath.section].emailLabel = (textField.text ?? "").removeAllWhitespaces
        default:
            break
        }
        showErrorForFirstLastName()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func getOnlyIntiger(_ str: String)->String{
        let newStr = str.lowercased()
        let okayChars = Set("1234567890")
        return newStr.filter {okayChars.contains($0) }
    }
}
