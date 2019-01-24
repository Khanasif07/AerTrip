//
//  SettingsVC.swift
//  AERTRIP
//
//  Created by Admin on 24/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class SettingsVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    
    //MARK:- Properties
    //MARK:- Public
    
    //MARK:- Private
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func setupFonts() {
        self.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.appVersionLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupTexts() {
        self.navTitleLabel.text = LocalizedString.Settings.localized
        
        self.appVersionLabel.text = "Build Version N/A"
        if let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String, let bundelVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as? String {
            self.appVersionLabel.text = "Build Version \(appVersion) (\(bundelVersion))"
        }
    }
    
    override func setupColors() {
        self.navTitleLabel.textColor = AppColors.themeBlack
        self.appVersionLabel.textColor = AppColors.themeBlack
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}
