//
//  ChangePasswordVM.swift
//  AERTRIP
//
//  Created by Admin on 20/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol ChangePasswordVMDelegate: class {
    func willCallApi()
    func getSuccess()
    func getFail(errors: ErrorCodes)
}

class ChangePasswordVM {
    
    enum ChangePasswordType {
        case setPassword, changePassword
    }
    
    ///Analytics Enum
    enum LogEventType{
        case invalidFormat, hidePassword, showPassword,invlidCurrentPassword, success
    }
    
    weak var delegate: ChangePasswordVMDelegate?
    var isPasswordType: ChangePasswordType = .setPassword
    var oldPassword = ""
    var password = ""
    
    
    var isValidateData : Bool {
        if isPasswordType == .changePassword {
            if self.oldPassword.isEmpty {
                AppToast.default.showToastMessage(message: LocalizedString.Please_enter_Current_Password.localized)
                return false
            }
            if self.oldPassword.checkInvalidity(.Password) {
                AppToast.default.showToastMessage(message: LocalizedString.Password_must_qualify_conditions.localized)
                return false
            }
            if self.password.checkInvalidity(.Password) {
                //AppToast.default.showToastMessage(message: LocalizedString.PleaseSelectSalutation.localized)
                return false
            }
        } else {
            if self.password.checkInvalidity(.Password) {
                //                AppToast.default.showToastMessage(message: LocalizedString.PleaseSelectSalutation.localized)
                return false
            }
        }
        return true
    }
}

//MARK:- Extension Webservices
//MARK:-
extension ChangePasswordVM {
    
    func webserviceForChangePassword() {
        
        var params = JSONDictionary()
        
        params[APIKeys.password.rawValue]  = self.oldPassword
        params[APIKeys.new_password.rawValue]     = self.password
        
        self.delegate?.willCallApi()
        APICaller.shared.callChangePasswordAPI(params: params, loader: true, completionBlock: {(success, errors) in
            
            if success {
                self.logEvent(with: .success)
                self.delegate?.getSuccess()
            }
            else {
                if errors.contains(47){
                    self.logEvent(with: .invlidCurrentPassword)
                }
                self.delegate?.getFail(errors: errors)
            }
        })
        
    }
    
    func webserviceForSetPassword() {
        
        var params = JSONDictionary()
        params[APIKeys.new_password.rawValue]     = self.password
        
        self.delegate?.willCallApi()
        APICaller.shared.callSetPasswordAPI(params: params, loader: true, completionBlock: {(success, errors) in
            
            if success {
                self.logEvent(with: .success)
                self.delegate?.getSuccess()
            }
            else {
                self.delegate?.getFail(errors: errors)
            }
        })
        
    }
}

///Analytics
extension ChangePasswordVM{
    
    func logEvent(with eventType: LogEventType){
        let eventName = (self.isPasswordType == .changePassword) ? AnalyticsEvents.ChangePassword.rawValue : AnalyticsEvents.SetPassword.rawValue
        var filterName:String = ""
        
        switch eventType{
        case .invalidFormat: filterName = "EnterIncorrectFormatAndContinue"
        case .invlidCurrentPassword: filterName = "EnterIncorrectCurrentPassword"
        case .hidePassword: filterName = "HidePassword"
        case .showPassword: filterName = "ShowPassword"
        case .success: filterName = (self.isPasswordType == .changePassword) ? "ChangeMobileSuccessfully" : "SetMobileSuccessfully"
        }
        FirebaseAnalyticsController.shared.logEvent(name: eventName, params: [AnalyticsKeys.FilterName.rawValue:filterName])
    }
    
    
}
