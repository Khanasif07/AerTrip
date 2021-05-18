//
//  ViewController.swift
//  AERTRIP
//
//  Created by Pramod Kumar on 03/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol LoginVMDelegate: class {
    func willLogin()
    func didLoginSuccess()
    func didLoginFail(errors: ErrorCodes)
}

class LoginVM {

    weak var delegate: LoginVMDelegate?
    var email    = ""
    var password = ""
    var isFirstTime = true
    var currentlyUsingFrom = LoginFlowUsingFor.loginProcess
    var checkoutType:CheckoutType = .none
    var isLoginButtonEnable: Bool {
        
        if self.email.isEmpty {
            return false
        } else if self.email.checkInvalidity(.Email) {
            return false
        } else if self.password.isEmpty {
            return false
        }else if !(self.password.isValidPasswordCharacterCount){
            return false
        }
//        else if self.password.checkInvalidity(.Password) {
//           return false
//        }
        return true
    }
    
    func isValidateData(vc: UIViewController) -> Bool {
        
        if self.email.isEmpty {
            self.firebaseLogEvent(with: .EnterIncorrectEmail)
            AppToast.default.showToastMessage(message: LocalizedString.Enter_email_address.localized)
            return false
            
        } else if self.email.checkInvalidity(.Email) {
            self.firebaseLogEvent(with: .EnterIncorrectEmail)
            AppToast.default.showToastMessage(message: LocalizedString.Enter_valid_email_address.localized)
            return false
            
        } else if self.password.isEmpty {
            self.firebaseLogEvent(with: .PasswordIncorrect)
            AppToast.default.showToastMessage(message: LocalizedString.Enter_password.localized)
            return false
            
        }
        
        else if (!self.password.isValidPasswordCharacterCount) {
            self.firebaseLogEvent(with: .PasswordIncorrect)
            AppToast.default.showToastMessage(message: LocalizedString.passwordCharacterCount.localized)
            return false
            
        }
        
//        else if self.password.checkInvalidity(.Password) {
//
//            AppToast.default.showToastMessage(message: LocalizedString.Enter_valid_Password.localized)
//            return false
//        }
        return true
    }
    
    func webserviceForLogin() {
        
        var params = JSONDictionary()
        
        params[APIKeys.loginid.rawValue]      = email
        params[APIKeys.password.rawValue]     = password

        self.delegate?.willLogin()
        APICaller.shared.callLoginAPI(params: params, completionBlock: {(success, errors) in
            if success {
                self.firebaseLogEvent(with: .login)
                self.delegate?.didLoginSuccess()
                UserInfo.loggedInUser?.socialLoginType = LinkedAccount.SocialType.none
                APICaller.shared.saveLocallyFavToServer()
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .login)
                self.delegate?.didLoginFail(errors: errors)
            }
        })
    }
}

///Log events for login
extension LoginVM{
    
    func firebaseLogEvent(with event:FirebaseEventLogs.EventsTypeName){
        switch self.currentlyUsingFrom {
        case .loginProcess:
            if event == .login{
                FirebaseEventLogs.shared.logLoginEvents(with: .LoginSuccessfully)
            }else{
                FirebaseEventLogs.shared.logLoginEvents(with: event)
            }
        case .loginVerificationForCheckout:
            if event == .login{
                switch checkoutType {
                case .hotelCheckout:
                    FirebaseEventLogs.shared.logHotelsGuestUserCheckoutEvents(with: event)
                case .flightCheckout:
                    FirebaseEventLogs.shared.logFlightGuestUserCheckoutEvents(with: event)
                default: break
                }
                
            }
        case .loginVerificationForBulkbooking:break;
        case .loginFromEmailShare:break
        }
    }
}
