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
    @IBOutlet weak var dividerLabel: UILabel!
    
    var desc = NSAttributedString()
    var isAnimated = false
    var handler: (()->())?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        fewSeatsLeftCountLabel.layer.cornerRadius = fewSeatsLeftCountLabel.frame.width/2
        dataDisplayView.layer.cornerRadius = 10
        selectButton.layer.cornerRadius = selectButton.bounds.height/2
        self.dataDisplayView.addShadow(cornerRadius: AppShadowProperties().cornerRadius, maskedCorners: [.layerMaxXMaxYCorner,.layerMaxXMinYCorner,.layerMinXMaxYCorner, .layerMinXMinYCorner], color: AppShadowProperties().shadowColor, offset: AppShadowProperties().offset, opacity: AppShadowProperties().opecity, shadowRadius: AppShadowProperties().shadowRadius)
        self.setColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setColor()
    }
    
    private func setColor(){
        self.dataDisplayView.backgroundColor = AppColors.themeWhiteDashboard
        self.fewSeatsLeftView.backgroundColor = AppColors.fewSeatLeftColor
        self.dividerLabel.backgroundColor = AppColors.fewSeatLeftColor
        self.txtView.backgroundColor = AppColors.themeWhiteDashboard
        self.txtView.textColor = AppColors.themeBlack
        self.fewSeatsLeftLabel.textColor = AppColors.themeRed
        self.fewSeatsLeftCountLabel.backgroundColor = AppColors.themeRed
        self.priceLabel.textColor = AppColors.themeGray60
    }
    
    @IBAction func tapSelectButton(_ sender: Any) {
        self.handler?()
    }
}
