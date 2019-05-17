//
//  BookingCheckinCheckOutTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 14/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingCheckinCheckOutTableViewCell: ATTableViewCell {
    
    //MARK: - IBOutlet
   
    // Check in
    @IBOutlet weak var checkInLabel: UILabel!
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkInDayLabel: UILabel!
    
    // number of Nights label
    @IBOutlet weak var numberOfNightsLabel: UILabel!
    
    // chekcout
    @IBOutlet weak var checkOutLabel: UILabel!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkOutDayLabel: UILabel!
    
   
    // MARK: - Override methods
    
    override func setupFonts() {
        self.checkInLabel.font = AppFonts.Regular.withSize(16.0)
        self.checkInDateLabel.font = AppFonts.Regular.withSize(26.0)
        self.checkInDayLabel.font = AppFonts.Regular.withSize(16.0)
        
        self.numberOfNightsLabel.font = AppFonts.SemiBold.withSize(14.0)
        
        self.checkOutLabel.font = AppFonts.Regular.withSize(16.0)
        self.checkOutDateLabel.font = AppFonts.Regular.withSize(26.0)
        self.checkOutDayLabel.font = AppFonts.Regular.withSize(16.0)
    }
    
    override func setupTexts() {
        self.checkInLabel.text = LocalizedString.CheckIn.localized
        self.checkOutLabel.text = LocalizedString.CheckOut.localized
    }
    
    override func setupColors() {
        self.checkInLabel.textColor = AppColors.themeGray40
        self.checkInDateLabel.textColor = AppColors.textFieldTextColor51
        self.checkInDayLabel.textColor = AppColors.textFieldTextColor51
        
        self.numberOfNightsLabel.textColor = AppColors.themeBlack
        
        self.checkOutLabel.textColor = AppColors.themeGray40
        self.checkOutDateLabel.textColor = AppColors.textFieldTextColor51
        self.checkOutDayLabel.textColor = AppColors.textFieldTextColor51
        
    }
    
    
    
    func configureCell() {
        // get all value in a format
        let checkInDate = Date.getDateFromString(stringDate:         HotelsSearchVM.hotelFormData.checkInDate, currentFormat: "yyyy-mm-dd", requiredFormat: "dd MMM")
        let checkOutDate = Date.getDateFromString(stringDate:   HotelsSearchVM.hotelFormData.checkOutDate, currentFormat: "yyyy-mm-dd", requiredFormat: "dd MMM")
        
        let totalNights = (        HotelsSearchVM.hotelFormData.checkOutDate
            .toDate(dateFormat: "yyyy-mm-dd")! ).daysFrom(        HotelsSearchVM.hotelFormData.checkInDate
                .toDate(dateFormat: "yyyy-mm-dd")! )
        
        let checkInDay = Date.getDateFromString(stringDate: HotelsSearchVM.hotelFormData.checkInDate , currentFormat: "yyyy-mm-dd", requiredFormat: "EEEE")
        let checkOutDay = Date.getDateFromString(stringDate: HotelsSearchVM.hotelFormData.checkOutDate, currentFormat: "yyyy-mm-dd", requiredFormat: "EEEE")
        
        self.checkInDateLabel.text  = checkInDate
        self.checkOutDateLabel.text = checkOutDate
        
        if let image = UIImage(named: "darkNights") {
             self.numberOfNightsLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "", image: image, endText: (totalNights == 1) ? "  \(totalNights) Night" : "  \(totalNights) Nights", font: AppFonts.SemiBold.withSize(14.0))
        }
        
        self.checkInDayLabel.text = checkInDay
        self.checkOutDayLabel.text = checkOutDay

        
    }
    
}
