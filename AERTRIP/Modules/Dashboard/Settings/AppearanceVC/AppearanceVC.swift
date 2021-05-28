//
//  AppearanceVC.swift
//  AERTRIP
//
//  Created by Rishabh on 27/05/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import UIKit

enum AppTheme: String {
    case light = "light"
    case dark = "dark"
    case system = "system"
}

class AppearanceVC: BaseVC {

    // MARK: Variables
    let viewModel = AppearanceVM()
    
    // MARK: Outlets
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var appearanceTableView: UITableView!
    
    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: Actions
    
    
    
    // MARK: Functions
    
    override func initialSetup() {
        self.topNavView.delegate = self
        topNavView.backgroundColor = AppColors.themeWhite
        self.topNavView.configureNavBar(title: LocalizedString.Appearance.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false,isDivider : true)
        configureTableView()
        self.appearanceTableView.backgroundColor = AppColors.themeGray04
    }
    
    private func configureTableView(){
        self.appearanceTableView.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "CountryCell")
        self.appearanceTableView.register(UINib(nibName: "SettingsHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SettingsHeaderView")
        self.appearanceTableView.dataSource = self
        self.appearanceTableView.delegate = self
    }
}

extension AppearanceVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}
