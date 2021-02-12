//
//  OtherFareModel.swift
//  AERTRIP
//
//  Created by Appinventiv  on 26/08/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

struct OtherFareModel {
    var fk: String
    var farepr: Double
    var fare: IntTaxes
    var cabinCalss, fareTypeName, title, bc: [String]
    var subtitle, description: [String]
    var img: [String]
    var apc: String
    var flightResult: IntJourney
    var isDefault: Bool
    var sortOrder:String
    
    var cellTitle:String{
        var titleVal = ""
        if title.count != 0{
            for (index, name) in title.enumerated(){
                var newbc = ""
                if bc.count < index{
                    newbc = bc.first ?? ""
                }else{
                    newbc = bc[index]
                }
                let val = name + " (\(newbc))"
                if !titleVal.contains(val){
                    if index == title.count - 1{
                        titleVal += " \(val)"
                    }else if index == 0{
                        titleVal += "\(val),"
                    }else{
                        titleVal += " \(val),"
                    }
                }
            }
        }else{
            for (index, name) in cabinCalss.enumerated(){
                var newbc = ""
                if bc.count < index{
                    newbc = bc.first ?? ""
                }else{
                    newbc = bc[index]
                }
                let val = name + " (\(newbc))"
                if !titleVal.contains(val){
                    if index == cabinCalss.count - 1{
                        titleVal += " \(val)"
                    }else if index == 0{
                        titleVal += "\(val),"
                    }else{
                        titleVal += " \(val),"
                    }
                }
            }
            
        }
        if titleVal.last == ","{
            titleVal.removeLast()
        }
        return titleVal
    }
    
    
    var descriptionShown:String{
        var totalText = ""
        for str in self.description{
            if var displayString = str.getAttributedString?.string, !str.isEmpty{
                if displayString.contains(find: "\t•\t"){
                    displayString = displayString.replacingOccurrences(of: "\t•\t", with: "•   ")
                }else if displayString.contains(find: " • "){
                    displayString = displayString.replacingOccurrences(of: " • ", with: "\n•   ")
                }else if displayString.contains(find: " · "){
                    displayString = displayString.replacingOccurrences(of: " · ", with: "\n•   ")
                }
                if totalText.isEmpty{
                    totalText += displayString
                }else{
                    totalText += "\n\(displayString)"
                }

            }
        }
        return totalText
        
//        guard let str = self.description.first, var displayString = str.getAttributedString?.string else  {return ""}
//        if displayString.contains(find: "\t•\t"){
//            displayString = displayString.replacingOccurrences(of: "\t•\t", with: "•   ")
//        }else if displayString.contains(find: " • "){
//            displayString = displayString.replacingOccurrences(of: " • ", with: "\n•   ")
//        }else if displayString.contains(find: " · "){
//            displayString = displayString.replacingOccurrences(of: " · ", with: "\n•   ")
//        }
//        return "\(displayString)\n"
    }
    
    var descriptionTitle:String{
        
        let dexcription = descriptionShown.components(separatedBy: "\n•   ").first ?? ""
        return dexcription
    }

    init(_ json: JSON = JSON()){
        fk = json["fk"].stringValue
        farepr = json["farepr"].doubleValue
        fare = IntTaxes(json["fare"])
        cabinCalss = json["class"].arrayValue.map({$0.arrayValue.map{$0.stringValue}}).flatMap{$0}
        fareTypeName = json["FareTypeName"].arrayValue.map({$0.arrayValue.map{$0.stringValue}}).flatMap{$0}
        title = json["title"].arrayValue.map({$0.arrayValue.map{$0.stringValue}}).flatMap{$0}
        bc = json["bc"].arrayValue.map({$0.arrayValue.map{$0.stringValue}}).flatMap{$0}
        subtitle = json["subtitle"].arrayValue.map({$0.arrayValue.map{$0.stringValue}}).flatMap{$0}
        description = json["description"].arrayValue.map({$0.arrayValue.map{$0.stringValue}}).flatMap{$0}
        img = json["img"].arrayValue.map({$0.arrayValue.map{$0.stringValue}}).flatMap{$0}
        apc = json["apc"].stringValue
        flightResult = IntJourney(jsonData: json["flight_result"])
        flightResult.fare = self.fare
        isDefault = json["default"].boolValue
        sortOrder = json["tax_sort"].stringValue
    }
}


struct OtherFareCache{
    
    var data:[OtherFareModel]?
    var date:Date
    var fk: String
    
}
