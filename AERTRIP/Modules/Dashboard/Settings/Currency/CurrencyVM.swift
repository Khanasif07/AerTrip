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
        let india = countries.filter { $0.countryID == 93 }
        selectedCountry = india.first ?? PKCountryModel(json: [:])
    }
    
    func getCurrencies() {
        countries = PKCountryPicker.default.getAllCountries().filter { !$0.currencySymbol.isEmpty }
    }
    
   func selectCurrency(index : Int){
        if self.getCurrentDaraSource()[index].countryID != 93 {
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
        return getCurrentDaraSource()[index].countryID == selectedCountry.countryID
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
        
        APICaller.shared.getCurrencies(params: [:]) { (success, data) in
        
        }
        
    }
    
}

