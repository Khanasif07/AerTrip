//
//  AerinTextSpeechVC.swift
//  AERTRIP
//
//  Created by apple on 22/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AerinTextSpeechVC: BaseVC {
    
    
    //MARK: - IB Outlets
    //MARK
    
    
    @IBOutlet weak var topNavigationView: TopNavigationView!
    @IBOutlet weak var aerinLogoImageView: UIImageView!
    @IBOutlet weak var aerinTitleLabel: UILabel!

    
    
    
    //MARK: - IB Properties
    

    //MARK: - View Life Cycle
  
    
    
    //MARK: - Override methods
    override func initialSetup() {
        self.setupTexts()
        self.setupFonts()
        self.setupColors()
        self.configureNavigationBar()
    }
    
    override func setupTexts() {
        if let user = UserInfo.loggedInUser {
            // user is logged in
            let totalText = LocalizedString.Hi.localized + ", " + user.firstName  + LocalizedString.HelpMessage.localized
            self.aerinTitleLabel.attributedText  = self.getAttributedBoldText(text: totalText, boldText:user.firstName + "\n")
        } else {
            let totalText = LocalizedString.Hi.localized + "," + "Guest" + "\n" + LocalizedString.HelpMessage.localized
            self.aerinTitleLabel.attributedText  = self.getAttributedBoldText(text: totalText, boldText:"Guest" )
        }
    }
    
    override func setupFonts() {
        self.aerinTitleLabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupColors() {
        self.aerinTitleLabel.textColor = AppColors.themeTextColor
    }
    
  
    
    //MARK: - IBAction
    
    @IBAction func keyboardButtonTapped(_ sender: Any) {
    }
    

    
    @IBAction func infoButtonTapped(_ sender: Any) {
        AppFlowManager.default.moveToAerinTextSpeechDetailVC()
    }
    
    
    
    //MARK: - Helper methods
    private func getAttributedBoldText(text: String, boldText: String) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(28.0), .foregroundColor: AppColors.themeBlack])
        
        attString.addAttributes([
            .font: AppFonts.Regular.withSize(28.0),
            .foregroundColor: AppColors.themeGreen
            ], range:(text as NSString).range(of: boldText))
        return attString
    }
    
    
    private func configureNavigationBar() {
        self.topNavigationView.configureNavBar(title: "", isDivider: false)
        self.topNavigationView.delegate = self
    }

}

// MARK: - TopNavigationViewDelegate

extension AerinTextSpeechVC : TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    
}
