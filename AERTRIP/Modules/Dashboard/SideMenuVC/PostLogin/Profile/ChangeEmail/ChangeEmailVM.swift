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
    
}

class ChangeEmailVM {
    
    weak var delegate : ChangeEmailDelegate?
    
    
    func changeEmail(email : String, password : String){
        
        if checkIfValid(email: email, password: password) {
            
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
    
    
}
