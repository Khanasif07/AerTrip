//
//  SideMenuLogoView.swift
//  AERTRIP
//
//  Created by Admin on 31/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class SideMenuLogoView: UIView {
    
    enum UsingFor {
        case sideMenu
        case socialLogin
    }
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoTextView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var logoImageAndNameConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoImageTopContraint: NSLayoutConstraint!
    @IBOutlet weak var messageLabelTopConstraint: NSLayoutConstraint!
    
    var currentlyUsingFor = UsingFor.sideMenu {
        didSet {
            switch currentlyUsingFor {
            case .socialLogin:
                self.setupForSocialLogin()
                
            default:
                self.setupForSideMenu()
            }
        }
    }
    
    var isAppNameHidden: Bool = false {
        didSet {
            self.updateAppName()
        }
    }
    
    class func instanceFromNib() -> SideMenuLogoView {
        
        return UINib(nibName: "SideMenuLogoView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SideMenuLogoView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initialSetup()
    }
    
    private func initialSetup() {
        self.setupTextAndFont()
    }
    
    private func setupTextAndFont() {
        self.messageLabel.font = AppFonts.Regular.withSize(16.0)
        self.messageLabel.text = LocalizedString.EnjoyAMorePersonalisedTravelExperience.localized
    }
    
    private func setupForSideMenu() {
//        logoImageTopContraint.constant = 28.0
    }
    
    private func setupForSocialLogin() {
//        logoImageTopContraint.constant = 70.0
//        self.logoImageView.layoutIfNeeded()
    }
    
    private func updateAppName() {
        self.logoTextView.isHidden = self.isAppNameHidden
//        self.logoImageAndNameConstraint.constant = self.isAppNameHidden ? -22.0 : 33.0
    }
}
