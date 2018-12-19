//
//  SocialLoginVC.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 04/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class SocialLoginVC: BaseVC {
    
    //MARK:- Properties
    //MARK:-
    let viewModel = SocialLoginVM()
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var centerTitleLabel: UILabel!
    @IBOutlet weak var fbButton: SocialButton!
    @IBOutlet weak var googleButton: SocialButton!
    @IBOutlet weak var linkedInButton: SocialButton!
    @IBOutlet weak var newRegisterLabel: UILabel!
    @IBOutlet weak var existingUserLabel: UILabel!
    @IBOutlet weak var sepratorLineImage: UIImageView!
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
        
        self.fbButton.cornerRadius = self.fbButton.height/2
        self.googleButton.cornerRadius  = self.googleButton.height/2
        self.linkedInButton.cornerRadius = self.linkedInButton.height/2
        
        self.fbButton.addShadowWith(shadowRadius: 5, shadowOpacity: 0.3)
        self.googleButton.addShadowWith(shadowRadius: 5, shadowOpacity: 0.3)
        self.linkedInButton.addShadowWith(shadowRadius: 5, shadowOpacity: 0.3)
    }
    
    override func setupFonts() {
        
        self.centerTitleLabel.font = AppFonts.Regular.withSize(16)
        self.fbButton.titleLabel?.font = AppFonts.Regular.withSize(16)
        self.googleButton.titleLabel?.font = AppFonts.Regular.withSize(16)
        self.linkedInButton.titleLabel?.font = AppFonts.Regular.withSize(16)
    }
    
    override func setupColors() {
        
        self.centerTitleLabel.textColor = AppColors.themeBlack
        self.fbButton.backgroundColor = AppColors.fbButtonBackgroundColor
        self.googleButton.backgroundColor = AppColors.themeWhite
        self.linkedInButton.backgroundColor = AppColors.linkedinButtonBackgroundColor
    }
    
    override func setupTexts() {
        
        self.fbButton.setTitle(LocalizedString.Continue_with_Facebook.localized, for: .normal)
        self.googleButton.setTitle(LocalizedString.Continue_with_Google.localized, for: .normal)
        self.linkedInButton.setTitle(LocalizedString.Continue_with_Linkedin.localized, for: .normal)
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    //MARK:- IBActions
    //MARK:-
    @IBAction func fbLoginButtonAction(_ sender: UIButton) {
        
        self.viewModel.fbLogin(vc: self)
    }
    
    @IBAction func googleLoginButtonAction(_ sender: UIButton) {
        
        self.viewModel.googleLogin()
    }
    
    @IBAction func linkedInLoginButtonAction(_ sender: UIButton) {
        
        self.viewModel.linkedLogin()
    }
    
    @IBAction func newRegistrationButtonAction(_ sender: UIButton) {
        
        AppFlowManager.default.moveToCreateYourAccountVC()
    }
    
    @IBAction func existingUserButtonAction(_ sender: UIButton) {
        
        AppFlowManager.default.moveToLoginVC()
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- Extension Initialsetups
//MARK:-
private extension SocialLoginVC {
    
    func initialSetups() {
        
        self.setupsFonts()
        self.fbButton.addRequiredActionToShowAnimation()
        self.googleButton.addRequiredActionToShowAnimation()
        self.linkedInButton.addRequiredActionToShowAnimation()
    }
    
    func setupsFonts() {
        
        
        let attributedString = NSMutableAttributedString(string: LocalizedString.I_am_new_register.localized, attributes: [
            .font: AppFonts.Regular.withSize(14.0),
            .foregroundColor: UIColor.black
            ])
        attributedString.addAttribute(.font, value: AppFonts.SemiBold.withSize(18.0), range: NSRange(location: 0, length: 7))
        self.newRegisterLabel.attributedText = attributedString
        
        let existingUserString = NSMutableAttributedString(string: LocalizedString.Existing_User_Sign.localized, attributes: [
            .font: AppFonts.SemiBold.withSize(18.0),
            .foregroundColor: UIColor.black
            ])
        existingUserString.addAttribute(.font, value: AppFonts.Regular.withSize(14.0), range: NSRange(location: 14, length: 7))
        self.existingUserLabel.attributedText = existingUserString
    }
}


//MARK:- Extension Initialsetups
//MARK:-
extension SocialLoginVC: SocialLoginVMDelegate {
    
    func willLogin() {
        
        if self.viewModel.userData.service == APIKeys.facebook.rawValue {
            
            self.fbButton.isLoading = true
        } else if self.viewModel.userData.service == APIKeys.google.rawValue {
            
            self.googleButton.isLoading = true
        } else {
            
            self.googleButton.isLoading = true
        }
    }
    
    func didLoginSuccess() {
        
        if self.viewModel.userData.service == APIKeys.facebook.rawValue {
            
            self.fbButton.isLoading = false
        } else if self.viewModel.userData.service == APIKeys.google.rawValue {
            
            self.googleButton.isLoading = false
        } else {
            
            self.googleButton.isLoading = false
        }
        AppFlowManager.default.goToDashboard()
    }
    
    func didLoginFail(errors: ErrorCodes) {
        
        if self.viewModel.userData.service == APIKeys.facebook.rawValue {
            
            self.fbButton.isLoading = false
        } else if self.viewModel.userData.service == APIKeys.google.rawValue {
            
            self.googleButton.isLoading = false
        } else {
            
            self.googleButton.isLoading = false
        }
        
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
extension SocialLoginVC {
    
    func setupInitialAnimation() {
        
        self.logoImage.transform         = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.topImage.transform          = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.centerTitleLabel.transform  = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.fbButton.transform          = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.googleButton.transform      = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.linkedInButton.transform    = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.newRegisterLabel.transform  = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.existingUserLabel.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.sepratorLineImage.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
    }
    
    func setupViewDidLoadAnimation() {
        
        
        UIView.animate(withDuration: 0.2) {
            
            self.logoImage.transform          = .identity
            self.topImage.transform          = .identity
        }
        
        UIView.animate(withDuration: 0.3) {
            
            self.centerTitleLabel.transform      = .identity
        }
        
        
        UIView.animate(withDuration: 0.35, animations:{
            
            self.fbButton.transform    = .identity
            self.googleButton.transform = .identity
            self.linkedInButton.transform    = .identity
            self.newRegisterLabel.transform  = .identity
            self.existingUserLabel.transform = .identity
            self.sepratorLineImage.transform = .identity
            
        }) { (success) in
            
            self.viewModel.isFirstTime = false
        }
    }
}
