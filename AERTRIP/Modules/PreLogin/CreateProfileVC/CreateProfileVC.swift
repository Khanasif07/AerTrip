//
//  CreateProfileVC.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 07/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class CreateProfileVC: BaseVC {
    
    //MARK:- Properties
    //MARK:-
    let viewModel = CreateProfileVM()
    let salutationPicker = UIPickerView()
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var createProfileTitleLabel: UILabel!
    @IBOutlet weak var createProfileSubTitleLabel: UILabel!
    @IBOutlet weak var nameTitleTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var firstNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var lastNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var countryTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var mobileNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var letsStartedButton: ATButton!
    @IBOutlet weak var countryCodeTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var countryFlagImage: UIImageView!
    @IBOutlet weak var titleDropDownImage: UIImageView!
    @IBOutlet weak var countryDropdownImage: UIImageView!
    @IBOutlet weak var letsStartButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var letStartButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var letStartButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var whiteBackgroundView: UIView!
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.viewModel.webserviceForGetSalutations()
        self.initialSetups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.viewModel.isFirstTime {
            self.setupInitialAnimation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.viewModel.isFirstTime {
            self.setupViewDidLoadAnimation()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.letsStartedButton.layer.cornerRadius = self.letsStartedButton.height/2
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        PKCountryPicker.default.closePicker()
    }
    
    override func setupFonts() {
        
        self.createProfileTitleLabel.font      = AppFonts.Bold.withSize(38)
        self.createProfileSubTitleLabel.font    = AppFonts.Regular.withSize(16)
        self.countryCodeLabel.font           = AppFonts.Regular.withSize(18)
        self.setupTextFieldColorTextAndFont()
        
    }
    
    override func setupTexts() {
        
        self.createProfileTitleLabel.text = LocalizedString.Create_Your_Profile.localized
        self.createProfileSubTitleLabel.text = LocalizedString.and_you_are_done.localized
        self.letsStartedButton.setTitle(LocalizedString.Lets_Get_Started.localized, for: .normal)
    }
    
    override func setupColors() {
        
        self.createProfileTitleLabel.textColor  = AppColors.themeBlack
        self.createProfileSubTitleLabel.textColor  = AppColors.themeBlack
    }
    
    //MARK:- IBOutlets
    //MARK:-
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func letsGetStartButton(_ sender: ATButton) {
        
        self.view.endEditing(true)
        
        if self.viewModel.isValidateData {
            self.viewModel.webserviceForUpdateProfile()
        }

    }
}

//MARK:- Extension Initialsetups
//MARK:-
private extension CreateProfileVC {
    
    func initialSetups() {
        
        self.viewModel.userData.maxNumberCount = 10
        self.viewModel.userData.minNumberCount  = 10
        self.viewModel.userData.countryCode = LocalizedString.selectedCountryCode.localized
        self.viewModel.userData.country = LocalizedString.selectedCountry.localized
        self.letsStartedButton.isEnabled = false
        self.firstNameTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
        self.lastNameTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
        self.mobileNumberTextField.addTarget(self, action: #selector(self.textFieldValueChanged(_:)), for: .editingChanged)
    }
    
    func setupTextFieldColorTextAndFont () {
        
        self.salutationPicker.delegate = self
        self.nameTitleTextField.delegate = self
        self.nameTitleTextField.setupTextField(placehoder: LocalizedString.Title.localized,textColor: AppColors.textFieldTextColor51, keyboardType: .default, returnType: .done, isSecureText: false)
        self.firstNameTextField.setupTextField(placehoder: LocalizedString.First_Name.localized,textColor: AppColors.textFieldTextColor51, keyboardType: .default, returnType: .next, isSecureText: false)
        self.lastNameTextField.setupTextField(placehoder: LocalizedString.Last_Name.localized,textColor: AppColors.textFieldTextColor51, keyboardType: .default, returnType: .next, isSecureText: false)
        self.countryTextField.setupTextField(placehoder: LocalizedString.Country.localized,textColor: AppColors.textFieldTextColor51, keyboardType: .default, returnType: .next, isSecureText: false)
        self.mobileNumberTextField.setupTextField(placehoder: LocalizedString.Mobile_Number.localized,textColor: AppColors.textFieldTextColor51,selectedTitleColor: UIColor.clear, keyboardType: .numberPad, returnType: .done, isSecureText: false)
        self.countryCodeTextField.setupTextField(placehoder:"",textColor: AppColors.textFieldTextColor51,selectedTitleColor: UIColor.clear, keyboardType: .numberPad, returnType: .done, isSecureText: false)
        
        self.countryTextField.delegate = self
        self.countryCodeTextField.delegate = self
        self.countryCodeTextField.tintColor = .clear
        self.nameTitleTextField.inputView = self.salutationPicker
        self.nameTitleTextField.inputAccessoryView = self.initToolBar(picker: self.salutationPicker)
        self.nameTitleTextField.tintColor = UIColor.clear
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.mobileNumberTextField.delegate = self
    }
    
    func initToolBar(picker: UIPickerView) -> UIToolbar {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red:14.0/255, green:122.0/255, blue:254.0/255, alpha: 1)
        toolBar.sizeToFit()
        // TODO need to update actions for all buttons
        let cancelButton = UIBarButtonItem(title: LocalizedString.Cancel.localized, style: UIBarButtonItem.Style.plain, target: self, action: nil)
        let doneButton = UIBarButtonItem()
        doneButton.title  = LocalizedString.Done.localized
        
        cancelButton.tintColor = AppColors.themeGreen
        doneButton.tintColor   = AppColors.themeGreen
        
        doneButton.addTargetForAction(self, action: #selector(self.pickerViewDoneButtonAction(_:)))
        cancelButton.addTargetForAction(self, action: #selector(self.cancleButtonAction(_:)))
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    
    
    @objc func pickerViewDoneButtonAction(_ sender: UITextField){
        
        let indexPath = self.salutationPicker.selectedRow(inComponent: 0)
        self.nameTitleTextField.text = self.viewModel.salutation[indexPath]
        self.viewModel.userData.salutation = self.viewModel.salutation[indexPath]
        self.letsStartedButton.isEnabled  = self.viewModel.isValidateForButtonEnable
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to:nil, from:nil, for:nil)
    }
    
    @objc func cancleButtonAction(_ sender: UITextField) {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to:nil, from:nil, for:nil)
    }
}

//MARK:- Extension UITextFieldDelegateMethods
//MARK:-
extension CreateProfileVC {
    
    @objc func textFieldValueChanged(_ textField: UITextField) {
        
        switch textField {
            
        case self.firstNameTextField:
            self.viewModel.userData.firstName = textField.text ?? ""
            
        case self.lastNameTextField:
            self.viewModel.userData.lastName = textField.text ?? ""
            
        case self.mobileNumberTextField:
            self.viewModel.userData.mobile = textField.text ?? ""
            
        default:
            break
        }
        
        self.letsStartedButton.isEnabled  = self.viewModel.isValidateForButtonEnable
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField === self.countryCodeTextField || textField === self.countryTextField {
            
            UIApplication.shared.sendAction(#selector(resignFirstResponder), to:nil, from:nil, for:nil)
            PKCountryPicker.default.chooseCountry(onViewController: self) { (selectedCountry) in
                printDebug("selected country data: \(selectedCountry)")
                
                self.countryCodeLabel.text  = selectedCountry.countryCode
                self.countryFlagImage.image = selectedCountry.flagImage
                self.countryTextField.text = selectedCountry.countryEnglishName
                self.viewModel.userData.country = selectedCountry.countryEnglishName
                self.viewModel.userData.isd = selectedCountry.countryCode
                self.viewModel.userData.countryCode = selectedCountry.ISOCode
                self.viewModel.userData.maxNumberCount = selectedCountry.maxNSN
                self.viewModel.userData.minNumberCount  = selectedCountry.minNSN
                
                if self.viewModel.userData.mobile.count > self.viewModel.userData.maxNumberCount  {
                    
                    self.viewModel.userData.mobile  = self.viewModel.userData.mobile.substring(to: self.viewModel.userData.maxNumberCount - 1)
                    self.mobileNumberTextField.text = self.viewModel.userData.mobile
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
        
//        var maxLength = 50
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        if textField === self.mobileNumberTextField {
            return newString.length <= self.viewModel.userData.maxNumberCount
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
        
        var message = ""
        for index in 0..<errors.count {
            if index == 0 {
                
                message = AppErrorCodeFor(rawValue: errors[index])?.message ?? ""
            } else {
                message += ", " + (AppErrorCodeFor(rawValue: errors[index])?.message ?? "")
            }
        }
        
        AppToast.default.showToastMessage(message: message, vc: self)
    }
}


//MARK:- Extension InitialAnimation
//MARK:-
extension CreateProfileVC {
    
    func setupViewForSuccessAnimation() {
        
//        self.letsStartedButton.setTitle("", for: .normal)
//
////        let myLayer = CALayer()
////        myLayer.backgroundColor = UIColor.clear.cgColor
////        let myImage = UIImage(named: "Checkmark")?.cgImage
////        myLayer.frame = CGRect(x: 27, y: 27, width: 20, height: 20)
////        myLayer.contents = myImage
////        self.letsStartedButton.layer.addSublayer(myLayer)
////
////        self.viewModel.isSuccessView = true
////
////        let scale = CGAffineTransform(scaleX: 0.41, y: 1.48)
////        let y = (self.whiteBackgroundView.height - 74.0) / 2.0
////        let translate = CGAffineTransform(translationX: 0, y: -(self.letsStartedButton.y - y) )
////
////        UIView.animate(withDuration: 1.0, animations: {
////            self.letsStartedButton.transform = scale.concatenating(translate)
////            self.whiteBackgroundView.alpha = 1.0
////            self.letsStartedButton.layer.cornerRadius = 37.0
////        }) { (isCompleted) in
////            if isCompleted {
////                self.whiteBackgroundView.isUserInteractionEnabled = true
////            }
////        }
//
//        let reScaleFrame = CGRect(x: (self.whiteBackgroundView.width - 74.0) / 2.0, y: self.letsStartedButton.y, width: 74.0, height: 74.0)
//
//        self.letsStartedButton.translatesAutoresizingMaskIntoConstraints = true
//        UIView.animate(withDuration: 0.2, animations: {
//            self.letsStartedButton.frame = reScaleFrame
//            self.whiteBackgroundView.alpha = 0.5
//
//            self.view.layoutIfNeeded()
//        }) { (isCompleted) in
////            let repositionFrame = CGRect(x: (self.whiteBackgroundView.width - 74.0) / 2.0, y: (self.whiteBackgroundView.height - 74.0) / 2.0, width: 74.0, height: 74.0)
////            UIView.animate(withDuration: 0.3, animations: {
////                self.letsStartedButton.frame = repositionFrame
////                self.whiteBackgroundView.alpha = 1.0
////            }) { (isCompleted) in
////                if isCompleted {
////                    self.whiteBackgroundView.isUserInteractionEnabled = true
////                }
////            }
//        }
    
        UIView.animate(withDuration: 0.5, animations: {


            self.letsStartedButton.setTitle("", for: .normal)

            let myLayer = CALayer()
            myLayer.backgroundColor = UIColor.clear.cgColor
            let myImage = UIImage(named: "Checkmark")?.cgImage
            myLayer.frame = CGRect(x: 27, y: 27, width: 20, height: 20)
            myLayer.contents = myImage
            self.letsStartedButton.layer.addSublayer(myLayer)

            self.letStartButtonHeight.constant   = 74
            self.letsStartButtonWidth.constant   = 74

            self.letsStartedButton.layer.cornerRadius = 37
            let y = UIScreen.main.bounds.height/2 - 37
            self.setViewAlphaZero()
            self.letsStartedButton.transform = CGAffineTransform(translationX: 0, y: -(self.letsStartedButton.y - y))


            DispatchQueue.main.async {

                self.letsStartedButton.bounds = self.letsStartedButton.layer.bounds
                self.letsStartedButton.layoutIfNeeded()
            }
        }, completion: { (success) in
            
            AppFlowManager.default.goToDashboard()
        })
    }
    
    func setupInitialAnimation() {
        
        self.logoImage.transform         = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.createProfileTitleLabel.transform   = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.createProfileSubTitleLabel.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.nameTitleTextField.transform      = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.firstNameTextField.transform      = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.lastNameTextField.transform   = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.countryTextField.transform    = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.mobileNumberTextField.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.letsStartedButton.transform    = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.countryCodeTextField.transform  = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.countryCodeLabel.transform     = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.countryFlagImage.transform     = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.titleDropDownImage.transform     = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.countryDropdownImage.transform     = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
    }
    
    func setupViewDidLoadAnimation() {
        
        
        UIView.animate(withDuration: 0.2) {
            
            self.logoImage.transform          = .identity
        }
        
        UIView.animate(withDuration: 0.3) {
            
            self.createProfileTitleLabel.transform      = .identity
            self.createProfileSubTitleLabel.transform      = .identity
            self.nameTitleTextField.transform      = .identity
            self.titleDropDownImage.transform      = .identity
            self.countryFlagImage.transform      = .identity
            self.countryCodeLabel.transform      = .identity
            self.countryCodeTextField.transform      = .identity
        }
        
        
        UIView.animate(withDuration: 0.35, animations:{
            
            self.firstNameTextField.transform    = .identity
            self.lastNameTextField.transform = .identity
            self.countryTextField.transform    = .identity
            self.countryDropdownImage.transform      = .identity
            self.mobileNumberTextField.transform  = .identity
            self.letsStartedButton.transform = .identity
            
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
        self.backButton.alpha = 0
        self.countryCodeTextField.alpha = 0
        self.countryCodeLabel.alpha = 0
        self.countryFlagImage.alpha = 0
        self.titleDropDownImage.alpha = 0
        self.countryDropdownImage.alpha = 0
    }
}
