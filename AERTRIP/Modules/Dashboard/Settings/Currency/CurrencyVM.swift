//
//  CurrencyVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 26/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class CurrencyVM {
    
    var countries: [PKCountryModel] = [PKCountryModel]()
    var selectedCountry = PKCountryModel(json: [:])
    
    func getCountries() {
        countries = PKCountryPicker.default.getAllCountries().filter { !$0.currencySymbol.isEmpty }
    }
    
}
