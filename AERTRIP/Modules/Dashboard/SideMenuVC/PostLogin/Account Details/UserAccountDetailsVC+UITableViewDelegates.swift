//
//  AccountDetailsVC+UITableViewDelegates.swift
//  AERTRIP
//
//  Created by Admin on 12/01/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import Foundation

extension UserAccountDetailsVC : UITableViewDelegate, UITableViewDataSource {

      func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.accountDetailsDict.count
      }
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.accountDetailsDict[section]?.count ?? 0
      }
      
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
      }
      
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 { return nil }
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingsHeaderView") as? SettingsHeaderView else {
            fatalError("SettingsHeaderView not found")
        }
//        headerView.topSepratorView.isHidden = self.settingsVm.isHeaderTopSeprator(section : section)
        headerView.titleLabel.text = ""
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserAccountDetailsCell", for: indexPath) as? UserAccountDetailsCell else { fatalError("UserAccountDetailsCell not found") }
        
        let type = self.viewModel.accountDetailsDict[indexPath.section]?[indexPath.row] ?? .pan
        cell.dividerView.isHidden = type == .gSTIN
        cell.populateData(type: type)
        return cell
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.openUpdateAccount(type: self.viewModel.accountDetailsDict[indexPath.section]?[indexPath.row] ?? .pan)
    }
    
    
    func openUpdateAccount(type : AccountUpdationType){
        
        let vc = UpdateAccountDetailsVC.instantiate(fromAppStoryboard: .OTPAndVarification)
        vc.viewModel.updationType = type
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
}
