//
//  AmenitiesDetailsCollectionCell.swift
//  AERTRIP
//
//  Created by Admin on 11/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AmenitiesDetailsCollectionCell: UICollectionViewCell {

    //Mark:- Variables
    //================

    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var amenitiesStackView: UIStackView!
    @IBOutlet weak var amenitiesImageView: UIImageView!
    @IBOutlet weak var amenitiesNameLabel: UILabel!
    @IBOutlet weak var dividerView: ATDividerView! {
        didSet {
            self.dividerView.alpha = 0.2
        }
    }
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUi()
        // Initialization code
    }
    
    private func configUi() {
        self.amenitiesNameLabel.font = AppFonts.Regular.withSize(17.0)//18 is to big
        self.amenitiesNameLabel.textColor = AppColors.themeBlack
    }

    //Mark:- Methods
    //==============
    internal func configureCell(amenitiesMainData: AmenitiesMain) {
        self.amenitiesImageView.image = amenitiesMainData.image
        self.amenitiesNameLabel.text = amenitiesMainData.name
        if amenitiesMainData.available {
            self.amenitiesImageView.alpha = 1.0
            self.amenitiesNameLabel.alpha = 1.0
            self.dividerView.alpha = 0.0
            self.dividerView.isHidden = true
        } else {
            self.amenitiesImageView.alpha = 0.20
            self.dividerView.alpha = 0.2
            self.amenitiesNameLabel.alpha = 0.20
            self.dividerView.isHidden = false
        }
    }
}
