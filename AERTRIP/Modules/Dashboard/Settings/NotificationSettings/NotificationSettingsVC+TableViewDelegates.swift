//
//  NotificationSettingsVC+TableViewDelegates.swift
//  AERTRIP
//
//  Created by Appinventiv on 26/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension NotificationSettingsVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationSettingsVm.notificationSettingsDataSource[section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 35 : 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 72 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 { return nil }
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingsHeaderView") as? SettingsHeaderView else {
            fatalError("SettingsHeaderView not found")
        }
        
        headerView.titleLabel.text = ""
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1 { return nil }
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingsHeaderView") as? SettingsHeaderView else {
                       fatalError("SettingsHeaderView not found")
                   }
        headerView.titleLabel.text = LocalizedString.EnableDisableAllNotifications.localized
        return headerView
//        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationSettingsCell", for: indexPath) as? NotificationSettingsCell else { fatalError("SettingsCell not found") }
        cell.sepratorView.isHidden = self.notificationSettingsVm.isSepratorHidden(section: indexPath.section, row: indexPath.row)
        cell.populateData(type: self.notificationSettingsVm.notificationSettingsDataSource[indexPath.section]?[indexPath.row].type ?? NotificationSettingsVM.NotificationSettingsType.bookings, desc: self.notificationSettingsVm.notificationSettingsDataSource[indexPath.section]?[indexPath.row].desc ?? "")
        cell.switch.addTarget(self, action: #selector(toggleSwitched), for: UIControl.Event.valueChanged)
        return cell
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
    
    @objc func toggleSwitched(sender : UISwitch){
        guard let indexPath = sender.tableViewIndexPath(self.notificationSettingsTableView) else { return }
        self.notificationSettingsVm.handleNotificationToggles(section: indexPath.section, row: indexPath.row, isOn: sender.isOn)
        if indexPath.section == 0 && indexPath.row == 0{
            self.notificationSettingsTableView.reloadData()
        }
    }
    
}
