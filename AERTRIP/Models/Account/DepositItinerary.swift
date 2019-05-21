//
//  DepositItinerary.swift
//  AERTRIP
//
//  Created by Admin on 20/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

struct DepositItinerary {
    var id: String = ""
    var netAmount: Double = 0.0
    var partPaymentAmount: Double = 0.0
    
    var razorpay: PaymentModeDetails?
    var chequeOrDD: PaymentModeDetails?
    var cashDeposit: PaymentModeDetails?
    var fundTransfer: PaymentModeDetails?
    
    var bankMaster: [String] = []
    
    
    init(json: JSONDictionary) {
        
        if let obj = json["id"] {
            self.id = "\(obj)".removeNull
        }
        
        if let obj = json["net_amount"] {
            self.netAmount = "\(obj)".toDouble ?? 0.0
        }
        
        if let paymentModes = json["payment_modes"] as? JSONDictionary {
            
            if let razorPay = paymentModes["razorpay"] as? JSONDictionary {
                self.razorpay = PaymentModeDetails(json: razorPay)
            }
            
            if let razorPay = paymentModes["cash-deposit-in-bank"] as? JSONDictionary {
                self.cashDeposit = PaymentModeDetails(json: razorPay)
            }
            
            if let razorPay = paymentModes["demand-draft-cheque"] as? JSONDictionary {
                self.chequeOrDD = PaymentModeDetails(json: razorPay)
            }
            
            if let razorPay = paymentModes["rtgs-neft-imps-transfer"] as? JSONDictionary {
                self.fundTransfer = PaymentModeDetails(json: razorPay)
            }
        }
        
        if let obj = json["bank_master"] as? [String] {
            self.bankMaster = obj
        }
    }
}


struct PaymentModeValidation {
    var maxAmount: Double = 0.0
    
    init(json: JSONDictionary) {
        if let obj = json["max_amt"] {
            self.maxAmount = "\(obj)".toDouble ?? 0.0
        }
    }
}

struct PaymentModeDetails {
    
    var id: String = ""
    var isDisplay : Bool = false
    var label: String = ""
    var category: String = ""
    var methodType: String = ""
    var types: [BankAccountDetail] = []
    var validation: PaymentModeValidation?
    var convenienceFees: Double = 0.0
    var convenienceFeesWallet: Double = 0.0
    var pgId: String = ""
    
    var allBanksName: [String] = []
    
    init(json: JSONDictionary) {
        
        if let obj = json["id"] {
            self.id = "\(obj)".removeNull
        }
        
        if let obj = json["is_display"] {
            self.isDisplay = "\(obj)".toBool
        }
        
        if let obj = json["label"] {
            self.label = "\(obj)".removeNull
        }
        
        if let obj = json["category"] {
            self.category = "\(obj)".removeNull
        }
        
        if let obj = json["method_type"] {
            self.methodType = "\(obj)".removeNull
        }
        
        if let dictArr = json["types"] as? JSONDictionary {
            self.types.removeAll()
            self.allBanksName.removeAll()
            for key in Array(dictArr.keys) {
                if let dict = dictArr[key] as? JSONDictionary {
                    let bank = BankAccountDetail(json: dict)
                    self.types.append(bank)
                    self.allBanksName.append(bank.bankName)
                }
            }
        }
        
        if let dict = json["validation"] as? JSONDictionary {
            self.validation = PaymentModeValidation(json: dict)
        }
        
        if let obj = json["convenience_fees"] {
            self.convenienceFees = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["convenience_fees_wallet"] {
            self.convenienceFeesWallet = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["pg_id"] {
            self.pgId = "\(obj)".removeNull
        }
    }
}
