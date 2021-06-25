//
//  BookingAmenityCollectionViewCell.swift
//  AERTRIP
//
//  Created by apple on 13/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingAmenityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var amenityImageView: UIImageView!
    @IBOutlet weak var amenityTitle: UILabel!
    
    var amenity: ATAmenity? {
        didSet {
            self.configureCell()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
     
        self.amenityTitle.font = AppFonts.Regular.withSize(14.0)
        self.amenityTitle.textColor = AppColors.themeGray60
    }
    
    private func configureCell() {
        self.backgroundColor = AppColors.themeBlack26
        self.amenityImageView.image = amenity?.icon
        self.amenityTitle.text = amenity?.title
    }
}
