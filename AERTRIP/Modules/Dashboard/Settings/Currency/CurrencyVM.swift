//
//  CurrencyVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 26/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol CurrencyVcDelegate : class {
    func showUnderDevelopmentPopUp()
    
    func willGetCurrencies()
    func getCurrenciesSuccessFull()
    func failedToGetCurrencies()
    
}

class CurrencyVM {
    
    private var countries: [CurrencyModel] = [CurrencyModel]()
    private var selectedCountry = CurrencyModel(json: [:], code: "")
    weak var delegate : CurrencyVcDelegate?
    private var filteredCountries: [CurrencyModel] = [CurrencyModel]()
    var searchText : String = ""
    var seperatorIndex = 0
    
    var currencyCount : Int {
        return getCurrentDaraSource().count
    }
    
    func preSelectIndia(){
        let india = countries.filter { $0.code == "INR"  }
        selectedCountry = india.first ?? CurrencyModel(json: [:], code: "")
    }
    
//    func getCurrencies() {
//        countries = PKCountryPicker.default.getAllCountries().filter { !$0.currencySymbol.isEmpty }
//    }
    
    func selectCurrency(index : Int){
//        if self.getCurrentDaraSource()[index].currencyCode != "INR" {
//            self.delegate?.showUnderDevelopmentPopUp()
//            return
//        }
        self.selectedCountry = self.getCurrentDaraSource()[index]
    }
    
    func againSelectIndia(){
        if let indiaIndex = self.getCurrentDaraSource().lastIndex(where: { (obj) -> Bool in
            return obj.code == "INR"
        }){
            self.selectedCountry = self.getCurrentDaraSource()[indiaIndex]
            self.delegate?.showUnderDevelopmentPopUp()
        }else{
            
            guard let indiaIndex = self.countries.lastIndex(where: { (obj) -> Bool in
                return obj.code == "INR"
            }) else { return }
            self.selectedCountry = self.countries[indiaIndex]
            self.delegate?.showUnderDevelopmentPopUp()
            
        }
    }
    
    func getCurrentDaraSource() -> [CurrencyModel] {
        return self.searchText.isEmpty ? countries : filteredCountries
    }
    
    func getCurrency(at index : Int) -> CurrencyModel {
        return getCurrentDaraSource()[index]
    }
    
    func isSelectedCurrency(index : Int) -> Bool {
        return getCurrentDaraSource()[index].code == selectedCountry.code
    }
    
    func isSeperatorHidden(index : Int) -> Bool {
        return self.seperatorIndex != index
    }
    
    func clearFilteredData(){
        self.filteredCountries.removeAll()
    }
    
    func filterCountries(txt : String) {
        self.filteredCountries = self.countries.filter { (obj) -> Bool in
            
            let currencyName = obj.name.lowercased()
            let currencyNameArray = currencyName.split(separator: " ")
            
            for item in currencyNameArray{
                if item.starts(with: txt.lowercased()){
                    return true
                }
            }
            
            let currencyCode = obj.code.lowercased()
            let currencyCodeArray = currencyCode.split(separator: " ")
            
            for item in currencyCodeArray {
                if item.starts(with: txt.lowercased()){
                    return true
                }            }
            
//            let currencySymbol = obj.currencySymbol.lowercased()
//            let currencySymbolArray = currencySymbol.split(separator: " ")
//
//            for item in currencySymbolArray {
//                if item.starts(with: txt.lowercased()){
//                    return true
//                }            }
            
            return false
        }
    }
    
    func getCurrenciesFromApi() {
        
        self.delegate?.willGetCurrencies()
        
        APICaller.shared.getCurrencies(params: [:]) { (success, data) in
            if success{
                
               let data = data.sorted { (one, two) -> Bool in
                    two.name.lowercased() > one.name.lowercased()
                }
                
                var topCountries =  data.filter { (obj) -> Bool in
                    return obj.code == "INR" || obj.code == "USD" || obj.code == "EUR" || obj.code == "JYP" || obj.code == "GBP"
                }
                
                let restCountries = data.filter { (obj) -> Bool in
                    return obj.code != "INR" && obj.code != "USD" && obj.code != "EUR" && obj.code != "JYP" && obj.code != "GBP"
                }
                
               topCountries = self.arangeTopCountries(countries: topCountries)
                
                self.countries = topCountries + restCountries
                self.seperatorIndex = topCountries.count - 1
                self.preSelectIndia()
                self.delegate?.getCurrenciesSuccessFull()
            }else{
                self.delegate?.failedToGetCurrencies()
            }
        }
    }
    
    func arangeTopCountries(countries : [CurrencyModel]) -> [CurrencyModel]{
       
        var topCountries = countries
        
        if let indiaIndex = topCountries.lastIndex(where: { (obj) -> Bool in
             return obj.code == "GBP"
         }){
             let india = topCountries[indiaIndex]
             topCountries.remove(at: indiaIndex)
             topCountries.insert(india, at: 0)
         }
         
         if let indiaIndex = topCountries.lastIndex(where: { (obj) -> Bool in
             return obj.code == "JYP"
         }){
             let india = topCountries[indiaIndex]
             topCountries.remove(at: indiaIndex)
             topCountries.insert(india, at: 0)
         }
         
         if let indiaIndex = topCountries.lastIndex(where: { (obj) -> Bool in
             return obj.code == "EUR"
         }){
             let india = topCountries[indiaIndex]
             topCountries.remove(at: indiaIndex)
             topCountries.insert(india, at: 0)
         }
         
         if let indiaIndex = topCountries.lastIndex(where: { (obj) -> Bool in
             return obj.code == "USD"
         }){
             let india = topCountries[indiaIndex]
             topCountries.remove(at: indiaIndex)
             topCountries.insert(india, at: 0)
         }
         
         if let indiaIndex = topCountries.lastIndex(where: { (obj) -> Bool in
             return obj.code == "INR"
         }){
             let india = topCountries[indiaIndex]
             topCountries.remove(at: indiaIndex)
             topCountries.insert(india, at: 0)
         }
        return topCountries
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

