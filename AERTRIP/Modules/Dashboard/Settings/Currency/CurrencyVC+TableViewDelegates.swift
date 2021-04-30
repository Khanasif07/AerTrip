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
        noResultemptyView.isHidden = self.currencyVm.currencyCount > 0
        return self.currencyVm.currencyCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath) as? CurrencyCell else {
                       fatalError("SettingsCell not found")
               }
                
        cell.populateData(country: currencyVm.getCurrency(at: indexPath.row), isSelected: !self.currencyVm.isSelectedCurrency(index: indexPath.row))
        cell.sepratorView.isHidden = self.currencyVm.isSeperatorHidden(index: indexPath.row)
        return cell
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        self.currencyVm.selectCurrency(index: indexPath.row)
        self.currencyTableView.reloadData()
        
//        delay(seconds: 0.3) {
//            self.currencyVm.againSelectIndia()
//            self.currencyTableView.reloadData()
//        }
        
    }
    
}



