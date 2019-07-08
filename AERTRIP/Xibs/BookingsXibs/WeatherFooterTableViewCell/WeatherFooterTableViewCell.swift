//
//  WeatherFooterTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 31/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class WeatherFooterTableViewCell: UITableViewCell {
    // MARK: - Variables
    
    // MARK: ===========
    
    // MARK: - IBOutlets
    
    // MARK: ===========
    
    @IBOutlet var weatherLabel: UILabel!
    
    // MARK: - LifeCycle
    
    // MARK: ===========
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    // MARK: - Functions
    
    // MARK: ===========
    
    private func configureUI() {
        // Font
        self.weatherLabel.font = AppFonts.Regular.withSize(14.0)
        
        // Color
        self.weatherLabel.textColor = AppColors.themeGray40
        
        // Text
        self.weatherLabel.text = LocalizedString.WeatherFooterInfo.localized
    }
}
