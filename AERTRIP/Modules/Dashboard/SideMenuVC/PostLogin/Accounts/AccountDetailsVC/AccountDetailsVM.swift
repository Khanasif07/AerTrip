//
//  AccountDetailsVM.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol AccountDetailsVMDelegate: class {
    func willGetAccountDetails()
    func getAccountDetailsSuccess()
    func getAccountDetailsFail()
    
    func searchEventsSuccess()
}

class AccountDetailsVM: NSObject {
    //MARK:- Properties
    //MARK:- Public
    var walletAmount: Double = 0.0
    var accountDetails: JSONDictionary = JSONDictionary()
    var allDates: [String] {
        return Array(accountDetails.keys)
    }
    var searchedAccountDetails: JSONDictionary = JSONDictionary()
    var searchedAllDates: [String] {
        return Array(searchedAccountDetails.keys)
    }
    
    weak var delegate: AccountDetailsVMDelegate? = nil
    
    //MARK:- Private
    
    
    
    //MARK:- Methods
    //MARK:- Public
    func searchEvent(forText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(self.callSearchEvent(_:)), with: forText, afterDelay: 0.5)
    }
    
    @objc private func callSearchEvent(_ forText: String) {
        printDebug("search text for: \(forText)")
        
        self.searchedAccountDetails = self.accountDetails.filter { (date, evnts) -> Bool in
            if let events = evnts as? [AccountDetailEvent] {
                return events.contains(where: { $0.title.contains(forText) })
            }
            return false
        }
        
        self.delegate?.searchEventsSuccess()
    }
    
    func getAccountDetails() {
        self.delegate?.willGetAccountDetails()
        
        delay(seconds: 0.8) { [weak self] in
            guard let sSelf = self else {
                self?.delegate?.getAccountDetailsFail()
                return
            }
            
            let allData = [[
                            "id":"1",
                            "title":"Ramada Powai Hotel And Convention Centre",
                            "creationDate":"Tue 30 Apr",
                            "voucher":"hotels",
                            "amount":-2314.51,
                            "balance":-345,
                            "names": ["Mr. Pratik Choudhary", "Mr. Om Prakash Bairwal", "Mr. Pratik Choudhary", "Mr. Om Prakash Bairwal"]
                           ],
                           [
                            "id":"11",
                            "title":"11 Ramada Powai Hotel And Convention Centre",
                            "creationDate":"Tue 30 Apr",
                            "voucher":"hotelCancellation",
                            "amount":-2314.51,
                            "balance":-345
                            ],
                           [
                            "id":"12",
                            "title":"12 Ramada Powai Hotel And Convention Centre",
                            "creationDate":"Tue 30 Apr",
                            "voucher":"journalVoucher",
                            "amount":-2314.51,
                            "balance":-345
                            ],
                           [
                            "id":"2",
                            "title":"DEL → BOM → DEL → GOA",
                            "creationDate":"Mon 29 Apr",
                            "voucher":"flight",
                            "amount":-3452.2,
                            "balance":-7856.2,
                            "names": ["Mrs. Shashi Poddar"]
                           ],
                           [
                            "id":"3",
                            "title":"Credit Card",
                            "creationDate":"Sat 27 Apr",
                            "voucher":"creditNote",
                            "amount":-645.2,
                            "balance":-6354.0
                           ]
                          ]
            
            sSelf.accountDetails = AccountDetailEvent.modelsDict(data: allData)
            
            sSelf.delegate?.getAccountDetailsSuccess()
        }
        
    }
    
    //MARK:- Private
}
