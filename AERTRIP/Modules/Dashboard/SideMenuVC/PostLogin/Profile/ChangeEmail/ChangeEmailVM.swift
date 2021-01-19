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
}

class ChangeEmailVM {
    
    weak var delegate : ChangeEmailDelegate?
    
    
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
