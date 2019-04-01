//
//  PaymentModal.swift
//  AERTRIP
//
//  Created by apple on 01/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct PaymentModal {
    var paymentModes : PaymentMode
    var bankMaster : [String]
    var paymentDetails: paymentDetail
    
    init() {
        let json = JSON()
        self.init(json: json)
    }
    
    
    init(json: JSON) {
        self.paymentModes = PaymentMode(json: json["payment_modes"])
        self.bankMaster = json["bank_master"].arrayValue.map {$0.stringValue}
        self.paymentDetails = paymentDetail(json: json["payment_details"])
    }
    
}

struct PaymentMode {
    var razorPay: RazorPay
    var wallet: Wallet
    
    init() {
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        self.razorPay = RazorPay(json: json["razorpay"])
        self.wallet = Wallet(json:json["wallet"])
    }
}


struct RazorPay {
    var id: String
    var idDisplay : Bool
    var label: String
    var category: String
    var methodType: String
    var types : [String]
    var validation: MaxAmount
    var convenienceFees: Double
    var convenienceFeesWallet: Double
    var pgId: String
    
    init() {
        let json = JSON()
        self.init(json: json)
    }
    
    init(json:JSON) {
        self.id = json["id"].stringValue.removeNull
        self.idDisplay = json["is_display"].boolValue
        self.label = json["label"].stringValue.removeNull
        self.category = json["category"].stringValue.removeNull
        self.methodType = json["method_type"].stringValue.removeNull
        self.types = json["types"].arrayValue.map { $0.stringValue}
        self.validation = MaxAmount(json: json["validation"])
        self.convenienceFees = json["convenience_fees"].doubleValue
        self.convenienceFeesWallet = json["convenience_fees_wallet"].doubleValue
        self.pgId = json["pg_id"].stringValue.removeNull
        
        
    }
    
}

struct Wallet {
    var id: String
    var idDisplay : Bool
    var label: String
    var category: String
    var methodType: String
    var types : [String]
    var validation: [String]
    var convenienceFees: Double
    var convenienceFeesWallet: Double
    var pgId: String

    init() {
        let json = JSON()
        self.init(json: json)
    }
    
    init(json:JSON) {
        self.id = json["id"].stringValue.removeNull
        self.idDisplay = json["is_display"].boolValue
        self.label = json["label"].stringValue.removeNull
        self.category = json["category"].stringValue.removeNull
        self.methodType = json["method_type"].stringValue.removeNull
        self.types = json["types"].arrayValue.map{ $0.stringValue }
        self.validation = json["validation"].arrayValue.map { $0.stringValue }
        self.convenienceFees = json["convenience_fees"].doubleValue
        self.convenienceFeesWallet = json["convenience_fees_wallet"].doubleValue
        self.pgId = json["pg_id"].stringValue.removeNull
        
        
    }
    
}


struct MaxAmount {
    var maxAmount: Double
    
    init() {
        let json = JSON()
        self.init(json: json)
    }
    
    init(json:JSON) {
        self.maxAmount = json["max_amt"].doubleValue
   
    }
    
    
    
}

struct paymentDetail {
    var netAmount: Double
    var allowPartPayment: Double
    var allowPointUsage: Double
    var minAmount: Double
    var wallet: Double
    var points: Double
    
    
    init() {
        let json = JSON()
        self.init(json: json)
    }
    
    init(json:JSON) {
      self.netAmount = json["net_amount"].doubleValue
      self.allowPartPayment = json["allow_part_payment"].doubleValue
      self.allowPointUsage = json["allow_point_usage"].doubleValue
      self.minAmount = json["min_amount"].doubleValue
      self.wallet = json["wallet"].doubleValue
      self.points = json["points"].doubleValue
    }
    
}
