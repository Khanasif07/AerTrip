//
//  BaggageVC.swift
//  Aertrip
//
//  Created by Monika Sonawane on 20/09/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit

class BaggageVC: BaseVC, UITableViewDelegate, UITableViewDataSource
{
    //MARK:- Outlets
    @IBOutlet weak var baggageTableView: UITableView!
    @IBOutlet weak var baggageTableViewBottom: NSLayoutConstraint!
    
    //MARK:- Variable Declaration
    var journey: [Journey]!
    var airportDetailsResult : [String : AirportDetailsWS]!
    var sid = ""
    var evaluatedBaggageResp = [[JSONDictionary]]()
    
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
    var fewSeatsLeftViewHeight = 0
    var dataResp = [JSONDictionary]()
    var dimensionDelegate : getBaggageDimentionsDelegate?

    //MARK:- Initialise Views
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baggageTableView.register(UINib(nibName: "BaggageDetailsPerFlightTableViewCell", bundle: nil), forCellReuseIdentifier: "BaggageDetailsPerFlightCell")
        baggageTableView.register(UINib(nibName: "ChangeAirportTableViewCell", bundle: nil), forCellReuseIdentifier: "ChangeAirportCell")
        
        baggageTableView.rowHeight = UITableView.automaticDimension
        baggageTableView.estimatedRowHeight = 175
        baggageTableView.alwaysBounceVertical = true
        baggageTableViewBottom.constant = 0.0
        if journey != nil{
            if journey.count > 0{
                for i in 0..<journey.count{
                    callAPIforBaggageInfo(sid: sid, fk: journey[i].fk, journeyObj: journey[i])
                }
            }
        }
    }
    
    //MARK:- Tableview Methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if journey != nil{
            return journey.count + 1
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == journey.count{
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == journey.count{
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
                
                var strArray = [String]()
                let attArray = displayTxt.components(separatedBy: "\n")
                for i in 0..<attArray.count-1{
                    let str = attArray[i].components(separatedBy: ":")
                    strArray.append(str[0]+":")
                }
                
                let attributedWithTextColor: NSAttributedString = displayTxt.attributedStringWithColor(strArray, color: UIColor.clear)

                changeAirportCell.dataLabel.attributedText = attributedWithTextColor
            }else{
                displayTxt = displayTxt + "•   Baggage details are indicative and subject to change without prior notice."
                
                let title = NSMutableAttributedString(string: displayTxt, attributes: [NSAttributedString.Key.paragraphStyle: style,NSAttributedString.Key.foregroundColor:UIColor.black])
                changeAirportCell.dataLabel.attributedText = title
            }
            
            changeAirportCell.seperatorBottom.constant = 35

            return changeAirportCell
        }else{
            let baggageCell = tableView.dequeueReusableCell(withIdentifier: "BaggageDetailsPerFlightCell") as! BaggageDetailsPerFlightTableViewCell
            
            if evaluatedBaggageResp.count > 0{
                baggageCell.dimensionsButton.tag = (indexPath.section*100)+indexPath.row
                baggageCell.dimensionsButton.addTarget(self, action: #selector(dimensionsButtonClicked(_:)), for: .touchUpInside)
                
                if let flightRoute = evaluatedBaggageResp[indexPath.section][indexPath.row]["flightRoute"] as? String{
                    baggageCell.journeyTitleLabel.text = flightRoute
                }
                
                if let flightIcon = evaluatedBaggageResp[indexPath.section][indexPath.row]["flightIcon"] as? NSArray{
                    let icon = flightIcon[indexPath.row] as! String
                    let logoURL = "http://cdn.aertrip.com/resources/assets/scss/skin/img/airline-master/" + icon.uppercased() + ".png"
                    setImageFromPath(urlPath : logoURL , to: baggageCell.airlineLogoImageView)
                }else if let flightIconStr = evaluatedBaggageResp[indexPath.section][indexPath.row]["flightIcon"] as? String{
                    let logoURL = "http://cdn.aertrip.com/resources/assets/scss/skin/img/airline-master/" + flightIconStr.uppercased() + ".png"
                    setImageFromPath(urlPath : logoURL , to: baggageCell.airlineLogoImageView)
                }
                
                if let baggageData = evaluatedBaggageResp[indexPath.section][indexPath.row]["baggageData"] as? JSONDictionary
                {
                    if let bgData = baggageData["bg"] as? JSONDictionary
                    {
                        if let adtCheckinBaggage = bgData["ADT"] as? JSONDictionary{
                            baggageCell.setPerAdultCheckinBaggage(adtCheckinBaggage: adtCheckinBaggage)
                            
                            if let weight = adtCheckinBaggage["weight"] as? String, let pieces = adtCheckinBaggage["pieces"] as? String, let max_pieces = adtCheckinBaggage["max_pieces"] as? String, let max_weight = adtCheckinBaggage["max_weight"] as? String
                            {
                                if (weight == "0 Kg" && max_pieces == "" && max_weight == "") || (weight == "" && max_pieces == "" && max_weight == "") || (weight == "-9" && max_pieces == "" && max_weight == "") && pieces != "0 pc"{
                                    let str = "\(pieces) : Most airline typically allow 23 kgs per piece."
                                    if !attStringArray.contains(str){
                                        attStringArray.append(str)
                                        if combineString != ""{
                                            combineString.append("\n     ")
                                        }
                                        combineString.append(str)
                                    }
                                }
                                
                                
                                if weight != "" && max_pieces != ""
                                {
                                    isAdultBaggageWithPiece = true
                                    var pc = ""
                                    if max_pieces.contains(find: " "){
                                        let pieces = max_pieces.components(separatedBy: " ")
                                        if pieces.count > 0{
                                            pc = pieces[0]
                                        }
                                    }

                                    adultBaggage = "Max \(pc) pieces can be carried weighing total \(weight)"
                                    
                                    let str = "\(weight) : Max \(pc) pieces can be carried weighing total \(weight)"
                                    if !attStringArray.contains(str){
                                        attStringArray.append(str)
                                        if combineString != ""{
                                            combineString.append("\n     ")
                                        }
                                        combineString.append(str)
                                    }
                                }
                            }
                        }else{
                            baggageCell.perAdultView.isHidden = true
                            baggageCell.perAdultViewHeight.constant = 0
                            baggageCell.perAdultCheckinLabel.text = "NA"
                        }
                        
                        if let chdCheckinBaggage = bgData["CHD"] as? JSONDictionary{
                            baggageCell.setPerChildCheckinBaggage(chdCheckinBaggage: chdCheckinBaggage)
                            
                            
                            if let weight = chdCheckinBaggage["weight"] as? String, let pieces = chdCheckinBaggage["pieces"] as? String, let max_pieces = chdCheckinBaggage["max_pieces"] as? String, let max_weight = chdCheckinBaggage["max_weight"] as? String{
                                
                                if (weight == "0 Kg" && max_pieces == "" && max_weight == "") || (weight == "" && max_pieces == "" && max_weight == "") || (weight == "-9" && max_pieces == "" && max_weight == "") && pieces != "0 pc"{
                                    let str = "\(pieces) : Most airline typically allow 23 kgs per piece."
                                    if !attStringArray.contains(str){
                                        attStringArray.append(str)
                                        if combineString != ""{
                                            combineString.append("\n     ")
                                        }
                                        combineString.append(str)
                                    }

                                }
                                
                                
                                if weight != "0 Kg" && weight != "" && weight != "-9" && max_pieces != ""{
                                    isChildBaggageWithPiece = true
                                    
                                    var pc = ""
                                    if max_pieces.contains(find: " "){
                                        let pieces = max_pieces.components(separatedBy: " ")
                                        if pieces.count > 0{
                                            pc = pieces[0]
                                        }
                                    }
                                    
                                    childBaggage = "Max \(pc) pieces can be carried weighing total \(weight)"
                                    
                                    let str = "\(weight) : Max \(pc) pieces can be carried weighing total \(weight)"
                                    if !attStringArray.contains(str){
                                        attStringArray.append(str)
                                        if combineString != ""{
                                            combineString.append("\n     ")
                                        }
                                        combineString.append(str)
                                    }

                                }
                            }else if let weight = chdCheckinBaggage["weight"] as? String, let pieces = chdCheckinBaggage["pieces"] as? String, let max_pieces = chdCheckinBaggage["max_pieces"] as? String{
                                
                                if weight == "0 Kg" && weight == "" && weight == "-9" && max_pieces == "" && pieces != "0 pc"{
                                    let str = "\(pieces) : Most airline typically allow 23 kgs per piece."
                                    if !attStringArray.contains(str){
                                        attStringArray.append(str)
                                        if combineString != ""{
                                            combineString.append("\n     ")
                                        }
                                        combineString.append(str)
                                    }

                                }
                                
                                
                                if pieces != ""{
                                    let str = "\(pieces) : Most airline typically allow 23 kgs per piece."
                                    if !attStringArray.contains(str){
                                        attStringArray.append(str)
                                        if combineString != ""{
                                            combineString.append("\n     ")
                                        }
                                        combineString.append(str)
                                    }

                                }
                                
                                
                                if weight != "0 Kg" && weight != "" && weight != "-9" && max_pieces != ""{
                                    isChildBaggageWithPiece = true
                                    
                                    var pc = ""
                                    if max_pieces.contains(find: " "){
                                        let pieces = max_pieces.components(separatedBy: " ")
                                        if pieces.count > 0{
                                            pc = pieces[0]
                                        }
                                    }
                                    
                                    childBaggage = "Max \(pc) pieces can be carried weighing total \(weight)"
                                    
                                    let str = "\(weight) : Max \(pc) pieces can be carried weighing total \(weight)"
                                    if !attStringArray.contains(str){
                                        attStringArray.append(str)
                                        if combineString != ""{
                                            combineString.append("\n     ")
                                        }
                                        combineString.append(str)
                                    }
                                }
                            }
                        }else{
                            baggageCell.perChildView.isHidden = true
                            baggageCell.perChildViewHeight.constant = 0
                            baggageCell.perChildCheckInLabel.text = "NA"
                        }

                        
                        if let infCheckInBaggage = bgData["INF"] as? JSONDictionary{
                            baggageCell.setPerInfantCheckinBaggage(infCheckInBaggage: infCheckInBaggage)
                            
                            
                            if let weight = infCheckInBaggage["weight"] as? String, let pieces = infCheckInBaggage["pieces"] as? String, let max_pieces = infCheckInBaggage["max_pieces"] as? String, let max_weight = infCheckInBaggage["max_weight"] as? String
                            {
                                if weight == "" && max_pieces == "" && max_weight == "" && pieces != "0 pc"{

                                    let str = "\(pieces) : Most airline typically allow 23 kgs per piece."
                                    if !attStringArray.contains(str){
                                        attStringArray.append(str)
                                        if combineString != ""{
                                            combineString.append("\n     ")
                                        }
                                        combineString.append(str)
                                    }
                                }
                                
                                
                                if weight != "" && max_pieces != "" && weight != "0 kg"{
                                    
                                    isInfantBaggageWithPiece = true
                                    
                                    var pc = ""
                                    if max_pieces.contains(find: " "){
                                        let pieces = max_pieces.components(separatedBy: " ")
                                        if pieces.count > 0{
                                            pc = pieces[0]
                                        }
                                    }
                                    infantBaggage = "Max \(pc) pieces can be carried weighing total \(weight)"

                                    
                                    let str = "\(weight) : Max \(pc) pieces can be carried weighing total \(weight)"
                                    if !attStringArray.contains(str){
                                        attStringArray.append(str)
                                        if combineString != ""{
                                            combineString.append("\n     ")
                                        }
                                        combineString.append(str)
                                    }
                                }
                            }
                        }else{
                            baggageCell.perInfantView.isHidden = true
                            baggageCell.perInfantViewHeight.constant = 0
                            baggageCell.perInfantCheckInLabel.text = "NA"
                        }
                    }
                    
                    if let cbgData = baggageData["cbg"] as? JSONDictionary{
                        
                        if let adtCabinBaggage = cbgData["ADT"] as? JSONDictionary{
                            baggageCell.setPerAdultCabinBaggage(adtCabinBaggage: adtCabinBaggage)
                        }
                        
                        if let chdCabinBaggage = cbgData["CHD"] as? JSONDictionary{
                            baggageCell.setPerChildCabinBaggage(chdCabinBaggage: chdCabinBaggage)
                        }

                        if let infCabinBaggage = cbgData["INF"] as? JSONDictionary{
                            baggageCell.setPerInfantCabinBaggage(infCabinBaggage: infCabinBaggage)
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
                baggageCell.bottomSeperatorBottom.constant = 35
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
    func setImageFromPath(urlPath : String  , to imageView : UIImageView)
    {
        guard  let urlobj = URL(string: urlPath) else { return }
        
        let urlRequest = URLRequest(url: urlobj)
        if let responseObj = URLCache.shared.cachedResponse(for: urlRequest)
        {
            let image = UIImage(data: responseObj.data)
            imageView.image = image
        }
    }
    
    //MARK:- Button Actions
    @objc func dimensionsButtonClicked(_ sender:UIButton)
    {
        self.dimensionDelegate?.getBaggageDimentions(baggage: evaluatedBaggageResp, sender: sender)
    }
    
    //MARK:- API Call
    func callAPIforBaggageInfo(sid:String, fk:String, journeyObj:Journey)
    {
        let webservice = WebAPIService()
        webservice.executeAPI(apiServive: .baggageResult(sid: sid, fk: fk), completionHandler: {    (data) in
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do{
                let jsonResult:AnyObject?  = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
                
                DispatchQueue.main.async {
                    if let result = jsonResult as? [String: AnyObject] {
                        
                        if let data = result["data"] as? JSONDictionary {
                            
                            let keys = data.keys//.allKeys
                            if keys.count > 0{
                                
                                for key in keys{
                                    if let datas = data["\(key)"] as? JSONDictionary
                                    {
                                        self.dataResp += [datas]
                                        self.displaySetValues(journeyObj: journeyObj, baggage: self.dataResp)
                                    }

                                }
                                
//                                for j in 0..<keys.count{
//                                    let str = keys[j] as! String
//                                    if let datas = data["\(str)"] as? JSONDictionary
//                                    {
//                                        self.dataResp += [datas]
//                                        self.displaySetValues(journeyObj: journeyObj, baggage: self.dataResp)
//                                    }
//                                }
                            }
                        }
                    }
                }
            }catch{
            }
        } , failureHandler : { (error ) in
            print(error)
        })
    }
    
    func displaySetValues(journeyObj:Journey, baggage:[JSONDictionary])
    {
        var baggageStringArray = [String]()
        var journeywiseBaggageData = [JSONDictionary]()
        
        if let allFlights = journeyObj.leg.first?.flights{
            if allFlights.count == baggage.count{
                if allFlights.count>0{
                    for i in 0..<allFlights.count{
                        
                        let str = "\(allFlights[i].al)*\(allFlights[i].oc!)-\(baggage[i])"
                        baggageStringArray.append(str)
                    }
                }
            }
        }
        
        let baggageStringArraySet = Set(baggageStringArray)
        
        if baggageStringArraySet.count == 1{
            let loc = journeyObj.ap[0] + " → " + journeyObj.ap[1]
            let data = ["flightIcon":journeyObj.al,
                        "flightRoute":loc,
                        "baggageData":baggage[0]] as JSONDictionary//[String : Any]
            journeywiseBaggageData.append(data)
            evaluatedBaggageResp.append(journeywiseBaggageData)
            journeywiseBaggageData.removeAll()
            self.dataResp.removeAll()
        }else{
            if let allFlights = journeyObj.leg.first?.flights{
                if allFlights.count == baggage.count{
                    if allFlights.count>0{
                        for i in 0..<allFlights.count{
                            
                            let loc = allFlights[i].fr + " → " + allFlights[i].to
                            let data = ["flightIcon":allFlights[i].al,
                                        "flightRoute":loc,
                                        "baggageData":baggage[i]] as JSONDictionary//[String : Any]
                            journeywiseBaggageData.append(data)
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
}


extension String {
    func attributedStringWithColor(_ strings: [String], color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)

        let style = NSMutableParagraphStyle()
        style.alignment = .left
        style.headIndent = 15
        style.paragraphSpacingBefore = 16

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
        let font:UIFont = UIFont(name: "SourceSansPro-Regular", size:CGFloat(14))!
        attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: NSRange(location: 0, length: attributedString.length))

        for string in strings {
            let range = (self as NSString).range(of: string)
            let font:UIFont = UIFont(name: "SourceSansPro-SemiBold", size:CGFloat(14))!
            attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: range)
        }

        guard let characterSpacing = characterSpacing else {return attributedString}


        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))

        return attributedString
    }
}
