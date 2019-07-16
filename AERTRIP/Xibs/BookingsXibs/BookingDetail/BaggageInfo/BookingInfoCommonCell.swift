//
//  BookingInfoCommonCell.swift
//  AERTRIP
//
//  Created by apple on 09/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class BookingInfoCommonCell: ATTableViewCell {
    
    // MARK: - IBOutlets
    enum UsingFor {
        case title
        case adult
        case child
        case infant
    }
    
    
    @IBOutlet weak  var leftLabel: UILabel!
    @IBOutlet weak  var middleLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    // MARK: - Variables
    var isForPassenger : Bool = false
    
    

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.leftLabel.text = ""
         self.middleLabel.text = ""
         self.rightLabel.text = ""
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        self.setUpFont()
        self.setUpColor()
        
    }
    
    private func setUpFont() {
        self.leftLabel.font = AppFonts.SemiBold.withSize(18.0)
        self.middleLabel.font = self.isForPassenger ? AppFonts.Regular.withSize(18.0) : AppFonts.SemiBold.withSize(18.0)
        self.rightLabel.font = self.isForPassenger ? AppFonts.Regular
            .withSize(18.0) : AppFonts.SemiBold.withSize(18.0)
    }
    
    private func setUpColor() {
        self.leftLabel.textColor = AppColors.themeBlack
        self.middleLabel.textColor = AppColors.themeBlack
        self.rightLabel.textColor = AppColors.themeBlack
    }

    func setData(forFlight: FlightDetail?, usingFor: UsingFor) {
        
        var leftLabelTxt = "Type"
        var middleLabelTxt = "Check-in"
        var rightLabelTxt = "Cabin"
        var font: UIFont? = AppFonts.SemiBold.withSize(18.0)
        
        let flight = forFlight ?? FlightDetail(json: [:])
        
        if usingFor == .adult {
            // adult
            leftLabelTxt = "Per Adult"
            middleLabelTxt = flight.baggage?.checkInBg?.adult ?? LocalizedString.na.localized
            rightLabelTxt = "\(flight.baggage?.cabinBg?.adult?.piece ?? "1") x \(flight.baggage?.cabinBg?.adult?.weight ?? "23 kgs")"
            font = AppFonts.Regular.withSize(18.0)
        }
        else if usingFor == .child {
            // child
            leftLabelTxt = "Per Child"
            middleLabelTxt = flight.baggage?.checkInBg?.child ?? LocalizedString.na.localized
            rightLabelTxt = "\(flight.baggage?.cabinBg?.child?.piece ?? "1") x \(flight.baggage?.cabinBg?.child?.weight ?? "23 kgs")"
            font = AppFonts.Regular.withSize(18.0)
        }
        else if usingFor == .infant {
            // infant
            leftLabelTxt = "Per Infant"
            middleLabelTxt = flight.baggage?.checkInBg?.infant ?? LocalizedString.na.localized
            rightLabelTxt = "\(flight.baggage?.cabinBg?.infant?.piece ?? "1") x \(flight.baggage?.cabinBg?.infant?.weight ?? "23 kgs")"
            font = AppFonts.Regular.withSize(18.0)
        }
        
        middleLabel.font = font
        rightLabel.font = font
        
        leftLabel.text = leftLabelTxt
        middleLabel.text = middleLabelTxt
        rightLabel.text = rightLabelTxt
    }
}
