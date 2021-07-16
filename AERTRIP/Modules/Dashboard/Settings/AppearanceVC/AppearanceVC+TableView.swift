//
//  AppearanceVC+TableView.swift
//  AERTRIP
//
//  Created by Rishabh on 27/05/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import Foundation

extension AppearanceVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as? CountryCell else {
                       fatalError("CountryCell not found")
               }
        cell.sepratorView.isHidden = false
        cell.configureForAppearance(type: viewModel.tableCells[indexPath.row])
        cell.backgroundColor = AppColors.themeBlack26
        cell.tickImgViewTrailing.constant = 12
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
                
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingsHeaderView") as? SettingsHeaderView else {
            fatalError("SettingsHeaderView not found")
        }
        headerView.topSepratorView.isHidden = true
        headerView.bottomSepratorView.isHidden = false
        headerView.titleLabel.text = ""
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingsHeaderView") as? SettingsHeaderView else {
            fatalError("SettingsHeaderView not found")
        }
        footerView.topSepratorView.isHidden = false
        footerView.bottomSepratorView.isHidden = true
        footerView.titleLabel.text = ""
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRow = viewModel.tableCells[indexPath.row]
        switch selectedRow {
        case .light:
            AppUserDefaults.save(value: AppTheme.light.rawValue, forKey: .appTheme)
            switchAppTheme(theme: .light)
        case .dark:
            AppUserDefaults.save(value: AppTheme.dark.rawValue, forKey: .appTheme)
            switchAppTheme(theme: .dark)
        case .system:
            AppUserDefaults.save(value: AppTheme.system.rawValue, forKey: .appTheme)
            switchAppTheme(theme: .system)
        }
        tableView.reloadData()
    }
    
    private func switchAppTheme(theme: AppTheme) {
        switch theme {
        case .light:
            AppDelegate.shared.window?.overrideUserInterfaceStyle = .light
        case .dark:
            AppDelegate.shared.window?.overrideUserInterfaceStyle = .dark
        default:
            AppDelegate.shared.window?.overrideUserInterfaceStyle = .unspecified
        }
    }
}
