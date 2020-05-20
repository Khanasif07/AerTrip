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
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
            case 1:
                return 54
            default:
                return CGFloat.leastNormalMagnitude
        }
    }
    
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            
            if section == 2 { return nil }
            
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingsHeaderView") as? SettingsHeaderView else {
                fatalError("SettingsHeaderView not found")
            }
            headerView.topSepratorView.isHidden = self.settingsVm.isHeaderTopSeprator(section : section)
            headerView.titleLabel.text = ""
            return headerView
        }
        
        
        func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            if section != 1 { return nil }
            
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingsHeaderView") as? SettingsHeaderView else {
                           fatalError("SettingsHeaderView not found") }
            headerView.titleLabel.text = LocalizedString.AllEventSyncedToCalendarApp.localized
            return headerView
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as? SettingsCell else { fatalError("SettingsCell not found") }
        cell.sepratorView.isHidden = self.settingsVm.isSepratorHidden(section: indexPath.section, row: indexPath.row)
        cell.populateCell(type : self.settingsVm.getSettingsType(key: indexPath.section, index: indexPath.row))
        cell.switch.addTarget(self, action: #selector(toggleSwitched), for: UIControl.Event.valueChanged)
        cell.switch.setOn(false, animated: true)
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

        case .aboutUs:
            AppFlowManager.default.moveToWebViewVC(type: WebViewVM.WebViewType.aboutUs)
            
        case .privacyPolicy:
            AppFlowManager.default.moveToWebViewVC(type: WebViewVM.WebViewType.privacypolicy)
            
        case .legal:
            AppFlowManager.default.moveToWebViewVC(type: WebViewVM.WebViewType.legal)
            
        default:
                break
        }
        
    }
    
    @objc func toggleSwitched(sender : UISwitch) {
//        toggleSettings.calenderSyncSettings = sender.isOn
        delay(seconds: 0.3) {
            AppToast.default.showToastMessage(message: LocalizedString.ThisFunctionalityWillBeAvailableSoon.localized)
            guard let cell = self.settingsTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? SettingsCell else { return }
            cell.switch.setOn(false, animated: true)
        }
    }
    
}
