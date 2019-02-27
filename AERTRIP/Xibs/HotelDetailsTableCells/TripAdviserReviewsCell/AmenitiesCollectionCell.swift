//
//  AmenitiesCollectionCell.swift
//  AERTRIP
//
//  Created by Admin on 21/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class AmenitiesCollectionCell: UICollectionViewCell {
    
    //Mark:- Variables
    //================
    
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var amenitiesImageView: UIImageView!
    
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //Mark:- Methods
    //==============
    internal func configureCell(amenitiesItem: UIImage) {
        self.amenitiesImageView.image = amenitiesItem
    }

}
