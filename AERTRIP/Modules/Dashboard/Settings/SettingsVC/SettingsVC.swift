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
        self.madeWithLabel.font = AppFonts.Regular.withSize(16)
        self.copyRightLabel.font = AppFonts.Regular.withSize(14)
        self.versionLabel.font = AppFonts.Regular.withSize(14)
    }
    
    override func setupColors() {
        self.copyRightLabel.textColor = AppColors.themeGray40
        self.versionLabel.textColor = AppColors.themeGray40
    }

    override func setupTexts() {
        self.copyRightLabel.text = LocalizedString.Copyright2018AllRightsReserved.localized.replacingOccurrences(of: "2018", with: "\(Date().year)")
        self.versionLabel.text = self.settingsVm.getVersion()
    }
        
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.Settings.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false,isDivider : true)
        configureTableView()
        self.settingsTableView.backgroundColor = AppColors.themeGray04
    }
    
    private func configureTableView(){
        self.settingsTableView.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
        self.settingsTableView.register(UINib(nibName: "SettingsHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SettingsHeaderView")
        self.settingsTableView.dataSource = self
        self.settingsTableView.delegate = self
    }
}

extension SettingsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}
