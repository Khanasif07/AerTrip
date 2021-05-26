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
    
    weak var delegate : CurrencyVcDelegate?
    private var filteredCountries: [CurrencyModel] = [CurrencyModel]()
    var searchText : String = ""
    var seperatorIndex = 0
    
    var currencyCount : Int {
        return getCurrentDataSource().count
    }
    
//    func preSelectIndia(){
//        let india = CurrencyControler.shared.currencies.filter { $0.currencyCode == CurrencyControler.shared.selectedCurrency.currencyCode  }
//        CurrencyControler.shared.selectedCurrency = india.first ?? CurrencyModel(json: [:], code: "")
//    }
    
    func selectCurrency(index : Int){
        CurrencyControler.shared.setSelectedCurrency(currency: self.getCurrentDataSource()[index])
        CurrencyControler.shared.updateUserCurrency()
    }
    
    
    func getCurrentDataSource() -> [CurrencyModel] {
        return self.searchText.isEmpty ? CurrencyControler.shared.currencies : filteredCountries
    }
    
    func getCurrency(at index : Int) -> CurrencyModel {
        return getCurrentDataSource()[index]
    }
    
    func isSelectedCurrency(index : Int) -> Bool {
        return getCurrentDataSource()[index].currencyCode == CurrencyControler.shared.selectedCurrency.currencyCode
    }
    
    func isSeperatorHidden(index : Int) -> Bool {
        return self.seperatorIndex != index
    }
    
    func clearFilteredData(){
        self.filteredCountries.removeAll()
    }
    
    func filterCountries(txt : String) {
        self.filteredCountries = CurrencyControler.shared.currencies.filter { (obj) -> Bool in
            
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
//                self.preSelectIndia()
                self.delegate?.getCurrenciesSuccessFull()
            } else{
                
                self.delegate?.failedToGetCurrencies()
            }
            
        }
        
    }
    
    
//    func getCurrencySymbol(from currencyCode: String) -> String? {
//        let locale = NSLocale(localeIdentifier: currencyCode)
//        if locale.displayName(forKey: .currencySymbol, value: currencyCode) == currencyCode {
//            let newlocale = NSLocale(localeIdentifier: currencyCode.dropLast() + "_en")
//            return newlocale.displayName(forKey: .currencySymbol, value: currencyCode)
//        }
//        return locale.displayName(forKey: .currencySymbol, value: currencyCode)
//    }
//    
    
    
}
