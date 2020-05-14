//
//  CreateProfileVC.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 07/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class CreateProfileVC: BaseVC {
    
    //MARK:- Properties
    //MARK:-
    let viewModel = CreateProfileVM()
    let salutationPicker = UIPickerView()
    // GenericPickerView
    var genericPickerView: UIView = UIView()
    let pickerSize: CGSize = UIPickerView.pickerSize
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var createProfileTitleLabel: UILabel!
    @IBOutlet weak var createProfileSubTitleLabel: UILabel!
    @IBOutlet weak var nameTitleTextField: PKFloatLabelTextField!
    @IBOutlet weak var firstNameTextField: PKFloatLabelTextField!
    @IBOutlet weak var lastNameTextField: PKFloatLabelTextField!
    @IBOutlet weak var countryTextField: PKFloatLabelTextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var letsStartedButton: ATButton!
    @IBOutlet weak var countryCodeTextField: PKFloatLabelTextField!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var countryFlagImage: UIImageView!
    @IBOutlet weak var titleDropDownImage: UIImageView!
    @IBOutlet weak var countryDropdownImage: UIImageView!
    @IBOutlet weak var letsStartButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var letStartButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var letStartButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var whiteBackgroundView: UIView!
    @IBOutlet weak var topNavBar: TopNavigationView!
    
    // Unicode Switch
    @IBOutlet weak var unicodeSwitch: ATUnicodeSwitch!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var verticalDividerView: UIView!
    @IBOutlet weak var switchParentContainerView: UIView!
    @IBOutlet weak var mobileNoseperatorView: ATDividerView!

    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
        self.setUpUnicodeSwitch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.viewModel.isFirstTime {
//            self.setupInitialAnimation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.viewModel.isFirstTime {
//            self.setupViewDidLoadAnimation()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        PKCountryPicker.default.closePicker()
    }
    
    override func setupFonts() {
        
        self.createProfileTitleLabel.font      = AppFonts.c.withSize(38)
        self.createProfileSubTitleLabel.font    = AppFonts.Regular.withSize(16)
        self.countryCodeLabel.font           = AppFonts.Regular.withSize(18)
        self.setupTextFieldColorTextAndFont()
        self.letsStartedButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .normal)
        self.letsStartedButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .selected)
        self.letsStartedButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .highlighted)

    }
    
    override func setupTexts() {
        
        self.createProfileTitleLabel.text = LocalizedString.Create_Your_Profile.localized
        self.createProfileSubTitleLabel.text = LocalizedString.and_you_are_done.localized
        self.letsStartedButton.setTitle(LocalizedString.Lets_Get_Started.localized, for: .normal)
    }
    
    override func setupColors() {
        
        self.createProfileTitleLabel.textColor  = AppColors.themeBlack
        self.createProfileSubTitleLabel.textColor  = AppColors.themeBlack
       // self.letsStartedButton.layer.masksToBounds = false
        self.letsStartedButton.shadowColor = AppColors.themeBlack.withAlphaComponent(0.16)
        self.letsStartedButton.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)
    }
    
    //MARK:- IBOutlets
    //MARK:-
    
    @IBAction func letsGetStartButton(_ sender: ATButton) {
        self.view.endEditing(true)
        if self.viewModel.isValidateData {
            self.viewModel.webserviceForUpdateProfile()
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
    }
    
    
    @IBAction func changeSelectedIndex(_ sender: ATUnicodeSwitch) {
        verticalDividerView.isHidden = true
        unicodeSwitch.sliderView.layer.borderColor = AppColors.themeBlack.withAlphaComponent(0.04).cgColor
        unicodeSwitch.sliderView.layer.borderWidth = 0.5
        unicodeSwitch.sliderView.dropShadowOnSwitch()
        if sender.selectedIndex == 1 {
            unicodeSwitch.titleLeft = "🙍🏻‍♂️"
            unicodeSwitch.titleRight = "🙋🏻‍♀️"
            self.viewModel.userData.salutation = AppConstants.kmS
        } else {
            unicodeSwitch.titleRight = "🙍🏻‍♀️"
            unicodeSwitch.titleLeft = "🙋🏻‍♂️"
            self.viewModel.userData.salutation = AppConstants.kmR
        }
        self.letsStartedButton.isEnabledShadow  = !self.viewModel.isValidateForButtonEnable

    }
    
    
}

//MARK:- Extension Initialsetups
//MARK:-
private extension CreateProfileVC {
    
    func initialSetups() {
        AppGlobals.shared.updateIQToolBarDoneButton(isEnabled: false)
        
        self.view.backgroundColor = AppColors.screensBackground.color
        self.whiteBackgroundView.backgroundColor = AppColors.screensBackground.color
        
        self.viewModel.webserviceForGetSalutations()
//        self.firstNameTextField.titleYPadding = 12.0
//        self.firstNameTextField.hintYPadding = 12.0
//        self.firstNameTextField.lineViewBottomSpace = 10.0
//        self.lastNameTextField.titleYPadding = 12.0
//        self.lastNameTextField.hintYPadding = 12.0
//        self.lastNameTextField.lineViewBottomSpace = 10.0
        self.firstNameTextField.titleYPadding = 12.0
        self.firstNameTextField.hintYPadding = 12.0
        self.lastNameTextField.hintYPadding = 12.0
        self.lastNameTextField.titleYPadding = 12.0
        self.countryTextField.titleYPadding = 2.0
        
        self.mobileNoseperatorView.defaultBackgroundColor = self.countryTextField.lineColor
        self.mobileNoseperatorView.defaultHeight = self.countryTextField.lineView.height
        //self.countryTextField.lineViewBottomSpace = 4.0
        self.topNavBar.configureNavBar(title: "", isDivider: false, backgroundType: .clear)
        self.topNavBar.delegate = self
        self.viewModel.userData.maxContactLimit = 10
        self.viewModel.userData.minContactLimit  = 10
        self.viewModel.userData.address?.countryCode = LocalizedString.selectedCountryCode.localized
        self.viewModel.userData.address?.country = LocalizedString.selectedCountry.localized
        self.viewModel.userData.salutation = ""
        self.letsStartedButton.isEnabledShadow = true
        self.firstNameTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
        self.lastNameTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
        self.mobileNumberTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
        
        if let currentCountry = PKCountryPicker.default.getCurrentLocalCountryData() {
            self.setupData(forCountry: currentCountry)
        }
        self.letsStartedButton.myCornerRadius = self.letsStartedButton.height/2
    }
    
    private func setupData(forCountry: PKCountryModel) {
        self.countryCodeLabel.text  = forCountry.countryCode
        self.countryFlagImage.image = forCountry.flagImage
        self.countryTextField.text = forCountry.countryEnglishName
        self.viewModel.userData.address?.country = forCountry.ISOCode
        self.viewModel.userData.isd = forCountry.countryCode
        self.viewModel.userData.address?.countryCode = forCountry.ISOCode
        self.viewModel.userData.maxContactLimit = forCountry.maxNSN
        self.viewModel.userData.minContactLimit  = forCountry.minNSN
    }
    
    func setupTextFieldColorTextAndFont () {
        self.viewModel.userData.salutation = ""
        self.salutationPicker.delegate = self
        self.nameTitleTextField.delegate = self
        self.nameTitleTextField.isEnabled = false
        self.nameTitleTextField.setupTextField(placehoder: LocalizedString.Title.localized,textColor: AppColors.textFieldTextColor51, keyboardType: .default, returnType: .done, isSecureText: false)
        self.firstNameTextField.setupTextField(placehoder: LocalizedString.First_Name.localized,with: "",textColor: AppColors.textFieldTextColor51, keyboardType: .default, returnType: .next, isSecureText: false)
        self.lastNameTextField.setupTextField(placehoder: LocalizedString.Last_Name.localized,with: "",textColor: AppColors.textFieldTextColor51, keyboardType: .default, returnType: .next, isSecureText: false)
        self.countryTextField.setupTextField(placehoder: LocalizedString.Country.localized,textColor: AppColors.textFieldTextColor51, keyboardType: .default, returnType: .next, isSecureText: false)
//        self.mobileNumberTextField.setupTextField(placehoder: LocalizedString.Mobile_Number.localized,textColor: AppColors.textFieldTextColor51, keyboardType: .numberPad, returnType: .done, isSecureText: false)
        self.mobileNumberTextField.setUpTextField(placehoder: LocalizedString.Mobile_Number.localized,textColor: AppColors.textFieldTextColor51, keyboardType: .numberPad, returnType: .done, isSecureText: false)
        self.countryCodeTextField.setupTextField(placehoder:"",textColor: AppColors.textFieldTextColor51, keyboardType: .numberPad, returnType: .done, isSecureText: false)
        
        salutationPicker.frame = CGRect(x: 0, y: 0, width: pickerSize.width, height: pickerSize.height)
        genericPickerView.addSubview(self.salutationPicker)
        genericPickerView.frame = CGRect(x: 0, y: 0, width: pickerSize.width, height: pickerSize.height)        
        genericPickerView.backgroundColor = AppColors.quaternarySystemFillColor
        
        self.countryTextField.delegate = self
        self.countryCodeTextField.delegate = self
        self.countryCodeTextField.tintColor = .clear
        self.nameTitleTextField.inputView = self.genericPickerView
        self.nameTitleTextField.inputAccessoryView = self.initToolBar(picker: self.salutationPicker)
        self.nameTitleTextField.tintColor = AppColors.clear
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.mobileNumberTextField.delegate = self
    }
    
    func initToolBar(picker: UIPickerView) -> UIToolbar {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(displayP3Red:14.0/255, green:122.0/255, blue:254.0/255, alpha: 1)
        toolBar.sizeToFit()
        // TODO need to update actions for all buttons
        let cancelButton = UIBarButtonItem(title: LocalizedString.Cancel.localized, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        let doneButton = UIBarButtonItem()
        doneButton.title  = LocalizedString.Done.localized
        
        toolBar.backgroundColor = .clear
        toolBar.barTintColor = AppColors.secondarySystemFillColor
        cancelButton.tintColor = AppColors.themeGreen
        doneButton.tintColor   = AppColors.themeGreen
        
        doneButton.addTargetForAction(self, action: #selector(self.pickerViewDoneButtonAction(_:)))
        cancelButton.addTargetForAction(self, action: #selector(self.cancleButtonAction(_:)))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        //self.genericPickerView.addBlurEffect(backgroundColor: AppColors.quaternarySystemFillColor, style: .dark, alpha: 1.0)
        return toolBar
    }
    
    
    
    @objc func pickerViewDoneButtonAction(_ sender: UITextField){
        
        valueChangedGenericPicker()
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to:nil, from:nil, for:nil)
    }
    
    @objc func valueChangedGenericPicker() {
        let indexPath = self.salutationPicker.selectedRow(inComponent: 0)
        self.nameTitleTextField.text = self.viewModel.salutation[indexPath]
//        self.viewModel.userData.salutation = self.viewModel.salutation[indexPath]
//        self.letsStartedButton.isEnabled  = self.viewModel.isValidateForButtonEnable
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to:nil, from:nil, for:nil)
    }
    
    @objc func cancleButtonAction(_ sender: UITextField) {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to:nil, from:nil, for:nil)
    }
}

extension CreateProfileVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popToRootViewController(animated: true)
    }
}

//MARK:- Extension UITextFieldDelegateMethods
//MARK:-
extension CreateProfileVC {
    
    @objc func textFieldValueChanged(_ textField: UITextField) {
        
        switch textField {
            
        case self.firstNameTextField:
           // self.firstNameTextField.lineViewBottomSpace = -3
           self.viewModel.userData.firstName = textField.text ?? ""
            
        case self.lastNameTextField:
          //  self.lastNameTextField.lineViewBottomSpace = -3
            self.viewModel.userData.lastName = textField.text ?? ""
            
        case self.mobileNumberTextField:
            self.viewModel.userData.mobile = textField.text ?? ""
            
        default:
            break
        }
        
        self.letsStartedButton.isEnabledShadow  = !self.viewModel.isValidateForButtonEnable
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField === self.countryCodeTextField || textField === self.countryTextField {
            
            UIApplication.shared.sendAction(#selector(resignFirstResponder), to:nil, from:nil, for:nil)
            let model = PKCountryPicker.default.getCountryData(forISOCode: self.viewModel.userData.address?.country ?? "")
            PKCountryPicker.default.chooseCountry(onViewController: self, preSelectedCountry: model) { [weak self] (selectedCountry,closePicker) in
                printDebug("selected country data: \(selectedCountry)")
                
                guard let sSelf = self else {return}
                sSelf.setupData(forCountry: selectedCountry)
                
                if sSelf.viewModel.userData.mobile.count > sSelf.viewModel.userData.minContactLimit  {
                    
                    sSelf.viewModel.userData.mobile  = sSelf.viewModel.userData.mobile.substring(to: sSelf.viewModel.userData.maxContactLimit - 1)
                    sSelf.mobileNumberTextField.text = sSelf.viewModel.userData.mobile
                }
                if closePicker {
                    PKCountryPicker.default.closePicker(animated: true)
                }
            }
            return false
        } else {
            
            PKCountryPicker.default.closePicker()
            if textField === self.nameTitleTextField {
                
                if self.viewModel.salutation.isEmpty {
                    return false
                }
            }
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        if textField === self.mobileNumberTextField {
            return newString.length <= self.viewModel.userData.minContactLimit
        }
        else if textField === self.firstNameTextField {
            return newString.length <= AppConstants.kNameTextLimit
        }
        else if textField === self.lastNameTextField {
            return newString.length <= AppConstants.kNameTextLimit
        }
        
        return true
    }
    


    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField === self.firstNameTextField {
            
            self.firstNameTextField.resignFirstResponder()
            self.lastNameTextField.becomeFirstResponder()
            
        } else if textField === self.lastNameTextField {
            
            self.countryTextField.becomeFirstResponder()
            self.lastNameTextField.resignFirstResponder()
            
        } else if textField == self.mobileNumberTextField {
            
            self.mobileNumberTextField.resignFirstResponder()
            self.letsGetStartButton(self.letsStartedButton)
        }
        
        return true
    }
}

//MARK:- Extension UIPickerViewDataSource, UIPickerViewDelegate
//MARK:-
extension CreateProfileVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.viewModel.salutation.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return self.self.viewModel.salutation[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.viewModel.userData.salutation = self.viewModel.salutation[row]
        valueChangedGenericPicker()
    }
}

//MARK:- Extension UIPickerViewDataSource, UIPickerViewDelegate
//MARK:-
extension CreateProfileVC: CreateProfileVMDelegate {
    
    func getSalutationResponse(salutations: [String]) {
        self.viewModel.salutation = salutations
    }
    
    func willApiCall() {
        
        self.letsStartedButton.isLoading = true
    }
    
    func getSuccess() {
        
        self.letsStartedButton.isLoading = false
        self.setupViewForSuccessAnimation()
    }
    
    func getFail(errors: ErrorCodes) {
        
        self.letsStartedButton.isLoading = false
    }
}


//MARK:- Extension InitialAnimation
//MARK:-
extension CreateProfileVC {
    
    func setupViewForSuccessAnimation() {
        
        self.letsStartedButton.setTitle(nil, for: .normal)
        self.letsStartedButton.setImage(#imageLiteral(resourceName: "Checkmark"), for: .normal)
//        self.letStartButtonHeight.constant = 74
//        self.letsStartButtonWidth.constant = 74
       // self.letsStartedButton.layer.masksToBounds = true
        //let reScaleFrame = CGRect(x: (self.whiteBackgroundView.width - (74.0)/2) / 2.0, y: self.letsStartedButton.y, width: 74.0, height: 74.0)

        //self.letsStartedButton.translatesAutoresizingMaskIntoConstraints = true

        UIView.animate(withDuration: AppConstants.kAnimationDuration / 4.0, animations: {
            self.letStartButtonHeight.constant = 74
            self.letsStartButtonWidth.constant = 74
            self.letsStartedButton.myCornerRadius = 74 / 2.0
            self.whiteBackgroundView.alpha = 0.5
            self.view.layoutIfNeeded()
            
        }) { (isCompleted) in
            //self.letsStartedButton.layer.cornerRadius = reScaleFrame.height / 2.0

            let tY = ((UIDevice.screenHeight - self.letsStartedButton.height) / 2.0) - self.letsStartedButton.y
            var t = CGAffineTransform.identity
            t = t.translatedBy(x: 0.0, y: tY)

            UIView.animate(withDuration: ((AppConstants.kAnimationDuration / 4.0) * 3.0), animations: {
                self.letsStartedButton.transform = t
                self.whiteBackgroundView.alpha = 1.0
            }) { (isCompleted) in
                if isCompleted {
                    self.whiteBackgroundView.isUserInteractionEnabled = true
                    AppFlowManager.default.goToDashboard()
                }
            }
        }
    }
    
    func setupInitialAnimation() {
        
        self.logoImage.transform         = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.createProfileTitleLabel.transform   = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.createProfileSubTitleLabel.transform = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.nameTitleTextField.transform      = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.firstNameTextField.transform      = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.lastNameTextField.transform   = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.countryTextField.transform    = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.mobileNumberTextField.transform = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.letsStartedButton.transform    = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.countryCodeTextField.transform  = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.countryCodeLabel.transform     = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.countryFlagImage.transform     = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.titleDropDownImage.transform     = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.countryDropdownImage.transform     = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.switchParentContainerView.transform = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        
    }
    
    func setupViewDidLoadAnimation() {
        
        let rDuration = 1.0 / 3.0
        UIView.animateKeyframes(withDuration: AppConstants.kAnimationDuration, delay: 0.0, options: .calculationModeLinear, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: (rDuration * 1.0), animations: {
                self.logoImage.transform          = .identity
            })
            
            UIView.addKeyframe(withRelativeStartTime: (rDuration * 0.1), relativeDuration: (rDuration * 2.0), animations: {
                self.createProfileTitleLabel.transform      = .identity
                self.createProfileSubTitleLabel.transform      = .identity
                self.nameTitleTextField.transform      = .identity
                self.titleDropDownImage.transform      = .identity
                self.countryFlagImage.transform      = .identity
                self.countryCodeLabel.transform      = .identity
                self.countryCodeTextField.transform      = .identity
            })
            
            UIView.addKeyframe(withRelativeStartTime: (rDuration * 2.0), relativeDuration: (rDuration * 3.0), animations: {
                self.firstNameTextField.transform    = .identity
                self.lastNameTextField.transform = .identity
                self.countryTextField.transform    = .identity
                self.countryDropdownImage.transform      = .identity
                self.mobileNumberTextField.transform  = .identity
                self.letsStartedButton.transform = .identity
                self.switchParentContainerView.transform = .identity

            })
            
        }) { (success) in
            self.viewModel.isFirstTime = false
        }
    }
    
    func setViewAlphaZero() {
        
        self.logoImage.alpha         = 0
        self.createProfileTitleLabel.alpha         = 0
        self.createProfileSubTitleLabel.alpha         = 0
        self.nameTitleTextField.alpha = 0
        self.firstNameTextField.alpha = 0
        self.lastNameTextField.alpha = 0
        self.countryTextField.alpha = 0
        self.mobileNumberTextField.alpha = 0
        self.topNavBar.leftButton.alpha = 0
        self.countryCodeTextField.alpha = 0
        self.countryCodeLabel.alpha = 0
        self.countryFlagImage.alpha = 0
        self.titleDropDownImage.alpha = 0
        self.countryDropdownImage.alpha = 0
        self.switchParentContainerView.alpha = 0
    }
}
