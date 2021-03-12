//
//  FirebaseEventLogController.swift
//  AERTRIP
//
//  Created by Admin on 12/03/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import Foundation


class FirebaseEventLogs{
    
    static let shared = FirebaseEventLogs()
    private init(){}
    
    enum EventsTypeName:String {
        ///Settings Events
        case changeCountry = "TryToChangeConuntry"
        case changeCurrency = "TryToChangeCurrency"
        case changeNotification = "TryToChangeNotification"
        case toggleCalender = "TryToToggleOnCalenderSync"
        case openChangeId = "OpenChangeAertripID"
        case openSetMobile = "OpenChangeMobileNumber"
        case openChangeMobile = "OpenSetMobileNumber"
        case openSetPassword = "OpenSetPassword"
        case openChangePassword = "OpenChangePassword"
        case openEnableWallet = "OpenEnableOTPForWalletPayments"
        case openDisableWallet = "OpenDisableOTPForWalletPayments"
        case openAboutUs = "OpenAboutUs"
        case openLegal = "OpenLegal"
        case openPrivacy = "OpenPrivacyPolicy"
        
        ///AccountDetailsUpdate
        case aadhar = "Aadhar"
        case pan = "PAN"
        case defaultRefundMode = "ChangeDefaultRefundMode"
        case billingAddress = "BillingAddress"
        case gstIn = "GSTIN"
        case billingName = "BillingName"
    }
    
    
    //MARK: Settings Events
    func logSettingEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Settings.rawValue, params: [AnalyticsKeys.FilterName.rawValue: type.rawValue])
    }

    
    
}
