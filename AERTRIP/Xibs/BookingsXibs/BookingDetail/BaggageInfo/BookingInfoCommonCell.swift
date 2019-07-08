//
//  BookingInfoCommonCell.swift
//  AERTRIP
//
//  Created by apple on 09/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingInfoCommonCell: ATTableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak  var leftLabel: UILabel!
    @IBOutlet weak  var middleLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    // MARK: - Variables
    var isForPassenger : Bool = false
    
    

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.leftLabel.text = ""
         self.middleLabel.text = ""
         self.rightLabel.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        self.setUpFont()
        self.setUpColor()
        
    }
    
    private func setUpFont() {
        self.leftLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.middleLabel.font = self.isForPassenger ? AppFonts.Regular.withSize(18.0) : AppFonts.SemiBold.withSize(18.0)
        self.rightLabel.font = self.isForPassenger ? AppFonts.Regular
            .withSize(18.0) : AppFonts.SemiBold.withSize(18.0)
    }
    
    private func setUpColor() {
        self.leftLabel.textColor = AppColors.themeBlack
        self.middleLabel.textColor = AppColors.themeBlack
        self.rightLabel.textColor = AppColors.themeBlack
    }
    

}
