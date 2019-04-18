//
//  AccountLegderVM.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol AccountLegderVMDelegate: class {
    func willGetAccountLedger()
    func getAccountLedgerSuccess()
    func getAccountLedgerFail()
}

class AccountLegderVM {
    //MARK:- Properties
    //MARK:- Public
    var walletAmount: Double = 0.0
    var accountLedger: JSONDictionary = JSONDictionary()
    var allDates: [String] {
        return Array(accountLedger.keys)
    }
    
    weak var delegate: AccountLegderVMDelegate? = nil
    
    //MARK:- Private
    
    
    
    //MARK:- Methods
    //MARK:- Public
    func getAccountLedger() {
        self.delegate?.willGetAccountLedger()
        
        delay(seconds: 0.8) { [weak self] in
            guard let sSelf = self else {
                self?.delegate?.getAccountLedgerFail()
                return
            }
            
            let allData = [[
                            "id":"1",
                            "title":"Ramada Powai Hotel And Convention Centre",
                            "creationDate":"Tue 30 Apr",
                            "voucher":"hotels",
                            "amount":-2314.51,
                            "balance":-345
                           ],
                           [
                            "id":"11",
                            "title":"11 Ramada Powai Hotel And Convention Centre",
                            "creationDate":"Tue 30 Apr",
                            "voucher":"flight",
                            "amount":-2314.51,
                            "balance":-345
                            ],
                           [
                            "id":"12",
                            "title":"12 Ramada Powai Hotel And Convention Centre",
                            "creationDate":"Tue 30 Apr",
                            "voucher":"receipt",
                            "amount":-2314.51,
                            "balance":-345
                            ],
                           [
                            "id":"2",
                            "title":"DEL → BOM → DEL → GOA",
                            "creationDate":"Mon 29 Apr",
                            "voucher":"cashback",
                            "amount":-3452.2,
                            "balance":-7856.2
                           ],
                           [
                            "id":"3",
                            "title":"Credit Card",
                            "creationDate":"Sat 27 Apr",
                            "voucher":"journalVoucher",
                            "amount":-645.2,
                            "balance":-6354.0
                           ]
                          ]
            
            sSelf.accountLedger = AccountDetailEvent.modelsDict(data: allData)
            
            sSelf.delegate?.getAccountLedgerSuccess()
        }
        
    }
    
    //MARK:- Private
}
