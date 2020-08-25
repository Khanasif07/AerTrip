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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.suggestionLabel.attributedText = nil
    }

    func configureHotelCell(data : RecentSearchesModel){
        self.suggestionLabel.font = AppFonts.SemiBold.withSize(14)
        self.suggestionLabel.textColor = AppColors.themeGray60
        
//        let suggestion = data.dest_name
//        self.suggestionLabel.attributedText = suggestion.attributeStringWithColors(stringToColor: "India", strClr: UIColor.black, substrClr: AppColors.themeGray60, strFont: AppFonts.SemiBold.withSize(18), strClrFont: AppFonts.SemiBold.withSize(14))
        let cityName = data.dest_name.split(separator: ",").first ?? ""
        let countryCode = data.dest_name.split(separator: ",").last ?? ""
        //        self.cityNameLabel.text = "\(cityName)"
        let prefix: String = cityName.isEmpty ? "" : "\(cityName),"
        let suffix: String = countryCode.isEmpty ? "" : ",\(countryCode)"
        
        var stateText = data.dest_name.deletingPrefix(prefix: prefix).removeSpaceAsSentence
        stateText = stateText.deletingSuffix(suffix: suffix).removeSpaceAsSentence
        
        self.suggestionLabel.text = "\(cityName) " + stateText
        self.suggestionLabel.AttributedFontAndColorForText(atributedText: "\(cityName)", textFont: AppFonts.SemiBold.withSize(18.0), textColor: AppColors.themeBlack)
        
//        self.suggestionLabel.text = suggestion
        self.suggestionImageView.image = #imageLiteral(resourceName: "hotelCopy4")
        
        let checkIn = Date.getDateFromString(stringDate: data.checkInDate, currentFormat: Date.DateFormat.EComaddMMMyy.rawValue, requiredFormat: Date.DateFormat.ddMMM.rawValue) ?? ""
        
        let checkOut = Date.getDateFromString(stringDate: data.checkOutDate, currentFormat: Date.DateFormat.EComaddMMMyy.rawValue, requiredFormat: Date.DateFormat.ddMMM.rawValue) ?? ""
        self.dateLabel.text = "\(String(describing: checkIn)) - \(String(describing: checkOut))"
        
        //MARK:- code structure is voilated here as code written previously in recent search model
    }
    
    func configureFlightCell(data : RecentSearchesModel){
        self.suggestionLabel.font = AppFonts.SemiBold.withSize(18)
        self.suggestionLabel.textColor = AppColors.themeBlack

        self.suggestionLabel.text = "BOM → DEL"
        self.dateLabel.text = "17 Jan"
        self.suggestionImageView.image = #imageLiteral(resourceName: "blueflight")
    }
    
    func populateData(data : RecentSearchesModel){
        data.type == .hotel ? self.configureHotelCell(data : data) : self.configureFlightCell(data : data)
    }
    
}
