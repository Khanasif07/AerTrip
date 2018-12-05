//
//  Globals.swift
//  
//
//  Created by Pramod Kumar on 09/03/17.
//  Copyright © 2017 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

func printDebug<T>(_ obj : T) {
    print(obj)
}

func printFonts() {
    for family in UIFont.familyNames {
        let fontsName = UIFont.fontNames(forFamilyName: family)
        printDebug(fontsName)
    }
}

func delay(seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}

func getCurrentCountryCode() {
    if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
        
        if let code = UserDefaults.getObject(forKey: UserDefaults.Key.currentCountryCode.rawValue) as? String, code != countryCode {
            
            let file = Bundle.main.path(forResource: "countryData", ofType: "json")
            let data = try? Data(contentsOf: URL(fileURLWithPath: file!))
            
            let jsonData = try? JSONSerialization.jsonObject(with: data!, options: []) as! [JSONDictionary]
            
            if let currentCountry = jsonData?.first(where: { (obj) -> Bool in
                if let countryName = obj["ISOCode"] as? String {
                    return countryCode == countryName
                } else {
                    return false
                }
            }) {
                printDebug(currentCountry["CountryCode"] as? Int)
                if let phoneCode = currentCountry["CountryCode"] as? Int {
                    UserDefaults.setObject("+\(phoneCode)", forKey: UserDefaults.Key.currentCountryCode.rawValue)
                    UserDefaults.setObject(countryCode, forKey: UserDefaults.Key.countryiSOCode.rawValue)
                }
            }
        }
    }
}
