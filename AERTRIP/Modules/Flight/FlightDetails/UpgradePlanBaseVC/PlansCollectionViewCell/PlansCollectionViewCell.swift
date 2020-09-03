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
    
    @IBOutlet weak var fewSeatsLeftView: UIView!
    @IBOutlet weak var fewSeatsLeftViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var fewSeatsLeftLabel: UILabel!
    @IBOutlet weak var fewSeatsLeftCountLabel: UILabel!
    
    var desc = NSAttributedString()
    var isAnimated = false
    var handler: (()->())?
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        fewSeatsLeftCountLabel.layer.cornerRadius = fewSeatsLeftCountLabel.frame.width/2
        dataDisplayView.layer.cornerRadius = 10
        selectButton.layer.cornerRadius = selectButton.bounds.height/2
    }
    
    @IBAction func tapSelectButton(_ sender: Any) {
        self.handler?()
    }
}
