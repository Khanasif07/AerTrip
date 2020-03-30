//
//  SettingsVC+TableViewDelegates.swift
//  AERTRIP
//
//  Created by Appinventiv on 25/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension SettingsVC : UITableViewDelegate, UITableViewDataSource {
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingsVm.getCountInParticularSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0,1:
            return 35
        default:
            return 54
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as? SettingsCell else { fatalError("SettingsCell not found") }
        cell.populateCell(type : self.settingsVm.getSettingsType(key: indexPath.section, index: indexPath.row))
        return cell
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch self.settingsVm.getSettingsType(key: indexPath.section, index: indexPath.row) {
            case .country:
                AppFlowManager.default.moveToCountryVC()
       
            case .currency:
                AppFlowManager.default.moveToCurrencyVC()
            
        case .notification:
            AppFlowManager.default.moveToNotificationSettingsVC()

            
        default:
                break
        }
        
    }
    
}
