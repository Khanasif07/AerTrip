//
//  PlansCollectionViewCell.swift
//  Aertrip
//
//  Created by Monika Sonawane on 01/10/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class PlansCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var dataDisplayView: UIView!
    @IBOutlet weak var dataDisplayViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var newPriceLabel: UILabel!
    @IBOutlet weak var upDownArrowImgView: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var selectButtonClick: UIButton!
    @IBOutlet weak var txtView: UITextView!
    
    var desc = NSAttributedString()
    var isAnimated = false
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        dataDisplayView.layer.cornerRadius = 10
                
        selectButton.layer.cornerRadius = selectButton.bounds.height/2
    }
}
