//
//  CurrencyControler.swift
//  AERTRIP
//
//  Created by Admin on 04/05/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import Foundation


class CurrencyControler {
    
    
    static let shared = CurrencyControler()
    
     var countries: [CurrencyModel] = [CurrencyModel]()
     var selectedCurrency = CurrencyModel(json: [:], code: "")
    
    
    func getCurrencies(completionBlock: @escaping (_ success: Bool, _ allCurrencies: [CurrencyModel], _ topCurrencies : [CurrencyModel]) -> Void) {
        
        APICaller.shared.getCurrencies { (success, currencies) in
            
            if success{
                
               let data = currencies.sorted { (one, two) -> Bool in
                    two.currencyName.lowercased() > one.currencyName.lowercased()
                }
                
                var topCountries =  data.filter { (obj) -> Bool in
                    return obj.group.lowercased() == "primary"
//                    return obj.currencyCode == "INR" || obj.currencyCode == "USD" || obj.currencyCode == "EUR" || obj.currencyCode == "JYP" || obj.currencyCode == "GBP"
                }
                
                let restCountries = data.filter { (obj) -> Bool in
                    return obj.group.lowercased() != "primary"
//                    return obj.currencyCode != "INR" && obj.currencyCode != "USD" && obj.currencyCode != "EUR" && obj.currencyCode != "JYP" && obj.currencyCode != "GBP"
                }
                
               topCountries = self.arangeTopCountries(countries: topCountries)
                
                self.countries = topCountries + restCountries
                
              //  self.delegate?.getCurrenciesSuccessFull()
            }else{
             //   self.delegate?.failedToGetCurrencies()
            }
            
        }
        
    }
    
    
    func arangeTopCountries(countries : [CurrencyModel]) -> [CurrencyModel]{
       
        var topCountries = countries
        
        if let indiaIndex = topCountries.lastIndex(where: { (obj) -> Bool in
             return obj.currencyCode == "GBP"
         }){
             let india = topCountries[indiaIndex]
             topCountries.remove(at: indiaIndex)
             topCountries.insert(india, at: 0)
         }
         
         if let indiaIndex = topCountries.lastIndex(where: { (obj) -> Bool in
             return obj.currencyCode == "JYP"
         }){
             let india = topCountries[indiaIndex]
             topCountries.remove(at: indiaIndex)
             topCountries.insert(india, at: 0)
         }
         
         if let indiaIndex = topCountries.lastIndex(where: { (obj) -> Bool in
             return obj.currencyCode == "EUR"
         }){
             let india = topCountries[indiaIndex]
             topCountries.remove(at: indiaIndex)
             topCountries.insert(india, at: 0)
         }
         
         if let indiaIndex = topCountries.lastIndex(where: { (obj) -> Bool in
             return obj.currencyCode == "USD"
         }){
             let india = topCountries[indiaIndex]
             topCountries.remove(at: indiaIndex)
             topCountries.insert(india, at: 0)
         }
         
         if let indiaIndex = topCountries.lastIndex(where: { (obj) -> Bool in
             return obj.currencyCode == "INR"
         }){
             let india = topCountries[indiaIndex]
             topCountries.remove(at: indiaIndex)
             topCountries.insert(india, at: 0)
         }
        return topCountries
    }
    
    
    func setSelectedCurrency(currency : CurrencyModel){
        self.selectedCurrency = currency
    }
    
    func updateUserCurrency(){
        let param:JSONDictionary = ["preferred_currency": self.selectedCountry.currencyCode, "action":"currency"]
        APICaller.shared.updateUserCurrency(params: param) {[weak self] (success, error) in
            guard let self = self else {return}
            if success{
                UserInfo.loggedInUser?.preferredCurrency = self.selectedCountry.currencyCode
                UserInfo.preferredCurrencyDetails = self.selectedCountry
                NotificationCenter.default.post(.init(name: .dataChanged))
            }
        }
    }
    
    
    func selectCurrency(index : Int){
//        if self.getCurrentDaraSource()[index].currencyCode != "INR" {
//            self.delegate?.showUnderDevelopmentPopUp()
//            return
//        }
        self.selectedCountry = self.getCurrentDaraSource()[index]
        CurrencyControler.shared.updateUserCurrency()
    }
    
}
