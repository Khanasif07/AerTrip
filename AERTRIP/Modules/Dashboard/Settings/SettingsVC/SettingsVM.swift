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
    }
    
    var settingsDataToPopulate: [Int:[SettingsOptions]] {
        if UserInfo.loggedInUser != nil {
            return [
                0 : [SettingsOptions.country, SettingsOptions.currency, SettingsOptions.notification],
                1 : [SettingsOptions.calenderSync],
                2 : [SettingsOptions.changeAertripId,SettingsOptions.changeMobileNumber,SettingsOptions.changePassword, SettingsOptions.disableWalletOtp],
                3 : [SettingsOptions.aboutUs, SettingsOptions.legal, SettingsOptions.privacyPolicy]
            ]
        } else {
            return [
                0 : [SettingsOptions.country, SettingsOptions.currency, SettingsOptions.notification],
                1 : [SettingsOptions.calenderSync],
                2 : [SettingsOptions.aboutUs, SettingsOptions.legal, SettingsOptions.privacyPolicy]
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
        if section == 0 && row == 2{
            return true
        }else if section == 1 {
            return true
        }else if section == 2 && row == 3 {
            return true
        }else if section == 3 && row == 2 {
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
    
    enum LogEventType{
        case changeCountry, changeCurrency, changeNotification, toggleCalender
        case openChangeId, openSetMobile, openChangeMobile, openSetPassword
        case openChangePassword, openEnableWallet, openDisableWallet
        case openAboutUs, openLegal, openPrivacy
    }
    
    
    func logEvenOnTap(with indexPath:IndexPath){
        switch self.getSettingsType(key: indexPath.section, index: indexPath.row) {
        case .country: self.logEvent(with: .changeCountry)
        case .currency: self.logEvent(with: .changeCurrency)
        case .notification: self.logEvent(with: .changeNotification)
        case .changeAertripId: self.logEvent(with: .openChangeId)
        case .changePassword:
            if (UserInfo.loggedInUser?.hasPassword == true){
                self.logEvent(with: .openChangePassword)
            } else {
                self.logEvent(with: .openSetPassword)
            }
        case .changeMobileNumber:
            if (UserInfo.loggedInUser?.mobile.isEmpty ?? false){
                self.logEvent(with: .openChangeMobile)
            }else{
                self.logEvent(with: .openSetMobile)
            }
        case .disableWalletOtp: self.logEvent(with: .changeCountry)
        case .calenderSync: self.logEvent(with: .toggleCalender)
        case .aboutUs: self.logEvent(with: .openAboutUs)
        case .legal: self.logEvent(with: .openLegal)
        case .privacyPolicy: self.logEvent(with: .openPrivacy)
        }
    }
    
    private func logEvent(with eventType:LogEventType){
        var filterName:String = ""
        switch eventType {
        case .changeCountry: filterName = "TryToChangeConuntry"
        case .changeCurrency: filterName = "TryToChangeCurrency"
        case .changeNotification: filterName = "TryToChangeNotification"
        case .toggleCalender: filterName = "TryToToggleOnCalenderSync"
        case .openChangeId: filterName = "OpenChangeAertripID"
        case .openSetMobile: filterName = "OpenChangeMobileNumber"
        case .openChangeMobile: filterName = "OpenSetMobileNumber"
        case .openSetPassword: filterName = "OpenSetPassword"
        case .openChangePassword: filterName = "OpenChangePassword"
        case .openEnableWallet: filterName = "OpenEnableOTPForWalletPayments"
        case .openDisableWallet: filterName = "OpenDisableOTPForWalletPayments"
        case .openAboutUs: filterName = "OpenAboutUs"
        case .openLegal: filterName = "OpenLegal"
        case .openPrivacy: filterName = "OpenPrivacyPolicy"
        }
        
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Settings.rawValue, params: [AnalyticsKeys.FilterName.rawValue: filterName])
    }
    
}






