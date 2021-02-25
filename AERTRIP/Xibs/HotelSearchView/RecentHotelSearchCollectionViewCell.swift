//
//  RecentHotelSearchCollectionViewCell.swift
//  AERTRIP
//
//  Created by Admin on 14/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class RecentHotelSearchCollectionViewCell: UICollectionViewCell {
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var containerView: UIView! {
        didSet {
            self.containerView.layer.cornerRadius = 10.0
            self.containerView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var blurVibranyEffectView: UIVisualEffectView!
    
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cityNameLabel.text = ""
        cityNameLabel.attributedText = nil
    }
    
    //Mark:- Functions
    //================
    ///InitialSetUp
    private func initialSetUp() {
        
        self.cityImageView.image = #imageLiteral(resourceName: "hotelsBlack").withRenderingMode(.alwaysTemplate)
        self.cityImageView.tintColor = AppColors.recentSeachesSearchTypeBlue
        ///Font
        let regularFont14 = AppFonts.Regular.withSize(14.0)
        self.timeLabel.font = regularFont14
        self.cityNameLabel.font = AppFonts.SemiBold.withSize(14.0)
        
        ///Colors
        self.timeLabel.textColor = AppColors.themeGray60
        self.cityNameLabel.textColor = AppColors.themeGray60
        
        //Text
        self.timeLabel.text = ""
        self.cityNameLabel.text = ""
        
        
        // add vibrancy blur effect you
        
        //AppGlobals.shared.removeBlur(fromView: self.blurVibranyEffectView)
        // self.blurVibranyEffectView.contentView.addSubview(AppGlobals.shared.getBlurView(forView: self.blurVibranyEffectView, isDark: false))
        //self.blurVibranyEffectView.insertSubview(AppGlobals.shared.getBlurView(forView: self.blurVibranyEffectView, isDark: false), at: 0)
    }
    
    ///ConfigureCell
    internal func configureCell(recentSearchesData: RecentSearchesModel) {
        //        self.timeLabel.text = recentSearchesData.time_ago
        
//        if recentSearchesData.search_nearby {
//            let nearMeText = LocalizedString.NearMe.localized
//            self.cityNameLabel.text = nearMeText
//            self.cityNameLabel.AttributedFontAndColorForText(atributedText: nearMeText, textFont: AppFonts.SemiBold.withSize(18.0), textColor: AppColors.themeBlack)
//        } else {
            printDebug(recentSearchesData.dest_name)
            let cityName = recentSearchesData.dest_name.split(separator: ",").first ?? ""
//            let countryCode = recentSearchesData.dest_name.split(separator: ",").last ?? ""
            //        self.cityNameLabel.text = "\(cityName)"
            let prefix: String = cityName.isEmpty ? "" : "\(cityName),"
//            let suffix: String = countryCode.isEmpty ? "" : ",\(countryCode)"
            
        let stateText = recentSearchesData.dest_name.deletingPrefix(prefix: prefix).removeSpaceAsSentence
            //stateText = stateText.deletingSuffix(suffix: suffix).removeSpaceAsSentence
            
//            self.cityNameLabel.text = "\(cityName) " + stateText
//            self.cityNameLabel.AttributedFontAndColorForText(atributedText: "\(cityName)", textFont: AppFonts.SemiBold.withSize(18.0), textColor: AppColors.themeBlack)
//        }
        self.cityNameLabel.attributedText = self.createAttributedText(attTxt: "\(cityName) ", normalText: stateText)
        //        let totalNights = (recentSearchesData.totalNights == 1 ? " (\(recentSearchesData.totalNights) Night)" : " (\(recentSearchesData.totalNights) Nights)")
        if let checkInDate = self.getDateFromString(stringDate: recentSearchesData.checkInDate), let checkOutDate = self.getDateFromString(stringDate: recentSearchesData.checkOutDate) {
            self.timeLabel.text = checkInDate + " - " + checkOutDate
        }
        //       / self.adultAndRoomText(recentSearchesData: recentSearchesData)
    }
    
    
    
    func createAttributedText(attTxt: String, normalText: String)-> NSAttributedString{
        let attStr = NSMutableAttributedString(string: attTxt, attributes: [.font: AppFonts.SemiBold.withSize(18.0), .foregroundColor: AppColors.themeBlack])
        
        let sufix = NSAttributedString(string: normalText, attributes: [.font: AppFonts.SemiBold.withSize(14.0), .foregroundColor: AppColors.themeGray60])
        attStr.append(sufix)
        return attStr
        
    }
    
    ///GetDateFromString
    private func getDateFromString(stringDate: String) -> String? {
        //String to Date Convert
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMM yy"
        let date = dateFormatter.date(from: stringDate)
        //CONVERT FROM Date to String
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: date!)
    }
    
    ///AdultAndRoomText
    private func adultAndRoomText(recentSearchesData: RecentSearchesModel) {
        var roomCount: Int = 0
        var adultCounts: Int = 0
        var childCounts: Int = 0
        if let roomData = recentSearchesData.room {
            for roomData in roomData {
                if roomData.isPresent{
                    roomCount += 1
                    adultCounts += Int(roomData.adultCounts) ?? 0
                    childCounts += Int(roomData.child.count)
                }
            }
        }
        let roomText = (roomCount == 1) ? "\(roomCount) Room" : "\(roomCount) Rooms"
        let adultText = adultCounts == 1 ? "\(adultCounts) Adult" : "\(adultCounts) Adults"
        let childText = adultCounts == 1 ? "\(childCounts) Children" : "\(childCounts) Childrens"
        
        let message = childCounts == 0 ? " (\(adultText))" : " (\(adultText), \(childText))"
        //        self.totalAdultsLabel.text = roomText + message
        
    }
}
