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
    
    private var countries: [PKCountryModel] = [PKCountryModel]()
    private var selectedCountry = PKCountryModel(json: [:])
    weak var delegate : CurrencyVcDelegate?
    private var filteredCountries: [PKCountryModel] = [PKCountryModel]()
    var searchText : String = ""
    
    var currencyCount : Int {
        return getCurrentDaraSource().count
    }
    
    func preSelectIndia(){
        let india = countries.filter { $0.currencyCode == "INR"  }
        selectedCountry = india.first ?? PKCountryModel(json: [:])
    }
    
    func getCurrencies() {
        countries = PKCountryPicker.default.getAllCountries().filter { !$0.currencySymbol.isEmpty }
    }
    
   func selectCurrency(index : Int){
        if self.getCurrentDaraSource()[index].currencyCode != "INR" {
            self.delegate?.showUnderDevelopmentPopUp()
            return
        }
        self.selectedCountry = self.getCurrentDaraSource()[index]
    }
    
    func getCurrentDaraSource() -> [PKCountryModel] {
        return self.searchText.isEmpty ? countries : filteredCountries
    }
    
    func getCurrency(at index : Int) -> PKCountryModel {
        return getCurrentDaraSource()[index]
    }
    
    func isSelectedCurrency(index : Int) -> Bool {
        return getCurrentDaraSource()[index].currencyCode == selectedCountry.currencyCode
    }
    
    func clearFilteredData(){
        self.filteredCountries.removeAll()
    }
    
    func filterCountries(txt : String) {
        self.filteredCountries = self.countries.filter { (obj) -> Bool in
            
            let currencyName = obj.currencyName.lowercased()
            let currencyNameArray = currencyName.split(separator: " ")
            
            for item in currencyNameArray{
                if item.starts(with: txt.lowercased()){
                    return true
                }
            }
            
            let currencyCode = obj.currencyCode.lowercased()
            let currencyCodeArray = currencyCode.split(separator: " ")
            
            for item in currencyCodeArray {
                if item.starts(with: txt.lowercased()){
                    return true
                }            }
            
            let currencySymbol = obj.currencySymbol.lowercased()
            let currencySymbolArray = currencySymbol.split(separator: " ")
            
            for item in currencySymbolArray {
                if item.starts(with: txt.lowercased()){
                    return true
                }            }
            
            return false
        }
    }

    func getCurrenciesFromApi() {
        
        self.delegate?.willGetCurrencies()
        
        APICaller.shared.getCurrencies(params: [:]) { (success, data) in
            if success{
                
              var topCountries =  data.filter { (obj) -> Bool in
                   return obj.currencyCode == "INR" || obj.currencyCode == "USD" || obj.currencyCode == "EUR" || obj.currencyCode == "JYP" || obj.currencyCode == "GBP"
                }
                
              let restCountries = data.filter { (obj) -> Bool in
                   return obj.currencyCode != "INR" && obj.currencyCode != "USD" && obj.currencyCode != "EUR" && obj.currencyCode != "JYP" && obj.currencyCode != "GBP"
                }
                
                if let indiaIndex = topCountries.lastIndex(where: { (obj) -> Bool in
                    return obj.currencyCode == "INR"
                }){
                    let india = topCountries[indiaIndex]
                    topCountries.remove(at: indiaIndex)
                    topCountries.insert(india, at: 0)
                }
                
                self.countries = topCountries + restCountries
                self.preSelectIndia()
                self.delegate?.getCurrenciesSuccessFull()
            }else{
                self.delegate?.failedToGetCurrencies()
            }
        }
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

