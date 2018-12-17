//
//  AccountModel.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 14/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

struct AccountModel {
    
    let id           : String
    var recentCredit : Double
    var lastStatement: LastStatement
    var recentDebit  : LastStatement
    var beforeAmountDue : LastStatement
    var amountDue : Double
    
    init() {
        
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        
        self.id         = json["id"].stringValue
        self.recentCredit  = json["recent_credit"].doubleValue
        self.amountDue  = json["recent_credit"].doubleValue
        self.lastStatement   = LastStatement.init(json: json["last_statement_balance"])
        self.recentDebit   = LastStatement.init(json: json["recent_debit"])
        self.beforeAmountDue   = LastStatement.init(json: json["before_amount_due"])
    }
}

struct LastStatement {
    
    var amount : String
//    var dates  : [Date]
    
    init() {
        
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        
        self.amount  = json["amount"].stringValue
//        self.dates = json["date"].array
        
    }
}

