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
    
    var travellerData: TravellerData? {
        didSet {
            self.configureCell()
        }
    }
    
    // MARK: - Helper methods
    
    private func configureCell() {
        profileImageView.image = travellerData?.salutationImage
        userNameLabel.text = travellerData?.firstName
    }
}
