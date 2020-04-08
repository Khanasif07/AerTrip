//
//  CountryCell.swift
//  AERTRIP
//
//  Created by Appinventiv on 26/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var sepratorView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        countryLabel.font = AppFonts.Regular.withSize(18)
        flagImageView.layer.borderWidth = 0.3
        flagImageView.layer.borderColor = AppColors.themeGray20.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(country : PKCountryModel, isSelected : Bool){
        self.countryLabel.text = country.countryEnglishName
        self.flagImageView.image = country.flagImage
        self.tickImageView.isHidden = isSelected
        self.sepratorView.isHidden = country.countryID != 93
    }
    
}
