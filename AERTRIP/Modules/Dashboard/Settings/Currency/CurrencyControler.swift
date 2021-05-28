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
    
     var currencies: [CurrencyModel] = [CurrencyModel]()
    
     var selectedCurrency = CurrencyModel(json: [:], code: "")
    
    var timer : Timer?
    
    
    init() {
        print("initialise CurrencyControler")
    }
    
    func scheduleCurrencyTimer(){
        timer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(callCurrencyApi), userInfo: nil, repeats: true)
    }
    
    @objc func callCurrencyApi(){
        self.getCurrencies { (success, currencies, topCurrencies) in  }
    }
    
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
                
                self.currencies = topCountries + restCountries
                completionBlock(true, currencies, topCountries)
              //  self.delegate?.getCurrenciesSuccessFull()
            }else{
                completionBlock(true, [], [])

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
    
    
    func setSelectedCurrency(currency : CurrencyModel?){
        guard let currency = currency else {
            CurrencyControler.shared.getCurrencyCodeFromLocale()
            return }
        self.selectedCurrency = currency
    }
    
    func updateUserCurrency(){
        let param:JSONDictionary = ["preferred_currency": self.selectedCurrency.currencyCode, "action":"currency"]
        
        UserInfo.preferredCurrencyCode = self.selectedCurrency.currencyCode
        UserInfo.preferredCurrencyDetails = self.selectedCurrency
        NotificationCenter.default.post(.init(name: .dataChanged))
        
        APICaller.shared.updateUserCurrency(params: param) {[weak self] (success, error) in
            guard let self = self else {return}
            if success{
  
            }
        }
    }
    
    func getPreferedCurrency(){
    
//        UserInfo.preferredCurrencyDetails
        
    }
    
    func getCurrencyCodeFromLocale(){
        
        let currentLocale = Locale.current
//        print("currencyCode..\(currentLocale.currencyCode)")
        
        UserInfo.preferredCurrencyCode = currentLocale.currencyCode ?? "INR"
        
    }
    
    func getDefaultCurrency(){
        
    }
    
}
