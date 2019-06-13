//
//  TravellersDetailsTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 04/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class TravellersDetailsTableViewCell: UITableViewCell {
    // MARK: - Variables
    
    // MARK: ===========
    
    // MARK: - IBOutlets
    
    // MARK: ===========
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var containerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var containerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var travellerProfileImage: UIImageView!
    @IBOutlet var travellerName: UILabel!
    @IBOutlet var dividerView: ATDividerView!
    @IBOutlet var travellerImgViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var containerViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - LifeCycle
    
    // MARK: ===========
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    // MARK: - Functions
    
    // MARK: ===========
    
    private func configureUI() {
        self.dividerView.isHidden = true
        self.travellerName.font = AppFonts.Regular.withSize(16.0)
        self.travellerName.textColor = AppColors.themeBlack
    }
    
    internal func configCell(imageUrl: String, travellerName: String, isLastTravellerInRoom: Bool, isLastTraveller: Bool, isOtherBookingData: Bool = false) {
        self.travellerProfileImage.setImageWithUrl(imageUrl, placeholder: #imageLiteral(resourceName: "profilePlaceholder"), showIndicator: true)
        self.travellerName.text = travellerName
        self.travellerImgViewBottomConstraint.constant = (isLastTraveller || isLastTravellerInRoom) ? 16.0 : 4.0
        self.containerViewBottomConstraint.constant = isLastTraveller ? 26.0 : 0.0
        if !isOtherBookingData {
            self.lastCellShadowSetUp(isLastCell: isLastTraveller)
        }
    }
    
    private func lastCellShadowSetUp(isLastCell: Bool) {
        if isLastCell {
            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
        } else {
            self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
        }
    }
}