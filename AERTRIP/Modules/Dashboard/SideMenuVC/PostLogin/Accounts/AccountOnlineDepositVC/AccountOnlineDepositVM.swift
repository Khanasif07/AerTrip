//
//  AccountOnlineDepositVM.swift
//  AERTRIP
//
//  Created by apple on 26/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation


protocol AccountOnlineDepositVMDelegate: class {

}

class AccountOnlineDepositVM: NSObject {
    
    weak var delegate: AccountOnlineDepositVMDelegate?
    var depositItinerary: DepositItinerary?
    
    var depositAmount: Double {
        return depositItinerary?.netAmount ?? 0.0
    }
    
    var feeAmount: Double {
        return depositItinerary?.razorpay?.convenienceFees ?? 0.0
    }
    
    var totalPayableAmount: Double {
        return depositAmount + feeAmount
    }
}
