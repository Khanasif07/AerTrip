//
//  AmenitiesNameTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 06/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AmenitiesNameTableViewCell: UITableViewCell {

    @IBOutlet weak var facilitiesNameLabel: UILabel!
    @IBOutlet weak var facilitiesIconView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        facilitiesNameLabel.attributedText = nil
    }
    
    private func configUI() {
        self.facilitiesNameLabel.font = AppFonts.Regular.withSize(18.0)
        self.facilitiesNameLabel.textColor = AppColors.themeBlack
    }
    
}
