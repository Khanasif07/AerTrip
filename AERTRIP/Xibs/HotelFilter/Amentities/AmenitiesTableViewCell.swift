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
    }
    
    
    private func populateProductType() {
        self.amenityImageView.image = eventType?.icon
        self.amentityTitleLabel.text = eventType?.title
    }
    
}
