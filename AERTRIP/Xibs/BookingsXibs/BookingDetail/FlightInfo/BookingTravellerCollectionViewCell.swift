//
//  BookingTravellerCollectionViewCell.swift
//  AERTRIP
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingTravellerCollectionViewCell: UICollectionViewCell {
    
    // MARK: -  IBOutlet
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var travellerNameLabel: UILabel!
    @IBOutlet weak var bottomSlideView: UIView!
    
    var paxData: Pax? {
        didSet {
            self.configureCell()
        }
    }
    
    var isPaxSelected: Bool = false {
        didSet {
            self.updateSelection()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        self.setUpTextColor()
        self.setUpFont()
        self.doInitialSetup()
        self.profileImageView.cornerRadius = self.profileImageView.height / 2.0
    }
    
    private func doInitialSetup() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
            self.profileImageView.layer.masksToBounds = true
    }
    
    private func setUpFont() {
        self.travellerNameLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
    private func setUpTextColor() {
        self.travellerNameLabel.textColor = AppColors.themeBlack
        self.bottomSlideView.backgroundColor = AppColors.themeGreen
    }
    
    private func updateSelection() {
        self.bottomSlideView.isHidden = !self.isPaxSelected
    }
    
    private func configureCell() {
        self.travellerNameLabel.text = self.paxData?.fullName ?? ""
        self.profileImageView.image = self.paxData?.salutationImage ?? #imageLiteral(resourceName: "boy")
    }

}
