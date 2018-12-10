//
//  ViewController.swift
//  AERTRIP
//
//  Created by Pramod Kumar on 03/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class LoginVM {

    var email    = ""
    var password = ""
    
    func webserviceForLogin() {
        
        var params = JSONDictionary()
        
        params[APIKeys.loginid.rawValue]     = email
        params[APIKeys.password.rawValue]    = password
        params[APIKeys.isGuestUser.rawValue]  = false
        
        APICaller.shared.callLoginAPI(params: params, loader: true, completionBlock: {(success, data) in
            
            printDebug(data)
        })
        
    }
}

