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
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var centerTitleLabel: UILabel!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var linkedInButton: UIButton!
    @IBOutlet weak var newRegisterLabel: UILabel!
    @IBOutlet weak var existingUserLabel: UILabel!
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initialSetups()
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
    
    //MARK:- IBActions
    //MARK:-
    @IBAction func fbLoginButtonAction(_ sender: UIButton) {
        
        self.viewModel.fbLogin(vc: self)
    }
    
    @IBAction func googleLoginButtonAction(_ sender: UIButton) {
        
        self.viewModel.googleLogin(vc: self)
    }
    
    @IBAction func linkedInLoginButtonAction(_ sender: UIButton) {
        
        self.viewModel.linkedLogin(vc: self)
    }
    
    @IBAction func newRegistrationButtonAction(_ sender: UIButton) {
        
        AppFlowManager.default.moveToCreateYourAccountVC()
    }
    
    @IBAction func existingUserButtonAction(_ sender: UIButton) {
        
        AppFlowManager.default.moveToLoginVC()
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
        
        self.centerTitleLabel.font = AppFonts.Regular.withSize(16)
        self.centerTitleLabel.textColor = AppColors.themeBlack
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
