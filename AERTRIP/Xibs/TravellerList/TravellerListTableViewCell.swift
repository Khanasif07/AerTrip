//
//  TravellerListTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 04/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class TravellerListTableViewCell: UITableViewCell {
    // MARK: - IB Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var separatorView: ATDividerView!
    @IBOutlet weak var selectTravellerButton: UIButton!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerStackView: UIStackView!
    
    
//    @IBOutlet weak var edgeToEdgeBottomSeparatorView: ATDividerView!
    
//    @IBOutlet weak var edgeToEdgeTopSeparatorView: ATDividerView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        searchedText = ""
    }
    
    var travellerData: TravellerData? {
        didSet {
            configureCell()
        }
    }
    
    var travellerModelData: TravellerModel? {
        didSet {
            configureCellForTraveller()
        }
    }
    var searchedText = ""
    
    // MARK: - Helper methods
    
    private func configureCell() {
        profileImageView.image = travellerData?.salutationImage
        if let firstName = travellerData?.firstName, let lastName = travellerData?.lastName, let salutation = travellerData?.salutation, (travellerData?.profileImage.isEmpty ?? false) {
            if UserInfo.loggedInUser?.generalPref?.displayOrder == "LF" {
                let boldText = (UserInfo.loggedInUser?.generalPref?.sortOrder == "LF") ? "\(lastName)" : "\(firstName)"
                userNameLabel.attributedText = getAttributedBoldText(text: "\(salutation) \(lastName) \(firstName)", boldText: boldText)
                
            } else {
                let boldText = (UserInfo.loggedInUser?.generalPref?.sortOrder == "LF") ? "\(lastName)" : "\(firstName)"
                userNameLabel.attributedText = getAttributedBoldText(text: "\(salutation) \(firstName) \(lastName)", boldText: boldText)
            }
        } 
        
        
    }
    
    private func configureCellForTraveller() {
        selectTravellerButton.isHidden = true
        leadingConstraint.constant = 16
        containerStackView.spacing = 16
        profileImageView.image = AppGlobals.shared.getEmojiIcon(dob: travellerModelData?.dob ?? "", salutation: travellerModelData?.salutation ?? "", dateFormatter: Date.DateFormat.yyyy_MM_dd.rawValue)
        let fullName = travellerModelData?.fullName ?? ""
        var age = ""
        if let dob = travellerModelData?.dob,!dob.isEmpty {
            age = AppGlobals.shared.getAgeLastString(dob: dob, formatter: Date.DateFormat.yyyy_MM_dd.rawValue)
            //travelName += age
        }
        self.userNameLabel.appendFixedText(text: fullName, fixedText: age)
        if !age.isEmpty {
            self.userNameLabel.AttributedFontColorForText(text: age, textColor: AppColors.themeGray40)
        }
        self.userNameLabel.AttributedFontForText(text: searchedText, textFont: AppFonts.SemiBold.withSize(18.0))
    }
    
    private func getAttributedBoldText(text: String, boldText: String) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), .foregroundColor: UIColor.black])
        
        attString.addAttribute(.font, value: AppFonts.SemiBold.withSize(18.0), range: (text as NSString).range(of: boldText))
        return attString
    }
}
