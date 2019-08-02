//
//  WhetherHeaderTableViewCell.swift
//  AERTRIP
//
//  Created by Admin on 31/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol WeatherHeaderTableViewCellDelegate: class {
    func seeAllWeathers(seeAllButton: UIButton)
}

class WeatherHeaderTableViewCell: UITableViewCell {
    // MARK: - Variables
    
    // MARK: ===========
    
    weak var delegate: WeatherHeaderTableViewCellDelegate?
    
    // MARK: - IBOutlets
    
    // MARK: ===========
    
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var seeAllBtnOutlet: UIButton!
    
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
        self.seeAllBtnOutlet.titleLabel?.font = AppFonts.Regular.withSize(14.0)
        
        // Color
        self.weatherLabel.textColor = AppColors.themeGray40
        self.seeAllBtnOutlet.setTitleColor(AppColors.themeGreen, for: .normal)
        
        // Text
        self.weatherLabel.text = LocalizedString.Weather.localized
        self.seeAllBtnOutlet.setTitle(LocalizedString.SeeAll.localized, for: .normal)
    }
    
    // MARK: - IBActions
    
    // MARK: ===========
    
    @IBAction func seeAllBtnAction(_ sender: UIButton) {
        self.delegate?.seeAllWeathers(seeAllButton: sender)
    }
}
