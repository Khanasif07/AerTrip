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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Helper methods
    
    func configureCell(salutation salutation: String, dob dob: String, userName userName: String) {
        switch salutation {
        case "Mrs":
            profileImageView.image = #imageLiteral(resourceName: "girl")
            break
        case "":
            profileImageView.image = #imageLiteral(resourceName: "person")
        case "Mr":
            profileImageView.image = #imageLiteral(resourceName: "boy")
        case "Mast":
            profileImageView.image = #imageLiteral(resourceName: "man")
        default:
            break
        }
        userNameLabel.text = userName
    }
}
