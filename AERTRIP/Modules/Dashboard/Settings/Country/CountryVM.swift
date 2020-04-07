//
//  CountryVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 26/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol CountryVcDelegate : class {
    func showUnderDevelopmentPopUp()
}

class CountryVM {
  
    private var countries: [PKCountryModel] = [PKCountryModel]()
    private var selectedCountry = PKCountryModel(json: [:])
    weak var delegate : CountryVcDelegate?
    private var filteredCountries: [PKCountryModel] = [PKCountryModel]()
    var searchText : String = ""
    
    func getCountries() {
        countries = PKCountryPicker.default.getAllCountries()
    }
        
    var countriesCount : Int {
        return getCurrentDaraSource().count
    }

    func preSelectIndia(){
       let india = countries.filter { $0.countryID == 93 }
       selectedCountry = india.first ?? PKCountryModel(json: [:])
    }
    
    func selectCountry(index : Int){
        if self.getCurrentDaraSource()[index].countryID != 93 {
            self.delegate?.showUnderDevelopmentPopUp()
            return
        }
        self.selectedCountry = self.getCurrentDaraSource()[index]
    }
    
    func getCurrentDaraSource() -> [PKCountryModel] {
        return self.searchText.isEmpty ? countries : filteredCountries
    }
    
    func getCountry(at index : Int) -> PKCountryModel {
        return getCurrentDaraSource()[index]
    }
    
    func isSelectedCountry(index : Int) -> Bool {
        return getCurrentDaraSource()[index].countryID == selectedCountry.countryID
    }
    
    func clearFilteredData(){
        self.filteredCountries.removeAll()
    }
    
    func filterCountries(txt : String) {
        self.filteredCountries = self.countries.filter { (obj) -> Bool in
            let name = obj.countryEnglishName.lowercased()
        
            let nameArray = name.split(separator: " ")
            
            for item in nameArray{
                if item.starts(with: txt.lowercased()){
                    return true
                }
            }
            return false
        }
    }
    
}
