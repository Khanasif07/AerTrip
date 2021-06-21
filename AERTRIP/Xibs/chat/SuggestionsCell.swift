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
        
        let cityName = data.dest_name.split(separator: ",").first ?? ""
        let prefix: String = cityName.isEmpty ? "" : "\(cityName),"
        let stateText = data.dest_name.deletingPrefix(prefix: prefix).removeSpaceAsSentence
        self.suggestionLabel.attributedText = self.createAttributedText(attTxt: "\(cityName) ", normalText: stateText)
        self.suggestionImageView.image = AppImages.hotelCopy4
        
        let checkIn = Date.getDateFromString(stringDate: data.checkInDate, currentFormat: Date.DateFormat.EComaddMMMyy.rawValue, requiredFormat: Date.DateFormat.ddMMM.rawValue) ?? ""
        
        let checkOut = Date.getDateFromString(stringDate: data.checkOutDate, currentFormat: Date.DateFormat.EComaddMMMyy.rawValue, requiredFormat: Date.DateFormat.ddMMM.rawValue) ?? ""
        self.dateLabel.text = "\(String(describing: checkIn)) - \(String(describing: checkOut))"
        
        //MARK:- code structure is voilated here as code written previously in recent search model
    }
    
    func configureFlightCell(data : RecentSearchesModel){
        self.suggestionLabel.font = AppFonts.SemiBold.withSize(18)
        self.suggestionLabel.textColor = AppColors.themeBlack
        
        guard let flight = data.flight  else {return}
        
//        self.suggestionLabel.text = "BOM → DEL"
//        self.dateLabel.text = "17 Jan"
        self.suggestionImageView.image = AppImages.blueflight
        
        suggestionLabel.attributedText = flight.travelPlan

        if(flight.travelDate.count > 33){

            let startIndex = flight.travelDate.index(flight.travelDate.startIndex, offsetBy: 6)
            let endIndex = flight.travelDate.index(flight.travelDate.endIndex, offsetBy: -6)

            let startString = String(flight.travelDate.prefix(upTo: startIndex))
            let endString = String(flight.travelDate.suffix(from: endIndex))

            dateLabel.text = startString + " ... " + endString

        }else{
            dateLabel.text = flight.travelDate
        }
    }
    
    func populateData(data : RecentSearchesModel){
        data.type == .hotel ? self.configureHotelCell(data : data) : self.configureFlightCell(data : data)
    }
    
    //MARK:- To add attributes in hotel title text.
    func createAttributedText(attTxt: String, normalText: String)-> NSAttributedString{
        let attStr = NSMutableAttributedString(string: attTxt, attributes: [.font: AppFonts.SemiBold.withSize(18.0), .foregroundColor: AppColors.themeBlack])
        
        let sufix = NSAttributedString(string: normalText, attributes: [.font: AppFonts.SemiBold.withSize(14.0), .foregroundColor: AppColors.themeGray60])
        attStr.append(sufix)
        return attStr
        
    }
    
}
