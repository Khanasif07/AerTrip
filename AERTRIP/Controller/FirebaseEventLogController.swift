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
        //MARK: Settings Events TypeNames
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
        
        //MARK: Account update Events TypeNames
        case aadhar = "Aadhar"
        case pan = "PAN"
        case defaultRefundMode = "ChangeDefaultRefundMode"
        case billingAddress = "BillingAddress"
        case gstIn = "GSTIN"
        case billingName = "BillingName"
    }
    
    
    //MARK: Settings Events Log Function
    func logSettingEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Settings.rawValue, params: [AnalyticsKeys.FilterName.rawValue: type.rawValue])
    }

    //MARK: Update Account Details Events Log Function
    func logUpdateAccountEvents(with type: EventsTypeName, isUpdating:Bool = false, value:String = ""){
        var eventDetails = "n/a"
        var value = "n/a"
        switch type{
        case .aadhar : eventDetails = isUpdating ? "UpdateAadhar" : "InsertAadhar"
        case .pan:
            eventDetails = isUpdating ? "UpdatePAN" : "InsertPAN"
        case .gstIn:
            eventDetails = isUpdating ? "UpdateGSTIN" : "InsertGSTIN"
        case .defaultRefundMode:
            value = (value == "1") ? "Change default refund to Wallet" : "Change default refund to Online"
        case .billingName:
            eventDetails = "UpdateBillingName"
        case .billingAddress:
            eventDetails = "UpdateBillingAddress"
        default: break;
        }
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.AccountDetails.rawValue, params: [AnalyticsKeys.FilterName.rawValue:type.rawValue, AnalyticsKeys.FilterType.rawValue:eventDetails, AnalyticsKeys.Values.rawValue:value])
    }
    
    
}
