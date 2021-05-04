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
    
//    private var countries: [CurrencyModel] = [CurrencyModel]()
//    private var selectedCountry = CurrencyModel(json: [:], code: "")
    weak var delegate : CurrencyVcDelegate?
    private var filteredCountries: [CurrencyModel] = [CurrencyModel]()
    var searchText : String = ""
    var seperatorIndex = 0
    
    var currencyCount : Int {
        return getCurrentDaraSource().count
    }
    
    func preSelectIndia(){
        let india = CurrencyControler.shared.countries.filter { $0.currencyCode == UserInfo.preferredCurrencyDetails?.currencyCode  }
        CurrencyControler.shared.selectedCurrency = india.first ?? CurrencyModel(json: [:], code: "")
    }
    
    func selectCurrency(index : Int){
        CurrencyControler.shared.setSelectedCurrency(currency: self.getCurrentDaraSource()[index])
        CurrencyControler.shared.updateUserCurrency()
    }
    
    
    func getCurrentDaraSource() -> [CurrencyModel] {
        return self.searchText.isEmpty ? CurrencyControler.shared.countries : filteredCountries
    }
    
    func getCurrency(at index : Int) -> CurrencyModel {
        return getCurrentDaraSource()[index]
    }
    
    func isSelectedCurrency(index : Int) -> Bool {
        return getCurrentDaraSource()[index].currencyCode == CurrencyControler.shared.selectedCurrency.currencyCode
    }
    
    func isSeperatorHidden(index : Int) -> Bool {
        return self.seperatorIndex != index
    }
    
    func clearFilteredData(){
        self.filteredCountries.removeAll()
    }
    
    func filterCountries(txt : String) {
        self.filteredCountries = CurrencyControler.shared.countries.filter { (obj) -> Bool in
            
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

            return false
        }
    }
    
    func getCurrenciesFromApi() {
        
        self.delegate?.willGetCurrencies()
        
        CurrencyControler.shared.getCurrencies { (success, allCurrencies, topCurrencies) in
            
            if success {
                self.seperatorIndex = topCurrencies.count - 1
                self.preSelectIndia()
                self.delegate?.getCurrenciesSuccessFull()
            } else{
                
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
