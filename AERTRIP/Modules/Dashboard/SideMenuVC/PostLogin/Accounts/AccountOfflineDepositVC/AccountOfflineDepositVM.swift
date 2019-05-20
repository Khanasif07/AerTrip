//
//  AccountOfflineDepositVM.swift
//  AERTRIP
//
//  Created by apple on 26/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation


protocol AccountOfflineDepositVMDelegate: class {

}

class AccountOfflineDepositVM: NSObject {
    
    var paymentModeDetails: PaymentModeDetails?
    var bankMaster: [String] = []

    var userEnteredDetails: AccountOfflineDepositDetails = AccountOfflineDepositDetails()
    
    weak var delegate: AccountOfflineDepositVMDelegate?    
}
