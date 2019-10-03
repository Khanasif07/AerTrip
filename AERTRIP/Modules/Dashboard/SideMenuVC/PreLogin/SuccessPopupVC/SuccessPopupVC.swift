//
//  SuccessPopupVC.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 07/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class SuccessPopupVC: BaseVC {
    
    //MARK:- Properties
    //MARK:-
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var successfullLabel: UILabel!
    @IBOutlet weak var centerImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginButton: ATButton!
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.loginButton.layer.cornerRadius = self.loginButton.height/2
        self.loginButton.layer.masksToBounds = true
    }
    
    
    override func setupFonts() {
        
        self.successfullLabel.font  = AppFonts.Bold.withSize(38)
        self.titleLabel.font        = AppFonts.Regular.withSize(16)
        self.loginButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .normal)
        self.loginButton.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .selected)

        
    }
    
    override func setupTexts() {
        
        self.successfullLabel.text = LocalizedString.Successful.localized
        self.titleLabel.text = LocalizedString.Your_password_has_been_reset_successfully.localized
        self.loginButton.setTitle(LocalizedString.Login.localized, for: .normal)
    }
    
    override func setupColors() {
        
        self.successfullLabel.textColor  = AppColors.themeBlack
        self.titleLabel.textColor  = AppColors.themeBlack
    }
    //MARK:- IBOutlets
    //MARK:-
    @IBAction func loginButtonAction(_ sender: ATButton) {
        
        self.view.endEditing(true)
        UIView.animate(withDuration: AppConstants.kAnimationDuration) {
            
            AppFlowManager.default.moveToLoginVC(email: "")
        }
    }
}

//MARK:- Extension Initialsetups
//MARK:-
private extension SuccessPopupVC {
    
    func initialSetups() {
        self.view.backgroundColor = AppColors.screensBackground.color
    }
}
