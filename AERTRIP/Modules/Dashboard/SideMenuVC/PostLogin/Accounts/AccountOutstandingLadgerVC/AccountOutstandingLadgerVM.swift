//
//  AccountOutstandingLadgerVM.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol AccountOutstandingLadgerVMDelegate: class {
    func willGetAccountDetails()
    func getAccountDetailsSuccess()
    func getAccountDetailsFail()
    
    func searchEventsSuccess()
}

class AccountOutstandingLadgerVM: NSObject {
    //MARK:- Properties
    //MARK:- Public
    var _accountDetails: JSONDictionary = JSONDictionary()
    var accountDetails: JSONDictionary = JSONDictionary()
    var allDates: [String] {
        return Array(accountDetails.keys)
    }
    var searchedAccountDetails: JSONDictionary = JSONDictionary()
    var searchedAllDates: [String] {
        return Array(searchedAccountDetails.keys)
    }
    
    var selectedEvent: [AccountDetailEvent] = []
    
    weak var delegate: AccountOutstandingLadgerVMDelegate? = nil
    
    var totalAmountForSelected: Double {
        return self.selectedEvent.reduce(0.0) { $0 + $1.pendingAmount}
    }
    
    //MARK:- Private
    
    
    
    //MARK:- Methods
    //MARK:- Public
    func selectedArrayIndex(forEvent: AccountDetailEvent) -> Int?{
        return self.selectedEvent.firstIndex { $0.id == forEvent.id}
    }
    func searchEvent(forText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(self.callSearchEvent(_:)), with: forText, afterDelay: 0.5)
    }
    
    @objc private func callSearchEvent(_ forText: String) {
        printDebug("search text for: \(forText)")
        
        self.searchedAccountDetails = self._accountDetails.filter { (date, evnts) -> Bool in
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
            
            sSelf._accountDetails = AccountDetailEvent.modelsDict(data: allData).data
            sSelf.accountDetails = sSelf._accountDetails
            
            sSelf.delegate?.getAccountDetailsSuccess()
        }
        
    }
    
    //MARK:- Private
}
