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
    @IBOutlet weak var searchTypeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var stateNameLabel: UILabel!
    @IBOutlet weak var totalNightsLabel: UILabel!
    @IBOutlet weak var totalAdultsLabel: UILabel!
    
    @IBOutlet weak var blurVibranyEffectView: UIVisualEffectView!
    
    
    //Mark:- LifeCycle
    //================
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialSetUp()
    }
    
    //Mark:- Functions
    //================
    ///InitialSetUp
    private func initialSetUp() {
        
        self.cityImageView.image = #imageLiteral(resourceName: "hotelsBlack").withRenderingMode(.alwaysTemplate)
        self.cityImageView.tintColor = AppColors.recentSeachesSearchTypeBlue
        ///Font
        let regularFont14 = AppFonts.Regular.withSize(14.0)
        self.searchTypeLabel.font = AppFonts.SemiBold.withSize(14.0)
        self.timeLabel.font = AppFonts.Regular.withSize(14.0)
        self.cityNameLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.stateNameLabel.font = regularFont14
        self.totalNightsLabel.font = regularFont14
        self.totalAdultsLabel.font = regularFont14
        
        ///Colors
        let grayColor = AppColors.themeGray60
        let blackColor = AppColors.themeBlack
        let greenColor = AppColors.recentSeachesSearchTypeBlue
        self.searchTypeLabel.textColor = blackColor
        self.timeLabel.textColor = blackColor
        self.cityNameLabel.textColor = blackColor
        self.stateNameLabel.textColor = blackColor
        self.totalNightsLabel.textColor = grayColor
        self.totalAdultsLabel.textColor = grayColor
        
        //Text
        self.searchTypeLabel.text = ""
        self.timeLabel.text = ""
        self.cityNameLabel.text = ""
        self.stateNameLabel.text = ""
        self.totalNightsLabel.text = ""
        self.totalAdultsLabel.text = ""
        
        // add vibrancy blur effect you
        
        //AppGlobals.shared.removeBlur(fromView: self.blurVibranyEffectView)
       // self.blurVibranyEffectView.contentView.addSubview(AppGlobals.shared.getBlurView(forView: self.blurVibranyEffectView, isDark: false))
    //self.blurVibranyEffectView.insertSubview(AppGlobals.shared.getBlurView(forView: self.blurVibranyEffectView, isDark: false), at: 0)
    }

    ///ConfigureCell
    internal func configureCell(recentSearchesData: RecentSearchesModel) {
        self.timeLabel.text = recentSearchesData.time_ago
        if recentSearchesData.dest_type != "popular_destination" {
              self.searchTypeLabel.text = recentSearchesData.dest_type
        } else {
             self.searchTypeLabel.text = LocalizedString.PopularDestinations.localized
        }
      
        let cityName = recentSearchesData.dest_name.split(separator: ",").first ?? ""
        self.cityNameLabel.text = "\(cityName)"
        let prefix: String = cityName.isEmpty ? "" : "\(cityName),"
        self.stateNameLabel.text = recentSearchesData.dest_name.deletingPrefix(prefix: prefix).removeSpaceAsSentence
        let totalNights = (recentSearchesData.totalNights == 1 ? " (\(recentSearchesData.totalNights) Night)" : " (\(recentSearchesData.totalNights) Nights)")
        if let checkInDate = self.getDateFromString(stringDate: recentSearchesData.checkInDate), let checkOutDate = self.getDateFromString(stringDate: recentSearchesData.checkOutDate) {
            self.totalNightsLabel.text = checkInDate + " - " + checkOutDate + "\(totalNights)"
        }
        self.adultAndRoomText(recentSearchesData: recentSearchesData)
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
        if let roomData = recentSearchesData.room {
            for roomData in roomData {
                if roomData.isPresent{
                    roomCount += 1
                    adultCounts += Int(roomData.adultCounts) ?? 0
                }
            }
        }
        let roomText = (roomCount == 1) ? "\(roomCount) Room" : "\(roomCount) Rooms"
        let adultText = adultCounts == 1 ? "\(adultCounts) Adult" : "\(adultCounts) Adults"
        self.totalAdultsLabel.text = roomText + " (\(adultText))"
        
    }
}
