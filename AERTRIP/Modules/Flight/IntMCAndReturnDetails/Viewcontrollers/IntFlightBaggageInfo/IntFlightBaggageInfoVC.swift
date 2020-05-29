//
//  IntFlightBaggageInfoVC.swift
//  Aertrip
//
//  Created by Apple  on 03.05.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import UIKit

class IntFlightBaggageInfoVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    //MARK:- Outlets
    @IBOutlet weak var baggageTableView: UITableView!
    @IBOutlet weak var baggageTableViewBottom: NSLayoutConstraint!
    
    //MARK:- Variable Declaration
    var journey: IntJourney?
    var airportDetailsResult : [String : IntAirportDetailsWS]!
    var sid = ""
    var evaluatedBaggageResp = [[NSDictionary]]()
    
    var isCheckinBaggageHasPieces = false
    var isCabinBaggageHasPieces = false
    var isAdultBaggageWithPiece = false
    var isChildBaggageWithPiece = false
    var isInfantBaggageWithPiece = false
    
    var adultBaggage = ""
    var childBaggage = ""
    var infantBaggage = ""
    
    var attStringArray = [String]()
    var combineString = ""
    var piecesArray = [String]()
    var weightArray = [String]()
    var fewSeatsLeftViewHeight = 0
    var dataResp = [NSDictionary]()

    //MARK:- Initialise Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baggageTableView.register(UINib(nibName: "BaggageDetailsPerFlightTableViewCell", bundle: nil), forCellReuseIdentifier: "BaggageDetailsPerFlightCell")
        baggageTableView.register(UINib(nibName: "ChangeAirportTableViewCell", bundle: nil), forCellReuseIdentifier: "ChangeAirportCell")
        
        baggageTableView.rowHeight = UITableView.automaticDimension
        baggageTableView.estimatedRowHeight = 175
        baggageTableView.alwaysBounceVertical = true
        baggageTableView.separatorStyle = .none
        
        switch UIScreen.main.bounds.height{
        case 568: //iPhone SE | 5S
            baggageTableViewBottom.constant = CGFloat(310 + fewSeatsLeftViewHeight)
            break
            
        case 667: //iPhone 8 | 6 | 6s | 7
            baggageTableViewBottom.constant = CGFloat(210 + fewSeatsLeftViewHeight)
            break
            
        case 736: //iPhone 6 Plus | 8 plus | 6s plus | 7 Plus
            baggageTableViewBottom.constant = CGFloat(145 + fewSeatsLeftViewHeight)
            break
            
        case 812: //11 Pro | X | Xs
            baggageTableViewBottom.constant = CGFloat(98 + fewSeatsLeftViewHeight)
            break
            
        case 896: //11 & 11 Pro Max & Xs Max & Xr
            baggageTableViewBottom.constant = CGFloat(20 + fewSeatsLeftViewHeight)
            break
            
        default :
            break
        }
        
        if let journey = journey{
            if journey.legsWithDetail.count > 0{
//                for i in 0..<journey.count{
                    callAPIforBaggageInfo(sid: sid, fk: journey.fk, journeyObj: journey)
//                }
            }
        }
    }
    
    //MARK:- Tableview Methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if let journey = journey{
            return journey.legsWithDetail.count + 1
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard let legs = journey?.legsWithDetail else {return 0}
        
        if section == legs.count{
            return 1
        }else{
            if evaluatedBaggageResp.count > 0{
                if section < evaluatedBaggageResp.count{
                    return evaluatedBaggageResp[section].count
                }else{
                    return 0
                }
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let legs = journey?.legsWithDetail else {return UITableViewCell()}
        if indexPath.section == legs.count{
            let changeAirportCell = tableView.dequeueReusableCell(withIdentifier: "ChangeAirportCell") as! ChangeAirportTableViewCell
            changeAirportCell.titleLabel.text = ""
            changeAirportCell.titleLabelHeight.constant = 0
            changeAirportCell.dataLabelTop.constant = 0
            
            let style = NSMutableParagraphStyle()
            style.alignment = .left
            style.headIndent = 15
            style.paragraphSpacingBefore = 16
            
            var displayTxt = ""
            
            if combineString != ""{
                
                displayTxt = displayTxt + "*   " + combineString + "\n"
                
                displayTxt = displayTxt + "•   Baggage details are indicative and subject to change without prior notice."
                
                let inx = combineString.range(of: ":")
                let index: Int = combineString.distance(from: combineString.startIndex, to: inx!.lowerBound)
                
                let font:UIFont = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(14))!
                
                let title = NSMutableAttributedString(string: displayTxt, attributes: [NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.black])
                title.addAttributes([.font:font], range: NSRange(location: 0, length: index+6))
                
                changeAirportCell.dataLabel.attributedText = title
            }else{
                displayTxt = displayTxt + "•   Baggage details are indicative and subject to change without prior notice."
                
                let title = NSMutableAttributedString(string: displayTxt, attributes: [NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.black])
                changeAirportCell.dataLabel.attributedText = title
            }
            return changeAirportCell
        }else{
            let baggageCell = tableView.dequeueReusableCell(withIdentifier: "BaggageDetailsPerFlightCell") as! BaggageDetailsPerFlightTableViewCell
            
            if evaluatedBaggageResp.count > 0{
                baggageCell.dimensionsButton.tag = (indexPath.section*100)+indexPath.row
                baggageCell.dimensionsButton.addTarget(self, action: #selector(dimensionsButtonClicked(_:)), for: .touchUpInside)
                
                if let flightRoute = evaluatedBaggageResp[indexPath.section][indexPath.row].value(forKey: "flightRoute") as? String{
                    baggageCell.journeyTitleLabel.text = flightRoute
                }
                
                if let flightIcon = evaluatedBaggageResp[indexPath.section][indexPath.row].value(forKey: "flightIcon") as? NSArray{
                    let icon = flightIcon[indexPath.row] as! String
                    let logoURL = "http://cdn.aertrip.com/resources/assets/scss/skin/img/airline-master/" + icon.uppercased() + ".png"
                    setImageFromPath(urlPath : logoURL , to: baggageCell.airlineLogoImageView)
                }else if let flightIconStr = evaluatedBaggageResp[indexPath.section][indexPath.row].value(forKey: "flightIcon") as? String{
                    let logoURL = "http://cdn.aertrip.com/resources/assets/scss/skin/img/airline-master/" + flightIconStr.uppercased() + ".png"
                    setImageFromPath(urlPath : logoURL , to: baggageCell.airlineLogoImageView)
                }
                
                if let baggageData = evaluatedBaggageResp[indexPath.section][indexPath.row].value(forKey: "baggageData") as? NSDictionary
                {
                    if let bgData = baggageData.value(forKey: "bg") as? NSDictionary{
                        if let adtBaggage = bgData.value(forKey: "ADT") as? NSDictionary{
                            if let weight = adtBaggage.value(forKey: "weight") as? String, let pieces = adtBaggage.value(forKey: "pieces") as? String, let max_pieces = adtBaggage.value(forKey: "max_pieces") as? String, let max_weight = adtBaggage.value(forKey: "max_weight") as? String
                            {
                                if weight == "0 Kg"{
                                    baggageCell.perAdultCheckinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    baggageCell.perAdultCheckinLabel.textColor = .red
                                    baggageCell.perAdultCheckinLabel.text = "No Baggage"
                                }else if weight == "" && pieces == "" && max_pieces == "" && max_weight == ""{
                                    baggageCell.perAdultCheckinLabel.text = "No Info"
                                }else{
                                    if pieces == "" && max_pieces == "" && max_weight == ""{
                                        if weight != "0 kg" {
                                            baggageCell.perAdultCheckinLabel.text = weight
                                        }else{
                                            baggageCell.perAdultCheckinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                            baggageCell.perAdultCheckinLabel.textColor = .red
                                            baggageCell.perAdultCheckinLabel.text = "No Baggage"
                                        }
                                    }
                                    
                                    if weight == "" && max_pieces == "" && max_weight == ""{
                                        if pieces == "0 pc"{
                                            baggageCell.perAdultCheckinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                            baggageCell.perAdultCheckinLabel.textColor = .red
                                            baggageCell.perAdultCheckinLabel.text = "No Baggage"
                                        }else{
                                            let result = pieces + "*"
                                            let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                                            let fontSuper:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(12))
                                            let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font!])
                                            attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                                            
                                            baggageCell.perAdultCheckinLabel.attributedText = attString
                                            
                                            let str = "\(pieces) : Most airline typically allow 23 kgs per piece."
                                            if !attStringArray.contains(str){
                                                attStringArray.append(str)
                                                if combineString != ""{
                                                    combineString.append("\n     ")
                                                }
                                                combineString.append(str)
                                            }
                                        }
                                    }
                                    
                                    if pieces != "" && max_weight != ""{
                                        baggageCell.perAdultCheckinLabel.textColor = AppColors.themeBlack
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
                                                    baggageCell.perAdultCheckinLabel.attributedText = attString
                                                }else{
                                                    baggageCell.perAdultCheckinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                                    baggageCell.perAdultCheckinLabel.textColor = .red
                                                    baggageCell.perAdultCheckinLabel.text = "No Baggage"
                                                }
                                            }
                                        }
                                    }
                                    
                                    if weight != "" && max_pieces != ""{
                                        isAdultBaggageWithPiece = true
                                        baggageCell.perAdultCheckinLabel.textColor = AppColors.themeBlack
                                        adultBaggage = "Max \(max_pieces) pieces can be carried weighing total \(weight)"
                                        let result = weight + "*"
                                        let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                                        let fontSuper:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(12))
                                        let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font!])
                                        attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                                        
                                        baggageCell.perAdultCheckinLabel.attributedText = attString
                                        
                                        let str = "\(weight) : Max \(max_pieces) pieces can be carried weighing total \(weight)"
                                        if !attStringArray.contains(str){
                                            attStringArray.append(str)
                                            if combineString != ""{
                                                combineString.append("\n     ")
                                            }
                                            combineString.append(str)
                                        }
                                    }
                                }
                            }else if let weight = adtBaggage.value(forKey: "weight") as? Int{
                                if weight == 0{
                                    baggageCell.perAdultCheckinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    baggageCell.perAdultCheckinLabel.textColor = .red
                                    baggageCell.perAdultCheckinLabel.text = "No Baggage"
                                }else if weight == -9{
                                    baggageCell.perAdultCheckinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    baggageCell.perAdultCheckinLabel.textColor = .black
                                    baggageCell.perAdultCheckinLabel.text = "No Info"
                                }
                            }else if let weight = adtBaggage.value(forKey: "weight") as? String{
                                if weight == "0"{
                                    baggageCell.perAdultCheckinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    baggageCell.perAdultCheckinLabel.textColor = .red
                                    baggageCell.perAdultCheckinLabel.text = "No Baggage"
                                }else if weight == "-9"{
                                    baggageCell.perAdultCheckinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    baggageCell.perAdultCheckinLabel.textColor = .black
                                    baggageCell.perAdultCheckinLabel.text = "No Info"
                                }else if weight != "0 kg" {
                                    baggageCell.perAdultCheckinLabel.text = weight
                                }
                            }
                            
                            baggageCell.perAdultView.isHidden = false
                            baggageCell.perAdultViewHeight.constant = 30
                        }else{
                            baggageCell.perAdultView.isHidden = true
                            baggageCell.perAdultViewHeight.constant = 0
                            baggageCell.perAdultCheckinLabel.text = "NA"
                        }
                        
                        if let chdBaggage = bgData.value(forKey: "CHD") as? NSDictionary{
                            if let weight = chdBaggage.value(forKey: "weight") as? String, let pieces = chdBaggage.value(forKey: "pieces") as? String, let max_pieces = chdBaggage.value(forKey: "max_pieces") as? String, let max_weight = chdBaggage.value(forKey: "max_weight") as? String{
                                
                                if weight == "0 Kg"{
                                    baggageCell.perChildCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    baggageCell.perChildCheckInLabel.textColor = .red
                                    baggageCell.perChildCheckInLabel.text = "No Baggage"
                                }else if weight == "" && pieces == "" && max_pieces == "" && max_weight == ""{
                                    baggageCell.perChildCheckInLabel.text = "No Info"
                                }else{
                                    if pieces == "" && max_pieces == "" && max_weight == ""{
                                        if weight != "0 kg" {
                                            baggageCell.perChildCheckInLabel.text = weight
                                        }else{
                                            baggageCell.perChildCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                            baggageCell.perChildCheckInLabel.textColor = .red
                                            baggageCell.perChildCheckInLabel.text = "No Baggage"
                                        }
                                    }
                                    
                                    if weight == "" && max_pieces == "" && max_weight == ""{
                                        if pieces == "0 pc"{
                                            baggageCell.perChildCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                            baggageCell.perChildCheckInLabel.textColor = .red
                                            baggageCell.perChildCheckInLabel.text = "No Baggage"
                                        }else{
                                            let result = pieces + "*"
                                            let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                                            let fontSuper:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(12))
                                            let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font!])
                                            attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                                            
                                            baggageCell.perChildCheckInLabel.attributedText = attString
                                            
                                            let str = "\(pieces) : Most airline typically allow 23 kgs per piece."
                                            if !attStringArray.contains(str){
                                                attStringArray.append(str)
                                                if combineString != ""{
                                                    combineString.append("\n     ")
                                                }
                                                combineString.append(str)
                                            }
                                        }
                                    }
                                    
                                    if pieces != "" && max_weight != ""{
                                        let pc = pieces.components(separatedBy: " ")
                                        let weights = max_weight.components(separatedBy: " ")
                                        
                                        if pc.count > 0, weights.count > 0{
                                            if let intPieces = Int(pc[0]), let intmax_weight = Int(weights[0])
                                            {
                                                if intmax_weight != 0{
                                                    baggageCell.perChildCheckInLabel.textColor = AppColors.themeBlack
                                                    let str1 = "\(intmax_weight*intPieces) kg"
                                                    let str2 = " (\(intPieces) pc X \(intmax_weight) kg)"
                                                    let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                                                    let fontSuper:UIFont? = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                                    let attString:NSMutableAttributedString = NSMutableAttributedString(string: str1, attributes: [.font:font!])
                                                    let attString1:NSMutableAttributedString = NSMutableAttributedString(string: str2, attributes: [.font:fontSuper!])
                                                    
                                                    attString.append(attString1)
                                                    baggageCell.perChildCheckInLabel.attributedText = attString
                                                }else{
                                                    baggageCell.perChildCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                                    baggageCell.perChildCheckInLabel.textColor = .red
                                                    baggageCell.perChildCheckInLabel.text = "No Baggage"
                                                }
                                            }
                                        }
                                    }
                                    
                                    if weight != "" && max_pieces != ""{
                                        isChildBaggageWithPiece = true
                                        childBaggage = "Max \(max_pieces) pieces can be carried weighing total \(weight)"
                                        let result = weight + "*"
                                        let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                                        let fontSuper:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(12))
                                        let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font!])
                                        attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                                        
                                        baggageCell.perChildCheckInLabel.attributedText = attString
                                        
                                        let str = "\(weight) : Max \(max_pieces) pieces can be carried weighing total \(weight)"
                                        if !attStringArray.contains(str){
                                            attStringArray.append(str)
                                            if combineString != ""{
                                                combineString.append("\n     ")
                                            }
                                            combineString.append(str)
                                        }
                                    }
                                }
                            }else if let weight = chdBaggage.value(forKey: "weight") as? String, let pieces = chdBaggage.value(forKey: "pieces") as? String, let max_pieces = chdBaggage.value(forKey: "max_pieces") as? String{
                                
                                if weight == "0 Kg"{
                                    baggageCell.perChildCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    baggageCell.perChildCheckInLabel.textColor = .red
                                    baggageCell.perChildCheckInLabel.text = "No Baggage"
                                }else if weight == "" && pieces == "" && max_pieces == ""{
                                    baggageCell.perChildCheckInLabel.text = "No Info"
                                }else{
                                    if pieces == "" && max_pieces == ""{
                                        if weight != "0 kg" {
                                            baggageCell.perChildCheckInLabel.text = weight
                                        }else{
                                            baggageCell.perChildCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                            baggageCell.perChildCheckInLabel.textColor = .red
                                            baggageCell.perChildCheckInLabel.text = "No Baggage"
                                        }
                                    }
                                    
                                    if weight == "" && max_pieces == ""{
                                        if pieces == "0 pc"{
                                            baggageCell.perChildCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                            baggageCell.perChildCheckInLabel.textColor = .red
                                            baggageCell.perChildCheckInLabel.text = "No Baggage"
                                        }else{
                                            let result = pieces + "*"
                                            let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                                            let fontSuper:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(12))
                                            let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font!])
                                            attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                                            
                                            baggageCell.perChildCheckInLabel.attributedText = attString
                                            
                                            let str = "\(pieces) : Most airline typically allow 23 kgs per piece."
                                            if !attStringArray.contains(str){
                                                attStringArray.append(str)
                                                if combineString != ""{
                                                    combineString.append("\n     ")
                                                }
                                                combineString.append(str)
                                            }
                                        }
                                    }
                                    
                                    if pieces != ""{
                                        let result = pieces + "*"
                                        let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                                        let fontSuper:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(12))
                                        let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font!])
                                        attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                                        baggageCell.perChildCheckInLabel.attributedText = attString
                                        
                                        let str = "\(pieces) : Most airline typically allow 23 kgs per piece."
                                        if !attStringArray.contains(str){
                                            attStringArray.append(str)
                                            if combineString != ""{
                                                combineString.append("\n     ")
                                            }
                                            combineString.append(str)
                                        }
                                    }
                                    
                                    if weight != "" && max_pieces != ""{
                                        isChildBaggageWithPiece = true
                                        childBaggage = "Max \(max_pieces) pieces can be carried weighing total \(weight)"
                                        let result = weight + "*"
                                        let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                                        let fontSuper:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(12))
                                        let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font!])
                                        attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                                        
                                        baggageCell.perChildCheckInLabel.attributedText = attString
                                        
                                        let str = "\(weight) : Max \(max_pieces) pieces can be carried weighing total \(weight)"
                                        if !attStringArray.contains(str){
                                            attStringArray.append(str)
                                            if combineString != ""{
                                                combineString.append("\n     ")
                                            }
                                            combineString.append(str)
                                        }
                                    }
                                }
                            }
                            
                            baggageCell.perChildView.isHidden = false
                            baggageCell.perChildViewHeight.constant = 30
                        }else{
                            baggageCell.perChildView.isHidden = true
                            baggageCell.perChildViewHeight.constant = 0
                            baggageCell.perChildCheckInLabel.text = "NA"
                        }
                        
                        if let infBaggage = bgData.value(forKey: "INF") as? NSDictionary{
                            if let weight = infBaggage.value(forKey: "weight") as? String, let pieces = infBaggage.value(forKey: "pieces") as? String, let max_pieces = infBaggage.value(forKey: "max_pieces") as? String, let max_weight = infBaggage.value(forKey: "max_weight") as? String{
                                if weight == "0 Kg"{
                                    baggageCell.perInfantCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    baggageCell.perInfantCheckInLabel.textColor = .red
                                    baggageCell.perInfantCheckInLabel.text = "No Baggage"
                                }else if weight == "" && pieces == "" && max_pieces == "" && max_weight == ""{
                                    baggageCell.perInfantCheckInLabel.text = "No Info"
                                    
                                }else{
                                    if pieces == "" && max_pieces == "" && max_weight == ""{
                                        if weight != "0 kg" {
                                            baggageCell.perInfantCheckInLabel.text = weight
                                        }else{
                                            baggageCell.perInfantCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                            baggageCell.perInfantCheckInLabel.textColor = .red
                                            baggageCell.perInfantCheckInLabel.text = "No Baggage"
                                        }
                                    }
                                    
                                    if weight == "" && max_pieces == "" && max_weight == ""{
                                        if pieces == "0 pc"{
                                            baggageCell.perInfantCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                            baggageCell.perInfantCheckInLabel.textColor = .red
                                            baggageCell.perInfantCheckInLabel.text = "No Baggage"
                                        }else{
                                            let result = pieces + "*"
                                            let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                                            let fontSuper:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(12))
                                            let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font!])
                                            attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                                            
                                            baggageCell.perInfantCheckInLabel.attributedText = attString
                                            
                                            let str = "\(pieces) : Most airline typically allow 23 kgs per piece."
                                            if !attStringArray.contains(str){
                                                attStringArray.append(str)
                                                if combineString != ""{
                                                    combineString.append("\n     ")
                                                }
                                                combineString.append(str)
                                            }
                                        }
                                        
                                    }
                                    
                                    if pieces != "" && max_weight != ""{
                                        let pc = pieces.components(separatedBy: " ")
                                        let weights = max_weight.components(separatedBy: " ")
                                        if pc.count > 0, weights.count > 0{
                                            if let intPieces = Int(pc[0]), let intmax_weight = Int(weights[0]){
                                                baggageCell.perInfantCheckInLabel.textColor = AppColors.themeBlack
                                                if intmax_weight != 0{
                                                    let str1 = "\(intmax_weight*intPieces) kg"
                                                    let str2 = " (\(intPieces) pc X \(intmax_weight)) kg)"
                                                    let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                                                    let fontSuper:UIFont? = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                                    let attString:NSMutableAttributedString = NSMutableAttributedString(string: str1, attributes: [.font:font!])
                                                    let attString1:NSMutableAttributedString = NSMutableAttributedString(string: str2, attributes: [.font:fontSuper!])
                                                    
                                                    attString.append(attString1)
                                                    baggageCell.perInfantCheckInLabel.attributedText = attString
                                                }else{
                                                    baggageCell.perInfantCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                                    baggageCell.perInfantCheckInLabel.textColor = .red
                                                    
                                                    baggageCell.perInfantCheckInLabel.text = "No Baggage"
                                                }
                                            }
                                        }
                                    }
                                    
                                    if weight != "" && max_pieces != ""{
                                        if weight != "0 kg"{
                                            isInfantBaggageWithPiece = true
                                            infantBaggage = "Max \(max_pieces) pieces can be carried weighing total \(weight)"
                                            
                                            let result = weight + "*"
                                            let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
                                            let fontSuper:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(12))
                                            let attString:NSMutableAttributedString = NSMutableAttributedString(string: result, attributes: [.font:font!])
                                            attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location:result.count-1,length:1))
                                            
                                            baggageCell.perInfantCheckInLabel.attributedText = attString
                                            
                                            let str = "\(weight) : Max \(max_pieces) pieces can be carried weighing total \(weight)"
                                            if !attStringArray.contains(str){
                                                attStringArray.append(str)
                                                if combineString != ""{
                                                    combineString.append("\n     ")
                                                }
                                                combineString.append(str)
                                            }
                                        }else{
                                            baggageCell.perInfantCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                            baggageCell.perInfantCheckInLabel.textColor = .red
                                            baggageCell.perInfantCheckInLabel.text = "No Baggage"
                                        }
                                        
                                    }
                                }
                            }else if let weight = infBaggage.value(forKey: "weight") as? Int{
                                if weight == 0{
                                    baggageCell.perInfantCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    baggageCell.perInfantCheckInLabel.textColor = .red
                                    baggageCell.perInfantCheckInLabel.text = "No Baggage"
                                }else if weight == -9{
                                    baggageCell.perInfantCheckInLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    baggageCell.perInfantCheckInLabel.textColor = .black
                                    baggageCell.perInfantCheckInLabel.text = "No Info"
                                }
                            }
                            
                            baggageCell.perInfantView.isHidden = false
                            baggageCell.perInfantViewHeight.constant = 30
                        }else{
                            baggageCell.perInfantView.isHidden = true
                            baggageCell.perInfantViewHeight.constant = 0
                            baggageCell.perInfantCheckInLabel.text = "NA"
                        }
                    }
                    
                    if let cbgData = baggageData.value(forKey: "cbg") as? NSDictionary{
                        if let adtCabinBaggage = cbgData.value(forKey: "ADT") as? NSDictionary{
                            if let weight = adtCabinBaggage.value(forKey: "weight") as? String, let pieces = adtCabinBaggage.value(forKey: "pieces") as? String{
                                if weight == "0 kg"{
                                    baggageCell.perAdultCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    baggageCell.perAdultCabinLabel.textColor = .red
                                    baggageCell.perAdultCabinLabel.text = "No Baggage"
                                }else if pieces == "0" && weight == "0 kg"{
                                    baggageCell.perAdultCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    baggageCell.perAdultCabinLabel.textColor = .red
                                    baggageCell.perAdultCabinLabel.text = "No Baggage"
                                }else if pieces == "" && weight == "" {
                                    baggageCell.perAdultCabinLabel.text = "No Info"
                                }else{
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
                                                baggageCell.perAdultCabinLabel.attributedText = attString
                                            }else{
                                                baggageCell.perAdultCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                                baggageCell.perAdultCabinLabel.textColor = .red
                                                baggageCell.perAdultCabinLabel.text = "No Baggage"
                                            }
                                        }
                                    }
                                }
                            }else if let weight = adtCabinBaggage.value(forKey: "weight") as? Int{
                                if weight == 0{
                                    baggageCell.perAdultCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    baggageCell.perAdultCabinLabel.textColor = .red
                                    baggageCell.perAdultCabinLabel.text = "No Baggage"
                                }else if weight == -9{
                                    baggageCell.perAdultCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    baggageCell.perAdultCabinLabel.textColor = .black
                                    baggageCell.perAdultCabinLabel.text = "No Info"
                                }
                            }
                        }else{
                            baggageCell.perAdultCabinLabel.text = "NA"
                        }
                        
                        if let chdCabinBaggage = cbgData.value(forKey: "CHD") as? NSDictionary{
                            if let weight = chdCabinBaggage.value(forKey: "weight") as? String, let pieces = chdCabinBaggage.value(forKey: "pieces") as? String{
                                if weight == "0 kg"{
                                    baggageCell.perChildCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    baggageCell.perChildCabinLabel.textColor = .red
                                    baggageCell.perChildCabinLabel.text = "No Baggage"
                                }else if pieces == "0" && weight == "0 kg"{
                                    baggageCell.perChildCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    baggageCell.perChildCabinLabel.textColor = .red
                                    baggageCell.perChildCabinLabel.text = "No Baggage"
                                }else if pieces == "" && weight == "" {
                                    baggageCell.perChildCabinLabel.text = "No Info"
                                }else{
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
                                                baggageCell.perChildCabinLabel.attributedText = attString
                                            }else{
                                                baggageCell.perChildCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                                baggageCell.perChildCabinLabel.textColor = .red
                                                baggageCell.perChildCabinLabel.text = "No Baggage"
                                            }
                                        }
                                    }
                                }
                            }else if let weight = chdCabinBaggage.value(forKey: "weight") as? Int{
                                if weight == 0{
                                    baggageCell.perChildCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    baggageCell.perChildCabinLabel.textColor = .red
                                    baggageCell.perChildCabinLabel.text = "No Baggage"
                                }else if weight == -9{
                                    baggageCell.perChildCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    baggageCell.perChildCabinLabel.textColor = .black
                                    baggageCell.perChildCabinLabel.text = "No Info"
                                }
                            }
                        }else{
                            baggageCell.perChildCabinLabel.text = "NA"
                        }
                        
                        if let infCabinBaggage = cbgData.value(forKey: "INF") as? NSDictionary{
                            if let weight = infCabinBaggage.value(forKey: "weight") as? String, let pieces = infCabinBaggage.value(forKey: "pieces") as? String{
                                if weight == "0 kg"{
                                    baggageCell.perInfantCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    baggageCell.perInfantCabinLabel.textColor = .red
                                    baggageCell.perInfantCabinLabel.text = "No Baggage"
                                }else if pieces == "0" && weight == "0 kg"{
                                    baggageCell.perInfantCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    baggageCell.perInfantCabinLabel.textColor = .red
                                    baggageCell.perInfantCabinLabel.text = "No Baggage"
                                }else if pieces == "" && weight == "" {
                                    baggageCell.perInfantCabinLabel.text = "No Info"
                                }else{
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
                                                baggageCell.perInfantCabinLabel.attributedText = attString
                                            }else{
                                                baggageCell.perInfantCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                                baggageCell.perInfantCabinLabel.textColor = .red
                                                baggageCell.perInfantCabinLabel.text = "No Baggage"
                                            }
                                        }
                                    }
                                }
                            }else if let weight = infCabinBaggage.value(forKey: "weight") as? Int{
                                if weight == 0{
                                    baggageCell.perInfantCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    baggageCell.perInfantCabinLabel.textColor = .red
                                    baggageCell.perInfantCabinLabel.text = "No Baggage"
                                }else if weight == -9{
                                    baggageCell.perInfantCabinLabel.font = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))
                                    baggageCell.perInfantCabinLabel.textColor = .black
                                    baggageCell.perInfantCabinLabel.text = "No Info"
                                }
                            }
                        }else{
                            baggageCell.perInfantCabinLabel.text = "NA"
                        }
                    }
                }
            }
            
            baggageCell.notesLabel.text = ""
            baggageCell.notesView.isHidden = true
            baggageCell.notesLabelTop.constant = 0
            baggageCell.notesLabelBottom.constant = 0
            
            if baggageCell.perAdultView.isHidden == true && baggageCell.perChildView.isHidden == true && baggageCell.perInfantView.isHidden == true{
                baggageCell.baggageDataDisplayView.isHidden = true
                baggageCell.baggageDataDisplayViewHeight.constant = 0
                
                baggageCell.flightDetailsView.isHidden = true
                baggageCell.flightDetailsViewHeight.constant = 0
            }
            
            let totalRow = tableView.numberOfRows(inSection: indexPath.section)
            if totalRow == 1 || indexPath.row == evaluatedBaggageResp[indexPath.section].count-1{
                baggageCell.bottomSeperator.isHidden = false
                baggageCell.bottomSeperatorHeight.constant = 0.6
                baggageCell.bottomSeperatorBottom.constant = 40
            }else{
                baggageCell.bottomSeperator.isHidden = true
                baggageCell.bottomSeperatorBottom.constant = 0
                baggageCell.bottomSeperatorHeight.constant = 0
            }
            
            if indexPath.section == 0 && indexPath.row == 0{
                baggageCell.topSeperatorView.isHidden = true
                baggageCell.topSeperatorViewHeight.constant = 0
            }else if tableView.numberOfRows(inSection: indexPath.section) > 1{
                if indexPath.row == 0{
                    baggageCell.topSeperatorView.isHidden = false
                    baggageCell.topSeperatorViewHeight.constant = 0.5
                }else{
                    baggageCell.topSeperatorView.isHidden = true
                    baggageCell.topSeperatorViewHeight.constant = 0
                }
            }else{
                baggageCell.topSeperatorView.isHidden = false
                baggageCell.topSeperatorViewHeight.constant = 0.5
            }
            
            return baggageCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK:- Scrollview Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        var isHidden = false
        var viewHeight = 0.0
        if scrollView.contentOffset.y < 0{
            isHidden = false
            viewHeight = 0.5
        }else{
            isHidden = true
            viewHeight = 0
        }
        if let cell = baggageTableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? BaggageDetailsPerFlightTableViewCell {
            cell.topSeperatorView.isHidden = isHidden
            cell.topSeperatorViewHeight.constant = CGFloat(viewHeight)
        }
    }
    
    //MARK:- Set Image
    func setImageFromPath(urlPath : String  , to imageView : UIImageView){
        imageView.setImageWithUrl(urlPath, placeholder: UIImage(), showIndicator: false)//resourceFor(urlPath: urlPath)
//        guard  let urlobj = URL(string: urlPath) else { return }
//
//        let urlRequest = URLRequest(url: urlobj)
//        if let responseObj = URLCache.shared.cachedResponse(for: urlRequest)
//        {
//            let image = UIImage(data: responseObj.data)
//            imageView.image = image
//        }
    }
    
    //MARK:- Button Actions
    @objc func dimensionsButtonClicked(_ sender:UIButton)
    {
        let baggageDimensionVC = BaggageDimensionsVC(nibName: "BaggageDimensionsVC", bundle: nil)
        
        let section = sender.tag / 100
        let row = sender.tag % 100
        if let baggageData = evaluatedBaggageResp[section][row].value(forKey: "baggageData") as? NSDictionary{
            if let cbgData = baggageData.value(forKey: "cbg") as? NSDictionary{
                if let adtCabinBaggage = cbgData.value(forKey: "ADT") as? NSDictionary{
                    if let weight = adtCabinBaggage.value(forKey: "weight") as? String{
                        baggageDimensionVC.weight = weight
                    }
                    if let dimension = adtCabinBaggage.value(forKey: "dimension") as? NSDictionary{
                        if let cm = dimension.value(forKey: "cm") as? NSDictionary{
                            baggageDimensionVC.dimensions = cm
                        }
                        
                        if let inch = dimension.value(forKey: "in") as? NSDictionary{
                            baggageDimensionVC.dimensions_inch = inch
                        }
                    }
                    
                    if let note = adtCabinBaggage.value(forKey: "note") as? String{
                        baggageDimensionVC.note = note
                    }
                }
            }
        }
//
//        baggageDimensionVC.view.frame = self.parent!.view.bounds
//        baggageDimensionVC.modalPresentationStyle = .overCurrentContext
        self.present(baggageDimensionVC, animated: true, completion: nil)
    }
    
    //MARK:- API Call
    func callAPIforBaggageInfo(sid:String, fk:String, journeyObj:IntJourney, count:Int = 3){
        let webservice = WebAPIService()
        webservice.executeAPI(apiServive: .baggageResult(sid: sid, fk: fk), completionHandler: {[weak self](data) in
            guard let self = self else {return}
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if let jsonResult:AnyObject  = try? JSONSerialization.jsonObject(with: data, options: []) as AnyObject{
                
                DispatchQueue.main.async {
                    if let result = jsonResult as? [String: AnyObject] {
                        
                        if let data = result["data"] as? NSDictionary {
                            let keys = data.allKeys
                            if keys.count > 0{
                                for j in 0..<keys.count{
                                    let str = keys[j] as! String
                                    if let datas = data.value(forKey: str) as? NSDictionary{
                                        self.dataResp += [datas]
                                    }
                                }
                                if self.dataResp.count != 0{
                                    self.displaySetValues(baggage: self.dataResp)
                                }
                            }
                        }
                    }
                }
                
            }
        }, failureHandler : {[weak self] (error ) in
            guard let self = self else {return}
            self.callAPIforBaggageInfo(sid:sid, fk:fk, journeyObj:journeyObj, count:count-1)
            print(error)
        })
    }
    
    func displaySetValues(baggage:[NSDictionary]){
        guard let journey = self.journey else {return}
        var baggageStringArray = [String]()
        var newBaggage = baggage
        var journeywiseBaggageData = [NSDictionary]()
        let allFlightsInJourney = journey.legsWithDetail.flatMap{$0.flightsWithDetails}
        guard newBaggage.count == allFlightsInJourney.count else {return}
        var baggageAccordingLegs = [[NSDictionary]]()
        
        for legs in journey.legsWithDetail{
            var bg = [NSDictionary]()
            for _ in 0..<legs.flightsWithDetails.count{
                bg.append(newBaggage[0])
                newBaggage.remove(at: 0)
            }
            baggageAccordingLegs.append(bg)
        }
        
        for (index,bgg) in baggageAccordingLegs.enumerated(){
            let leg = journey.legsWithDetail[index]
            let allFlights = leg.flightsWithDetails
            if allFlights.count == bgg.count{
                if allFlights.count>0{
                    for i in 0..<allFlights.count{
                        let str = "\(allFlights[i].al)*\(allFlights[i].oc)-\(bgg[i])"
                        baggageStringArray.append(str)
                    }
                }
            }
            
            let baggageStringArraySet = Set(baggageStringArray)
            
            if baggageStringArraySet.count == 1{
                let loc = leg.ap[0] + " → " + leg.ap[1]
                let data = ["flightIcon":leg.al,
                            "flightRoute":loc,
                            "baggageData":bgg[0]] as [String : Any]
                journeywiseBaggageData.append(data as NSDictionary)
                evaluatedBaggageResp.append(journeywiseBaggageData)
                journeywiseBaggageData.removeAll()
                self.dataResp.removeAll()
            }else{
                let allFlights = leg.flightsWithDetails
                if allFlights.count == bgg.count{
                    if allFlights.count>0{
                        for i in 0..<allFlights.count{
                            
                            let loc = allFlights[i].fr + " → " + allFlights[i].to
                            let data = ["flightIcon":allFlights[i].al,
                                        "flightRoute":loc,
                                        "baggageData":bgg[i]] as [String : Any]
                            journeywiseBaggageData.append(data as NSDictionary)
                        }
                        evaluatedBaggageResp.append(journeywiseBaggageData)
                        journeywiseBaggageData.removeAll()
                        self.dataResp.removeAll()
                    }
                }
                
            }
        }
        self.baggageTableView.reloadData()
    }
    
//    func getAttibutedText(weight:Int, pieces: Int)-> NSAttributedString{
//        let str1 = "\(weight*pieces) kg"
//        let str2 = " (\(pieces) pc X \(weight) kg)"
//        let font = AppFonts.SemiBold.withSize(16)
//        let fontSuper = AppFonts.Regular.withSize(14)
//        let attString:NSMutableAttributedString = NSMutableAttributedString(string: str1, attributes: [.font:font])
//        let attString1:NSMutableAttributedString = NSMutableAttributedString(string: str2, attributes: [.font:fontSuper])
//        attString.append(attString1)
//        return  attString
//    }
    
//    func getStarAttibuted(str:String)-> NSAttributedString{
//
//        let font:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(16))
//        let fontSuper:UIFont? = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(12))
//        let attString:NSMutableAttributedString = NSMutableAttributedString(string: str, attributes: [.font:font!])
//        attString.setAttributes([.font:fontSuper!,.baselineOffset:5], range: NSRange(location:str.count-1,length:1))
//        return attString
//    }
    
//    func combineString(with pieces: String){
//        let str = "\(pieces) : Most airline typically allow 23 kgs per piece."
//        if !attStringArray.contains(str){
//            attStringArray.append(str)
//            if combineString != ""{
//                combineString.append("\n     ")
//            }
//            self.piecesArray.append("\(pieces) :")
//            combineString.append(str)
//        }
//
//    }
    
//    func combineStringwith(weight: String, pieces: String){
//        let str = "\(weight) : Max \(pieces) pieces can be carried weighing total \(weight)"
//        if !attStringArray.contains(str){
//            attStringArray.append(str)
//            if combineString != ""{
//                combineString.append("\n     ")
//            }
//            self.weightArray.append("\(weight) :")
//            combineString.append(str)
//        }
//    }
    
//    func setLabelText(lbl:UILabel, isRed:Bool){
//        lbl.text = isRed ? "No Baggage" : "No Info"
//        lbl.textColor = isRed ? .red :.black
//        lbl.font = AppFonts.Regular.withSize(14)
//    }
    
}
