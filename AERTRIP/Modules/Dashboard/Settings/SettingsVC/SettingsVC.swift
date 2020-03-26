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
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var copyRightLabel: UILabel!
    @IBOutlet weak var madeWithLabel: UILabel!
    
    //MARK:- Properties
    let settingsVm = SettingsVM()
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initialSetups()
    }
    
    override func setupFonts() {
        self.appVersionLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupTexts() {
        self.appVersionLabel.text = "Build Version N/A"
        self.appVersionLabel.isHidden = true
        if let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String, let bundelVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as? String {
            self.appVersionLabel.text = "Build Version \(appVersion) (\(bundelVersion))"
        }
    }
    

    override func setupColors() {
        self.appVersionLabel.textColor = AppColors.themeBlack
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.Settings.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false)
        configureTableView()
    }
    
    func setUpViewAttributes(){
        self.madeWithLabel.font = AppFonts.Regular.withSize(16)
        self.copyRightLabel.font = AppFonts.Regular.withSize(14)
        self.versionLabel.font = AppFonts.Regular.withSize(14)
        self.copyRightLabel.textColor = AppColors.themeGray40
        self.versionLabel.textColor = AppColors.themeGray40
    }
    
    private func configureTableView(){
        self.settingsTableView.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
        self.settingsTableView.dataSource = self
        self.settingsTableView.delegate = self
    }
    
    //MARK:- Public
    
    
    //MARK:- Action
}

extension SettingsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}
