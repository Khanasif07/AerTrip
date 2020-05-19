//
//  NotificationVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 17/09/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class NotificationVC: BaseVC {

    @IBOutlet weak var topNavigation: TopNavigationView!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTiteLabel: UILabel!
    
    
    
    // MARK: - Override methods
    
    
    override func initialSetup() {
        self.configureNavBar()
    }
    
    override func setupTexts() {
        self.titleLabel.text = LocalizedString.NoNotificationYet.localized
        self.subTiteLabel.text = LocalizedString.NotificationInfo.localized
        
    }
    
    override func setupFonts() {
        self.titleLabel.font = AppFonts.Regular.withSize(22.0)
        self.subTiteLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupColors() {
        self.titleLabel.textColor = AppColors.themeBlack
        self.subTiteLabel.textColor = AppColors.themeGray60
    }
    
    
    
    // MARK: - Helper methods
    
    private func configureNavBar() {
        self.topNavigation.configureNavBar(title: LocalizedString.Notifications.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: true, backgroundType: .color(color: AppColors.themeWhite))
        self.topNavigation.delegate = self
    }
    
}



// MARK: - Top Navigation View Delegae methods

extension NotificationVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    
}
