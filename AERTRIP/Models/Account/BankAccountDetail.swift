//
//  BankAccountDetail.swift
//  AERTRIP
//
//  Created by Admin on 13/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

struct BankAccountDetail {
    var bankName: String = ""
    var accountName: String = ""
    var accountNumber: String = ""
    var branch: String = ""
    var ifsc: String = ""
    var accType: String = ""
    
    init(json: JSONDictionary) {
        
        if let obj = json["bankName"] {
            self.bankName = "\(obj)"
        }
        
        if let obj = json["accountName"] {
            self.accountName = "\(obj)"
        }
        
        if let obj = json["accountNumber"] {
            self.accountNumber = "\(obj)"
        }
        
        if let obj = json["branch"] {
            self.branch = "\(obj)"
        }
        
        if let obj = json["ifsc"] {
            self.ifsc = "\(obj)"
        }
        
        if let obj = json["accType"] {
            self.accType = "\(obj)"
        }
    }
    
    static func getModels(data: [JSONDictionary]) -> [BankAccountDetail] {
        
        var temp: [BankAccountDetail] = []
        
        for item in data {
            temp.append(BankAccountDetail(json: item))
        }
        
        return temp
    }
}
