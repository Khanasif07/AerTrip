//
//  OTPVarificationVC.swift
//  AERTRIP
//
//  Created by Appinventiv  on 24/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import ActiveLabel
import PhoneNumberKit
import IQKeyboardManager

protocol  OtpConfirmationDelegate:NSObject {
    func otpValidationCompleted(_ isSuccess: Bool)
}

class OTPVarificationVC: BaseVC {

    @IBOutlet weak var transparentBackView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var oneTimePassLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var otpTextField: PKFloatLabelTextField!
    @IBOutlet weak var resendLabel: ActiveLabel!
    @IBOutlet weak var nextButton: ATButton!
    @IBOutlet weak var mobileAndISDView: UIView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var contactNumberTextField: PhoneNumberTextField!
    @IBOutlet weak var dividerView: ATDividerView!
    //Constraints Outlet
    @IBOutlet weak var containerViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var descriptionTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var resendLabelTopConstraints: NSLayoutConstraint!
    
    
    
    var anomationDuration:TimeInterval = 0.3
    var viewModel = OTPVarificationVM()
    weak var delegate:OtpConfirmationDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubView()
        self.setNextButton()
        self.setOptTextField()
        self.mobileAndISDView.isHidden = true
        switch self.viewModel.varificationType{
        case .walletOtp: self.viewModel.sendOtpToUser()
        case .phoneNumberChangeOtp:
            self.viewModel.logEvent(with: .generatedOtp)
            self.setPhoneNumberSection()
            self.viewModel.sendOTPForNumberChange(isNeedParam: false)
        case .setMobileNumber:
            self.setPasswordTextField()
            self.setUIForPassword()
            self.setPhoneNumberSection()
        default: break;
        }
        self.viewModel.delegate = self
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        self.linkSetupForResend(withLabel: self.resendLabel, isResend: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.transformViewToOriginalState()
    }
    
    override func setupFonts() {
        self.cancelButton.titleLabel?.font = AppFonts.Regular.withSize(16.0)
        self.oneTimePassLabel.font = AppFonts.Regular.withSize(24.0)
        self.descriptionLabel.font = AppFonts.Regular.withSize(14.0)
        self.setOptTextField()
    }
    
    override func setupColors() {
        self.cancelButton.setTitleColor(AppColors.themeGreen, for: .normal)
        self.oneTimePassLabel.textColor = AppColors.themeBlack
        self.descriptionLabel.textColor = AppColors.themeBlack
    }
    
    override func setupTexts() {
        self.cancelButton.setTitle(LocalizedString.Cancel.localized, for: .normal)
        switch self.viewModel.varificationType{
        case .walletOtp:
            self.oneTimePassLabel.text = LocalizedString.oneTimePassword.localized
            self.descriptionLabel.text = LocalizedString.toProceedWalletBalance.localized + LocalizedString.kindlyEnterOtp.localized + " \(UserInfo.loggedInUser?.mobileWithISD ?? "")"
        case .phoneNumberChangeOtp:
            self.oneTimePassLabel.text = LocalizedString.veryItsYou.localized
            self.descriptionLabel.text = LocalizedString.tochangeMobileNumber.localized + LocalizedString.kindlyEnterOtp.localized + " \(UserInfo.loggedInUser?.mobileWithISD ?? "")."
        case .setMobileNumber:
            self.oneTimePassLabel.text = LocalizedString.veryItsYou.localized
            self.descriptionLabel.text = LocalizedString.toChangeMobileNumber.localized
        default: break;
        }

    }
    private func setUpSubView(){
        self.containerView.layer.masksToBounds = true
        self.containerView.layer.cornerRadius = 13.0
        self.containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.transparentBackView.backgroundColor = UIColor.clear
        self.transparentBackView.transform = CGAffineTransform(translationX: 0, y: transparentBackView.height)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        self.containerView.backgroundColor = AppColors.themeWhiteDashboard
    }
    
    private func transformViewToOriginalState() {
        UIView.animate(withDuration: self.anomationDuration, animations: {
            self.transparentBackView.transform = CGAffineTransform.identity
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        })
    }
    
    
    private func linkSetupForResend(withLabel: ActiveLabel, isResend: Bool) {
        let seeExample = ActiveType.custom(pattern: "\\sResend OTP\\b")
        let allTypes: [ActiveType] = [seeExample]
        let textToDisplay = !isResend ? LocalizedString.waitAminToOtp.localized : LocalizedString.didntGetOtp.localized
        withLabel.textColor = AppColors.themeGray40
        withLabel.enabledTypes = allTypes
        withLabel.customize { label in
            label.font = AppFonts.Regular.withSize(14.0)
            label.text = textToDisplay
            for item in allTypes {
                label.customColor[item] = AppColors.themeGreen
                label.customSelectedColor[item] = AppColors.themeGreen
            }
            label.highlightFontName = AppFonts.SemiBold.rawValue
            label.highlightFontSize = 14.0
            label.handleCustomTap(for: seeExample) {[weak self] _ in
                guard let self = self else {return}
                self.resendOtp()
            }
        }
    }
    
    
    private func resendOtp(){
        switch self.viewModel.varificationType{
        case .walletOtp:
            self.viewModel.sendOtpToUser()
            self.linkSetupForResend(withLabel: self.resendLabel, isResend: false)
        case .phoneNumberChangeOtp:
            self.viewModel.logEvent(with: .generatedOtp)
            switch self.viewModel.state {
            case .otpToOldNumber:
                self.viewModel.sendOTPForNumberChange(isNeedParam: false)
            case .otpForNewNumnber:
                self.viewModel.sendOTPForNumberChange(on: self.viewModel.mobile, isd: self.viewModel.isdCode, isNeedParam: true)
            default: break;
            }
        case .setMobileNumber:
            self.viewModel.logEvent(with: .generatedOtp)
            self.viewModel.setMobileNumber()
        default: break;
        }
        
        
    }
    
    private func setOptTextField(){
        otpTextField.titleYPadding = 12.0
        otpTextField.hintYPadding = 12.0
        otpTextField.titleFont = AppFonts.Regular.withSize(14)
        otpTextField.font = AppFonts.Regular.withSize(18.0)
        otpTextField.textColor = AppColors.themeBlack
        otpTextField.titleTextColour = AppColors.themeGray40
        otpTextField.titleActiveTextColour = AppColors.themeGreen
        otpTextField.textContentType = .oneTimeCode
        otpTextField.selectedLineColor = AppColors.themeGreen
        otpTextField.editingBottom = 0.0
        otpTextField.lineColor = AppColors.themeGray40
        otpTextField.lineErrorColor = AppColors.themeRed
        otpTextField.autocorrectionType = .no
        otpTextField.keyboardType = .numberPad
        otpTextField.isSecureTextEntry = false
        otpTextField.delegate = self
        otpTextField.placeholder = LocalizedString.enterOtp.localized
    }
    
    private func setPasswordTextField(){
        otpTextField.titleYPadding = 12.0
        otpTextField.hintYPadding = 12.0
        otpTextField.titleFont = AppFonts.Regular.withSize(14)
        otpTextField.font = AppFonts.Regular.withSize(18.0)
        otpTextField.textColor = AppColors.themeBlack
        otpTextField.titleTextColour = AppColors.themeGray40
        otpTextField.titleActiveTextColour = AppColors.themeGreen
        otpTextField.textContentType = .password
        otpTextField.selectedLineColor = AppColors.themeGreen
        otpTextField.editingBottom = 0.0
        otpTextField.lineColor = AppColors.themeGray40
        otpTextField.lineErrorColor = AppColors.themeRed
        otpTextField.autocorrectionType = .no
        otpTextField.keyboardType = .asciiCapable
        otpTextField.isSecureTextEntry = true
        otpTextField.delegate = self
        otpTextField.placeholder = LocalizedString.Password.localized
    }

    private func setNextButton(){
        self.nextButton.layer.cornerRadius = self.nextButton.height / 2.0
        self.nextButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .normal)
        self.nextButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .highlighted)
        self.nextButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .selected)
        self.nextButton.shadowColor = AppColors.appShadowColor
        self.nextButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.nextButton.setTitleColor(AppColors.themeWhite, for: .selected)
        self.nextButton.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)
        switch self.viewModel.varificationType{
        case .walletOtp:
            self.nextButton.setTitle(LocalizedString.Next.localized, for: .normal)
            self.nextButton.setTitle(LocalizedString.Next.localized, for: .selected)
        case .phoneNumberChangeOtp, .setMobileNumber:
            self.nextButton.setTitle(LocalizedString.proceed.localized, for: .normal)
            self.nextButton.setTitle(LocalizedString.proceed.localized, for: .selected)
        default: break;
        }

    }
    
    private func setPhoneNumberSection(){
        countryCodeLabel.font = AppFonts.Regular.withSize(18.0)
        countryCodeLabel.textColor = AppColors.themeBlack
        
        dividerView.backgroundColor = AppColors.divider.color
         contactNumberTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        contactNumberTextField.font = AppFonts.Regular.withSize(18.0)
        contactNumberTextField.textColor = AppColors.themeBlack
        contactNumberTextField.placeholder = LocalizedString.Mobile.localized
        
        if let current = PKCountryPicker.default.getCountryData(forISDCode: "+91") {
            self.viewModel.preSelectedCountry = current
            flagImageView.image = current.flagImage
            countryCodeLabel.text = current.countryCode
        }
        contactNumberTextField.delegate = self
        self.setIntitialISD()
    }

    
    private func setIntitialISD(){
        let isd = (self.viewModel.isdCode != "") ? self.viewModel.isdCode : "+91"
        if let current = PKCountryPicker.default.getCountryData(forISDCode: isd) {
            self.viewModel.preSelectedCountry = current
            flagImageView.image = current.flagImage
            countryCodeLabel.text = current.countryCode
        }
        self.contactNumberTextField.text = self.viewModel.mobile
    }
    
    func setUIForMobileNumber(_ isUsingForPhone: Bool){
        
        if isUsingForPhone{
            self.viewModel.state = .enterNewNumber
            UIView.animate(withDuration: self.anomationDuration, delay: 0.0, options: .curveEaseOut) {
                self.containerViewHeightConstraints.constant = 270.0
                self.descriptionTopConstraints.constant = 0.0
                self.resendLabelTopConstraints.constant = 0.0
                self.updateText()
                self.otpTextField.alpha = 0.0
                self.mobileAndISDView.alpha = 1.0
                self.resendLabel.alpha = 0.0
            } completion: { (_) in
                self.resendLabel.isHidden = true
                self.otpTextField.isHidden = true
                self.mobileAndISDView.isHidden = false
            }

        }else{
            UIView.animate(withDuration: self.anomationDuration, delay: 0.0, options: .curveEaseOut) {
                self.containerViewHeightConstraints.constant = 360.0
                self.descriptionTopConstraints.constant = 16.0
                self.resendLabelTopConstraints.constant = 8.0
                self.updateText()
                self.otpTextField.alpha = 1.0
                self.mobileAndISDView.alpha = 0.0
                self.resendLabel.alpha = 1.0
            } completion: { (_) in
                self.resendLabel.isHidden = false
                self.otpTextField.isHidden = false
                self.mobileAndISDView.isHidden = true
            }
        }
    }
    
    
    func setUIForPassword(){
        self.containerViewHeightConstraints.constant = 360.0
        self.descriptionTopConstraints.constant = 16.0
        self.resendLabelTopConstraints.constant = 0.0
        self.updateText()
        self.otpTextField.alpha = 1.0
        self.mobileAndISDView.alpha = 0.0
        self.resendLabel.alpha = 1.0
        self.resendLabel.isHidden = true
        self.otpTextField.isHidden = false
        self.mobileAndISDView.isHidden = true
    }
    
    
    func updateText(){
        
        switch self.viewModel.varificationType{
        case .walletOtp:
            self.oneTimePassLabel.text = LocalizedString.oneTimePassword.localized
            self.descriptionLabel.text = LocalizedString.toProceedWalletBalance.localized + LocalizedString.kindlyEnterOtp.localized + " \(UserInfo.loggedInUser?.mobileWithISD ?? "")"
        case .phoneNumberChangeOtp:
            switch self.viewModel.state{
            case .otpToOldNumber:
                self.oneTimePassLabel.text = LocalizedString.veryItsYou.localized
                self.descriptionLabel.text = LocalizedString.tochangeMobileNumber.localized + LocalizedString.kindlyEnterOtp.localized + " \(UserInfo.loggedInUser?.mobileWithISD ?? "")."
                self.linkSetupForResend(withLabel: self.resendLabel, isResend: false)
            case .enterNewNumber:
                self.oneTimePassLabel.text = LocalizedString.newMobileNumber.localized
                self.descriptionLabel.text = ""
                self.resendLabel.text = ""
            case .otpForNewNumnber:
                self.oneTimePassLabel.text = LocalizedString.oneTimePassword.localized
                self.descriptionLabel.text = LocalizedString.kindlyEnterOtp.localized.capitalized + " \(self.viewModel.isdCode) \(self.viewModel.mobile)."
                self.linkSetupForResend(withLabel: self.resendLabel, isResend: false)
            }
        case .setMobileNumber:
            switch self.viewModel.state{
            case .otpToOldNumber:
                self.oneTimePassLabel.text = LocalizedString.veryItsYou.localized
                self.descriptionLabel.text = LocalizedString.toChangeMobileNumber.localized
            case .enterNewNumber:
                self.oneTimePassLabel.text = LocalizedString.newMobileNumber.localized
                self.descriptionLabel.text = ""
                self.resendLabel.text = ""
            case .otpForNewNumnber:
                self.oneTimePassLabel.text = LocalizedString.oneTimePassword.localized
                self.descriptionLabel.text = LocalizedString.kindlyEnterOtp.localized.capitalized + " \(self.viewModel.isdCode) \(self.viewModel.mobile)."
                self.linkSetupForResend(withLabel: self.resendLabel, isResend: false)
            }
            
        default: break;
        }
        
    }
    
    
    func performDismissAnimation(isValidationComleted: Bool){
        UIView.animate(withDuration: self.anomationDuration, animations: {
            self.transparentBackView.transform = CGAffineTransform(translationX: 0, y: self.transparentBackView.height)
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        }) { (success) in
            self.dismiss(animated: false, completion: {
                CustomToast.shared.fadeAllToasts()
                self.delegate?.otpValidationCompleted(isValidationComleted)
            })
        }
    }
    
    @IBAction func transparentViewTapped(_ sender: Any) {
        
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        switch self.viewModel.varificationType{
        case .walletOtp:break;
        case .phoneNumberChangeOtp:
            self.viewModel.cancelValidation(isForUpdate: true)
            self.performDismissAnimation(isValidationComleted: false)
        case .setMobileNumber:
            self.viewModel.cancelValidation(isForUpdate: false)
            self.performDismissAnimation(isValidationComleted: false)
        default: break;
        }
        
        
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        switch self.viewModel.varificationType{
        case .walletOtp:
            self.performDismissAnimation(isValidationComleted: false)
        case .phoneNumberChangeOtp:
            self.viewModel.cancelValidation(isForUpdate: true)
            self.performDismissAnimation(isValidationComleted: false)
        case .setMobileNumber:
            self.viewModel.cancelValidation(isForUpdate: false)
            self.performDismissAnimation(isValidationComleted: false)
        default: break;
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        let validation = self.viewModel.validateAndApiCall(with: (self.otpTextField.text ?? ""))
        
        if validation.isSucces{
            self.nextButton.isLoading = true
        }else{
            self.otpTextField.isError = true
            self.dividerView.backgroundColor = AppColors.themeRed
            AppToast.default.showToastMessage(message: validation.errorMsg)
        }
        
    }
    
    
    @IBAction func countryCodeButtonTapped(_ sender: Any) {
        self.viewModel.logEvent(with: .openCC)
        if let prevSectdContry = self.viewModel.preSelectedCountry {
            PKCountryPicker.default.chooseCountry(onViewController: self, preSelectedCountry: prevSectdContry) { [weak self] (selectedCountry,closePicker) in
                guard let self = self else {return}
                self.viewModel.preSelectedCountry = selectedCountry
                self.flagImageView.image = selectedCountry.flagImage
                self.countryCodeLabel.text = selectedCountry.countryCode
                self.viewModel.isdCode = selectedCountry.countryCode
                self.viewModel.maxMNS = selectedCountry.maxNSN
                self.viewModel.minMNS = selectedCountry.minNSN
                self.contactNumberTextField.defaultRegion = selectedCountry.ISOCode
                self.contactNumberTextField.text = self.contactNumberTextField.nationalNumber
            }
        }
    }
}


extension OTPVarificationVC : OTPVarificationVMDelegate{
    func comoletedValidation(_ isSucess: Bool) {
        self.nextButton.isLoading = false
        self.otpTextField.isError = false
        self.dividerView.backgroundColor = AppColors.divider.color
        switch self.viewModel.varificationType{
        case .walletOtp:
            if isSucess{
                IQKeyboardManager.shared().isEnableAutoToolbar = true
                self.performDismissAnimation(isValidationComleted: true)
            }else{
                self.otpTextField.isError = true
            }
        case .phoneNumberChangeOtp:
            self.otpTextField.text = ""
            if isSucess{
                if self.viewModel.state == .otpToOldNumber{
                    self.setUIForMobileNumber(true)
                    self.updateText()
                }else{
                    IQKeyboardManager.shared().isEnableAutoToolbar = true
                    UserInfo.loggedInUser?.mobile = self.viewModel.mobile
                    UserInfo.loggedInUser?.isd = self.viewModel.isdCode
                    self.viewModel.logEvent(with: .success)
                    self.performDismissAnimation(isValidationComleted: true)
                }
            }else{
                self.otpTextField.isError = true
            }
            
        case .setMobileNumber:
            if isSucess{
                if self.viewModel.state == .enterNewNumber{
                    self.setUIForMobileNumber(true)
                    self.updateText()
                }else{
                    IQKeyboardManager.shared().isEnableAutoToolbar = true
                    UserInfo.loggedInUser?.mobile = self.viewModel.mobile
                    UserInfo.loggedInUser?.isd = self.viewModel.isdCode
                    self.viewModel.logEvent(with: .success)
                    self.performDismissAnimation(isValidationComleted: true)
                }
            }else{
                self.otpTextField.isError = true
            }
        default: break
        }
        
        
    }
    
    func getSendOTPResponse(_ isSucess: Bool) {
        self.nextButton.isLoading = false
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.updateResendText), object: nil)
        self.perform(#selector(self.updateResendText), with: nil, afterDelay: 60)
        guard isSucess else {return}
        switch self.viewModel.varificationType{
        case .walletOtp: break;
        case .phoneNumberChangeOtp:
//            self.nextButton.isLoading = false
            if self.viewModel.state == .otpForNewNumnber{
                self.setUIForMobileNumber(false)
            }
        case .setMobileNumber:
//            self.nextButton.isLoading = false
            if self.viewModel.state == .otpForNewNumnber{
                self.otpTextField.text = ""
                self.setOptTextField()
                self.setUIForMobileNumber(false)
            }
        default: break;
        }
    }
    
    @objc func updateResendText(){
        self.linkSetupForResend(withLabel: self.resendLabel, isResend: true)
    }
    
}

extension OTPVarificationVC  {
    @objc func textFieldDidChanged(_ textField: PhoneNumberTextField) {
        self.viewModel.mobile = textField.nationalNumber
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        PKCountryPicker.default.closePicker()
        if textField == self.otpTextField{
            IQKeyboardManager.shared().isEnableAutoToolbar = false
        }else if textField == self.contactNumberTextField{
            IQKeyboardManager.shared().isEnableAutoToolbar = true
        }
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.otpTextField && textField.textContentType == .oneTimeCode{
//            switch self.viewModel.varificationType{
//            case .walletOtp, .phoneNumberChangeOtp:
                return ((textField.text?.count ?? 0) < 6) || string == ""
//            default: return true
//            }
            
        }
//        else if textField == self.contactNumberTextField{
//            return ((textField.text?.count ?? 0) < self.viewModel.maxMNS) || string == ""
//        }
        return true
    }
}
