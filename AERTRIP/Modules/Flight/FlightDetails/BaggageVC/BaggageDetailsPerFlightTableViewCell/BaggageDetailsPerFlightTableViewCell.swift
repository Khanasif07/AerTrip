//
//  BaggageDetailsPerFlightTableViewCell.swift
//  Aertrip
//
//  Created by Monika Sonawane on 20/09/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class BaggageDetailsPerFlightTableViewCell: UITableViewCell
{
    @IBOutlet weak var airlineLogoImageView: UIImageView!
    @IBOutlet weak var journeyTitleLabel: UILabel!
    @IBOutlet weak var dimensionsButton: UIButton!
    
    @IBOutlet weak var dataDisplayViewHeight: NSLayoutConstraint!
    @IBOutlet weak var perAdultView: UIView!
    @IBOutlet weak var perAdultViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var perChildView: UIView!
    @IBOutlet weak var perChildViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var perInfantView: UIView!
    @IBOutlet weak var perInfantViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var perAdultCheckinLabel: UILabel!
    @IBOutlet weak var perChildCheckInLabel: UILabel!
    @IBOutlet weak var perInfantCheckInLabel: UILabel!
    
    @IBOutlet weak var perAdultCabinLabel: UILabel!
    @IBOutlet weak var perChildCabinLabel: UILabel!
    @IBOutlet weak var perInfantCabinLabel: UILabel!
    
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var notesViewHeight: NSLayoutConstraint!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var notesLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var notesLabelTop: NSLayoutConstraint!
    
    @IBOutlet weak var bottomSeperator: ATDividerView!
    @IBOutlet weak var bottomSeperatorHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomSeperatorBottom: NSLayoutConstraint!
    
    @IBOutlet weak var topSeperatorView: ATDividerView!
    @IBOutlet weak var topSeperatorViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var flightDetailsView: UIView!
    @IBOutlet weak var flightDetailsViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var baggageDataDisplayView: UIView!
    @IBOutlet weak var baggageDataDisplayViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var noteLabelBottomConstraints: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        airlineLogoImageView.layer.cornerRadius = 3
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bottomSeperator.isHidden = true
    }
    
    func setPerAdultCheckinBaggage(adtCheckinBaggage:JSONDictionary)
    {
        if adtCheckinBaggage.count > 0{
            
            var isNewLineAdded = false
            
            let weight = adtCheckinBaggage["weight"] as? String ?? ""
            let pieces = adtCheckinBaggage["pieces"] as? String ?? ""
            let max_pieces = adtCheckinBaggage["max_pieces"] as? String ?? ""
            let max_weight = adtCheckinBaggage["max_weight"] as? String ?? ""
            
            if weight == "" && pieces == "" && max_pieces == "" && max_weight == ""{
                perAdultCheckinLabel.text = "No Info"
            }
            
            //  15 kg {API/DB gives weight. Max pieces NOT available from DB} {ignore max weight}
            
            if weight.lowercased() != "0 kg" && weight != "" && weight != "-9"{
                perAdultCheckinLabel.text = weight
            }else{
                perAdultCheckinLabel.font = AppFonts.Regular.withSize(14)
                perAdultCheckinLabel.textColor = .black
                perAdultCheckinLabel.text = "No Baggage"
            }
            
            
            
            //  21 kg* (21 kg: Max 3 pieces can be carried weighing total 21 kg.) {API/DB gives weight. Max pieces from DB} {ignore max weight}
            if  weight != "-9" && weight != "" && max_pieces != ""  && max_pieces != "0 pc"{
                let result = weight + "*"
                let font = AppFonts.SemiBold.withSize(16)
                let fontSuper = AppFonts.SemiBold.withSize(12)
                let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font])
                attString.setAttributes([.font:fontSuper,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                perAdultCheckinLabel.attributedText = attString
            }
            
            
            //   1 pc* (Most Airlines typically allow max 23 kg per piece) {API / DB gives Pieces. Max Weight NOT available from DB} {ignore weight}
            
            if pieces != "-9" && pieces != "" && pieces != "0 pc" && max_weight == ""
            {
                let result = pieces + "*"
                let font = AppFonts.SemiBold.withSize(16)
                let fontSuper = AppFonts.SemiBold.withSize(12)
                let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font])
                attString.setAttributes([.font:fontSuper,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                perAdultCheckinLabel.attributedText = attString
            }
            
            //30 kg (2 pc x 15 kg): Max 2 pieces of 15 kg each can be carried weighing total 30 kg.)
            if pieces != "" && max_weight != ""
            {
                if pieces != "0 pc"{
                    let pc = pieces.components(separatedBy: " ")
                    let weights = max_weight.components(separatedBy: " ")
                    
                    if pc.count > 0, weights.count > 0{
                        if let intmax_weight = Int(weights[0]), let intPieces = Int(pc[0]){
                            if intmax_weight != 0{
                                let str1 = "\(intmax_weight*intPieces) kg"
                                var str2 = ""
                                
                                if isSEDevice{
                                    isNewLineAdded = true
                                    str2 = "\n(\(intPieces) pc X \(intmax_weight) kg)*"
                                }else{
                                    isNewLineAdded = false
                                    str2 = " (\(intPieces) pc X \(intmax_weight) kg)*"
                                }
                                let font = AppFonts.SemiBold.withSize(16)
                                let fontSuper = AppFonts.Regular.withSize(14)
                                let attString:NSMutableAttributedString = NSMutableAttributedString(string: str1, attributes: [.font:font])
                                let attString1:NSMutableAttributedString = NSMutableAttributedString(string: str2, attributes: [.font:fontSuper])
                                attString1.setAttributes([.baselineOffset:5], range: NSRange(location:str2.count-1,length:1))

                                attString.append(attString1)
                                perAdultCheckinLabel.attributedText = attString
                            }else{
                                perAdultCheckinLabel.font = AppFonts.Regular.withSize(14)
                                perAdultCheckinLabel.textColor = .black
                                perAdultCheckinLabel.text = "No Baggage"
                            }
                        }
                    }
                }else{
                    perAdultCheckinLabel.font = AppFonts.Regular.withSize(14)
                    perAdultCheckinLabel.textColor = .black
                    perAdultCheckinLabel.text = "No Baggage"
                }
            }
            
            
            if isNewLineAdded{
                perAdultViewHeight.constant = 45
            }else{
                perAdultViewHeight.constant = 30
            }
            
        }else{
            perAdultView.isHidden = true
            perAdultViewHeight.constant = 0
            perAdultCheckinLabel.text = "NA"
        }
    }
    
    
    func setPerChildCheckinBaggage(chdCheckinBaggage:JSONDictionary)
    {
        var isNewLineAdded = false
        if chdCheckinBaggage.count > 0{
            let weight = chdCheckinBaggage["weight"] as? String ?? ""
            let pieces = chdCheckinBaggage["pieces"] as? String ?? ""
            let max_pieces = chdCheckinBaggage["max_pieces"] as? String ?? ""
            let max_weight = chdCheckinBaggage["max_weight"] as? String ?? ""
            
            if weight == "" && pieces == "" && max_pieces == "" && max_weight == ""{
                perChildCheckInLabel.text = "No Info"
            }
            
            //  15 kg {API/DB gives weight. Max pieces NOT available from DB} {ignore max weight}
            
            if weight.lowercased() != "0 kg" && weight != "" && weight != "-9"{
                perChildCheckInLabel.text = weight
            }else{
                perChildCheckInLabel.font = AppFonts.Regular.withSize(14)
                perChildCheckInLabel.textColor = .black
                perChildCheckInLabel.text = "No Baggage"
            }
            
            //  21 kg* (21 kg: Max 3 pieces can be carried weighing total 21 kg.) {API/DB gives weight. Max pieces from DB} {ignore max weight}
            if weight != "-9" && weight != "" && max_pieces != ""  && max_pieces != "0 pc"{
                let result = weight + "*"
                let font = AppFonts.SemiBold.withSize(16)
                let fontSuper = AppFonts.SemiBold.withSize(12)
                let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font])
                attString.setAttributes([.font:fontSuper,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                perChildCheckInLabel.attributedText = attString
            }
            
            //  1 pc* (Most Airlines typically allow max 23 kg per piece) {API / DB gives Pieces. Max Weight NOT available from DB} {ignore weight}
            
            if pieces != "-9" && pieces != "" && pieces != "0 pc" && max_weight == ""
            {
                let result = pieces + "*"
                let font = AppFonts.SemiBold.withSize(16)
                let fontSuper = AppFonts.SemiBold.withSize(12)
                let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font])
                attString.setAttributes([.font:fontSuper,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                perChildCheckInLabel.attributedText = attString
            }
            
            if pieces != "" && max_weight != ""
            {
                if pieces != "0 pc"{
                    let pc = pieces.components(separatedBy: " ")
                    let weights = max_weight.components(separatedBy: " ")
                    
                    if pc.count > 0, weights.count > 0{
                        if let intmax_weight = Int(weights[0]), let intPieces = Int(pc[0]){
                            if intmax_weight != 0{
                                let str1 = "\(intmax_weight*intPieces) kg"
                                var str2 = ""
                                if isSEDevice{
                                    isNewLineAdded = true
                                    str2 = "\n(\(intPieces) pc X \(intmax_weight) kg)*"
                                }else{
                                    isNewLineAdded = false
                                    str2 = " (\(intPieces) pc X \(intmax_weight) kg)*"
                                }
                                let font = AppFonts.SemiBold.withSize(16)
                                let fontSuper = AppFonts.Regular.withSize(14)
                                let attString:NSMutableAttributedString = NSMutableAttributedString(string: str1, attributes: [.font:font])
                                let attString1:NSMutableAttributedString = NSMutableAttributedString(string: str2, attributes: [.font:fontSuper])
                                attString1.setAttributes([.baselineOffset:5], range: NSRange(location:str2.count-1,length:1))
                                attString.append(attString1)
                                perChildCheckInLabel.attributedText = attString
                            }else{
                                perChildCheckInLabel.font = AppFonts.Regular.withSize(14)
                                perChildCheckInLabel.textColor = .black
                                perChildCheckInLabel.text = "No Baggage"
                            }
                        }
                    }
                }else{
                    perChildCheckInLabel.font = AppFonts.Regular.withSize(14)
                    perChildCheckInLabel.textColor = .black
                    perChildCheckInLabel.text = "No Baggage"
                }
                
                
                if isNewLineAdded{
                    perChildViewHeight.constant = 45
                }else{
                    perChildViewHeight.constant = 30
                }
            }
        }else{
            perChildView.isHidden = true
            perChildViewHeight.constant = 0
            perChildCheckInLabel.text = "NA"
        }
    }
    
    func setPerInfantCheckinBaggage(infCheckInBaggage:JSONDictionary)
    {
        var isNewLineAdded = false
        if infCheckInBaggage.count > 0{
            let weight = infCheckInBaggage["weight"] as? String ?? ""
            let pieces = infCheckInBaggage["pieces"] as? String ?? ""
            let max_pieces = infCheckInBaggage["max_pieces"] as? String ?? ""
            let max_weight = infCheckInBaggage["max_weight"] as? String ?? ""
            
            if weight == "" && pieces == "" && max_pieces == "" && max_weight == ""{
                perInfantCheckInLabel.text = "No Info"
            }
            
            //  15 kg {API/DB gives weight. Max pieces NOT available from DB} {ignore max weight}
            
            if weight.lowercased() != "0 kg" && weight != "" && weight != "-9"{
                perInfantCheckInLabel.text = weight
            }else{
                perInfantCheckInLabel.font = AppFonts.Regular.withSize(14)
                perInfantCheckInLabel.textColor = .black
                perInfantCheckInLabel.text = "No Baggage"
            }
            
            
            
            //   21 kg* (21 kg: Max 3 pieces can be carried weighing total 21 kg.) {API/DB gives weight. Max pieces from DB} {ignore max weight}
            if weight != "-9" && weight != "" && max_pieces != ""  && max_pieces != "0 pc"{
                let result = weight + "*"
                let font = AppFonts.SemiBold.withSize(16)
                let fontSuper = AppFonts.SemiBold.withSize(12)
                let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font])
                attString.setAttributes([.font:fontSuper,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                perInfantCheckInLabel.attributedText = attString
            }
            
            
            //   1 pc* (Most Airlines typically allow max 23 kg per piece) {API / DB gives Pieces. Max Weight NOT available from DB} {ignore weight}
            
            if pieces != "-9" && pieces != "" && pieces != "0 pc" && max_weight == ""
            {
                let result = pieces + "*"
                let font = AppFonts.SemiBold.withSize(16)
                let fontSuper = AppFonts.SemiBold.withSize(12)
                let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font])
                attString.setAttributes([.font:fontSuper,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                perInfantCheckInLabel.attributedText = attString
            }
            
            if pieces != "" && max_weight != ""
            {
                if pieces != "0 pc"{
                    let pc = pieces.components(separatedBy: " ")
                    let weights = max_weight.components(separatedBy: " ")
                    
                    if pc.count > 0, weights.count > 0{
                        if let intmax_weight = Int(weights[0]), let intPieces = Int(pc[0]){
                            if intmax_weight != 0{
                                let str1 = "\(intmax_weight*intPieces) kg"
                                
                                var str2 = ""
                                
                                if isSEDevice{
                                    isNewLineAdded = true
                                    str2 = "\n(\(intPieces) pc X \(intmax_weight) kg)*"
                                }else{
                                    isNewLineAdded = false
                                    str2 = " (\(intPieces) pc X \(intmax_weight) kg)*"
                                }
                                let font = AppFonts.SemiBold.withSize(16)
                                let fontSuper = AppFonts.Regular.withSize(14)
                                let attString:NSMutableAttributedString = NSMutableAttributedString(string: str1, attributes: [.font:font])
                                let attString1:NSMutableAttributedString = NSMutableAttributedString(string: str2, attributes: [.font:fontSuper])
                                attString1.setAttributes([.baselineOffset:5], range: NSRange(location:str2.count-1,length:1))
                                attString.append(attString1)
                                perInfantCheckInLabel.attributedText = attString
                            }else{
                                perInfantCheckInLabel.font = AppFonts.Regular.withSize(14)
                                perInfantCheckInLabel.textColor = .black
                                perInfantCheckInLabel.text = "No Baggage"
                            }
                        }
                        
                        if isNewLineAdded{
                            perInfantViewHeight.constant = 45
                        }else{
                            perInfantViewHeight.constant = 30
                        }
                    }
                }else{
                    perInfantCheckInLabel.font = AppFonts.Regular.withSize(14)
                    perInfantCheckInLabel.textColor = .black
                    perInfantCheckInLabel.text = "No Baggage"
                }
            }
        }
    }
    
    func setPerAdultCabinBaggage(adtCabinBaggage:JSONDictionary)
    {
        if adtCabinBaggage.count > 0{
            if let weight = adtCabinBaggage["weight"] as? String, let pieces = adtCabinBaggage["pieces"] as? String{
                if weight.lowercased() != "0 kg" && weight != "" && weight != "-9"{
                    dimensionsButton.isHidden = false
                    dimensionsButton.isUserInteractionEnabled = true
                }else{
                    dimensionsButton.isHidden = true
                    dimensionsButton.isUserInteractionEnabled = false
                }
                
                if weight == "0 kg"{
                    perAdultCabinLabel.font = AppFonts.Regular.withSize(14)
                    perAdultCabinLabel.textColor = .black
                    perAdultCabinLabel.text = "No Baggage"
                }else if pieces == "0" && weight == "0 kg"{
                    perAdultCabinLabel.font = AppFonts.Regular.withSize(14)
                    perAdultCabinLabel.textColor = .black
                    perAdultCabinLabel.text = "No Baggage"
                }else if pieces == "" && weight == "" {
                    perAdultCabinLabel.text = "No Info"
                }else{
                    if pieces != "0 pc" && pieces != "-9" {
                        let pc = pieces.components(separatedBy: " ")
                        let weights = weight.components(separatedBy: " ")
                        
                        if pc.count > 0, weights.count > 0{
                            if let intPieces = Int(pc[0]), let intWeight = Int(weights[0]){
                                if intWeight != 0{
                                    let str1 = "\(intWeight*intPieces) kg"
                                    let str2 = " (\(intPieces) pc X \(intWeight) kg)"
                                    
                                    let font = AppFonts.SemiBold.withSize(16)
                                    let fontSuper = AppFonts.Regular.withSize(14)
                                    
                                    let attString:NSMutableAttributedString = NSMutableAttributedString(string: str1, attributes: [.font:font])
                                    let attString1:NSMutableAttributedString = NSMutableAttributedString(string: str2, attributes: [.font:fontSuper])
                                    
                                    attString.append(attString1)
                                    perAdultCabinLabel.attributedText = attString
                                }else{
                                    perAdultCabinLabel.font = AppFonts.Regular.withSize(14)
                                    perAdultCabinLabel.textColor = .black
                                    perAdultCabinLabel.text = "No Baggage"
                                }
                            }
                        }
                    }else{
                        perAdultCabinLabel.font = AppFonts.Regular.withSize(14)
                        perAdultCabinLabel.textColor = .black
                        perAdultCabinLabel.text = "No Baggage"
                    }
                }
            }else if let weight = adtCabinBaggage["weight"] as? Int{
                
                if weight != 0 && weight != -9{
                    dimensionsButton.isHidden = false
                    dimensionsButton.isUserInteractionEnabled = true
                }else{
                    dimensionsButton.isHidden = true
                    dimensionsButton.isUserInteractionEnabled = false
                }
                if weight == 0{
                    perAdultCabinLabel.font = AppFonts.Regular.withSize(14)
                    perAdultCabinLabel.textColor = .black
                    perAdultCabinLabel.text = "No Baggage"
                }else if weight == -9{
                    perAdultCabinLabel.font = AppFonts.Regular.withSize(14)
                    perAdultCabinLabel.textColor = .black
                    perAdultCabinLabel.text = "No Info"
                }
            }else if let weight = adtCabinBaggage["weight"] as? String{
                
                if weight.lowercased() != "0 kg" && weight != "" && weight != "-9"{
                    dimensionsButton.isHidden = false
                    dimensionsButton.isUserInteractionEnabled = true
                }else{
                    dimensionsButton.isHidden = true
                    dimensionsButton.isUserInteractionEnabled = false
                }
                if weight == "0"{
                    perAdultCabinLabel.font = AppFonts.Regular.withSize(14)
                    perAdultCabinLabel.textColor = .black
                    perAdultCabinLabel.text = "No Baggage"
                }else if weight == "-9"{
                    perAdultCabinLabel.font = AppFonts.Regular.withSize(14)
                    perAdultCabinLabel.textColor = .black
                    perAdultCabinLabel.text = "No Info"
                }
            }
        }else{
            perAdultCabinLabel.text = "NA"
        }
    }
    
    
    func setPerChildCabinBaggage(chdCabinBaggage:JSONDictionary)
    {
        if chdCabinBaggage.count > 0{
            if let weight = chdCabinBaggage["weight"] as? String, let pieces = chdCabinBaggage["pieces"] as? String{
                if weight == "0 kg"{
                    perChildCabinLabel.font = AppFonts.Regular.withSize(14)
                    perChildCabinLabel.textColor = .black
                    perChildCabinLabel.text = "No Baggage"
                }else if pieces == "0" && weight == "0 kg"{
                    perChildCabinLabel.font = AppFonts.Regular.withSize(14)
                    perChildCabinLabel.textColor = .black
                    perChildCabinLabel.text = "No Baggage"
                }else if pieces == "" && weight == "" {
                    perChildCabinLabel.text = "No Info"
                }else{
                    if pieces != "0 pc" && pieces != "-9"{
                        let pc = pieces.components(separatedBy: " ")
                        let weights = weight.components(separatedBy: " ")
                        
                        if pc.count > 0, weights.count > 0{
                            if let intPieces = Int(pc[0]), let intWeight = Int(weights[0]){
                                if intWeight != 0{
                                    let str1 = "\(intWeight*intPieces) kg"
                                    let str2 = " (\(intPieces) pc X \(intWeight) kg)"
                                    
                                    let font = AppFonts.SemiBold.withSize(16)
                                    let fontSuper = AppFonts.Regular.withSize(14)
                                    
                                    let attString:NSMutableAttributedString = NSMutableAttributedString(string: str1, attributes: [.font:font])
                                    let attString1:NSMutableAttributedString = NSMutableAttributedString(string: str2, attributes: [.font:fontSuper])
                                    
                                    attString.append(attString1)
                                    perChildCabinLabel.attributedText = attString
                                }else{
                                    perChildCabinLabel.font = AppFonts.Regular.withSize(14)
                                    perChildCabinLabel.textColor = .black
                                    perChildCabinLabel.text = "No Baggage"
                                }
                            }
                        }
                    }else{
                        perChildCabinLabel.font = AppFonts.Regular.withSize(14)
                        perChildCabinLabel.textColor = .black
                        perChildCabinLabel.text = "No Baggage"
                    }
                }
            }else if let weight = chdCabinBaggage["weight"] as? Int{
                if weight == 0{
                    perChildCabinLabel.font = AppFonts.Regular.withSize(14)
                    perChildCabinLabel.textColor = .black
                    perChildCabinLabel.text = "No Baggage"
                }else if weight == -9{
                    perChildCabinLabel.font = AppFonts.Regular.withSize(14)
                    perChildCabinLabel.textColor = .black
                    perChildCabinLabel.text = "No Info"
                }
            }else if let weight = chdCabinBaggage["weight"] as? String{
                if weight == "0"{
                    perChildCabinLabel.font = AppFonts.Regular.withSize(14)
                    perChildCabinLabel.textColor = .black
                    perChildCabinLabel.text = "No Baggage"
                }else if weight == "-9"{
                    perChildCabinLabel.font = AppFonts.Regular.withSize(14)
                    perChildCabinLabel.textColor = .black
                    perChildCabinLabel.text = "No Info"
                }
            }
        }else{
            perChildCabinLabel.text = "NA"
        }
    }
    
    func setPerInfantCabinBaggage(infCabinBaggage:JSONDictionary)
    {
        if infCabinBaggage.count > 0{
            if let weight = infCabinBaggage["weight"] as? String, let pieces = infCabinBaggage["pieces"] as? String{
                if weight == "0 kg"{
                    perInfantCabinLabel.font = AppFonts.Regular.withSize(14)
                    perInfantCabinLabel.textColor = .black
                    perInfantCabinLabel.text = "No Baggage"
                }else if pieces == "0" && weight == "0 kg"{
                    perInfantCabinLabel.font = AppFonts.Regular.withSize(14)
                    perInfantCabinLabel.textColor = .black
                    perInfantCabinLabel.text = "No Baggage"
                }else if pieces == "" && weight == "" {
                    perInfantCabinLabel.text = "No Info"
                }else{
                    if pieces != "0 pc" && pieces != "-9"{
                        let pc = pieces.components(separatedBy: " ")
                        let weights = weight.components(separatedBy: " ")
                        
                        if pc.count > 0, weights.count > 0{
                            if let intPieces = Int(pc[0]), let intWeight = Int(weights[0]){
                                if intWeight != 0{
                                    let str1 = "\(intWeight*intPieces) kg"
                                    let str2 = " (\(intPieces) pc X \(intWeight) kg)"
                                    
                                    let font = AppFonts.SemiBold.withSize(16)
                                    let fontSuper = AppFonts.Regular.withSize(14)
                                    
                                    let attString:NSMutableAttributedString = NSMutableAttributedString(string: str1, attributes: [.font:font])
                                    let attString1:NSMutableAttributedString = NSMutableAttributedString(string: str2, attributes: [.font:fontSuper])
                                    
                                    attString.append(attString1)
                                    perInfantCabinLabel.attributedText = attString
                                }else{
                                    perInfantCabinLabel.font = AppFonts.Regular.withSize(14)
                                    perInfantCabinLabel.textColor = .black
                                    perInfantCabinLabel.text = "No Baggage"
                                }
                            }
                        }
                    }else{
                        perInfantCabinLabel.font = AppFonts.Regular.withSize(14)
                        perInfantCabinLabel.textColor = .black
                        perInfantCabinLabel.text = "No Baggage"
                    }
                }
            }else if let weight = infCabinBaggage["weight"] as? Int{
                if weight == 0{
                    perInfantCabinLabel.font = AppFonts.Regular.withSize(14)
                    perInfantCabinLabel.textColor = .black
                    perInfantCabinLabel.text = "No Baggage"
                }else if weight == -9{
                    perInfantCabinLabel.font = AppFonts.Regular.withSize(14)
                    perInfantCabinLabel.textColor = .black
                    perInfantCabinLabel.text = "No Info"
                }
            }else if let weight = infCabinBaggage["weight"] as? String{
                if weight == "0"{
                    perInfantCabinLabel.font = AppFonts.Regular.withSize(14)
                    perInfantCabinLabel.textColor = .black
                    perInfantCabinLabel.text = "No Baggage"
                }else if weight == "-9"{
                    perInfantCabinLabel.font = AppFonts.Regular.withSize(14)
                    perInfantCabinLabel.textColor = .black
                    perInfantCabinLabel.text = "No Info"
                }
            }
        }else{
            perInfantCabinLabel.text = "NA"
        }
    }
}
