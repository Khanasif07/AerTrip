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
            self.containerView.backgroundColor = AppColors.themeWhite.withAlphaComponent(0.5)
        }
    }
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var searchTypeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var stateNameLabel: UILabel!
    @IBOutlet weak var totalNightsLabel: UILabel!
    @IBOutlet weak var totalAdultsLabel: UILabel!
    
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
        self.cityImageView.tintColor = AppColors.themeGreenWithBlur
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
        let greenColor = AppColors.themeGreenWithBlur
        self.searchTypeLabel.textColor = greenColor
        self.timeLabel.textColor = greenColor
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
    }

    ///ConfigureCell
    internal func configureCell(recentSearchesData: RecentSearchesModel) {
        self.timeLabel.text = recentSearchesData.time_ago
        self.searchTypeLabel.text = recentSearchesData.dest_type
        let cityName = recentSearchesData.dest_name.split(separator: ",")
        self.cityNameLabel.text = "\(cityName.first ?? "")"
        let prefix: String = recentSearchesData.dest_name.firstWord + " "
        self.stateNameLabel.text = recentSearchesData.dest_name.deletingPrefix(prefix: prefix)
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
        
       /*let guestsData = recentSearchesData.guestsValue.split(separator: ",")
         let roomCounts = guestsData.first
         let adultData = guestsData.last?.split(separator: " ")
         let adultCount = "\(adultData?.first ?? "")" == "1" ? "\(adultData?.first ?? "") Adult" : "\(adultData?.first ?? "") Adults"
         self.totalAdultsLabel.text = "\(roomCounts ?? "") (\(adultCount))"*/
    }
}
