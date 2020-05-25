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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mealTitleLabel.font = AppFonts.Regular.withSize(18)
        mealForLabel.font = AppFonts.Regular.withSize(14)
        mealAutoSelectedForLabel.font = AppFonts.Regular.withSize(12)
        priceLabel.font = AppFonts.Regular.withSize(18)
        quantityLabel.font = AppFonts.SemiBold.withSize(16)

        quantityLabel.textColor = AppColors.themeGreen
        mealForLabel.textColor = AppColors.themeGray40
        mealAutoSelectedForLabel.textColor = AppColors.themeGray60

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
