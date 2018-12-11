//
//  ThankYouRegistrationVM.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 05/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

class ThankYouRegistrationVM {
    
    var email = ""
}

//MARK:- Extension Webservices
//MARK:-
extension ThankYouRegistrationVM {
    
    func webserviceForGetRegistrationData() {
        
        var params = JSONDictionary()
        
        params[APIKeys.ref.rawValue]  = "2e1370bb3ca3fc8939aac7eff2dc06bf"
        
        APICaller.shared.callVerifyRegistrationApi(params: params, loader: true, completionBlock: {(success, data) in
            
            printDebug(data)
            //            AppFlowManager.default.moveToRegistrationSuccefullyVC(email: self.email)
        })
        
    }
}
