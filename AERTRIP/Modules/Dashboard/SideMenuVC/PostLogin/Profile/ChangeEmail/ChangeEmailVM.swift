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
    func changeEmailSuccess()
    func errorInChangingEmail(error : ErrorCodes)
}

class ChangeEmailVM {
    
    weak var delegate : ChangeEmailDelegate?
    
    
    func changeEmail(email : String, password : String){
        
        if checkIfValid(email: email, password: password) {
            self.changeEmailApi(email: email, password: password)
        }
        
    }
    
    
    func checkIfValid(email : String, password : String) -> Bool {
        
        if email.isEmpty {
            self.delegate?.validate(isValid: false, msg: "Please enter email.")
            return false
        } else if !email.isEmail {
            self.delegate?.validate(isValid: false, msg: "Please enter a valid email.")
            return false
        } else if password.isEmpty {
            self.delegate?.validate(isValid: false, msg: "Please enter password.")
            return false
        }
        return true
    }
    
    
    func changeEmailApi(email : String, password : String) {
    
        let params : JSONDictionary = ["new_email" : email, "password" : password]
        
        APICaller.shared.changeEmail(params: params) { (success, codes) in
            if success {
                self.delegate?.changeEmailSuccess()
            } else {
                self.delegate?.errorInChangingEmail(error: codes)
            }
        }
        
    }
    
}
