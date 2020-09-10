//
//  AmenitiesTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 06/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AmenitiesTableViewCell: UITableViewCell {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var amenityImageView: UIImageView!
    @IBOutlet weak var amentityTitleLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    
    
    var amenitie: ATAmenity? {
        didSet {
            self.populateData()
        }
    }
    
    var eventType: ProductType? {
        didSet {
            self.populateProductType()
        }
    }
    
    
    // MARK: - View Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func populateData() {
        self.amenityImageView.image = amenitie?.icon
        self.amentityTitleLabel.text = amenitie?.title
        
        if HotelFilterVM.shared.availableAmenities.contains(amenitie?.id ?? "") {
            amentityTitleLabel.alpha = 1.0
            amenityImageView.alpha = 1.0
            statusButton.alpha = 1.0
        } else {
            amentityTitleLabel.alpha = 0.2
            amenityImageView.alpha = 0.2
            statusButton.alpha = 0.2
        }
    }
    
    
    private func populateProductType() {
        self.amenityImageView.image = eventType?.icon
        self.amentityTitleLabel.text = eventType?.title
    }
    
}
