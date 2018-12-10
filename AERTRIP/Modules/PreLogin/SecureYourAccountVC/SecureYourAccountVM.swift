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
