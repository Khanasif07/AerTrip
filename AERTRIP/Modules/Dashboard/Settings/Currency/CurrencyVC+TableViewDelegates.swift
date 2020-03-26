//
//  CurrencyVC+TableViewDelegates.swift
//  AERTRIP
//
//  Created by Appinventiv on 26/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation


extension CurrencyVC : UITableViewDelegate, UITableViewDataSource {
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currencyVm.countries.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as? CurrencyCell else {
                       fatalError("SettingsCell not found")
               }
        cell.populateData(country: self.currencyVm.countries[indexPath.row], isSelected: self.currencyVm.countries[indexPath.row].countryID != self.currencyVm.selectedCountry.countryID)
        return cell
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currencyVm.selectedCountry = self.currencyVm.countries[indexPath.row]
        self.currencyTableView.reloadData()
    }
    
}


