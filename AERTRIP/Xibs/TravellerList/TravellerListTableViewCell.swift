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
                if UserInfo.loggedInUser?.generalPref?.sortOrder == "LF" {
                    let attributedString = NSMutableAttributedString(string: "\(salutation) \(lastName) \(firstName)", attributes: [
                        .font: UIFont(name: "SourceSansPro-Regular", size: 18.0)!,
                        .foregroundColor: UIColor.black
                    ])
                    attributedString.addAttribute(.font, value: UIFont(name: "SourceSansPro-Semibold", size: 18.0)!, range: NSRange(location: salutation.count + 1, length: lastName.count))
                    userNameLabel.attributedText = attributedString
                } else {
                    let attributedString = NSMutableAttributedString(string: "\(salutation) \(lastName) \(firstName)", attributes: [
                        .font: UIFont(name: "SourceSansPro-Regular", size: 18.0)!,
                        .foregroundColor: UIColor.black
                    ])
                    attributedString.addAttribute(.font, value: UIFont(name: "SourceSansPro-Semibold", size: 18.0)!, range: NSRange(location: salutation.count + 1, length: lastName.count))
                    userNameLabel.attributedText = attributedString
                }
                
            } else {
                if UserInfo.loggedInUser?.generalPref?.sortOrder == "LF" {
                    let attributedString = NSMutableAttributedString(string: "\(salutation) \(firstName) \(lastName)", attributes: [
                        .font: UIFont(name: "SourceSansPro-Regular", size: 18.0)!,
                        .foregroundColor: UIColor.black
                    ])
                    attributedString.addAttribute(.font, value: UIFont(name: "SourceSansPro-Semibold", size: 18.0)!, range: NSRange(location: salutation.count + 1, length: firstName.count))
                    userNameLabel.attributedText = attributedString
                } else {
                    let attributedString = NSMutableAttributedString(string: "\(salutation) \(firstName) \(lastName)", attributes: [
                        .font: UIFont(name: "SourceSansPro-Regular", size: 18.0)!,
                        .foregroundColor: UIColor.black
                    ])
                    attributedString.addAttribute(.font, value: UIFont(name: "SourceSansPro-Semibold", size: 18.0)!, range: NSRange(location: firstName.count + 1, length: lastName.count))
                    userNameLabel.attributedText = attributedString
                }
            }
        }
    }
}
