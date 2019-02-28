//
//  HotelMailComposerCardViewTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 28/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelMailComposerCardViewTableViewCell: UITableViewCell {

    // MARK: - IB Outlets
    @IBOutlet weak var hotelCardImageView: UIImageView!
    @IBOutlet weak var hotelNameLabel: UILabel!
    @IBOutlet weak var hotelPriceLabel: UILabel!
    @IBOutlet weak var starRatingView: FloatRatingView!
    @IBOutlet weak var tripRatingView: FloatRatingView!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.doIntitialSetup()
        self.setUpColors()
       
    }
    
    // MARK: - Helper methods
    
    private func  doIntitialSetup() {
        self.hotelNameLabel.font = AppFonts.SemiBold.withSize(22.0)
        self.hotelPriceLabel.font = AppFonts.SemiBold.withSize(22.0)
        self.addressLabel.font = AppFonts.Regular.withSize(18.0)
        
        
    }
    
    private func setUpColors() {
        self.hotelNameLabel.textColor = AppColors.themeBlack
        self.hotelPriceLabel.textColor = AppColors.themeBlack
        self.addressLabel.textColor = AppColors.themeBlack
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
