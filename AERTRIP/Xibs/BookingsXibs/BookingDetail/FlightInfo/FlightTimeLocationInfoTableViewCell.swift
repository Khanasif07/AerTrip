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
//    @IBOutlet weak var sourceNameHeightConstraint: NSLayoutConstraint!
//    @IBOutlet weak var desNameHeightConstraint: NSLayoutConstraint!
    
    
    // Travel Time Label
    
    @IBOutlet weak var dayNightImageView: UIImageView!
    @IBOutlet weak var travelTimeLabel: UILabel!
    @IBOutlet weak var dottedView: UIView!
    @IBOutlet weak var wingNameLabel: UILabel!
    @IBOutlet weak var moonIconHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var moonIconLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var travelTimeLableCenterConstraint: NSLayoutConstraint!
    
    var flightDetail: FlightDetail? {
        didSet {
            self.configureCell()
        }
    }
    
    private let defaultStr = ""//LocalizedString.na.localized
    
    var isMoonIConNeedToHide:Bool = false{
        didSet{
            configureMoonIcon()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFonts()
        self.setUpTextColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.dottedView.makeDottedLine()
        self.manageNameHeight()
    }
    
    private func setToDefault() {
        self.manageNameHeight()
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
        self.sourceDateLabel.text = self.checkForDefault(string: details.departDate?.toString(dateFormat: "EEE, dd MMM yyyy") ?? "")
        self.sourceFlightNameLbel.text = self.checkForDefault(string: details.departureAirport) == LocalizedString.na.localized ? LocalizedString.na.localized : self.checkForDefault(string: details.departureAirport) + ","
        
        let sAdd = "\(details.departCity), \(details.departureCountryCode)"
        self.sourceFlightAddressLabel.text = (sAdd.count > 1) ? sAdd : defaultStr
        self.sourceTerminalLabel.text = self.checkForDefault(string: details.departureTerminal)
        
        // Destination
        let desTimeStr = "\(details.arrivalTime) \(details.arrival)"
        let destAttr = NSMutableAttributedString(string: desTimeStr)
        destAttr.addAttributes([NSAttributedString.Key.font : AppFonts.Regular.withSize(23.0)], range: (desTimeStr as NSString).range(of: details.arrival))
        self.destinationFlightCodeLabel.attributedText = destAttr
        self.destinationDateLabel.text = self.checkForDefault(string: details.arrivalDate?.toString(dateFormat: "EEE, dd MMM yyyy") ?? "")
        self.destinationFlightNameLbel.text = self.checkForDefault(string: details.arrivalAirport) == LocalizedString.na.localized ? LocalizedString.na.localized : self.checkForDefault(string: details.arrivalAirport) + ","
        
        let dAdd = "\(details.arrivalCity), \(details.arrivalCountryCode)"
        self.destinationFlightAddressLabel.text = (dAdd.count > 1) ? dAdd : defaultStr
        self.destinationTerminalLabel.text = self.checkForDefault(string: details.arrivalTerminal)
        
        
        // Travel
        self.travelTimeLabel.text = details.flightTime.asString(units: [.hour, .minute], style: .abbreviated)
        self.wingNameLabel.text = details.equipmentDetails
        
        self.manageNameHeight()
    }
    
    private func checkForDefault(string: String) -> String {
        return string.isEmpty ? defaultStr : string
    }
    
    private func manageNameHeight() {
//        let sourceName = self.sourceFlightNameLbel.text ?? ""
//        let desName = self.destinationFlightNameLbel.text ?? ""
//        let textToCount = (sourceName.count > desName.count) ? sourceName : desName
//
//        var height = textToCount.sizeCount(withFont: AppFonts.Regular.withSize(14.0), bundingSize: CGSize(width: self.sourceFlightNameLbel.width, height: 10000.0)).height
//
//        if height <= 20.0 {
//            height = 20.0
//        }
//        else if height > 20.0 {
//            height = 40.0
//        }
//
//        self.sourceNameHeightConstraint.constant = height
//        self.desNameHeightConstraint.constant = height
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
 
    
    func configureMoonIcon(){
        moonIconHeightConstraint.constant = (isMoonIConNeedToHide) ? 0.0 : 12.0
        moonIconLeadingConstraint.constant = (isMoonIConNeedToHide) ? 0.0 : 5.0
        travelTimeLableCenterConstraint.constant = (isMoonIConNeedToHide) ? 0.0 : 8.5
    }
    
}
