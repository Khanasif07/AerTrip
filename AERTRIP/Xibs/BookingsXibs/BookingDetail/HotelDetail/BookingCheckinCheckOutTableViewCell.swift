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
    
    
    
    func configureCell(checkInDate: Date?,checkOutDate: Date?, totalNights: Int) {
        // get all value in a format
        
        let checkInStr = checkInDate?.toString(dateFormat: "dd MMM") ?? ""
        let checkOutStr = checkOutDate?.toString(dateFormat: "dd MMM") ?? ""
        self.checkInDateLabel.text = checkInStr.isEmpty ? LocalizedString.na.localized : checkInStr
        self.checkOutDateLabel.text = checkOutStr.isEmpty ? LocalizedString.na.localized : checkOutStr
        
        var finalNight = totalNights
        if totalNights == 0, let inDate = checkInDate, let outDate = checkOutDate {
            finalNight = outDate.daysFrom(inDate)
        }
        self.numberOfNightsLabel.text = (finalNight == 1) ? "\(finalNight) \(LocalizedString.Night.localized)" : "\(finalNight) \(LocalizedString.Nights.localized)"
        
        
        self.checkInDayLabel.text = checkInDate?.toString(dateFormat: "EEEE") ?? LocalizedString.na.localized
        self.checkOutDayLabel.text = checkOutDate?.toString(dateFormat: "EEEE") ?? LocalizedString.na.localized
        
        if let image = UIImage(named: "darkNights") {
             self.numberOfNightsLabel.attributedText = AppGlobals.shared.getTextWithImage(startText: "", image: image, endText: (totalNights == 1) ? "  \(totalNights) Night" : "  \(totalNights) Nights", font: AppFonts.SemiBold.withSize(14.0))
        }
        
        self.checkInDayLabel.text = checkInDate?.toString(dateFormat: "EEEE") ?? LocalizedString.na.localized
        self.checkOutDayLabel.text = checkOutDate?.toString(dateFormat: "EEEE") ?? LocalizedString.na.localized

        
    }
    
}
