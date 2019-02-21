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
    
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configUi()
        // Initialization code
    }
    
    private func configUi() {
        self.amenitiesNameLabel.font = AppFonts.Regular.withSize(18.0)
    }

    //Mark:- Methods
    //==============
    internal func configureCell(amenitiesItem: UIImage,amenitiesName: String) {
        self.amenitiesImageView.image = amenitiesItem
        self.amenitiesNameLabel.text = amenitiesName
    }
}
