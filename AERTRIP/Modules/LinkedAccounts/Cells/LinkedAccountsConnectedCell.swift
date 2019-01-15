//
//  LinkedAccountsConnectedCell.swift
//  AERTRIP
//
//  Created by Admin on 15/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class LinkedAccountsTableCell: UITableViewCell {

    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var socialTypeLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var disconnectButton: UIButton!
    
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
            self.delegate?.disConnect(forType: type)
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
        
        self.disconnectButton.setTitleColor(AppColors.themeRed, for: .normal)
        self.disconnectButton.setTitleColor(AppColors.themeGray20, for: .disabled)
        
        self.disconnectButton.titleLabel?.font = AppFonts.Regular.withSize(18.0)
        self.disconnectButton.addTarget(self, action: #selector(disconnectButtonAction(_:)), for: .touchUpInside)
    }
    
    private func configureData() {
        func socialType() -> String {
            if let type = self.linkedAccount?.socialType {
                switch type {
                    
                case .facebook:
                    return LocalizedString.Facebook.localized
                    
                case .google:
                    return LocalizedString.Google.localized
                    
                case .linkedIn:
                    return LocalizedString.LinkedIn.localized
                    
                default:
                    return ""
                }
            }
            return ""
        }
        
        self.emailLabel.text = self.linkedAccount?.email
        self.socialTypeLabel.text = socialType()
    }
}
