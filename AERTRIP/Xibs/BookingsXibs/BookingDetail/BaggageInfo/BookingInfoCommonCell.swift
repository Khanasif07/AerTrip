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
    
    @IBOutlet weak var viewTopConstraint: NSLayoutConstraint!
    // MARK: - Variables
    var isForPassenger : Bool = false
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.leftLabel.text = ""
        self.middleLabel.text = ""
        self.rightLabel.text = ""
        self.leftLabel.attributedText = nil
        self.middleLabel.attributedText = nil
        self.rightLabel.attributedText = nil

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setUpFont()
        self.setUpColor()
        
    }
    
    private func setUpFont() {
        self.leftLabel.font = AppFonts.Regular.withSize(16.0)
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
        setUpColor()
        var font: UIFont? = AppFonts.SemiBold.withSize(18.0)
        
        let flight = forFlight ?? FlightDetail(json: [:])
        
        if usingFor == .adult {
            // adult
            leftLabelTxt = "Per Adult"
            if let object = flight.baggage?.checkInBg?.adult {
                middleLabelTxt = getCheckInDataToShow(info: object)
            } else {
                middleLabelTxt = LocalizedString.na.localized
            }
            if let object = flight.baggage?.cabinBg?.adult {
                rightLabelTxt = getCabInDataToShow(info: object)
            } else {
                rightLabelTxt = LocalizedString.na.localized
            }
            
            font = AppFonts.Regular.withSize(14.0)
        }
        else if usingFor == .child {
            // child
            leftLabelTxt = "Per Child"
            if let object = flight.baggage?.checkInBg?.child {
                middleLabelTxt = getCheckInDataToShow(info: object)
            } else {
                middleLabelTxt = LocalizedString.na.localized
            }
            if let object = flight.baggage?.cabinBg?.child {
                rightLabelTxt = getCabInDataToShow(info: object)
            } else {
                rightLabelTxt = LocalizedString.na.localized
            }
            font = AppFonts.Regular.withSize(14.0)
        }
        else if usingFor == .infant {
            // infant
            leftLabelTxt = "Per Infant"
            if let object = flight.baggage?.checkInBg?.infant {
                middleLabelTxt = getCheckInDataToShow(info: object)
            } else {
                middleLabelTxt = LocalizedString.na.localized
            }
            if let object = flight.baggage?.cabinBg?.infant {
                rightLabelTxt = getCabInDataToShow(info: object)
            } else {
                rightLabelTxt = LocalizedString.na.localized
            }
            font = AppFonts.Regular.withSize(14.0)
        } else if usingFor == .title {
            font = AppFonts.Regular.withSize(16.0)
        }

        middleLabel.font = font
        rightLabel.font = font
        
        if middleLabelTxt == LocalizedString.NoBaggage.localized {
            middleLabel.textColor = AppColors.themeRed
        }
        if rightLabelTxt == LocalizedString.NoBaggage.localized {
            rightLabel.textColor = AppColors.themeRed
        }
        leftLabel.text = leftLabelTxt
        middleLabel.text = middleLabelTxt
        rightLabel.text = rightLabelTxt
        
        if usingFor != .title {
            
        middleLabel.AttributedFontColorForText(text: LocalizedString.NoBaggage.localized, textColor: AppColors.themeRed)
        rightLabel.AttributedFontColorForText(text: LocalizedString.NoBaggage.localized, textColor: AppColors.themeRed)
            
        middleLabel.AttributedFontForText(text: middleLabelTxt.components(separatedBy: "(").first ?? "", textFont: AppFonts.SemiBold.withSize(16.0))
        rightLabel.AttributedFontForText(text: rightLabelTxt.components(separatedBy: "(").first ?? "", textFont: AppFonts.SemiBold.withSize(16.0))
            
            middleLabel.AttributedFontForText(text: LocalizedString.NoInfo.localized, textFont: AppFonts.Regular.withSize(14.0))
            rightLabel.AttributedFontForText(text: LocalizedString.NoInfo.localized, textFont: AppFonts.Regular.withSize(14.0))
            viewTopConstraint.constant = 8.0
        } else {
            viewTopConstraint.constant = 0.0
        }

    }
    
    
    private func getCheckInDataToShow(info: BaggageInfo) -> String {
        
        let weight = info.weight
        let pieces = info.piece
        let max_pieces = info.maxPieces
        let max_weight = info.maxWeight
        
        
        if weight == "0" || weight == "0 Kg"{
            return LocalizedString.NoBaggage.localized
        }else if weight == "-9"{
            return LocalizedString.NoInfo.localized
        }else if !weight.isEmpty && max_weight.isEmpty && max_pieces.isEmpty && (pieces == "0 pc" || pieces == "0" || pieces == ""){
            return weight // only weight present
        }else if !pieces.isEmpty && weight.isEmpty && max_weight.isEmpty && max_pieces.isEmpty {
            if pieces == "0 pc" || pieces == "0" {
                return LocalizedString.NoBaggage.localized
            }
            return pieces // only pieces present
        }
        else if !max_weight.isEmpty && !pieces.isEmpty && weight.isEmpty && max_pieces.isEmpty {
            // only max_weight and  pieces present
            if pieces == "0 pc" || pieces == "0" {
                return LocalizedString.NoBaggage.localized
            }
            let pc = pieces.components(separatedBy: " ")
            let weights = max_weight.components(separatedBy: " ")
            
            if pc.count > 0, weights.count > 0{
                if let intmax_weight = Int(weights[0]), let intPieces = Int(pc[0]){
                    if intmax_weight != 0{
                        let str1 = "\(intmax_weight*intPieces) kg"
                        let str2 = " (\(intPieces) pc X \(intmax_weight) kg)"
                        return str1 + str2
                    }else{
                        return LocalizedString.NoBaggage.localized
                    }
                }
            }
        }else if !weight.isEmpty && !max_pieces.isEmpty && max_weight.isEmpty && (pieces == "0 pc" || pieces == "0" || pieces == "") {
            // only weight and  max_pieces present
            return weight + "*"
        }
        return LocalizedString.na.localized.uppercased()
        
    }
    
    private func getCabInDataToShow(info: BaggageInfo) -> String {
        
        let weight = info.weight
        let pieces = info.piece
        
        if weight == "0" || weight == "0 Kg"{
            return LocalizedString.NoBaggage.localized
        }else if weight == "-9"{
            return LocalizedString.NoInfo.localized
        }else if !weight.isEmpty && (pieces == "0 pc" || pieces == "0" || pieces == ""){
            return weight // only weight present
        }else if !pieces.isEmpty && weight.isEmpty {
            if pieces == "0 pc" || pieces == "0" {
                return LocalizedString.NoBaggage.localized
            }
            return pieces // only pieces present
        }else if !pieces.isEmpty && !weight.isEmpty {
            if pieces == "0 pc" || pieces == "0" {
                return LocalizedString.NoBaggage.localized
            }
            
            let pc = pieces.components(separatedBy: " ")
            let weights = weight.components(separatedBy: " ")
            
            if pc.count > 0, weights.count > 0{
                if let intPieces = Int(pc[0]), let intWeight = Int(weights[0]){
                    if intWeight != 0{
                        let str1 = "\(intWeight*intPieces) kg"
                        let str2 = " (\(intPieces) pc X \(intWeight) kg)"
                        return str1 + str2
                    }else{
                        return LocalizedString.NoBaggage.localized
                    }
                }
            }
        }
        return LocalizedString.na.localized.uppercased()
        
    }
    
}
