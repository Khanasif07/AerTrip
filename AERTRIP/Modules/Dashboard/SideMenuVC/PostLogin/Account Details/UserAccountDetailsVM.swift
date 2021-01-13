//
//  AccountDetailsVM.swift
//  AERTRIP
//
//  Created by Admin on 12/01/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import Foundation


class UserAccountDetailsVM {
    
    enum UserAccountDetailsOptions  {
        case pan
        case adhar
        case gstin
        case defaultRefundMode
        case billingName
        case billingAddress
    }
    
    
    
    let accountDetailsDict = [0 : [AccountUpdationType.pan,AccountUpdationType.aadhar,AccountUpdationType.gSTIN],
                              1 : [AccountUpdationType.defaultRefundMode,AccountUpdationType.billingName,AccountUpdationType.billingAddress]
    ]
    
    
    func getProfilData() {
        
        APICaller.shared.getUserMeta(params: [:]) { (success, error) in
            
            
        }
        
    }
    
    
}
