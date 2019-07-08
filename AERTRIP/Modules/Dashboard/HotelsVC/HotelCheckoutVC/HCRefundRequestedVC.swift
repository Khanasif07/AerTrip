//
//  HCRefundRequestedVC.swift
//  AERTRIP
//
//  Created by Admin on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HCRefundRequestedVC: BaseVC {
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var topNavView: TopNavigationView!
    @IBOutlet weak var tickButton: ATButton!
    @IBOutlet weak var requestedTextLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var goToHomeButton: ATButton!
    
    
    //MARK:- Properties
    //MARK:- Public
    
    //MARK:- Private
    private var paymentMethod = "{payment method}"
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.statusBarStyle = .default
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tickButton.layer.cornerRadius = tickButton.height / 2
    }
    
    override func initialSetup() {
        topNavView.configureNavBar(title: nil, isLeftButton: false, isFirstRightButton: false, isSecondRightButton: false, isDivider: false)
    }
    
    override func setupFonts() {
        requestedTextLabel.font = AppFonts.Bold.withSize(31.0)
        
        messageLabel.font = AppFonts.Regular.withSize(16.0)
        
        goToHomeButton.titleLabel?.font = AppFonts.SemiBold.withSize(20.0)
    }
    
    override func setupTexts() {
        requestedTextLabel.text = LocalizedString.Requested.localized
        
        tickButton.setTitle(nil, for: .normal)
        
        let messageText = "\(LocalizedString.WeNotedYourRequestToRefund.localized) \(2000.0.amountInDelimeterWithSymbol) \(LocalizedString.ToYour.localized) \(paymentMethod)"
        
        let attrMessageText = NSMutableAttributedString(string: messageText)
        attrMessageText.addAttributes([NSAttributedString.Key.font: AppFonts.SemiBold.withSize(18.0)], range: (messageText as NSString).range(of: "\(2000.0.amountInDelimeterWithSymbol)"))
        attrMessageText.addAttributes([NSAttributedString.Key.font: AppFonts.SemiBold.withSize(18.0)], range: (messageText as NSString).range(of: "\(paymentMethod)"))
        
        messageLabel.attributedText = attrMessageText
        
        goToHomeButton.setTitle(LocalizedString.ReturnHome.localized, for: .normal)
    }
    
    override func setupColors() {
        tickButton.setImage(#imageLiteral(resourceName: "Checkmark"), for: .normal)
        
        requestedTextLabel.textColor = AppColors.themeBlack

        goToHomeButton.setTitleColor(AppColors.themeWhite, for: .normal)
    }
    
    //MARK:- Methods
    //MARK:- Private
    
    
    //MARK:- Public
    
    
    //MARK:- Action
    @IBAction func goToHomeButtonAction(_ sender: ATButton) {
        AppFlowManager.default.popViewController(animated: true)
    }
}
