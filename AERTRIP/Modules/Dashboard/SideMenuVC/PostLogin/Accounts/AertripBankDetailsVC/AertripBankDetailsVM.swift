//
//  AertripBankDetailsVM.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol AertripBankDetailsVMDelegate: class {
    func getBankAccountDetailsSuccess()
    func getBankAccountDetailsFail()
}

class AertripBankDetailsVM: NSObject {
    //MARK:- Properties
    //MARK:- Public
    weak var delegate: AertripBankDetailsVMDelegate? = nil
    var allBanks: [BankAccountDetail] = []
    
    //MARK:- Private
    
    
    
    //MARK:- Methods
    //MARK:- Public

//    func getBankAccountDetails() {
//
//        delay(seconds: 0.8) { [weak self] in
//            guard let sSelf = self else {
//                self?.delegate?.getBankAccountDetailsFail()
//                return
//            }
//
//            let allData = [[
//                            "bankName": "ICICI Bank",
//                            "accountName": "Aertrip India Limited",
//                            "accountNumber": "08605001395",
//                            "branch": "J B Nagar",
//                            "ifsc": "ICIC0001086",
//                            "accType": "Current Account"
//                           ],
//                           [
//                            "bankName": "HDFC Bank",
//                            "accountName": "Aertrip India Limited",
//                            "accountNumber": "5020025506172",
//                            "branch": "Sahar Plaza, JB Nagar",
//                            "ifsc": "HDFC0001204",
//                            "accType": "Current Account"
//                           ]
//                          ]
//
//            sSelf.allBanks = BankAccountDetail.getModels(data: allData)
//
//            sSelf.delegate?.getBankAccountDetailsSuccess()
//        }
//
//    }
    
    //MARK:- Private
}
