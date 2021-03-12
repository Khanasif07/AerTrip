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
        
        //MARK: Set and Change Mobile Events TypeNames
        case emptyMobile = "PressCTAWithoutEnteringMobileNumber"
        case incorrectMobile = "PressCTAEnteringWrongMobileNumber"
        case invlidCurrentPassword = "EnterIncorrectCurrentPassword"
        case openCC = "OpenCountryDD"
        case incorrectOtp = "EnterIncorrectOTP"
        case generatedOtp = "GenerateNewOTP"
        case success
        
         //MARK: Set And Change Password Events TypeNames
        case invalidPasswordFormat = "EnterIncorrectFormatAndContinue"
        case hidePassword = "HidePassword"
        case showPassword = "ShowPassword"
        
        //MARK: Enable And Disable OTP Events TypeNames
        case generateOtpForMob = "GenerateNewMobileOTP"
        case incorrectMobOtp = "EnterIncorrectMobileOTP"
        case generateOtpForEmail = "GenerateNewEmailOTP"
        case incorrectEmailOtp = "EnterIncorrectEmailOTP"
        case enterPasswordAndContinue = "EnterPasswordAndProceed"
        case enableDisableOtp
        
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
    
    //MARK: Set and Change Mobile Log Function
    func logSetUpdateMobileEvents(with type: EventsTypeName, isUpdated:Bool = false){
        let eventName = isUpdated ? AnalyticsEvents.ChangeMobile.rawValue : AnalyticsEvents.SetMobile.rawValue
        var value = type.rawValue
        if type == .success{
            if isUpdated{
                value = "ChangeMobileNumberSuccessfully"
            }else{
                value = "SetMobileNumberSuccessfully"
            }
        }
        FirebaseAnalyticsController.shared.logEvent(name: eventName, params: [AnalyticsKeys.FilterName.rawValue: value])
    }
    
    //MARK: Set and Change Password Log Function
    func logSetUpdatePasswordEvents(with type: EventsTypeName, isUpdated:Bool = false){
        let eventName = isUpdated ? AnalyticsEvents.ChangePassword.rawValue : AnalyticsEvents.SetPassword.rawValue
        var value = type.rawValue
        if type == .success{
            if isUpdated{
                value = "ChangePasswordSuccessfully"
            }else{
                value = "SetPasswordSuccessfully"
            }
        }
        FirebaseAnalyticsController.shared.logEvent(name: eventName, params: [AnalyticsKeys.FilterName.rawValue: value])
    }
    
    //MARK: Enable and Disble wallet OTP Log Function
    func logEnableDisableWalletEvents(with type: EventsTypeName, isEnabled:Bool = false){
        let eventName = isEnabled ? AnalyticsEvents.EnableOTP.rawValue : AnalyticsEvents.DisableOTP.rawValue
        var value = type.rawValue
        if type == .enableDisableOtp{
            if isEnabled{
                value = "EnabledOTP"
            }else{
                value = "DisbaledOTP"
            }
        }
        FirebaseAnalyticsController.shared.logEvent(name: eventName, params: [AnalyticsKeys.FilterName.rawValue: value])
    }
    
}
