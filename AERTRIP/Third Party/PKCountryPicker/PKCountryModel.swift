//
//  PKCountryModel.swift
//
//  Created by Pramod Kumar on 07/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
import SwiftyJSON

public struct PKCountryModel {
    var countryID: Int = 0
    var countryEnglishName: String = ""
    var countryLocalName: String = ""
    var countryFlag: String = ""
    var ISOCode: String = ""
    var countryCode: String = ""
    var countryExitCode: Int = 0
    var minNSN: Int = 0
    var maxNSN: Int = 0
    var trunkCode: Int = 0
    var googleStore: Int = 0
    var appleStore: Int = 0
    var uNRank: Int = 0
    var mobileRank: Int = 0
    var sortIndex: Int = 0
    var flagImage: UIImage? {
        return UIImage(named: self.countryFlag)
    }
    var currencyId : String = ""
    var currencySymbol : String = ""
    var currencyName : String = ""
    var currencyCode : String = ""
    
    init(json: [String: Any]) {
        if let obj = json["CountryID"] as? Int {
            self.countryID = obj
        }
        
        if let obj = json["CountryEnglishName"] as? String {
            self.countryEnglishName = obj
        }
        
        if let obj = json["CountryLocalName"] as? String {
            self.countryLocalName = obj
        }
        
        if let obj = json["CountryFlag"] as? String {
            self.countryFlag = obj
        }
        
        if let obj = json["ISOCode"] as? String {
            self.ISOCode = obj
            self.countryFlag = "\(obj).png".lowercased()
        }
        
        if let obj = json["CountryCode"] {
            self.countryCode = PKCountryPickerSettings.shouldAddPlusInCountryCode ? "+\(obj)" : "\(obj)"
        }
        
        if let obj = json["CountryExitCode"] as? Int {
            self.countryExitCode = obj
        }
        
        if let obj = json["Min NSN"] as? Int {
            self.minNSN = obj
        }
        
        if let obj = json["Max NSN"] as? Int {
            self.maxNSN = obj
        }
        
        if let obj = json["TrunkCode"] as? Int {
            self.trunkCode = obj
        }
        
        if let obj = json["GoogleStore"] as? Int {
            self.googleStore = obj
        }
        
        if let obj = json["AppleStore"] as? Int {
            self.appleStore = obj
        }
        
        if let obj = json["UNRank"] as? Int {
            self.uNRank = obj
        }
        
        if let obj = json["MobileRank"] as? Int {
            self.mobileRank = obj
        }
        
        if let obj = json["SortIndex"] as? Int {
            self.sortIndex = obj
        }
        
        if let obj = json["CurrencySymbol"] as? String {
            self.currencySymbol = obj
        }
        
        if let obj = json["CurrencyCode"] as? String {
            self.currencyCode = obj
        }
        
        if let obj = json["CurrencyName"] as? String {
            self.currencyName = obj
        }
        
    }
    
    init(json: JSON) {
        currencyId = json[APIKeys.id.rawValue].stringValue
        currencyCode = json[APIKeys.currency_code.rawValue].stringValue
        currencyName = json[APIKeys.name.rawValue].stringValue
        self.currencySymbol = self.getCurrencySymbol(from: json[APIKeys.currency_code.rawValue].stringValue) ?? ""
    }
    
    static func getModels(jsonArr: [[String:Any]]) -> [PKCountryModel] {
        var all = jsonArr.map { (json) -> PKCountryModel in
            PKCountryModel(json: json)
        }
        
        all.sort { (first, second) -> Bool in
            first.sortIndex < second.sortIndex
        }
        
        return all
    }
    
    func getCurrencySymbol(from currencyCode: String) -> String? {

         let locale = NSLocale(localeIdentifier: currencyCode)
         if locale.displayName(forKey: .currencySymbol, value: currencyCode) == currencyCode {
             let newlocale = NSLocale(localeIdentifier: currencyCode.dropLast() + "_en")
             return newlocale.displayName(forKey: .currencySymbol, value: currencyCode)
         }
         return locale.displayName(forKey: .currencySymbol, value: currencyCode)
     }
}

