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
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var travellerProfileImage: UIImageView!
    @IBOutlet weak var travellerName: UILabel!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var travellerImgViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
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
    
    internal func configCell(travellersImage: String, travellerName: String,firstName: String,lastName: String, isLastTravellerInRoom: Bool, isLastTraveller: Bool, isOtherBookingData: Bool = false) {
        self.travellerName.text = travellerName
        self.travellerImgViewBottomConstraint.constant = (isLastTraveller || isLastTravellerInRoom) ? 16.0 : 4.0
        self.containerViewBottomConstraint.constant = isLastTraveller ? 26.0 : 0.0
        if !isOtherBookingData {
            self.lastCellShadowSetUp(isLastCell: isLastTraveller)
        }
        if !travellersImage.isEmpty {
            self.travellerProfileImage.setImageWithUrl(travellersImage, placeholder: #imageLiteral(resourceName: "profilePlaceholder"), showIndicator: true)
        } else {
            self.travellerProfileImage.makeCircular(borderWidth: 1.0, borderColor: AppColors.themeGray04)
            self.travellerProfileImage.image = AppGlobals.shared.getImageFor(firstName: firstName, lastName: lastName, font: AppFonts.Regular.withSize(35.0))
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
