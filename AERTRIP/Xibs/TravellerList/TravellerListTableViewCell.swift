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
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var separatorView: UIView!
    @IBOutlet var selectTravellerButton: UIButton!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var travellerData: TravellerData? {
        didSet {
            configureCell()
        }
    }
    
    // MARK: - Helper methods
    
    private func configureCell() {
        profileImageView.image = travellerData?.salutationImage
        if let firstName = travellerData?.firstName, let lastName = travellerData?.lastName,let salutation = travellerData?.salutation {
            
            if UserInfo.loggedInUser?.generalPref?.displayOrder == "LF" {
                let boldText = (UserInfo.loggedInUser?.generalPref?.sortOrder == "LF") ? "\(lastName)" : "\(firstName)"
                userNameLabel.attributedText = self.getAttributedBoldText(text: "\(salutation) \(lastName) \(firstName)", boldText: boldText)
                
            } else {
                let boldText = (UserInfo.loggedInUser?.generalPref?.sortOrder == "LF") ? "\(lastName)" : "\(firstName)"
                userNameLabel.attributedText = self.getAttributedBoldText(text: "\(salutation) \(firstName) \(lastName)", boldText: boldText)
            }
        }
    }
    
    private func getAttributedBoldText(text: String, boldText: String) -> NSMutableAttributedString {
        let attString: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: AppFonts.Regular.withSize(18.0), .foregroundColor: UIColor.black])
        
        attString.addAttribute(.font, value: AppFonts.SemiBold.withSize(18.0), range: (text as NSString).range(of: boldText))
        return attString
    }
}
