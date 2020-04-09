//
//  CountryVC+TableViewDelegates.swift
//  AERTRIP
//
//  Created by Appinventiv on 26/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

import Foundation

extension CountryVC : UITableViewDelegate, UITableViewDataSource {
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        noResultemptyView.isHidden = self.countryVm.countriesCount > 0
        return self.countryVm.countriesCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as? CountryCell else {
                       fatalError("SettingsCell not found")
               }
        
        cell.populateData(country: self.countryVm.getCountry(at: indexPath.row), isSelected: !self.countryVm.isSelectedCountry(index: indexPath.row))
                
        return cell
        
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        self.countryVm.selectCountry(index: indexPath.row)
        self.countryTableView.reloadData()
        
        delay(seconds: 0.3) {
            self.countryVm.againSelectIndia()
            self.countryTableView.reloadData()
        }
        
    }
    
}
