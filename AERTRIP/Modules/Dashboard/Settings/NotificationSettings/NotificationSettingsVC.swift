//
//  NotificationSettingsVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 26/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class NotificationSettingsVC: BaseVC {

    @IBOutlet weak var notificationSettingsTableView: UITableView!
    @IBOutlet weak var topNavView: TopNavigationView!

    let notificationSettingsVm = NotificationSettingsVM()
    
       //MARK:- ViewLifeCycle
        //MARK:-
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            self.initialSetups()
        }

        override func setupTexts() {
            super.setupTexts()
        }
        

        override func setupColors() {
            super.setupColors()
        }
        
        //MARK:- Methods
        //MARK:- Private
        private func initialSetups() {
            self.topNavView.delegate = self
            self.topNavView.configureNavBar(title: LocalizedString.Settings.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false)
            configureTableView()
            setUpViewAttributes()
        }
        
        func setUpViewAttributes(){
            
        }
        
        private func configureTableView(){
            self.notificationSettingsTableView.register(UINib(nibName: "NotificationSettingsCell", bundle: nil), forCellReuseIdentifier: "NotificationSettingsCell")
            notificationSettingsTableView.register(UINib(nibName: "SettingsHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SettingsHeaderView")
//            messageListTableView.registerHeaderFooter(with: MessageHeaderView.self)

//            notificationSettingsTableView.register(<#T##nib: UINib?##UINib?#>, forHeaderFooterViewReuseIdentifier: <#T##String#>)
            
            self.notificationSettingsTableView.dataSource = self
            self.notificationSettingsTableView.delegate = self
        }
        
        //MARK:- Public
        
        
        //MARK:- Action
    }

    extension NotificationSettingsVC: TopNavigationViewDelegate {
        func topNavBarLeftButtonAction(_ sender: UIButton) {
            AppFlowManager.default.popViewController(animated: true)
        }
    }
