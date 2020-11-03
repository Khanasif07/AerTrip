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
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var travellerImageView: UIImageView!
    @IBOutlet weak var travellerNameLabel: UILabel!
    @IBOutlet weak var travellerPnrStatusLabel: UILabel!
    @IBOutlet weak var nameDividerView: UIView!
    @IBOutlet weak var travellerImgViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tavellerImageBlurView: UIView!
    
    // MARK: - LifeCycle
    
    // MARK: ===========
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.travellerNameLabel.attributedText = nil
    }
    // MARK: - Functions
    
    // MARK: ===========
    
    private func configUI() {
        self.containerView.layoutIfNeeded()
        // Font
        self.travellerNameLabel.font = AppFonts.Regular.withSize(16.0)
        self.travellerPnrStatusLabel.font = AppFonts.Regular.withSize(16.0)
        
        // Color
        self.travellerNameLabel.textColor = AppColors.themeBlack
        self.travellerPnrStatusLabel.textColor = AppColors.themeBlack
        //self.travellerImageView.makeCircular()
        self.tavellerImageBlurView.makeCircular()
        self.nameDividerView.isHidden = true
        self.nameDividerView.backgroundColor = AppColors.themeGray40
        self.travellerImageView.makeCircular(borderWidth: 1.0, borderColor: AppColors.themeGray20)
        
//        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
        //self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.14), offset: CGSize.zero, opacity: 0.7, shadowRadius: 5.0)
        self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
    }
    
    internal func configCell(travellersImage: String, travellerName: String, travellerPnrStatus: String, firstName: String, lastName: String, isLastTraveller: Bool,paxType: String, dob: String, salutation: String) {
        self.tavellerImageBlurView.isHidden = true
        let travelName = travellerName
        if !travellersImage.isEmpty {
            self.travellerImageView.setImageWithUrl(travellersImage, placeholder: #imageLiteral(resourceName: "profilePlaceholder"), showIndicator: false)
            self.travellerImageView.contentMode = .scaleAspectFill
        } else {
            self.travellerImageView.makeCircular(borderWidth: 1.0, borderColor: AppColors.themeGray20)
            //self.travellerImageView.image = AppGlobals.shared.getImageFor(firstName: firstName, lastName: lastName, font: AppFonts.Regular.withSize(35.0))
            self.travellerImageView.image = AppGlobals.shared.getEmojiIcon(dob: dob, salutation: salutation, dateFormatter: Date.DateFormat.yyyy_MM_dd.rawValue)
            self.travellerImageView.contentMode = .center
        }
        
        
//        if paxType == AppConstants.kChildPax {
//            travelName += " ( \(LocalizedString.Child.localized))"
//        } else if  paxType == AppConstants.kInfantPax {
//            travelName += " (\(LocalizedString.Infant.localized))"
//        }
        
        var age = ""
        if !dob.isEmpty {
            age = AppGlobals.shared.getAgeLastString(dob: dob, formatter: Date.DateFormat.yyyy_MM_dd.rawValue)
            //travelName += age
        }
       // self.travellerNameLabel.text = travelName
        self.travellerNameLabel.appendFixedText(text: travelName, fixedText: age)
        self.travellerPnrStatusLabel.text = travellerPnrStatus
        self.nameDividerView.isHidden = true
        self.travellerPnrStatusLabel.text = travellerPnrStatus
        if !age.isEmpty {
           self.travellerNameLabel.AttributedFontColorForText(text: age, textColor: AppColors.themeGray40)
        }
        switch self.pnrStatus {
        case .active:
            self.travellerPnrStatusLabel.textColor = AppColors.themeBlack
        case .cancelled, .rescheduled:
            self.tavellerImageBlurView.isHidden = false
            self.travellerNameLabel.textColor = AppColors.themeGray40
            self.travellerNameLabel.attributedText = AppGlobals.shared.getStrikeThroughText(str: travelName)
            
            self.travellerPnrStatusLabel.textColor = AppColors.themeRed
        case .pending:
            self.travellerPnrStatusLabel.textColor = AppColors.themeGray40
        }
        self.travellerImgViewBottomConstraint.constant = isLastTraveller ? 16.0 : 4.0
        self.containerViewBottomConstraint.constant = isLastTraveller ? 16 : 0.0 // 21 : 0.0
        self.lastCellShadowSetUp(isLastCell: isLastTraveller)
    }
    
    private func lastCellShadowSetUp(isLastCell: Bool) {
        if isLastCell {
//            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner ,.layerMinXMaxYCorner], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
            self.containerView.addShadow(cornerRadius: 10.0, maskedCorners: [.layerMaxXMaxYCorner, .layerMinXMaxYCorner], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
        } else {
//            self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.themeBlack.withAlphaComponent(0.4), offset: CGSize.zero, opacity: 0.7, shadowRadius: 1.5)
            self.containerView.addShadow(cornerRadius: 0.0, maskedCorners: [], color: AppColors.appShadowColor, offset: CGSize.zero, opacity: 1, shadowRadius: 4.0)
        }
    }
    
    // MARK: - IBActions
    
    // MARK: ===========
}

// MARK: - Extensions

// MARK: ============
