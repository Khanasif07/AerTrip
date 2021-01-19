//
//  ChangeEmailVM.swift
//  AERTRIP
//
//  Created by Admin on 04/01/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import Foundation

protocol ChangeEmailDelegate : class {
    func validate(isValid: Bool, msg : String)
    func willChnageEmail()
    func changeEmailSuccess(email : String)
    func errorInChangingEmail(error : ErrorCodes)
    func showErrorState(with errorState: ChangeEmailValidationState)
    func showErrorMessage(with errorState: ChangeEmailValidationState)
}
enum ChangeEmailValidationState{
    case email(success:Bool, msg:String)
    case password(success:Bool, msg:String)
}
class ChangeEmailVM {
    
    struct UserEntries{
        var email: String = ""
        var password:String = ""
    }
    
    weak var delegate : ChangeEmailDelegate?
    
    var details = UserEntries()
    
    
    var isValidEmail:ChangeEmailValidationState{
        if !self.details.email.isEmail{
            let state = ChangeEmailValidationState.email(success: false, msg: LocalizedString.Enter_valid_email_address.localized)
            self.delegate?.showErrorState(with: state)
            return state
        }
        return .email(success: true, msg: "")
    }
    
    var isValidPassword:ChangeEmailValidationState{
        if self.details.password.isEmpty{
            let state = ChangeEmailValidationState.password(success: false, msg: LocalizedString.enterAccountPasswordMsg.localized)
            self.delegate?.showErrorState(with: state)
            return state
        }
        return .password(success: true, msg: "")
    }
    
    func validate(){
        _ = self.isValidEmail
        _ = self.isValidPassword
        self.showMessage()
    }
    
    
    func showMessage(){
        if case  ChangeEmailValidationState.email(let succes, _) = self.isValidEmail{
            //display msg
            if !succes{
                self.delegate?.showErrorMessage(with: self.isValidEmail)
                return
            }
        }
        if case  ChangeEmailValidationState.password(let succes, _) = self.isValidPassword{
            //display msg
            if !succes{
                self.delegate?.showErrorMessage(with: self.isValidPassword)
                return
            }
        }
        
        self.changeEmailApi(email: self.details.email, password: self.details.password)
    }
    func changeEmail(email : String, password : String){
        
//        if checkIfValid(email: email, password: password) {
//            self.changeEmailApi(email: email, password: password)
//        }
        
    }
    
    

    
    
    func changeEmailApi(email : String, password : String) {
    
        let params : JSONDictionary = ["new_email" : email, "password" : password]
        
        APICaller.shared.changeEmail(params: params) { (success, codes) in
            if success {
                self.delegate?.changeEmailSuccess(email : email)
            } else {
                self.delegate?.errorInChangingEmail(error: codes)
            }
        }
        
    }
    
}
