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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        countryLabel.font = AppFonts.Regular.withSize(18)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(country : PKCountryModel, isSelected : Bool){
        self.countryLabel.text = country.countryEnglishName
        self.flagImageView.image = country.flagImage
        self.tickImageView.isHidden = isSelected
    }
    
}
