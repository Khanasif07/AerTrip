//
//  SocialLoginVC.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 04/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol SocialLoginVCDelegate: class {
    func backButtonTapped(_ sender: UIButton)
}

class SocialLoginVC: BaseVC {
    // MARK: - Properties
    
    // MARK: -
    // used to find the logo view to hide
    let viewModel = SocialLoginVM()
    weak var delegate: SocialLoginVCDelegate?
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var fbButton: ATButton!
    @IBOutlet weak var googleButton: ATButton!
    @IBOutlet weak var linkedInButton: ATButton!
    @IBOutlet weak var newRegisterLabel: UILabel!
    @IBOutlet weak var existingUserLabel: UILabel!
    @IBOutlet weak var sepratorLineImage: UIImageView!
    @IBOutlet weak var bottomStackView: UIStackView!
    @IBOutlet weak var socialButtonsStackView: UIStackView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var logoContainerView: UIView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.viewModel.isFirstTime {
            self.backButton.isHidden  = true
            self.view.backgroundColor = .clear
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.backButton.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.fbButton.cornerRadius = self.fbButton.height / 2
        self.googleButton.cornerRadius = self.googleButton.height / 2
        self.linkedInButton.cornerRadius = self.linkedInButton.height / 2
        
        self.fbButton.addShadowWith(shadowRadius: 5, shadowOpacity: 0.3)
        self.googleButton.addShadowWith(shadowRadius: 5, shadowOpacity: 0.3)
        self.linkedInButton.addShadowWith(shadowRadius: 5, shadowOpacity: 0.3)
    }
    
    override func setupFonts() {
        self.fbButton.titleLabel?.font = AppFonts.Regular.withSize(16)
        self.googleButton.titleLabel?.font = AppFonts.Regular.withSize(16)
        self.linkedInButton.titleLabel?.font = AppFonts.Regular.withSize(16)
    }
    
    override func setupColors() {
        self.fbButton.shadowColor = AppColors.themeBlack
        self.googleButton.shadowColor = AppColors.themeBlack
        self.linkedInButton.shadowColor = AppColors.themeBlack
        
        self.fbButton.gradientColors = [AppColors.fbButtonBackgroundColor, AppColors.fbButtonBackgroundColor]
        self.googleButton.gradientColors = [AppColors.themeWhite, AppColors.themeWhite]
        self.linkedInButton.gradientColors = [AppColors.linkedinButtonBackgroundColor, AppColors.linkedinButtonBackgroundColor]
    }
    
    override func setupTexts() {
        self.fbButton.setTitle(LocalizedString.Continue_with_Facebook.localized, for: .normal)
        self.googleButton.setTitle(LocalizedString.Continue_with_Google.localized, for: .normal)
        self.linkedInButton.setTitle(LocalizedString.Continue_with_Linkedin.localized, for: .normal)
        self.fbButton.setImage(AppImage.facebookLogoImage, for: .normal)
        self.fbButton.setImage(AppImage.facebookLogoImage, for: .highlighted)
        self.googleButton.setImage(AppImage.googleLogoImage, for: .normal)
        self.googleButton.setImage(AppImage.googleLogoImage, for: .highlighted)
        self.linkedInButton.setImage(AppImage.linkedInLogoImage, for: .normal)
        self.linkedInButton.setImage(AppImage.linkedInLogoImage, for: .highlighted)
        
    }
    
    override func bindViewModel() {
        self.viewModel.delegate = self
    }
    
    // MARK: - IBActions
    
    // MARK: -
    
    @IBAction func fbLoginButtonAction(_ sender: UIButton) {
       
        self.viewModel.fbLogin(vc: self, completionBlock: nil)
    }
    
    @IBAction func googleLoginButtonAction(_ sender: UIButton) {
        self.viewModel.googleLogin(vc: self, completionBlock: nil)
    }
    
    @IBAction func linkedInLoginButtonAction(_ sender: UIButton) {
        self.viewModel.linkedLogin(vc: self)
    }
    
    @IBAction func newRegistrationButtonAction(_ sender: UIButton) {
        AppFlowManager.default.moveToCreateYourAccountVC(email: "")
    }
    
    @IBAction func existingUserButtonAction(_ sender: UIButton) {
        
        AppFlowManager.default.moveToLoginVC(email: "")
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.delegate?.backButtonTapped(sender)
    }
}

// MARK: - Extension Initialsetups

// MARK: -

private extension SocialLoginVC {
    func initialSetups() {
        self.setupsFonts()
        self.fbButton.addRequiredActionToShowAnimation()
        self.googleButton.addRequiredActionToShowAnimation()
        self.linkedInButton.addRequiredActionToShowAnimation()
        
        self.addAppLogoView()
        statusBarStyle = .default
    }
    
    private func addAppLogoView() {
        let view = SideMenuLogoView.instanceFromNib()
        view.backgroundColor = AppColors.clear
        view.frame = self.logoContainerView.bounds
        
        self.logoContainerView.addSubview(view)
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

// MARK: - Extension Initialsetups

// MARK: -

extension SocialLoginVC: SocialLoginVMDelegate {
    func willLogin() {
        if self.viewModel.userData.service == APIKeys.facebook.rawValue {
            self.fbButton.isLoading = true
        } else if self.viewModel.userData.service == APIKeys.google.rawValue {
            self.googleButton.isLoading = true
        } else {
            self.linkedInButton.isLoading = true
        }
    }
    
    func didLoginSuccess() {
        if self.viewModel.userData.service == APIKeys.facebook.rawValue {
            self.fbButton.isLoading = false
        } else if self.viewModel.userData.service == APIKeys.google.rawValue {
            self.googleButton.isLoading = false
        } else {
            self.linkedInButton.isLoading = false
        }
        AppFlowManager.default.goToDashboard()
    }
    
    func didLoginFail(errors: ErrorCodes) {
        if self.viewModel.userData.service == APIKeys.facebook.rawValue {
            self.fbButton.isLoading = false
        } else if self.viewModel.userData.service == APIKeys.google.rawValue {
            self.googleButton.isLoading = false
        } else {
            self.linkedInButton.isLoading = false
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

// MARK: - Extension InitialAnimation

// MARK: -

extension SocialLoginVC {

    
    func animateContentOnLoad() {
        
        self.fbButton.transform          = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.googleButton.transform      = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.linkedInButton.transform    = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
        self.bottomStackView.transform   = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        self.sepratorLineImage.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        
        self.fbButton.alpha = 0
        self.googleButton.alpha = 0
        self.linkedInButton.alpha = 0

        UIView.animateKeyframes(withDuration: AppConstants.kAnimationDuration, delay: 0.0, options: .calculationModeLinear, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: AppConstants.kAnimationDuration / 4.0, animations: {
                self.fbButton.transform = .identity
                self.fbButton.alpha = 1.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: AppConstants.kAnimationDuration / 4.0, relativeDuration: AppConstants.kAnimationDuration / 4.0, animations: {
                self.googleButton.transform = .identity
                self.googleButton.alpha = 1.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: AppConstants.kAnimationDuration / 2.0, relativeDuration: AppConstants.kAnimationDuration / 4.0, animations: {
                self.bottomStackView.transform    = .identity
                self.sepratorLineImage.transform  = .identity
            })
            
            UIView.addKeyframe(withRelativeStartTime: ((AppConstants.kAnimationDuration / 4.0) * 3.0), relativeDuration: AppConstants.kAnimationDuration / 4.0, animations: {
                self.linkedInButton.transform     = .identity
                self.linkedInButton.alpha = 1.0
            })
            
        }) { (success) in
            self.viewModel.isFirstTime = false
            
        }
    }
    
    func animateContentOnPop() {

        UIView.animateKeyframes(withDuration: AppConstants.kAnimationDuration, delay: 0.0, options: .calculationModeLinear, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: AppConstants.kAnimationDuration / 4.0, animations: {
                self.linkedInButton.transform     = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
                self.linkedInButton.alpha = 0.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: AppConstants.kAnimationDuration / 4.0, relativeDuration: AppConstants.kAnimationDuration / 4.0) {
                self.bottomStackView.transform    = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
                self.sepratorLineImage.transform  = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
            }
            
            UIView.addKeyframe(withRelativeStartTime: AppConstants.kAnimationDuration / 2.0, relativeDuration: AppConstants.kAnimationDuration / 4.0, animations: {
                self.googleButton.transform     = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
                self.googleButton.alpha = 0.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: ((AppConstants.kAnimationDuration / 4.0) * 3.0), relativeDuration: AppConstants.kAnimationDuration / 4.0, animations: {
                self.fbButton.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
                self.fbButton.alpha = 0.0
            })
            
        }) { (success) in
            self.viewModel.isFirstTime = true
        }
    }
}
