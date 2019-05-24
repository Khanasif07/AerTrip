//
//  BankAccountDetail.swift
//  AERTRIP
//
//  Created by Admin on 13/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

struct BankAccountDetail {
    
    var id: String = ""
    var bankName: String = ""
    var branchName: String = ""
    var accountName: String = ""
    var accountNumber: String = ""
    var ifsc: String = ""
    var accType: String = ""
    
    var addressLine1: String = ""
    var addressLine2: String = ""
    var city: String = ""
    var state: String = ""
    var country: String = ""
    var postalCode: String = ""
    var bsrCode: String = ""
    var micrCode: String = ""
    var swiftCode: String = ""
    var customerId: String = ""
    var netBankingUrl: String = ""
    var branchPhone: String = ""
    var supportPhone: String = ""
    var rmName: String = ""
    var rmPhone: String = ""
    var depositSlip: String = ""
    var gst: String = ""
    var pan: String = ""
    
    init(json: JSONDictionary) {
        
        if let obj = json["id"] {
            self.id = "\(obj)".removeNull
        }
        
        if let obj = json["bank_name"] {
            self.bankName = "\(obj)".removeNull
        }
        
        if let obj = json["branch_name"] {
            self.branchName = "\(obj)".removeNull
        }
        
        if let obj = json["account_name"] {
            self.accountName = "\(obj)".removeNull
        }
        
        if let obj = json["account_number"] {
            self.accountNumber = "\(obj)".removeNull
        }
        
        if let obj = json["ifsc_code"] {
            self.ifsc = "\(obj)".removeNull
        }
        
        if let obj = json["account_type"] {
            self.accType = "\(obj)".removeNull
        }

        
        if let obj = json["address_line1"] {
            self.addressLine1 = "\(obj)".removeNull
        }
        
        if let obj = json["address_line2"] {
            self.addressLine2 = "\(obj)".removeNull
        }
        
        if let obj = json["city"] {
            self.city = "\(obj)".removeNull
        }
        
        if let obj = json["state"] {
            self.state = "\(obj)".removeNull
        }
        
        if let obj = json["country"] {
            self.country = "\(obj)".removeNull
        }
        
        if let obj = json["postal_code"] {
            self.postalCode = "\(obj)".removeNull
        }
        
        if let obj = json["bsr_code"] {
            self.bsrCode = "\(obj)".removeNull
        }
        
        if let obj = json["micr_code"] {
            self.micrCode = "\(obj)".removeNull
        }
        
        if let obj = json["customer_id"] {
            self.customerId = "\(obj)".removeNull
        }
        
        if let obj = json["net_banking_url"] {
            self.netBankingUrl = "\(obj)".removeNull
        }
        
        if let obj = json["branch_phone"] {
            self.branchPhone = "\(obj)".removeNull
        }
        
        if let obj = json["support_phone"] {
            self.supportPhone = "\(obj)".removeNull
        }
        
        if let obj = json["rm_name"] {
            self.rmName = "\(obj)".removeNull
        }
        
        if let obj = json["rm_phone"] {
            self.rmPhone = "\(obj)".removeNull
        }
        
        if let obj = json["deposit_slip"] {
            self.depositSlip = "\(obj)".removeNull
        }
        
        if let obj = json["gst"] {
            self.gst = "\(obj)".removeNull
        }
        
        if let obj = json["pan"] {
            self.pan = "\(obj)".removeNull
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
