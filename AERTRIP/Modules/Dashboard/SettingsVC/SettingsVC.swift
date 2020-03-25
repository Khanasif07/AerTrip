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
