//
//  SuggestionsCellCollectionViewCell.swift
//  AERTRIP
//
//  Created by Appinventiv on 24/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SuggestionsCell : UICollectionViewCell {

    @IBOutlet weak var suggestionBackView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var suggestionLabel: UILabel!
    @IBOutlet weak var suggestionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
        self.contentView.roundedCorners(cornerRadius: 10)
        self.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        self.suggestionLabel.font = AppFonts.SemiBold.withSize(18)
        self.dateLabel.font = AppFonts.Regular.withSize(14)
        self.dateLabel.textColor = AppColors.themeGray60
    }

    func configureHotelCell(data : RecentSearchesModel){
        let suggestion = data.dest_name
//        self.suggestionLabel.attributedText = suggestion.attributeStringWithColors(stringToColor: "India", strClr: UIColor.black, substrClr: AppColors.themeGray60, strFont: AppFonts.SemiBold.withSize(18), strClrFont: AppFonts.SemiBold.withSize(14))
        self.suggestionLabel.text = suggestion
        self.suggestionImageView.image = #imageLiteral(resourceName: "hotelCopy4")
        
        let checkIn = Date.getDateFromString(stringDate: data.checkInDate, currentFormat: Date.DateFormat.EComaddMMMyy.rawValue, requiredFormat: Date.DateFormat.ddMMM.rawValue) ?? ""
        
        let checkOut = Date.getDateFromString(stringDate: data.checkOutDate, currentFormat: Date.DateFormat.EComaddMMMyy.rawValue, requiredFormat: Date.DateFormat.ddMMM.rawValue) ?? ""
        self.dateLabel.text = "\(String(describing: checkIn)) - \(String(describing: checkOut))"
        
        //MARK:- code structure is voilated here as code written previously in recent search model
    }
    
    func configureFlightCell(data : RecentSearchesModel){
        self.suggestionLabel.text = "BOM → DEL"
        self.dateLabel.text = "17 Jan"
        self.suggestionImageView.image = #imageLiteral(resourceName: "blueflight")
    }
    
    func populateData(data : RecentSearchesModel){
        data.type == .hotel ? self.configureHotelCell(data : data) : self.configureFlightCell(data : data)
    }
    
}
