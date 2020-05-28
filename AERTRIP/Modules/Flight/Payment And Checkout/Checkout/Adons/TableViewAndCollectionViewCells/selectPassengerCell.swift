//
//  selectPassengerCell.swift
//  AERTRIP
//
//  Created by Appinventiv on 29/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class selectPassengerCell: UICollectionViewCell {

    
    @IBOutlet weak var selectionImageView: UIView!
    @IBOutlet weak var passengerImageView: UIImageView!
    @IBOutlet weak var nameLabe: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        passengerImageView.roundedCorners(cornerRadius: selectionImageView.frame.height/2)
        selectionImageView.roundedCorners(cornerRadius: selectionImageView.frame.height/2)
        //self.setNeedsLayout()
        //self.layoutIfNeeded()
    }

}
