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
    
    
    var amenitie : (amenititesImage: UIImage, amentitiesTitle: String,status:Int)? {
        didSet {
            self.populateData()
        }
    }
    
    
    // MARK: - View Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func populateData() {
        self.amenityImageView.image = amenitie?.amenititesImage
        self.amentityTitleLabel.text = amenitie?.amentitiesTitle
        self.statusButton.isSelected = amenitie?.status.toBool ?? false
    }

    
}
