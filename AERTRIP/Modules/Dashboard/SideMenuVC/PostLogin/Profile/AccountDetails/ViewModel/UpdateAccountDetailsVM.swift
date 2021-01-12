//
//  UpdateAccountDetailsVM.swift
//  AERTRIP
//
//  Created by Appinventiv  on 12/01/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import Foundation

public enum AccountUpdationType : String{
    case billingName = "Billing Name"
    case gSTIN = "GSTIN Number"
    case aadhar = "Aadhar Number"
    case pan = "PAN Number"
    case billingAddress = "Billing Address"
    case defaultRefundMode = "Default Refund Mode"
}

class UpdateAccountDetailsVM{
    
    var updationType: AccountUpdationType = .pan
    
}
