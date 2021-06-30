//
//  NotificationSettingsVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 26/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

struct ToggleSettings {
    
    var calenderSyncSettings = false
    var allNotificationS = false
    var bookingNotifications = false
    var tripEventsNotifications = false
    var otherNotifications = false
    
}

var toggleSettings = ToggleSettings()

//MARK:- Above structure and a variable is just to manage ui because api's are in progress

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
            self.view.backgroundColor = AppColors.themeBlack
            self.notificationSettingsTableView.backgroundColor = AppColors.themeGray04
        }
        
        //MARK:- Methods
        //MARK:- Private
        private func initialSetups() {
            self.topNavView.delegate = self
            self.topNavView.configureNavBar(title: LocalizedString.Notifications.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: true)
            configureTableView()
            setUpViewAttributes()
            self.notificationSettingsTableView.contentInset = UIEdgeInsets(top: topNavView.height , left: 0, bottom: 0, right: 0)

        }
        
        func setUpViewAttributes(){
            
        }
        
        private func configureTableView(){
            self.notificationSettingsTableView.register(UINib(nibName: "NotificationSettingsCell", bundle: nil), forCellReuseIdentifier: "NotificationSettingsCell")
            self.notificationSettingsTableView.register(UINib(nibName: "SettingsHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "SettingsHeaderView")
            self.notificationSettingsTableView.dataSource = self
            self.notificationSettingsTableView.delegate = self
        }
    }

    extension NotificationSettingsVC: TopNavigationViewDelegate {
        func topNavBarLeftButtonAction(_ sender: UIButton) {
            AppFlowManager.default.popViewController(animated: true)
        }
    }
