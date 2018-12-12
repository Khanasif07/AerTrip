//
//  SecureYourAccountVM.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 06/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

class SecureYourAccountVM {
    
    enum SecureAccount {
        case setPassword, resetPasswod
    }
    
    var isPasswordType: SecureAccount = .setPassword
    var password = ""
}

//MARK:- Extension Webservices
//MARK:-
extension SecureYourAccountVM {
    
    func webserviceForUpdatePassword(_ sender: ATButton) {
        
        var params = JSONDictionary()
        
        params[APIKeys.password.rawValue]  = self.password
        
        APICaller.shared.callUpdatePasswordAPI(params: params, loader: true, completionBlock: {(success, data) in
            
            sender.isLoading = false
            AppFlowManager.default.moveToCreateProfileVC()
            printDebug(data)
            //            AppFlowManager.default.moveToRegistrationSuccefullyVC(email: self.email)
        })
        
    }
}
