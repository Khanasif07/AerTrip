//
//  BookingAddOnPassengerTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 22/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingAddOnPassengerTableViewCell: ATTableViewCell {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var passengerNameLabel: UILabel!
      @IBOutlet weak var passengerImageView: UIImageView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
   
    
    override func setupFonts() {
        self.passengerNameLabel.font = AppFonts.SemiBold.withSize(18.0)
    }
    
    
    
    override func setupColors() {
        self.passengerNameLabel.textColor  = AppColors.themeBlack
    }
    
    
    func configureCell(profileImage: UIImage,passengerName:String) {
        self.passengerImageView.image = profileImage
        self.passengerNameLabel.text = passengerName
    }
    
}
