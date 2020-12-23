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
    var allDates: [String] = []
    
  //  {
//        var arr = Array(accountDetails.keys)
//        arr.sort { ($0.toDate(dateFormat: "EEE dd MMM")?.timeIntervalSince1970 ?? 0) < ($1.toDate(dateFormat: "EEE dd MMM")?.timeIntervalSince1970 ?? 0)}
//        return arr
//    }
    weak var delegate: OnAccountDetailVMDelegate? = nil
    
    var outstanding: AccountOutstanding? = nil {
        didSet {
            if let obj = outstanding {
                self.accountDetails = obj.onAccountLadger
            }
        }
    }
    
    //MARK:- Private
    
    
    //MARK:- Methods
    //MARK:- Public
    
    //MARK:- Private
    
    func sortByDate(){
        var arr = Array(accountDetails.keys)
        arr.sort { ($0.toDate(dateFormat: "EEE dd MMM")?.timeIntervalSince1970 ?? 0) > ($1.toDate(dateFormat: "EEE dd MMM")?.timeIntervalSince1970 ?? 0)}
        allDates = arr
    }
    
}
