//
//  BookingAddOnHeaderView.swift
//  AERTRIP
//
//  Created by apple on 22/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingAddOnHeaderView: UITableViewHeaderFooterView {

    // MARK: - IBOutlet
    @IBOutlet weak var routeLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFont()
        self.setUpColor()
    }
    
    
    
      // MARK: - Helper methods
   func  setUpFont() {
        self.routeLabel.font = AppFonts.SemiBold.withSize(22.0)
        self.infoLabel.font = AppFonts.Regular.withSize(14.0)
    }
    
   func setUpColor() {
    self.routeLabel.textColor = AppColors.themeBlack
        self.infoLabel.textColor = AppColors.themeBlack

    }
    
}
