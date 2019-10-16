//
//  LinkedAccountsConnectedCell.swift
//  AERTRIP
//
//  Created by Admin on 15/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol LinkedAccountsCellDelegate: class {
    func connect(_ sender: ATButton, forType: LinkedAccount.SocialType)
    func disConnect(_ sender: UIButton, forType: LinkedAccount.SocialType)
}

class LinkedAccountsTableCell: UITableViewCell {

    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var connectedContainerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var socialTypeLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var disconnectButton: UIButton!
    
    @IBOutlet weak var disConnectedContainerView: UIView!
    @IBOutlet weak var connectButton: ATButton!
    @IBOutlet weak var buttonBackgroundView: UIView!
    
    //MARK:- Properties
    //MARK:- Public
    weak var delegate: LinkedAccountsCellDelegate?
    var linkedAccount: LinkedAccount? {
        didSet {
            self.configureData()
        }
    }
    
    //MARK:- Private
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initialSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc private func disconnectButtonAction(_ sender: UIButton) {
        if let type = self.linkedAccount?.socialType {
            self.delegate?.disConnect(sender, forType: type)
        }
    }
    
    @objc private func connectButtonAction(_ sender: ATButton) {
        if let type = self.linkedAccount?.socialType {
            self.delegate?.connect(sender, forType: type)
        }
    }
    
    private func initialSetup() {
        self.selectionStyle = .none
        
        self.socialTypeLabel.font = AppFonts.Regular.withSize(20.0)
        self.socialTypeLabel.textColor = AppColors.themeBlack
        
        self.emailLabel.font = AppFonts.Regular.withSize(14.0)
        self.emailLabel.textColor = AppColors.themeGray40
        
        self.disconnectButton.setTitle(LocalizedString.Disconnect.localized, for: .normal)
        self.disconnectButton.setTitle(LocalizedString.Disconnect.localized, for: .selected)
        
       // self.disconnectButton.setTitleColor(AppColors.themeRed, for: .normal)
       // self.disconnectButton.setTitleColor(AppColors.themeGray20, for: .disabled)
        
        self.disconnectButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
        self.disconnectButton.addTarget(self, action: #selector(disconnectButtonAction(_:)), for: .touchUpInside)
        
        self.connectButton.addTarget(self, action: #selector(connectButtonAction(_:)), for: .touchUpInside)
        self.connectButton.fontForTitle = AppFonts.Regular.withSize(16.0)
    }
    
    private func configureData() {
        
        if let eid = self.linkedAccount?.eid, !eid.isEmpty {
            //setup for connected
            self.connectedContainerView.isHidden = false
            self.disConnectedContainerView.isHidden = true
            self.emailLabel.text = self.linkedAccount?.email ?? LocalizedString.na.localized
            self.socialTypeLabel.text = self.linkedAccount?.socialType.socialTitle
            self.iconImageView.image = self.linkedAccount?.socialType.socialIconImage
            if let loggedSocial = UserInfo.loggedInUser?.socialLoginType, let currentSocial = self.linkedAccount?.socialType {
                self.disconnectButton.setTitleColor( loggedSocial != currentSocial ?  AppColors.themeRed : AppColors.themeGray20, for: .normal)
            }
        }
        else {
            //setup for disConnected
            self.connectedContainerView.isHidden = true
            self.disConnectedContainerView.isHidden = false
            if let type = self.linkedAccount?.socialType {
                switch type {
                    
                case .facebook:
                    self.setupForFacobook()
                    
                case .google:
                    self.setupForGoogle()
                    
                case .linkedin:
                    self.setupForLinkedIn()
                    
                default:
                    self.connectButton.isHidden = true
                }
            }
        }
    }
    
    private func setupForFacobook() {
        self.connectButton.isHidden = false
//        self.buttonBackgroundView.addShadow(cornerRadius: self.connectButton.height/2.0, shadowColor: AppColors.themeBlack, backgroundColor: AppColors.fbButtonBackgroundColor, offset: CGSize(width: -1.0, height: 1.0))
        self.connectButton.gradientColors = [AppColors.fbButtonBackgroundColor, AppColors.fbButtonBackgroundColor]
        self.connectButton.setTitle(LocalizedString.ConnectWithFB.localized, for: .normal)
        self.connectButton.setTitle(LocalizedString.ConnectWithFB.localized, for: .selected)
        self.connectButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.connectButton.setTitleColor(AppColors.themeWhite, for: .selected)
        self.connectButton.setTitleFont(font: AppFonts.Regular.withSize(16.0), for: .normal)
        self.connectButton.setImage(#imageLiteral(resourceName: "facebook").withRenderingMode(.alwaysOriginal), for: .normal)
        self.connectButton.setImage(#imageLiteral(resourceName: "facebook").withRenderingMode(.alwaysOriginal), for: .selected)
        self.connectButton.layer.cornerRadius = self.connectButton.height / 2.0
        self.connectButton.shadowColor = AppColors.themeBlack
        self.connectButton.isSocial = true
    }
    
    private func setupForGoogle() {
        self.connectButton.isHidden = false
//        self.buttonBackgroundView.addShadow(cornerRadius: self.connectButton.height/2.0, shadowColor: AppColors.themeBlack, backgroundColor: AppColors.themeWhite, offset: CGSize(width: -1.0, height: 1.0))
        self.connectButton.gradientColors = [AppColors.themeWhite, AppColors.themeWhite]
        self.connectButton.setTitle(LocalizedString.ConnectWithGoogle.localized, for: .normal)
        self.connectButton.setTitle(LocalizedString.ConnectWithGoogle.localized, for: .selected)
        self.connectButton.setTitleColor(AppColors.themeBlack, for: .normal)
        self.connectButton.setTitleColor(AppColors.themeBlack, for: .selected)
        self.connectButton.setTitleFont(font: AppFonts.Regular.withSize(16.0), for: .normal)
        self.connectButton.setImage(#imageLiteral(resourceName: "google").withRenderingMode(.alwaysOriginal), for: .normal)
        self.connectButton.setImage(#imageLiteral(resourceName: "google").withRenderingMode(.alwaysOriginal), for: .selected)
        self.connectButton.layer.cornerRadius = self.connectButton.height / 2.0
        self.connectButton.shadowColor = AppColors.themeBlack
        self.connectButton.isSocial = true
    }
    
    private func setupForLinkedIn() {
        self.connectButton.isHidden = false
//        self.buttonBackgroundView.addShadow(cornerRadius: self.connectButton.height/2.0, shadowColor: AppColors.themeBlack, backgroundColor: AppColors.linkedinButtonBackgroundColor, offset: CGSize(width: -1.0, height: 1.0))
        self.connectButton.gradientColors = [AppColors.linkedinButtonBackgroundColor, AppColors.linkedinButtonBackgroundColor]
        self.connectButton.setTitle(LocalizedString.ConnectWithLinkedIn.localized, for: .normal)
        self.connectButton.setTitle(LocalizedString.ConnectWithLinkedIn.localized, for: .selected)
        self.connectButton.setTitleColor(AppColors.themeWhite, for: .normal)
        self.connectButton.setTitleColor(AppColors.themeWhite, for: .selected)
        self.connectButton.setTitleFont(font: AppFonts.Regular.withSize(16.0), for: .normal)
        self.connectButton.setImage(#imageLiteral(resourceName: "linkedInIcon").withRenderingMode(.alwaysOriginal), for: .normal)
        self.connectButton.setImage(#imageLiteral(resourceName: "linkedInIcon").withRenderingMode(.alwaysOriginal), for: .selected)
        self.connectButton.layer.cornerRadius = self.connectButton.height / 2.0
        self.connectButton.shadowColor = AppColors.themeBlack
        self.connectButton.isSocial = true
    }
}
