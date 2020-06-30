//
//  AddonsPassangerCell.swift
//  AERTRIP
//
//  Created by Apple  on 26.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class AddonsPassangerCell: UITableViewCell {
//    enum CellUseFor {
//        case title, passenger
//    }
    
    // MARK: - Variables
    
    // MARK: ===========
    
//    var pnrStatus: PNRStatus = .active
//    var useType  = CellUseFor.title
    
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
        self.travellerImageView.makeCircular()
        self.tavellerImageBlurView.makeCircular()
        self.nameDividerView.isHidden = true
        self.nameDividerView.backgroundColor = AppColors.themeGray40

    }
    
    internal func configCell(travellersImage: String, travellerName: String, travellerPnrStatus: String, firstName: String, lastName: String, isLastTraveller: Bool,paxType: String, dob: String, salutation: String) {
        self.tavellerImageBlurView.isHidden = true
        let travelName = travellerName
        if !travellersImage.isEmpty {
            self.travellerImageView.setImageWithUrl(travellersImage, placeholder: #imageLiteral(resourceName: "profilePlaceholder"), showIndicator: true)
            self.travellerImageView.contentMode = .scaleAspectFit
        } else {
            self.travellerImageView.makeCircular(borderWidth: 1.0, borderColor: AppColors.themeGray20)

            self.travellerImageView.image = AppGlobals.shared.getEmojiIcon(dob: dob, salutation: salutation, dateFormatter: Date.DateFormat.yyyy_MM_dd.rawValue)
            self.travellerImageView.contentMode = .center
        }
        

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
//        switch self.useType {
//        case .title:
//            self.travellerPnrStatusLabel.textColor = AppColors.themeBlack
//        case .cancelled, .rescheduled:
//            self.tavellerImageBlurView.isHidden = false
//            self.travellerNameLabel.textColor = AppColors.themeGray40
//            self.travellerNameLabel.attributedText = AppGlobals.shared.getStrikeThroughText(str: travelName)
//
//            self.travellerPnrStatusLabel.textColor = AppColors.themeRed
//        case .passenger:
//            self.travellerPnrStatusLabel.textColor = AppColors.themeGray40
//        }
//        self.travellerImgViewBottomConstraint.constant = isLastTraveller ? 16.0 : 4.0
        self.containerViewBottomConstraint.constant = isLastTraveller ? 12.0 : 0.0
    }
        
    // MARK: - IBActions
    
    // MARK: ===========
}
