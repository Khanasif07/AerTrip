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
        case changeAertripId = "Change Aertrip Id"
        case changePassword = "Change Password"
        case changeMobileNumber = "Change Mobile Number"
        case disableWalletOtp = "Disable Wallet OTP"
        case calenderSync = "Calendar Sync"
        case aboutUs = "About Us"
        case legal = "Legal"
        case privacyPolicy = "Privacy Policy"
    }
    
    let settingsDataToPopulate = [
        0 : [SettingsOptions.country, SettingsOptions.currency, SettingsOptions.notification, SettingsOptions.changeAertripId,SettingsOptions.changePassword,SettingsOptions.changeMobileNumber, SettingsOptions.disableWalletOtp],
        1 : [SettingsOptions.calenderSync],
        2 : [SettingsOptions.aboutUs, SettingsOptions.legal, SettingsOptions.privacyPolicy]
    ]
    
    
    func getSettingsType(key : Int, index : Int) -> SettingsOptions {
        guard let items = self.settingsDataToPopulate[key]?[index] else { return SettingsVM.SettingsOptions.aboutUs }
        return items
    }
    
    func getCountInParticularSection(section : Int) -> Int {
        guard let items = self.settingsDataToPopulate[section] else { return 0 }
        return items.count
    }
    
    func isSepratorHidden(section : Int, row : Int) -> Bool {
        if section == 0 && row == 6{
            return true
        }else if section == 1 {
            return true
        }else if section == 2 && row == 2 {
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
