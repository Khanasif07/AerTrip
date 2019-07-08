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
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var filterTitleLabel: UILabel!
    @IBOutlet weak var filterTextlabel: UILabel!
    
    // MARK: - Variables
    var isFromHotelResult: Bool = false
    
    //MARK: - IB Properties
    

    //MARK: - View Life Cycle
  
    
    
    //MARK: - Override methods
    override func initialSetup() {
        self.setupTexts()
        self.setupFonts()
        self.setupColors()
        self.configureNavigationBar()
        self.setupWaterWaveView()
        
        // setting view for Hotel result
        self.filterTitleLabel.isHidden = !self.isFromHotelResult
        self.closeButton.isHidden = !self.isFromHotelResult
        self.filterTextlabel.isHidden = !self.isFromHotelResult
    }
    
    override func setupTexts() {
        if self.isFromHotelResult {
            self.setUpUIForHotelResultFlow()
        } else {
            self.setUpUIForNormalFlow()
        }
    }
    
    override func setupFonts() {
        self.aerinTitleLabel.font = AppFonts.Regular.withSize(18.0)
        self.filterTitleLabel.font = AppFonts.Regular.withSize(14.0)
        self.filterTextlabel.font = AppFonts.Regular.withSize(18.0)
    }
    
    override func setupColors() {
        self.aerinTitleLabel.textColor = AppColors.themeTextColor
        self.filterTitleLabel.textColor = AppColors.themeGray60
        self.filterTextlabel.textColor = AppColors.themeBlack
    }
    
    
    // setup for Water wave View
    private func setupWaterWaveView() {
        let frame = CGRect(x: 0, y: UIDevice.screenHeight - 250, width: self.view.frame.size.width, height: 250)
        
        let waterWaveView = PKWaterWaveView(frame: frame, color: AppColors.themeGreen.withAlphaComponent(0.20))
        waterWaveView.waveHeight = 100
        waterWaveView.waveSpeed = 0.2
        waterWaveView.waveCurvature = 0.2
       
        self.view.addSubview(waterWaveView)
        self.view.bringSubviewToFront(self.bottomView)
        
        waterWaveView.start()
       
    }
    
    private func setUpUIForNormalFlow() {
        if let user = UserInfo.loggedInUser {
            // user is logged in
            let totalText = LocalizedString.Hi.localized + ", " + user.firstName  + LocalizedString.HelpMessage.localized
            self.aerinTitleLabel.attributedText  = self.getAttributedBoldText(text: totalText, boldText:user.firstName + "\n")
        } else {
            // guest user
            let totalText = LocalizedString.Hi.localized + "," + "Guest" + "\n" + LocalizedString.HelpMessage.localized
            self.aerinTitleLabel.attributedText  = self.getAttributedBoldText(text: totalText, boldText:"Guest" )
        }
    }
    
    
    private func setUpUIForHotelResultFlow() {
        self.filterTitleLabel.text = LocalizedString.TryAskingFor.localized
         let attString: NSMutableAttributedString = NSMutableAttributedString(string: LocalizedString.Listening.localized, attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(28.0), .foregroundColor: AppColors.themeTextColor.withAlphaComponent(0.54)])
        self.aerinTitleLabel.attributedText = attString
        self.filterTextlabel.text = LocalizedString.FilterText.localized
    }
  
    
    //MARK: - IBAction
    
    @IBAction func keyboardButtonTapped(_ sender: Any) {
        
    }
    

    
    @IBAction func infoButtonTapped(_ sender: Any) {
        AppFlowManager.default.moveToAerinTextSpeechDetailVC()
    }
    
    
    
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
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
        self.topNavigationView.leftButton.isHidden = isFromHotelResult
        self.topNavigationView.delegate = self
    }

}

// MARK: - TopNavigationViewDelegate

extension AerinTextSpeechVC : TopNavigationViewDelegate {
    func topNavBarLeftButtonAction(_ sender: UIButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
    
    
}
