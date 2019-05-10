//
//  OnAccountDetailVM.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol OnAccountDetailVMDelegate: class {
    func willGetOnAccountDetails()
    func getOnAccountDetailsSuccess()
    func getOnAccountDetailsFail()
}

class OnAccountDetailVM: NSObject {
    //MARK:- Properties
    //MARK:- Public
    var accountDetails: JSONDictionary = JSONDictionary()
    var allDates: [String] {
        return Array(accountDetails.keys)
    }
    weak var delegate: OnAccountDetailVMDelegate? = nil
    
    //MARK:- Private
    
    
    //MARK:- Methods
    //MARK:- Public
    func getOnAccountDetails() {
        self.delegate?.willGetOnAccountDetails()
        
        delay(seconds: 0.8) { [weak self] in
            guard let sSelf = self else {
                self?.delegate?.getOnAccountDetailsFail()
                return
            }
            
            let allData = [[
                            "id":"1",
                            "title":"Ramada Powai Hotel And Convention Centre",
                            "creationDate":"Tue 30 Apr",
                            "voucher":"hotels",
                            "amount":24425.01,
                            "pendingAmount":24425.01,
                            "names": ["Mr. Pratik Choudhary", "Mr. Om Prakash Bairwal", "Mr. Pratik Choudhary", "Mr. Om Prakash Bairwal"]
                           ],
                           [
                            "id":"11",
                            "title":"11 Ramada Powai Hotel And Convention Centre",
                            "creationDate":"Tue 30 Apr",
                            "voucher":"hotelCancellation",
                            "amount":2314.51,
                            "pendingAmount":2314.51
                            ],
                           [
                            "id":"12",
                            "title":"12 Ramada Powai Hotel And Convention Centre",
                            "creationDate":"Tue 30 Apr",
                            "voucher":"journalVoucher",
                            "amount":2314.51,
                            "pendingAmount":2314.51
                            ],
                           [
                            "id":"2",
                            "title":"DEL → BOM → DEL → GOA",
                            "creationDate":"Mon 29 Apr",
                            "voucher":"flight",
                            "amount":3452.2,
                            "pendingAmount":3452.2,
                            "names": ["Mrs. Shashi Poddar"]
                           ],
                           [
                            "id":"3",
                            "title":"Credit Card",
                            "creationDate":"Sat 27 Apr",
                            "voucher":"creditNote",
                            "amount":645.2,
                            "pendingAmount":645.2
                           ]
                          ]
            
            sSelf.accountDetails = AccountDetailEvent.modelsDict(data: allData)
            
            sSelf.delegate?.getOnAccountDetailsSuccess()
        }
    }
    
    //MARK:- Private
}
