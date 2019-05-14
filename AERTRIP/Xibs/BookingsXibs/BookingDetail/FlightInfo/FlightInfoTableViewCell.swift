//
//  FlightInfoTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 10/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightInfoTableViewCell: UITableViewCell {
    
    // MARK: - IB Outlet
    
    @IBOutlet weak var flightImageView: UIImageView!
    @IBOutlet weak var flightNameLabel: UILabel!
    @IBOutlet weak var flightOwnerLabel: UILabel!
    @IBOutlet weak var flightCodeClassLabel: UILabel!
    
    

    // MARK: - View life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        self.setUpFont()
        self.setUpTextColor()
    }
    
    
    // MARK: - Helper methods
    
    private func setUpFont() {
        self.flightNameLabel.font = AppFonts.SemiBold.withSize(14.0)
          self.flightOwnerLabel.font = AppFonts.Regular.withSize(14.0)
          self.flightCodeClassLabel.font = AppFonts.Regular.withSize(14.0)
        
    }
    
    private func setUpTextColor() {
        self.flightNameLabel.textColor = AppColors.themeBlack
        self.flightOwnerLabel.textColor = AppColors.themeGray40
        self.flightCodeClassLabel.textColor = AppColors.themeGray40
    }
    
    
    func configureCell() {
        self.flightNameLabel.text = "Virgin Atlantic"
        self.flightOwnerLabel.text = "Operated by Jet Airways"
        self.flightCodeClassLabel.text = "EK-5154・Premium E (B)"
    }

    
}
