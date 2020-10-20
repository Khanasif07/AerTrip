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
    
    
    func setPerAdultCheckinBaggage(adtCheckinBaggage:JSONDictionary){
        if adtCheckinBaggage.count > 0{
            if let weight = adtCheckinBaggage["weight"] as? String, let pieces = adtCheckinBaggage["pieces"] as? String, let max_pieces = adtCheckinBaggage["max_pieces"] as? String, let max_weight = adtCheckinBaggage["max_weight"] as? String
            {
                if weight.lowercased() == "0 kg"{
                    perAdultCheckinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perAdultCheckinLabel.textColor = .black
                    perAdultCheckinLabel.text = "No Baggage"
                }else if weight == "" && pieces == "" && max_pieces == "" && max_weight == ""{
                    perAdultCheckinLabel.text = "No Info"
                }else{
                    if pieces == "" && max_pieces == "" && max_weight == ""{
                        if weight != "0 kg" {
                            perAdultCheckinLabel.text = weight
                        }else{
                            perAdultCheckinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                            perAdultCheckinLabel.textColor = .black
                            perAdultCheckinLabel.text = "No Baggage"
                        }
                    }
                    
                    if weight.lowercased() != "0 kg" && weight != "" && weight != "-9"{
                        perAdultCheckinLabel.text = weight
                    }
                    
                    if (weight == "0 Kg" && max_pieces == "" && max_weight == "") || (weight == "" && max_pieces == "" && max_weight == "") || (weight == "-9" && max_pieces == "" && max_weight == ""){
                        if pieces == "0 pc"{
                            perAdultCheckinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                            perAdultCheckinLabel.textColor = .black
                            perAdultCheckinLabel.text = "No Baggage"
                        }else{
                            let result = pieces + "*"
                            let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                            let fontSuper:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(12))
                            let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font!])
                            attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                            perAdultCheckinLabel.attributedText = attString
                        }
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
                                        let str2 = " (\(intPieces) pc X \(intmax_weight) kg)"
                                        let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                                        let fontSuper:UIFont? = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                        let attString:NSMutableAttributedString = NSMutableAttributedString(string: str1, attributes: [.font:font!])
                                        let attString1:NSMutableAttributedString = NSMutableAttributedString(string: str2, attributes: [.font:fontSuper!])
                                        
                                        attString.append(attString1)
                                        perAdultCheckinLabel.attributedText = attString
                                    }else{
                                        perAdultCheckinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                        perAdultCheckinLabel.textColor = .black
                                        perAdultCheckinLabel.text = "No Baggage"
                                    }
                                }
                            }
                        }else{
                            perAdultCheckinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                            perAdultCheckinLabel.textColor = .black
                            perAdultCheckinLabel.text = "No Baggage"
                        }
                        
                    }
                    
                    if weight != "" && max_pieces != ""{
                        let result = weight + "*"
                        let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                        let fontSuper:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(12))
                        let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font!])
                        attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                        perAdultCheckinLabel.attributedText = attString
                    }
                }
            }else if let weight = adtCheckinBaggage["weight"] as? Int{
                if weight == 0{
                    perAdultCheckinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perAdultCheckinLabel.textColor = .black
                    perAdultCheckinLabel.text = "No Baggage"
                }else if weight == -9{
                    perAdultCheckinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perAdultCheckinLabel.textColor = .black
                    perAdultCheckinLabel.text = "No Info"
                }else{
                    perAdultCheckinLabel.text = "\(weight)"
                }
            }else if let weight = adtCheckinBaggage["weight"] as? String{
                if weight == "0"{
                    perAdultCheckinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perAdultCheckinLabel.textColor = .black
                    perAdultCheckinLabel.text = "No Baggage"
                }else if weight == "-9"{
                    perAdultCheckinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perAdultCheckinLabel.textColor = .black
                    perAdultCheckinLabel.text = "No Info"
                }else if weight != "0 kg" {
                    perAdultCheckinLabel.text = weight
                }
            }
            
            perAdultView.isHidden = false
            perAdultViewHeight.constant = 30
        }else{
            perAdultView.isHidden = true
            perAdultViewHeight.constant = 0
            perAdultCheckinLabel.text = "NA"
        }
        
    }
    
    
    func setPerChildCheckinBaggage(chdCheckinBaggage:JSONDictionary){
        if chdCheckinBaggage.count > 0{
            if let weight = chdCheckinBaggage["weight"] as? String, let pieces = chdCheckinBaggage["pieces"] as? String, let max_pieces = chdCheckinBaggage["max_pieces"] as? String, let max_weight = chdCheckinBaggage["max_weight"] as? String{
                
                if weight == "0 Kg" || weight == "0 kg"{
                    perChildCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perChildCheckInLabel.textColor = .black
                    perChildCheckInLabel.text = "No Baggage"
                }else if weight == "" && pieces == "" && max_pieces == "" && max_weight == ""{
                    perChildCheckInLabel.text = "No Info"
                }else{
                    if pieces == "" && max_pieces == "" && max_weight == ""{
                        if weight != "0 kg" {
                            perChildCheckInLabel.text = weight
                        }else{
                            perChildCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                            perChildCheckInLabel.textColor = .black
                            perChildCheckInLabel.text = "No Baggage"
                        }
                    }
                    
                    if weight != "0 Kg" && weight != "" && weight != "-9"{
                        perChildCheckInLabel.text = weight
                    }
                    if (weight == "0 Kg" && max_pieces == "" && max_weight == "") || (weight == "" && max_pieces == "" && max_weight == "") || (weight == "-9" && max_pieces == "" && max_weight == ""){
                        if pieces == "0 pc"{
                            perChildCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                            perChildCheckInLabel.textColor = .black
                            perChildCheckInLabel.text = "No Baggage"
                        }else{
                            let result = pieces + "*"
                            let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                            let fontSuper:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(12))
                            let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font!])
                            attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                            perChildCheckInLabel.attributedText = attString
                        }
                    }
                    
                    if pieces != "" && max_weight != ""{
                        if pieces != "0 pc"{
                            let pc = pieces.components(separatedBy: " ")
                            let weights = max_weight.components(separatedBy: " ")
                            
                            if pc.count > 0, weights.count > 0{
                                if let intPieces = Int(pc[0]), let intmax_weight = Int(weights[0])
                                {
                                    if intmax_weight != 0{
                                        let str1 = "\(intmax_weight*intPieces) kg"
                                        let str2 = " (\(intPieces) pc X \(intmax_weight) kg)"
                                        let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                                        let fontSuper:UIFont? = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                        let attString:NSMutableAttributedString = NSMutableAttributedString(string: str1, attributes: [.font:font!])
                                        let attString1:NSMutableAttributedString = NSMutableAttributedString(string: str2, attributes: [.font:fontSuper!])
                                        
                                        attString.append(attString1)
                                        perChildCheckInLabel.attributedText = attString
                                    }else{
                                        perChildCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                        perChildCheckInLabel.textColor = .black
                                        perChildCheckInLabel.text = "No Baggage"
                                    }
                                }
                            }
                        }else{
                            perChildCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                            perChildCheckInLabel.textColor = .black
                            perChildCheckInLabel.text = "No Baggage"
                        }
                        
                    }
                    
                    if weight != "" && max_pieces != ""{
                        let result = weight + "*"
                        let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                        let fontSuper:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(12))
                        let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font!])
                        attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                        perChildCheckInLabel.attributedText = attString
                    }
                }
            }else if let weight = chdCheckinBaggage["weight"] as? String, let pieces = chdCheckinBaggage["pieces"] as? String, let max_pieces = chdCheckinBaggage["max_pieces"] as? String{
                
                if weight == "0 Kg" || weight == "0 kg"{
                    perChildCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perChildCheckInLabel.textColor = .black
                    perChildCheckInLabel.text = "No Baggage"
                }else if weight == "" && pieces == "" && max_pieces == ""{
                    perChildCheckInLabel.text = "No Info"
                }else{
                    if pieces == "" && max_pieces == ""{
                        if weight != "0 kg" {
                            perChildCheckInLabel.text = weight
                        }else{
                            perChildCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                            perChildCheckInLabel.textColor = .black
                            perChildCheckInLabel.text = "No Baggage"
                        }
                    }
                    
                    if weight == "" && max_pieces == ""{
                        if pieces == "0 pc"{
                            perChildCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                            perChildCheckInLabel.textColor = .black
                            perChildCheckInLabel.text = "No Baggage"
                        }else{
                            let result = pieces + "*"
                            let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                            let fontSuper:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(12))
                            let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font!])
                            attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                            perChildCheckInLabel.attributedText = attString
                        }
                    }
                    
                    if pieces != ""{
                        let result = pieces + "*"
                        let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                        let fontSuper:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(12))
                        let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font!])
                        attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                        perChildCheckInLabel.attributedText = attString
                    }
                    
                    if weight != "" && max_pieces != ""{
                        let result = weight + "*"
                        let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                        let fontSuper:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(12))
                        let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font!])
                        attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                        perChildCheckInLabel.attributedText = attString
                    }
                }
            }
            
            perChildView.isHidden = false
            perChildViewHeight.constant = 30
        }else{
            perChildView.isHidden = true
            perChildViewHeight.constant = 0
            perChildCheckInLabel.text = "NA"
        }
    }
    
    
    func setPerInfantCheckinBaggage(infCheckInBaggage:JSONDictionary){
        if infCheckInBaggage.count > 0{
            if let weight = infCheckInBaggage["weight"] as? String, let pieces = infCheckInBaggage["pieces"] as? String, let max_pieces = infCheckInBaggage["max_pieces"] as? String, let max_weight = infCheckInBaggage["max_weight"] as? String{
                if weight == "0 Kg" || weight == "0 kg"{
                    perInfantCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perInfantCheckInLabel.textColor = .black
                    perInfantCheckInLabel.text = "No Baggage"
                }else if weight == "" && pieces == "" && max_pieces == "" && max_weight == ""{
                    perInfantCheckInLabel.text = "No Info"
                    
                }else{
                    if pieces == "" && max_pieces == "" && max_weight == ""{
                        if weight != "0 kg" {
                            perInfantCheckInLabel.text = weight
                        }else{
                            perInfantCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                            perInfantCheckInLabel.textColor = .black
                            perInfantCheckInLabel.text = "No Baggage"
                        }
                    }
                    
                    if weight != "0 Kg" || weight != "" || weight != "0 kg"{
                        perInfantCheckInLabel.text = weight
                    }
                    
                    if weight == "" && max_pieces == "" && max_weight == ""{
                        if pieces == "0 pc"{
                            perInfantCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                            perInfantCheckInLabel.textColor = .black
                            perInfantCheckInLabel.text = "No Baggage"
                        }else{
                            let result = pieces + "*"
                            let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                            let fontSuper:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(12))
                            let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font!])
                            attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                            perInfantCheckInLabel.attributedText = attString
                        }
                    }
                    
                    if pieces != "" && max_weight != ""
                    {
                        if pieces != "0 pc"{
                            let pc = pieces.components(separatedBy: " ")
                            let weights = max_weight.components(separatedBy: " ")
                            if pc.count > 0, weights.count > 0{
                                if let intPieces = Int(pc[0]), let intmax_weight = Int(weights[0]){
                                    
                                    if intmax_weight != 0{
                                        let str1 = "\(intmax_weight*intPieces) kg"
                                        let str2 = " (\(intPieces) pc X \(intmax_weight)) kg)"
                                        let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                                        let fontSuper:UIFont? = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                        let attString:NSMutableAttributedString = NSMutableAttributedString(string: str1, attributes: [.font:font!])
                                        let attString1:NSMutableAttributedString = NSMutableAttributedString(string: str2, attributes: [.font:fontSuper!])
                                        
                                        attString.append(attString1)
                                        perInfantCheckInLabel.attributedText = attString
                                    }else{
                                        perInfantCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                        perInfantCheckInLabel.textColor = .black
                                        perInfantCheckInLabel.text = "No Baggage"
                                    }
                                }
                            }
                        }else{
                            perInfantCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                            perInfantCheckInLabel.textColor = .black
                            perInfantCheckInLabel.text = "No Baggage"
                        }
                        
                    }
                    
                    if weight != "" && max_pieces != ""{
                        if weight != "0 kg"{
                            let result = weight + "*"
                            let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                            let fontSuper:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(12))
                            let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font!])
                            attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                            
                            perInfantCheckInLabel.attributedText = attString
                        }else{
                            perInfantCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                            perInfantCheckInLabel.textColor = .black
                            perInfantCheckInLabel.text = "No Baggage"
                        }
                    }
                }
            }else if let weight = infCheckInBaggage["weight"] as? Int{
                if weight == 0{
                    perInfantCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perInfantCheckInLabel.textColor = .black
                    perInfantCheckInLabel.text = "No Baggage"
                }else if weight == -9{
                    perInfantCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perInfantCheckInLabel.textColor = .black
                    perInfantCheckInLabel.text = "No Info"
                }else{
                    perInfantCheckInLabel.text = "\(weight)"
                }
            }
            
            perInfantView.isHidden = false
            perInfantViewHeight.constant = 30
        }else{
            perInfantView.isHidden = true
            perInfantViewHeight.constant = 0
            perInfantCheckInLabel.text = "NA"
        }
    }
    
    
    func setPerAdultCabinBaggage(adtCabinBaggage:JSONDictionary){
        if adtCabinBaggage.count > 0{
            if let weight = adtCabinBaggage["weight"] as? String, let pieces = adtCabinBaggage["pieces"] as? String{
                if weight == "0 kg"{
                    perAdultCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perAdultCabinLabel.textColor = .black
                    perAdultCabinLabel.text = "No Baggage"
                }else if pieces == "0" && weight == "0 kg"{
                    perAdultCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perAdultCabinLabel.textColor = .black
                    perAdultCabinLabel.text = "No Baggage"
                }else if pieces == "" && weight == "" {
                    perAdultCabinLabel.text = "No Info"
                }else{
                    if pieces != "0 pc"{
                        let pc = pieces.components(separatedBy: " ")
                        let weights = weight.components(separatedBy: " ")
                        
                        if pc.count > 0, weights.count > 0{
                            if let intPieces = Int(pc[0]), let intWeight = Int(weights[0]){
                                if intWeight != 0{
                                    let str1 = "\(intWeight*intPieces) kg"
                                    let str2 = " (\(intPieces) pc X \(intWeight) kg)"
                                    let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                                    let fontSuper:UIFont? = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    let attString:NSMutableAttributedString = NSMutableAttributedString(string: str1, attributes: [.font:font!])
                                    let attString1:NSMutableAttributedString = NSMutableAttributedString(string: str2, attributes: [.font:fontSuper!])
                                    
                                    attString.append(attString1)
                                    perAdultCabinLabel.attributedText = attString
                                }else{
                                    perAdultCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    perAdultCabinLabel.textColor = .black
                                    perAdultCabinLabel.text = "No Baggage"
                                }
                            }
                        }
                    }else{
                        perAdultCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                        perAdultCabinLabel.textColor = .black
                        perAdultCabinLabel.text = "No Baggage"
                    }

                }
            }else if let weight = adtCabinBaggage["weight"] as? Int{
                if weight == 0{
                    perAdultCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perAdultCabinLabel.textColor = .black
                    perAdultCabinLabel.text = "No Baggage"
                }else if weight == -9{
                    perAdultCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perAdultCabinLabel.textColor = .black
                    perAdultCabinLabel.text = "No Info"
                }
            }else if let weight = adtCabinBaggage["weight"] as? String{
                if weight == "0"{
                    perAdultCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perAdultCabinLabel.textColor = .black
                    perAdultCabinLabel.text = "No Baggage"
                }else if weight == "-9"{
                    perAdultCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perAdultCabinLabel.textColor = .black
                    perAdultCabinLabel.text = "No Info"
                }
            }
        }else{
            perAdultCabinLabel.text = "NA"
        }
    }
    
    
    func setPerChildCabinBaggage(chdCabinBaggage:JSONDictionary){
        if chdCabinBaggage.count > 0{
            if let weight = chdCabinBaggage["weight"] as? String, let pieces = chdCabinBaggage["pieces"] as? String{
                if weight == "0 kg"{
                    perChildCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perChildCabinLabel.textColor = .black
                    perChildCabinLabel.text = "No Baggage"
                }else if pieces == "0" && weight == "0 kg"{
                    perChildCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perChildCabinLabel.textColor = .black
                    perChildCabinLabel.text = "No Baggage"
                }else if pieces == "" && weight == "" {
                    perChildCabinLabel.text = "No Info"
                }else{
                    if pieces != "0 pc"{
                        let pc = pieces.components(separatedBy: " ")
                        let weights = weight.components(separatedBy: " ")
                        
                        if pc.count > 0, weights.count > 0{
                            if let intPieces = Int(pc[0]), let intWeight = Int(weights[0]){
                                if intWeight != 0{
                                    let str1 = "\(intWeight*intPieces) kg"
                                    let str2 = " (\(intPieces) pc X \(intWeight) kg)"
                                    let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                                    let fontSuper:UIFont? = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    let attString:NSMutableAttributedString = NSMutableAttributedString(string: str1, attributes: [.font:font!])
                                    let attString1:NSMutableAttributedString = NSMutableAttributedString(string: str2, attributes: [.font:fontSuper!])
                                    
                                    attString.append(attString1)
                                    perChildCabinLabel.attributedText = attString
                                }else{
                                    perChildCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    perChildCabinLabel.textColor = .black
                                    perChildCabinLabel.text = "No Baggage"
                                }
                            }
                        }
                    }else{
                        perChildCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                        perChildCabinLabel.textColor = .black
                        perChildCabinLabel.text = "No Baggage"
                    }
                    
                }
            }else if let weight = chdCabinBaggage["weight"] as? Int{
                if weight == 0{
                    perChildCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perChildCabinLabel.textColor = .black
                    perChildCabinLabel.text = "No Baggage"
                }else if weight == -9{
                    perChildCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perChildCabinLabel.textColor = .black
                    perChildCabinLabel.text = "No Info"
                }
            }else if let weight = chdCabinBaggage["weight"] as? String{
                if weight == "0"{
                    perChildCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perChildCabinLabel.textColor = .black
                    perChildCabinLabel.text = "No Baggage"
                }else if weight == "-9"{
                    perChildCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perChildCabinLabel.textColor = .black
                    perChildCabinLabel.text = "No Info"
                }
            }
        }else{
            perChildCabinLabel.text = "NA"
        }
    }
    
    func setPerInfantCabinBaggage(infCabinBaggage:JSONDictionary){
        if infCabinBaggage.count > 0{
            if let weight = infCabinBaggage["weight"] as? String, let pieces = infCabinBaggage["pieces"] as? String{
                if weight == "0 kg"{
                    perInfantCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perInfantCabinLabel.textColor = .black
                    perInfantCabinLabel.text = "No Baggage"
                }else if pieces == "0" && weight == "0 kg"{
                    perInfantCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perInfantCabinLabel.textColor = .black
                    perInfantCabinLabel.text = "No Baggage"
                }else if pieces == "" && weight == "" {
                    perInfantCabinLabel.text = "No Info"
                }else{
                    if pieces != "0 pc"{
                        let pc = pieces.components(separatedBy: " ")
                        let weights = weight.components(separatedBy: " ")
                        
                        if pc.count > 0, weights.count > 0{
                            if let intPieces = Int(pc[0]), let intWeight = Int(weights[0]){
                                if intWeight != 0{
                                    let str1 = "\(intWeight*intPieces) kg"
                                    let str2 = " (\(intPieces) pc X \(intWeight) kg)"
                                    let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                                    let fontSuper:UIFont? = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    let attString:NSMutableAttributedString = NSMutableAttributedString(string: str1, attributes: [.font:font!])
                                    let attString1:NSMutableAttributedString = NSMutableAttributedString(string: str2, attributes: [.font:fontSuper!])
                                    
                                    attString.append(attString1)
                                    perInfantCabinLabel.attributedText = attString
                                }else{
                                    perInfantCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    perInfantCabinLabel.textColor = .black
                                    perInfantCabinLabel.text = "No Baggage"
                                }
                            }
                        }
                    }else{
                        perInfantCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                        perInfantCabinLabel.textColor = .black
                        perInfantCabinLabel.text = "No Baggage"
                    }
                    
                }
            }else if let weight = infCabinBaggage["weight"] as? Int{
                if weight == 0{
                    perInfantCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perInfantCabinLabel.textColor = .black
                    perInfantCabinLabel.text = "No Baggage"
                }else if weight == -9{
                    perInfantCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perInfantCabinLabel.textColor = .black
                    perInfantCabinLabel.text = "No Info"
                }
            }else if let weight = infCabinBaggage["weight"] as? String{
                if weight == "0"{
                    perInfantCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perInfantCabinLabel.textColor = .black
                    perInfantCabinLabel.text = "No Baggage"
                }else if weight == "-9"{
                    perInfantCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                    perInfantCabinLabel.textColor = .black
                    perInfantCabinLabel.text = "No Info"
                }
            }
        }else{
            perInfantCabinLabel.text = "NA"
        }
    }
}
