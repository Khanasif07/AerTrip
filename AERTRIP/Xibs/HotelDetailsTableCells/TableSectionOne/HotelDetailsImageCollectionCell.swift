//
//  HotelFilterImageCell.swift
//  AERTRIP
//
//  Created by Admin on 08/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotelDetailsImageCollectionCell: UICollectionViewCell {

    //Mark:- Variables
    //================
    
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var hotelImageView: UIImageView!
    
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bgView.roundTopCorners(cornerRadius: 10.0)
    }
    
    //Mark:- Methods
    //==============
    internal func configCell(imgUrl: String) {
        self.hotelImageView.setImageWithUrl(imgUrl, placeholder: #imageLiteral(resourceName: "hotelCardPlaceHolder"), showIndicator: true)
    }
    
}
