//
//  QuickPayVC.swift
//  AERTRIP
//
//  Created by Appinventiv on 16/09/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

class QuickPayVC: BaseVC {
  
    @IBOutlet weak var topNavigation: TopNavigationView!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTiteLabel: UILabel!
    
    
    
    // MARK: - Override methods
    
    
    override func initialSetup() {
        self.configureNavBar()
    }
    
    override func setupTexts() {
        self.titleLabel.text = LocalizedString.ComingSoon.localized
        self.subTiteLabel.text = LocalizedString.QuickPayInfo.localized
       
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
        self.topNavigation.configureNavBar(title: LocalizedString.QuickPay.localized, isLeftButton: true, isFirstRightButton: false, isSecondRightButton: false, isDivider: false, backgroundType: .color(color: AppColors.themeWhite))
        self.topNavigation.delegate = self
    }
    
}



// MARK: - Top Navigation View Delegae methods

extension QuickPayVC: TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    
}
