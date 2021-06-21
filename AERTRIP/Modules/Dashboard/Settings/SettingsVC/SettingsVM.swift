//
//  SettingsVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 25/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SettingsVM {
    
    enum SettingsOptions : String {
        case country = "Country"
        case currency = "Currency"
        case notification = "Notification"
        case changeAertripId = "Change Aertrip ID"
        case changePassword = "Change Password"
        case changeMobileNumber = "Change Mobile Number"
        case disableWalletOtp = "Disable OTP for Wallet Payments"
        case calenderSync = "Calendar Sync"
        case aboutUs = "About Us"
        case legal = "Legal"
        case privacyPolicy = "Privacy Policy"
        case appearance = "Appearance"
    }
    
    var settingsDataToPopulate: [Int:[SettingsOptions]] {
        if UserInfo.loggedInUser != nil {
            return [
                0 : [SettingsOptions.appearance],
                1 : [SettingsOptions.country, SettingsOptions.currency, SettingsOptions.notification],
                2 : [SettingsOptions.calenderSync],
                3 : [SettingsOptions.changeAertripId,SettingsOptions.changeMobileNumber,SettingsOptions.changePassword, SettingsOptions.disableWalletOtp],
                4 : [SettingsOptions.aboutUs, SettingsOptions.legal, SettingsOptions.privacyPolicy]
            ]
        } else {
            return [
                0 : [SettingsOptions.appearance],
                1 : [SettingsOptions.country, SettingsOptions.currency, SettingsOptions.notification],
                2 : [SettingsOptions.calenderSync],
                3 : [SettingsOptions.aboutUs, SettingsOptions.legal, SettingsOptions.privacyPolicy]
            ]
        }
    }
    
    
    func getSettingsType(key : Int, index : Int) -> SettingsOptions {
        guard let items = self.settingsDataToPopulate[key]?[index] else { return SettingsVM.SettingsOptions.aboutUs }
        return items
    }
    
    func getCountInParticularSection(section : Int) -> Int {
        guard let items = self.settingsDataToPopulate[section] else { return 0 }
        return items.count
    }
    
    func isSepratorHidden(section : Int, row : Int) -> Bool {
        let curSecRowCount = settingsDataToPopulate[section]?.count ?? 0
        if section == 0 {
            return true
        } else if section == 1 && row == curSecRowCount - 1 {
            return true
        }else if section == 2 {
            return true
        }else if section == 3 && row == curSecRowCount - 1 {
            return true
        }else if section == 4 && row == curSecRowCount - 1 {
            return true
        }else{
            return false
        }
    }
    
    func isHeaderTopSeprator(section : Int) -> Bool {
        return section == 0
    }
    
    func getVersion() -> String {
        guard let info = Bundle.main.infoDictionary else { return "" }
        let appVersion = info["CFBundleShortVersionString"] as? String ?? ""
        let appBuild = info[kCFBundleVersionKey as String] as? String ?? ""
        return "Version " + appVersion + "(" + appBuild + ")"
    }
    
}

extension SettingsVM{

    func logEvenOnTap(with indexPath:IndexPath){
        switch self.getSettingsType(key: indexPath.section, index: indexPath.row) {
        case .country:
            FirebaseEventLogs.shared.logSettingEvents(with: .changeCountry)
        case .currency:
            FirebaseEventLogs.shared.logSettingEvents(with: .changeCurrency)
        case .notification:
            FirebaseEventLogs.shared.logSettingEvents(with: .changeNotification)
        case .changeAertripId:
            FirebaseEventLogs.shared.logSettingEvents(with: .openChangeId)
        case .changePassword:
            if (UserInfo.loggedInUser?.hasPassword == true){
                FirebaseEventLogs.shared.logSettingEvents(with: .openChangePassword)
            } else {
                FirebaseEventLogs.shared.logSettingEvents(with: .openSetPassword)
            }
        case .changeMobileNumber:
            if (UserInfo.loggedInUser?.mobile.isEmpty ?? false){
                FirebaseEventLogs.shared.logSettingEvents(with: .openChangeMobile)
            }else{
                FirebaseEventLogs.shared.logSettingEvents(with: .openSetMobile)
            }
        case .disableWalletOtp:
            FirebaseEventLogs.shared.logSettingEvents(with: .changeCountry)
        case .calenderSync:
            FirebaseEventLogs.shared.logSettingEvents(with: .toggleCalendar)
        case .aboutUs:
            FirebaseEventLogs.shared.logSettingEvents(with: .OpenAboutUs)
        case .legal:
            FirebaseEventLogs.shared.logSettingEvents(with: .OpenLegal)
        case .privacyPolicy:
            FirebaseEventLogs.shared.logSettingEvents(with: .openPrivacy)
        case .appearance:
            FirebaseEventLogs.shared.logSettingEvents(with: .openAppearance)
        }
    }
    
    
}






