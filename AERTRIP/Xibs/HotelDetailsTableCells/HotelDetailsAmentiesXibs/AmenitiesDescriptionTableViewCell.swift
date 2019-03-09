//
//  AmenitiesDescriptionTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 06/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AmenitiesDescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var imgViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUI()
    }
    
    private func configUI() {
        self.titleLabel.textColor = AppColors.themeBlack
        self.titleLabel.font = AppFonts.SemiBold.withSize(16.0)
    }
    
}
