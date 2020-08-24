//
//  CurrencyCellTableViewCell.swift
//  AERTRIP
//
//  Created by Appinventiv on 26/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {

    @IBOutlet weak var tickImageView: UIImageView!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var currencySymbolLabel: UILabel!
    @IBOutlet weak var sepratorView: ATDividerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        currencyNameLabel.font = AppFonts.Regular.withSize(18)
        currencyCodeLabel.font = AppFonts.Regular.withSize(18)
        currencySymbolLabel.font = AppFonts.Regular.withSize(18)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.currencySymbolLabel.attributedText = nil
        self.currencySymbolLabel.text = nil
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(country : PKCountryModel, isSelected : Bool){
        self.currencySymbolLabel.text = country.currencySymbol
        self.currencyNameLabel.text = country.currencyName
        self.currencyCodeLabel.text = country.currencyCode
        self.tickImageView.isHidden = isSelected
//        if let image = UIImage(named: country.currencyIcon) {
//            self.currencySymbolLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "", image: image, endText: "", font: AppFonts.Regular.withSize(18))
//        } else {
//            self.currencySymbolLabel.text = country.currencySymbol
//        }
        
    }
    
}
