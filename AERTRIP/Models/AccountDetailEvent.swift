//
//  AccountDetailEvent.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct AccountDetailEvent {
    
    enum Voucher: String {
        
        case none
        case hotels
        case cashback
        case creditNote
        case debitNote
        case flight
        case flightReScheduling
        case hotelCancellation
        case journalVoucher
        case lockAmount
        case receipt
        case receiptCopy
        case refund

        
        var image: UIImage? {
            switch self {
            case .hotels:
                return #imageLiteral(resourceName: "ic_acc_hotels")
                
            case .cashback:
                return #imageLiteral(resourceName: "ic_acc_cashback")
                
            case .creditNote:
                return #imageLiteral(resourceName: "ic_acc_creditNote")
                
            case .debitNote:
                return #imageLiteral(resourceName: "ic_acc_debitNote")
                
            case .flight:
                return #imageLiteral(resourceName: "ic_acc_flight")
                
            case .flightReScheduling:
                return #imageLiteral(resourceName: "ic_acc_flightReScheduling")
                
            case .hotelCancellation:
                return #imageLiteral(resourceName: "ic_acc_hotelCancellation")
                
            case .journalVoucher:
                return #imageLiteral(resourceName: "ic_acc_journalVoucher")
                
            case .lockAmount:
                return #imageLiteral(resourceName: "ic_acc_lockAmount")
                
            case .receipt:
                return #imageLiteral(resourceName: "ic_acc_receipt")
                
            case .receiptCopy:
                return #imageLiteral(resourceName: "ic_acc_receiptCopy")
                
            case .refund:
                return #imageLiteral(resourceName: "ic_acc_refund")
                
            default: return nil
            }
        }
    }

    var id : String = ""
    var title : String = ""
    var creationDate: String = ""
    private var _voucher : String = ""
    var voucher: Voucher {
        get {
            return Voucher(rawValue: self._voucher) ?? Voucher.none
        }
        
        set {
            self._voucher = newValue.rawValue
        }
    }
    var amount : Double = 0.0
    var balance : Double = 0.0
    
    var numOfRows: Int {
        return 2
    }
    
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["id"] {
            self.id = "\(obj)"
        }
        
        if let obj = json["title"] {
            self.title = "\(obj)"
        }
        
        if let obj = json["creationDate"] {
            self.creationDate = "\(obj)"
        }
        
        if let obj = json["voucher"] {
            self._voucher = "\(obj)"
        }
        
        if let obj = json["amount"] {
            self.amount = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["balance"] {
            self.balance = "\(obj)".toDouble ?? 0.0
        }
    }
    
    static func modelsDict(data: [JSONDictionary]) -> JSONDictionary {
        var temp = JSONDictionary()
        
        for dict in data {
            let obj = AccountDetailEvent(json: dict)
            if var allOld = temp[obj.creationDate] as? [AccountDetailEvent] {
                allOld.append(obj)
                temp[obj.creationDate] = allOld
            }
            else {
                temp[obj.creationDate] = [obj]
            }
        }
        
        return temp
    }
}
