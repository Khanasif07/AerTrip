//
//  AccountDetailsVC.swift
//  AERTRIP
//
//  Created by Admin on 12/01/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import UIKit

class UserAccountDetailsVC : BaseVC {
    
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var accountDetailsTableView: UITableView!
    
    let viewModel = UserAccountDetailsVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initialSetups()
        self.viewModel.getProfilData()
    }
    
    override func setupFonts() {

    }
    
    override func setupColors() {
       
    }

    override func setupTexts() {
    
    }
        
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        self.topNavView.delegate = self
        self.topNavView.configureNavBar(title: LocalizedString.Account_Details.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false,isDivider : true)
        configureTableView()
        self.accountDetailsTableView.backgroundColor = AppColors.themeGray04
        self.accountDetailsTableView.contentInset = UIEdgeInsets(top: topNavView.height, left: 0, bottom: 0, right: 0)
    
    }
    
    private func configureTableView(){
        self.accountDetailsTableView.register(UINib(nibName: "UserAccountDetailsCell", bundle: nil), forCellReuseIdentifier: "UserAccountDetailsCell")
        self.accountDetailsTableView.register(UINib(nibName: "SettingsHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SettingsHeaderView")
        self.accountDetailsTableView.separatorStyle = .none
        self.accountDetailsTableView.rowHeight = UITableView.automaticDimension
        self.accountDetailsTableView.estimatedRowHeight = 44
        self.accountDetailsTableView.dataSource = self
        self.accountDetailsTableView.delegate = self
    }
    
}


extension UserAccountDetailsVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}
