//
//  HCSocialShareTripTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 08/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol HCSocialShareTripTableViewCellDelegate: class {
    func shareOnFaceBook()
    func shareOnTwitter()
    func shareOnLinkdIn()
}

class HCSocialShareTripTableViewCell: UITableViewCell {
    
    internal weak var delegate: HCSocialShareTripTableViewCellDelegate?
    
    @IBOutlet weak var icTicketUp: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tellYourPlanLabel: UILabel!
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var linkdInButton: UIButton!
    
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    //Mark:- Methods
    //==============
    ///COnfigure UI
    private func configUI() {
        //UI
        self.containerView.backgroundColor = AppColors.screensBackground.color
        self.fbButton.addShadow(cornerRadius: self.fbButton.frame.size.height / 2.0, maskedCorners: [.layerMinXMaxYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner,.layerMinXMinYCorner], color: AppColors.fbButtonBackgroundColor.withAlphaComponent(0.3), offset: CGSize.init(width: 0.0, height: 3.0), opacity: 1.0, shadowRadius: 5.0)
        self.twitterButton.addShadow(cornerRadius: self.fbButton.frame.size.height / 2.0, maskedCorners: [.layerMinXMaxYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner,.layerMinXMinYCorner], color: AppColors.twitterBackgroundColor.withAlphaComponent(0.3), offset: CGSize.init(width: 0.0, height: 3.0), opacity: 1.0, shadowRadius: 5.0)
        self.linkdInButton.addShadow(cornerRadius: self.fbButton.frame.size.height / 2.0, maskedCorners: [.layerMinXMaxYCorner,.layerMaxXMinYCorner,.layerMaxXMaxYCorner,.layerMinXMinYCorner], color: AppColors.linkedinButtonBackgroundColor.withAlphaComponent(0.3), offset: CGSize.init(width: 0.0, height: 3.0), opacity: 1.0, shadowRadius: 5.0)
        //Image
        self.fbButton.setImage(AppImages.fbIconWhite.withRenderingMode(.alwaysTemplate), for: .normal)
        self.fbButton.tintColor = AppColors.themeWhite
        self.twitterButton.setImage(AppImages.twiterIcon.withRenderingMode(.alwaysTemplate), for: .normal)
        self.twitterButton.tintColor = AppColors.themeWhite
        self.linkdInButton.setImage(AppImages.linkedInLogoImage, for: .normal)
        //Font
        self.tellYourPlanLabel.font = AppFonts.Regular.withSize(16.0)
        //Text
        self.tellYourPlanLabel.text = LocalizedString.TellYourFriendsAboutYourPlan.localized
        //Color
        self.tellYourPlanLabel.textColor = AppColors.themeGray40
        self.fbButton.backgroundColor = AppColors.fbButtonBackgroundColor
        self.twitterButton.backgroundColor = AppColors.twitterBackgroundColor
        self.linkdInButton.backgroundColor = AppColors.linkedinButtonBackgroundColor
    }
    
    //Mark:- IBActions
    //================
    @IBAction func fbButtonAction(_ sender: UIButton) {
        self.delegate?.shareOnFaceBook()
    }
    
    @IBAction func twitterButtonAction(_ sender: UIButton) {
        self.delegate?.shareOnTwitter()
    }
    
    @IBAction func linkedInButtonAction(_ sender: UIButton) {
        self.delegate?.shareOnLinkdIn()
    }
}
