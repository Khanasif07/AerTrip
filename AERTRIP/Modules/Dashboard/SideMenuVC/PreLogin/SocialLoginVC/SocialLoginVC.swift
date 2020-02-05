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

enum LoginFlowUsingFor {
    case loginProcess, loginVerificationForCheckout, loginVerificationForBulkbooking
}

class SocialLoginVC: BaseVC {
    
    // MARK: - Properties
    // MARK: -
    // used to find the logo view to hide
    let viewModel = SocialLoginVM()
    weak var delegate: SocialLoginVCDelegate?
    internal var currentlyUsingFrom = LoginFlowUsingFor.loginProcess
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var fbButton: ATButton!
    @IBOutlet weak var googleButton: ATButton!
    @IBOutlet weak var linkedInButton: ATButton!
    @IBOutlet weak var newRegisterLabel: UILabel!
    @IBOutlet weak var existingUserLabel: UILabel!
    @IBOutlet weak var sepratorLineImage: UIImageView!
    @IBOutlet weak var socialButtonsStackView: UIStackView!
    @IBOutlet weak var logoContainerView: UIView!
    @IBOutlet weak var newRegistrationContainerView: UIView!
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var socialButtosCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var socialAndLogoSpace: NSLayoutConstraint!
    
    private var logoView: SideMenuLogoView?
    
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
            self.topNavView.leftButton.isHidden  = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.topNavView.leftButton.isHidden = true
        self.statusBarStyle = .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.topNavView.leftButton.isHidden = false
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.fbButton.layer.cornerRadius = self.fbButton.height / 2
        self.googleButton.layer.cornerRadius = self.googleButton.height / 2
        self.linkedInButton.layer.cornerRadius = self.linkedInButton.height / 2
//        self.fbButton.layer.masksToBounds = true
//        self.googleButton.layer.masksToBounds = true
//        self.linkedInButton.layer.masksToBounds = true
    }
    
    override func setupFonts() {
         self.fbButton.setTitleFont(font: AppFonts.Regular.withSize(16), for: .highlighted)
         self.googleButton.setTitleFont(font: AppFonts.Regular.withSize(16), for: .highlighted)
         self.linkedInButton.setTitleFont(font: AppFonts.Regular.withSize(16), for: .highlighted)
        self.fbButton.setTitleFont(font: AppFonts.Regular.withSize(16), for: .normal)
        self.googleButton.setTitleFont(font: AppFonts.Regular.withSize(16), for: .normal)
        self.linkedInButton.setTitleFont(font: AppFonts.Regular.withSize(16), for: .normal)
        self.fbButton.setTitleFont(font: AppFonts.Regular.withSize(16), for: .selected)
        self.googleButton.setTitleFont(font: AppFonts.Regular.withSize(16), for: .selected)
        self.linkedInButton.setTitleFont(font: AppFonts.Regular.withSize(16), for: .selected)
        
    }
    
    override func setupColors() {
    
        self.fbButton.gradientColors = [AppColors.fbButtonBackgroundColor, AppColors.fbButtonBackgroundColor]
        self.googleButton.gradientColors = [AppColors.themeWhite, AppColors.themeWhite]
        self.linkedInButton.gradientColors = [AppColors.linkedinButtonBackgroundColor, AppColors.linkedinButtonBackgroundColor]
        
        self.fbButton.isSocial = true
      
//        self.fbButton.shadowColor = AppColors.themeBlack
        
        self.googleButton.isSocial = true
//        self.googleButton.shadowColor = AppColors.themeGray20
        
        self.fbButton.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)
        
        self.googleButton.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)
//
        self.linkedInButton.isSocial = true
        
        self.linkedInButton.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)
        
     //   self.linkedInButton.shadowColor = AppColors.themeBlack
    }
    
    override func setupTexts() {
        self.fbButton.setTitle(LocalizedString.Continue_with_Facebook.localized, for: .normal)
        self.googleButton.setTitle(LocalizedString.Continue_with_Google.localized, for: .normal)
        self.linkedInButton.setTitle(LocalizedString.Continue_with_Linkedin.localized, for: .normal)
        
//        self.fbButton.shadowColor = AppColors.themeBlack
//        self.view.backgroundColor = AppColors.clear
        self.fbButton.isSocial = false
        self.googleButton.isSocial = false
        self.linkedInButton.isSocial = false
        self.googleButton.shadowColor = AppColors.themeBlack.withAlphaComponent(0.16)
        self.fbButton.shadowColor = AppColors.themeBlack.withAlphaComponent(0.16)
        self.linkedInButton.shadowColor = AppColors.themeBlack.withAlphaComponent(0.16)

        delay(seconds: 0.4) {
            self.fbButton.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)
            self.googleButton.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)
            self.linkedInButton.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)

        }

        self.fbButton.setImage(AppImage.facebookLogoImage, for: .normal)
        self.googleButton.setImage(AppImage.googleLogoImage, for: .normal)
        self.linkedInButton.setImage(AppImage.linkedInLogoImage, for: .normal)
        self.setUpSocialBtnInset(button: fbButton)
        self.setUpSocialBtnInset(button: googleButton)
        self.setUpSocialBtnInset(button: linkedInButton)
    }
    
    func setUpSocialBtnInset(button: UIButton) {
            var imgInset = button.imageEdgeInsets
            var titleInset = button.titleEdgeInsets
            titleInset.left = titleInset.left + 2.5
            button.titleEdgeInsets = titleInset
            imgInset.left =  imgInset.left + 10
            button.imageEdgeInsets = imgInset
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
        if currentlyUsingFrom == .loginVerificationForCheckout {
            popIfUsingFromCheckOut()
        }
        else {
            AppFlowManager.default.moveToCreateYourAccountVC(email: "", usingFor: currentlyUsingFrom)
        }
    }
    
    @IBAction func existingUserButtonAction(_ sender: UIButton) {
        
        AppFlowManager.default.moveToLoginVC(email: "", usingFor: currentlyUsingFrom)
    }
    
    private func popIfUsingFromCheckOut() {
        self.sendDataChangedNotification(data: ATNotification.userAsGuest)
//        if let obj = AppFlowManager.default.mainNavigationController.viewControllers.first(where: { (vc) -> Bool in
//            return vc.isKind(of: HotelResultVC.self)
//        }) {
//            AppFlowManager.default.popToViewController(obj, animated: true)
//        }
    }
}

// MARK: - Extension Initialsetups

// MARK: -

private extension SocialLoginVC {
    func initialSetups() {
        
        self.view.backgroundColor = AppColors.screensBackground.color
        
        self.setupsFonts()
        self.fbButton.isSocial = true
        self.googleButton.isSocial = true
        self.linkedInButton.isSocial = true
        self.fbButton.addRequiredActionToShowAnimation()
        self.googleButton.addRequiredActionToShowAnimation()
        self.linkedInButton.addRequiredActionToShowAnimation()
        
        self.addAppLogoView()
        self.kickContentOutToScreen()
        
        self.topNavView.configureNavBar(title: "", isDivider: false, backgroundType: .clear)
        self.topNavView.delegate = self
    }
    
    private func addAppLogoView() {
        let view = SideMenuLogoView.instanceFromNib()
        logoView = view
        self.updateLogoMessage()
        logoView?.frame = logoContainerView.bounds
        self.logoContainerView.addSubview(logoView!)
        
    }
    
    private func updateLogoMessage() {
        
        if currentlyUsingFrom == .loginProcess {
            logoView?.messageLabel.font = AppFonts.Regular.withSize(16.0)
            logoView?.messageLabel.text = LocalizedString.EnjoyAMorePersonalisedTravelExperience.localized
            logoView?.isAppNameHidden = false
            socialButtosCenterConstraint.constant = 0.0
            socialAndLogoSpace.constant = 89.0
        }
        else {
            logoView?.messageLabel.font = AppFonts.Bold.withSize(38.0)
            logoView?.messageLabel.text = LocalizedString.PleaseSignInToContinue.localized
            logoView?.isAppNameHidden = true
            logoView?.logoImageView.image = #imageLiteral(resourceName: "logoImage")
            
            socialButtosCenterConstraint.constant = -44.0
            socialAndLogoSpace.constant = 63.0
        }
    }
    
    func setupsFonts() {
        
        if currentlyUsingFrom == .loginVerificationForCheckout {
            let finalStr = "\(LocalizedString.SkipSignIn.localized)\n\(LocalizedString.ContinueAsGuest.localized)"
            let attributedString = NSMutableAttributedString(string: finalStr, attributes: [
                .font: AppFonts.Regular.withSize(14.0),
                .foregroundColor: UIColor.black
                ])
            attributedString.addAttribute(.font, value: AppFonts.SemiBold.withSize(18.0), range: (finalStr as NSString).range(of: LocalizedString.SkipSignIn.localized))
            self.newRegisterLabel.attributedText = attributedString
        }
        else {
            let attributedString = NSMutableAttributedString(string: LocalizedString.I_am_new_register.localized, attributes: [
                .font: AppFonts.Regular.withSize(14.0),
                .foregroundColor: UIColor.black
                ])
            attributedString.addAttribute(.font, value: AppFonts.SemiBold.withSize(18.0), range: NSRange(location: 0, length: 7))
            self.newRegisterLabel.attributedText = attributedString
        }
        
        let existingUserString = NSMutableAttributedString(string: LocalizedString.Existing_User_Sign.localized, attributes: [
            .font: AppFonts.SemiBold.withSize(18.0),
            .foregroundColor: UIColor.black
            ])
        existingUserString.addAttribute(.font, value: AppFonts.Regular.withSize(14.0), range: NSRange(location: 14, length: 7))
        self.existingUserLabel.attributedText = existingUserString
    }
}

extension SocialLoginVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        if self.currentlyUsingFrom == .loginProcess {
            self.delegate?.backButtonTapped(sender)
        } else {
            AppFlowManager.default.popViewController(animated: true)
        }
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
        
        if self.currentlyUsingFrom == .loginProcess {
            AppFlowManager.default.goToDashboard()
        }
        else {
            self.sendDataChangedNotification(data: ATNotification.userLoggedInSuccess)
        }
    }
    
    func didLoginFail(errors: ErrorCodes) {
        if self.viewModel.userData.service == APIKeys.facebook.rawValue {
            self.fbButton.isLoading = false
        } else if self.viewModel.userData.service == APIKeys.google.rawValue {
            self.googleButton.isLoading = false
        } else {
            self.linkedInButton.isLoading = false
        }
    }
}

// MARK: - Extension InitialAnimation

// MARK: -

extension SocialLoginVC {

    func kickContentOutToScreen() {
        self.fbButton.transform          = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.googleButton.transform      = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.linkedInButton.transform    = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
        self.newRegistrationContainerView.transform   = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        self.sepratorLineImage.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
        
        self.fbButton.alpha = 0
        self.googleButton.alpha = 0
        self.linkedInButton.alpha = 0
    }
    func animateContentOnLoad() {
        self.kickContentOutToScreen()
        let rDuration = 1.0 / 4.0
        
        UIView.animateKeyframes(withDuration: AppConstants.kAnimationDuration, delay: 0.0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: (rDuration * 1.0), animations: {
                
                self.fbButton.transform = .identity
                self.fbButton.alpha = 1.0
                
            })
            UIView.addKeyframe(withRelativeStartTime: (rDuration * 1.0), relativeDuration: (rDuration * 2.0), animations: {
                
                self.googleButton.transform = .identity
                self.googleButton.alpha = 1.0
                
            })
            UIView.addKeyframe(withRelativeStartTime: (rDuration * 2.0), relativeDuration: (rDuration * 3.0), animations: {
                
                self.newRegistrationContainerView.transform    = .identity
                
                self.sepratorLineImage.transform  = .identity
                
            })
            UIView.addKeyframe(withRelativeStartTime: (rDuration * 3.0), relativeDuration: (rDuration * 4.0), animations: {
                
                self.linkedInButton.transform     = .identity
                
                self.linkedInButton.alpha = 1.0
                
            })
        }) { (success) in
            
            self.viewModel.isFirstTime = false
            
            
            
        }
    }
    
    func animateContentOnPop() {
       
        let rDuration = 1.0 / 4.0
        UIView.animateKeyframes(withDuration: AppConstants.kAnimationDuration, delay: 0.0, options: .calculationModeLinear, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: (rDuration * 1.0), animations: {
                self.newRegistrationContainerView.transform    = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
                self.linkedInButton.transform     = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
                self.linkedInButton.alpha = 0.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: (rDuration * 1.0), relativeDuration: (rDuration * 2.0)) {
                self.sepratorLineImage.transform  = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height)
            }
            
            UIView.addKeyframe(withRelativeStartTime: (rDuration * 2.0), relativeDuration: (rDuration * 3.0), animations: {
                self.googleButton.transform = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
                self.googleButton.alpha = 0.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: (rDuration * 3.0), relativeDuration: (rDuration * 4.0), animations: {
                self.fbButton.transform = CGAffineTransform(translationX: UIDevice.screenWidth, y: 0)
                self.fbButton.alpha = 0.0
            })
            
        }) { (success) in
            self.viewModel.isFirstTime = true
        }
    }
}
