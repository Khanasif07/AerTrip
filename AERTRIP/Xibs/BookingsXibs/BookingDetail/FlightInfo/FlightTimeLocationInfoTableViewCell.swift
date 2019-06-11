//
//  FlightTimeLocationInfoTableViewCell.swift
//  AERTRIP
//
//  Created by apple on 10/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightTimeLocationInfoTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    // source
    @IBOutlet weak var sourceFlightCodeLabel: UILabel!
    @IBOutlet weak var sourceDateLabel: UILabel!
    @IBOutlet weak var sourceFlightNameLbel: UILabel!
    @IBOutlet weak var sourceFlightAddressLabel: UILabel!
    @IBOutlet weak var sourceTerminalLabel: UILabel!
    
    // Destination
    @IBOutlet weak var destinationFlightCodeLabel: UILabel!
    @IBOutlet weak var destinationDateLabel: UILabel!
    @IBOutlet weak var destinationFlightNameLbel: UILabel!
    @IBOutlet weak var destinationFlightAddressLabel: UILabel!
    @IBOutlet weak var destinationTerminalLabel: UILabel!
    
    
    // Travel Time Label
    
    @IBOutlet weak var dayNightImageView: UIImageView!
    @IBOutlet weak var travelTimeLabel: UILabel!
    @IBOutlet weak var dottedView: UIView!
    @IBOutlet weak var wingNameLabel: UILabel!
    
    var flightDetail: FlightDetail? {
        didSet {
            self.configureCell()
        }
    }
    
    private let defaultStr = LocalizedString.na.localized
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dottedView.makeDottedLine()
        self.setUpFonts()
        self.setUpTextColor()
        
    }
    
    private func setToDefault() {

        // source
        self.sourceFlightCodeLabel.text = defaultStr
        self.sourceDateLabel.text = defaultStr
        self.sourceFlightNameLbel.text = defaultStr
        self.sourceFlightAddressLabel.text = defaultStr
        self.sourceTerminalLabel.text = defaultStr
        
        // Destination
        self.destinationFlightCodeLabel.text = defaultStr
        self.destinationDateLabel.text = defaultStr
        self.destinationFlightNameLbel.text = defaultStr
        self.destinationFlightAddressLabel.text = defaultStr
        self.destinationTerminalLabel.text = defaultStr
        
        
        // Travel
        
        self.travelTimeLabel.text = defaultStr
        self.wingNameLabel.text = defaultStr
    }
    
    private func configureCell() {
        
        guard let details = self.flightDetail else {
            self.setToDefault()
            return
        }
        
        // source
        let sourceTimeStr = "\(details.departure) \(details.departureTime)"
        let sourceAttr = NSMutableAttributedString(string: sourceTimeStr)
        sourceAttr.addAttributes([NSAttributedString.Key.font : AppFonts.Regular.withSize(23.0)], range: (sourceTimeStr as NSString).range(of: details.departure))
        self.sourceFlightCodeLabel.attributedText = sourceAttr
        self.sourceDateLabel.text = details.departDate.toDate(dateFormat: "yyyy-MM-dd")?.toString(dateFormat: "EEE, dd MMM yyyy") ?? defaultStr
        self.sourceFlightNameLbel.text = details.departureAirport
        self.sourceFlightAddressLabel.text = "\(details.departCity), \(details.departureCountryCode)"
        self.sourceTerminalLabel.text = details.departureTerminal
        
        // Destination
        let desTimeStr = "\(details.arrivalTime) \(details.arrival)"
        let destAttr = NSMutableAttributedString(string: sourceTimeStr)
        destAttr.addAttributes([NSAttributedString.Key.font : AppFonts.Regular.withSize(23.0)], range: (desTimeStr as NSString).range(of: details.arrival))
        self.destinationFlightCodeLabel.attributedText = destAttr
        self.destinationDateLabel.text = details.arrivalDate.toDate(dateFormat: "yyyy-MM-dd")?.toString(dateFormat: "EEE, dd MMM yyyy") ?? defaultStr
        self.destinationFlightNameLbel.text = details.arrivalAirport
        self.destinationFlightAddressLabel.text = "\(details.arrivalCity), \(details.arrivalCountryCode)"
        self.destinationTerminalLabel.text = details.arrivalTerminal
        
        
        // Travel
        self.travelTimeLabel.text = details.flightTime.asString(units: [.hour, .minute], style: .abbreviated)
        self.wingNameLabel.text = details.equipmentDetails
    }
    
    
    // MARK: - Helper methods
    
    private func setUpFonts() {
        self.sourceFlightCodeLabel.font = AppFonts.SemiBold.withSize(24.0)
        self.sourceDateLabel.font = AppFonts.Regular.withSize(14.0)
        self.sourceFlightNameLbel.font = AppFonts.Regular.withSize(14.0)
        self.sourceFlightAddressLabel.font = AppFonts.Regular.withSize(14.0)
        self.sourceTerminalLabel.font = AppFonts.Regular.withSize(14.0)
        
        //Destination
        self.destinationFlightCodeLabel.font = AppFonts.SemiBold.withSize(24.0)
        self.destinationDateLabel.font = AppFonts.Regular.withSize(14.0)
        self.destinationFlightNameLbel.font = AppFonts.Regular.withSize(14.0)
        self.destinationFlightAddressLabel.font = AppFonts.Regular.withSize(14.0)
        self.destinationTerminalLabel.font = AppFonts.Regular.withSize(14.0)
        
        // Travel Time
        self.travelTimeLabel.font = AppFonts.SemiBold.withSize(14.0)
        self.wingNameLabel.font = AppFonts.Regular.withSize(12.0)
        
    }
    
    private func setUpTextColor() {
        self.sourceFlightCodeLabel.textColor = AppColors.themeBlack
        self.sourceDateLabel.textColor = AppColors.themeBlack
        self.sourceFlightNameLbel.textColor = AppColors.themeGray40
        self.sourceFlightAddressLabel.textColor = AppColors.themeBlack
        self.sourceTerminalLabel.textColor = AppColors.themeBlack
        
        self.destinationFlightCodeLabel.textColor = AppColors.themeBlack
        self.destinationDateLabel.textColor = AppColors.themeBlack
        self.destinationFlightNameLbel.textColor = AppColors.themeGray40
        self.destinationFlightAddressLabel.textColor = AppColors.themeBlack
        self.destinationTerminalLabel.textColor = AppColors.themeBlack
        
        // Travel Time
        self.travelTimeLabel.textColor = AppColors.themeGray60
        self.wingNameLabel.textColor = AppColors.themeGray40
    }
    
}
