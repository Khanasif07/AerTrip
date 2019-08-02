//
//  SideMenuProfileImageCell.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 14/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class SideMenuProfileImageCell: UITableViewCell {


    @IBOutlet weak var profileSuperView: UIView!
    @IBOutlet weak var viewProfileButton: UIButton!
    @IBOutlet weak var sepratorView: ATDividerView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initialSetups()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.layer.cornerRadius = profileImageView.height / 2.0
        profileImageView.layer.borderWidth = 3.0
        profileImageView.layer.borderColor = AppColors.themeGray20.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK:- Extension Setup Text
//MARK:-
extension SideMenuProfileImageCell {
    
    private func initialSetups() {
        self.viewProfileButton.titleLabel?.font = AppFonts.Regular.withSize(14)
        self.viewProfileButton.titleLabel?.textColor = AppColors.themeGreen
        self.viewProfileButton.setTitle(LocalizedString.ViewProfile.localized, for: .normal)
        
        profileNameLabel.font = AppFonts.Regular.withSize(20.0)
        profileNameLabel.text = "\(UserInfo.loggedInUser?.firstName ?? LocalizedString.na.localized ) \(UserInfo.loggedInUser?.lastName ?? LocalizedString.na.localized )"
        
        if let imagePath = UserInfo.loggedInUser?.profileImage, !imagePath.isEmpty {
            profileImageView.setImageWithUrl(imagePath, placeholder: UserInfo.loggedInUser?.profileImagePlaceholder() ?? UIImage(), showIndicator: false)
        }
        else {
            profileImageView.image = UserInfo.loggedInUser?.profileImagePlaceholder()
        }
    }
}
