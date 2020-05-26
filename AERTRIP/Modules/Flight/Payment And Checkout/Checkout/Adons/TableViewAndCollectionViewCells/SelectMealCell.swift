//
//  SelectMealCell.swift
//  AERTRIP
//
//  Created by Appinventiv on 25/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SelectMealCell: UITableViewCell {

    @IBOutlet weak var mealTitleLabel: UILabel!
    @IBOutlet weak var mealForLabel: UILabel!
    @IBOutlet weak var mealAutoSelectedForLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var autoSelectionBackView: UIView!
    @IBOutlet weak var mealForLabelTop: NSLayoutConstraint!
    @IBOutlet weak var mealAutoSelectedTop: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        mealTitleLabel.font = AppFonts.Regular.withSize(18)
        mealForLabel.font = AppFonts.Regular.withSize(14)
        mealAutoSelectedForLabel.font = AppFonts.Regular.withSize(12)
        priceLabel.font = AppFonts.Regular.withSize(18)
        quantityLabel.font = AppFonts.SemiBold.withSize(16)

        quantityLabel.textColor = AppColors.themeGreen
        mealForLabel.textColor = AppColors.themeGray40
        mealAutoSelectedForLabel.textColor = AppColors.themeGray60
        
        autoSelectionBackView.roundedCorners(cornerRadius: 3)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func populateData(index : Int){
        if index == 3{
                            
                self.mealTitleLabel.text = "Hindu (Non- Vegetarian) Meal Specific Hindu (Non- Vegetarian) Meal Specific"
                
                self.mealForLabel.text = "For Julin and Clifford"

                self.mealAutoSelectedForLabel.text = "Auto Selected for DEL → HYD"
                
                let price = "₹1,33554"
                self.priceLabel.text = price
                //cell.priceLabelWidth.constant = price.widthOfText(cell.priceLabel.frame.height, font: AppFonts.Regular.withSize(18))
                self.quantityLabel.text = "X5"
                self.priceLabel.isHidden = false
                 self.quantityLabel.isHidden = false

            self.mealForLabelTop.constant = 2
            self.mealAutoSelectedTop.constant = 11
            autoSelectionBackView.isHidden = false
            
            }else if index == 4 {
                
                self.mealTitleLabel.text = "Gluten Free Non-Veg Meal"
                
                self.mealForLabel.text = "For Julin and Clifford For Julin and Clifford"

                self.mealAutoSelectedForLabel.text = ""
                
                let price = "₹12"
                self.priceLabel.text = price
                //cell.priceLabelWidth.constant = price.widthOfText(cell.priceLabel.frame.height, font: AppFonts.Regular.withSize(18))
                self.quantityLabel.text = "X5"
                self.priceLabel.isHidden = false
                self.quantityLabel.isHidden = false
                
            self.mealForLabelTop.constant = 2
            self.mealAutoSelectedTop.constant = 0
            autoSelectionBackView.isHidden = true

          
        } else {
                
                self.mealTitleLabel.text = "Gluten Free Non-Veg Meal Free Non-Veg Meal"
                
                self.mealForLabel.text = ""

                self.mealAutoSelectedForLabel.text = ""
                
                let price = "₹12"
                self.priceLabel.text = price
                //cell.priceLabelWidth.constant = price.widthOfText(cell.priceLabel.frame.height, font: AppFonts.Regular.withSize(18))
                self.quantityLabel.text = "X5"
                self.priceLabel.isHidden = true
                self.quantityLabel.isHidden = true
           
            self.mealForLabelTop.constant = 0
                       self.mealAutoSelectedTop.constant = 0
            autoSelectionBackView.isHidden = true

            }
        
        self.priceLabel.setNeedsLayout()
        self.priceLabel.layoutIfNeeded()
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
}
