//
//  AccountOutstanding.swift
//  AERTRIP
//
//  Created by Admin on 16/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct OnAccountLedgerEvent {
    
    var transactionId: String = ""
    var amount: Double = 0.0
    
    private var _voucher : String = ""
    var voucher: VoucherType {
        get {
            return VoucherType(rawValue: self._voucher) ?? VoucherType.none
        }
        
        set {
            self._voucher = newValue.rawValue
        }
    }
    var voucherNo: String = ""
    
    var voucherName: String {
        return self.voucher.rawValue
    }
    
    private var _onAccountDate: String = ""
    var onAccountDate: Date? {
        //"2019-05-15 16:39:11"
        return _onAccountDate.toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")
    }
    
    var creationDateStr: String? {
        return onAccountDate?.toString(dateFormat: "EEE dd MMM")
    }
    
    init(json: JSONDictionary) {
        if let obj = json["transaction_datetime"] as? String {
            self._onAccountDate = obj
        }
        
        if let obj = json["transaction_id"] {
            self.transactionId = "\(obj)"
        }
        
        if let obj = json["voucher"] {
            self._voucher = "\(obj)"
        }
        
        if let obj = json["voucher_number"] {
            self.voucherNo = "\(obj)"
        }
        
        if let obj = json["amount"] {
            self.amount = "\(obj)".toDouble ?? 0.0
        }
    }
    
    static func modelsDict(data: [JSONDictionary]) -> JSONDictionary {
        
        return data.reduce(into: [String:[OnAccountLedgerEvent]]()) {
            let obj = OnAccountLedgerEvent(json: $1)
            $0[obj.creationDateStr ?? "", default: [OnAccountLedgerEvent]()].append(obj)
        }
        
//        var temp = JSONDictionary()
//
//        for dict in data {
//            let obj = OnAccountLedgerEvent(json: dict)
//            if let cDate = obj.creationDateStr, !cDate.isEmpty {
//                if var allOld = temp[cDate] as? [OnAccountLedgerEvent] {
//                    allOld.append(obj)
//                    allOld.sort { ($0.onAccountDate?.timeIntervalSince1970 ?? 0) < ($1.onAccountDate?.timeIntervalSince1970 ?? 0)}
//                    temp[cDate] = allOld
//                }
//                else {
//                    temp[cDate] = [obj]
//                }
//            }
//        }
//
//        return temp
    }
}

struct AccountOutstanding {
    var ladger: JSONDictionary = JSONDictionary()
    var onAccountLadger: JSONDictionary = JSONDictionary()
    var vouchers: [String] = []
    var grossAmount: Double = 0.0
    var onAccountAmount: Double = 0.0
    
    var netAmount: Double {
        return grossAmount + onAccountAmount
    }
    
    private var _onAccountDate: String = ""
    var onAccountDate: Date? {
        //"2019-05-15 16:39:11"
        return _onAccountDate.toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")
    }
    
    init(json: JSONDictionary) {
        if let transactions = json["transactions"] as? [JSONDictionary] {
            let (lad, vchr) = AccountDetailEvent.modelsDict(data: transactions)
            self.ladger = lad
            self.vouchers = vchr
        }
        
        
        
        if let subTotal = json["sub_total"] as? JSONDictionary, let pending = subTotal["pending"] {
            self.grossAmount = "\(pending)".toDouble ?? 0.0
        }
        
        if let onAccount = json["on_account"] as? JSONDictionary {
            if let obj = onAccount["amount"] {
                self.onAccountAmount = "\(obj)".toDouble ?? 0.0
            }
            
            if let obj = onAccount["transaction_datetime"] as? String {
                self._onAccountDate = obj
            }
            
            if let transactions = onAccount["detail"] as? [JSONDictionary] {
                self.onAccountLadger = OnAccountLedgerEvent.modelsDict(data: transactions)
            }
        }
    }
}
