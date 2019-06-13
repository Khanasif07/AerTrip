//
//  TravellersPnrStatusTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 29/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class TravellersPnrStatusTableViewCell: UITableViewCell {
    enum PNRStatus {
        case active, pending, cancelled, rescheduled
    }
    
    // MARK: - Variables
    
    // MARK: ===========
    
    var pnrStatus: PNRStatus = .active
    
    // MARK: - IBOutlets
    
    // MARK: ===========
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var travellerImageView: UIImageView!
    @IBOutlet var travellerNameLabel: UILabel!
    @IBOutlet var travellerPnrStatusLabel: UILabel!
    @IBOutlet var nameDividerView: UIView!
    @IBOutlet var travellerImgViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var containerViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - LifeCycle
    
    // MARK: ===========
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    // MARK: - Functions
    
    // MARK: ===========
    
    private func configUI() {
        // Font
        self.travellerNameLabel.font = AppFonts.Regular.withSize(16.0)
        self.travellerPnrStatusLabel.font = AppFonts.Regular.withSize(16.0)
        
        // Color
        self.travellerNameLabel.textColor = AppColors.themeBlack
        self.travellerPnrStatusLabel.textColor = AppColors.themeBlack
        self.travellerImageView.makeCircular()
        self.nameDividerView.isHidden = true
        self.nameDividerView.backgroundColor = AppColors.themeGray40
        
//        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
    }
    
    internal func configCell(travellersImage: String, travellerName: String, travellerPnrStatus: String, firstName: String, lastName: String, isLastTraveller: Bool) {
        if !travellersImage.isEmpty {
            self.travellerImageView.setImageWithUrl(travellersImage, placeholder: #imageLiteral(resourceName: "profilePlaceholder"), showIndicator: true)
        } else {
            self.travellerImageView.makeCircular(borderWidth: 1.0, borderColor: AppColors.themeGray04)
            self.travellerImageView.image = AppGlobals.shared.getImageFor(firstName: firstName, lastName: lastName, font: AppFonts.Regular.withSize(35.0))
        }
        
        self.travellerNameLabel.text = travellerName
        self.travellerPnrStatusLabel.text = travellerPnrStatus
        self.nameDividerView.isHidden = true
        self.travellerPnrStatusLabel.text = travellerPnrStatus
        switch self.pnrStatus {
        case .active:
            self.travellerPnrStatusLabel.textColor = AppColors.themeBlack
        case .cancelled, .rescheduled:
            self.travellerImageView.applyGaussianBlurEffect(image: self.travellerImageView.image ?? #imageLiteral(resourceName: "profilePlaceholder"))
            self.travellerImageView.makeCircular()
            self.travellerNameLabel.textColor = AppColors.themeGray40
            self.nameDividerView.isHidden = false
            self.travellerPnrStatusLabel.textColor = AppColors.themeRed
        case .pending:
            self.travellerPnrStatusLabel.textColor = AppColors.themeGray40
        }
        self.travellerImgViewBottomConstraint.constant = isLastTraveller ? 16.0 : 4.0
        self.containerViewBottomConstraint.constant = isLastTraveller ? 21.0 : 0.0
        self.lastCellShadowSetUp(isLastCell: isLastTraveller)
    }
    
    private func lastCellShadowSetUp(isLastCell: Bool) {
        if isLastCell {
//            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner ,.layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
        } else {
//            self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
            self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
        }
    }
    
    // MARK: - IBActions
    
    // MARK: ===========
}

// MARK: - Extensions

// MARK: ============