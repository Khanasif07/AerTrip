//
//  AccountModel.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 14/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

struct AccountModel {
    
    var statements : Statements? = nil
    var credit     : Credit? = nil
    
    var jsonDict: JSONDictionary {
        var temp: JSONDictionary = JSONDictionary()
        
        if let obj = self.statements?.jsonDict {
            temp["statement"] = obj
        }
        
        if let obj = self.credit?.jsonDict {
            temp["credit"] = obj
        }
        
        return temp
    }
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        
        if let obj = json["statement"] as? JSONDictionary {
            self.statements = Statements(json: obj)
        }
        
        if let obj = json["credit"] as? JSONDictionary {
            self.credit   = Credit(json: obj)
        }
    }
}

struct Statements {
    
    var id: Int = 0
    var recentCredit: Double = 0.0
    var amountDue   : Double = 0.0
    var lastStatementBalence: LastStatement? = nil
    var recentDebit         : LastStatement? = nil
    var beforeAmountDue     : LastStatement? = nil
    
    var jsonDict: JSONDictionary {
        
        var temp: JSONDictionary = ["id": self.id,
                    "recent_credit": self.recentCredit,
                    "amount_due": self.amountDue]
        
        if let obj = self.lastStatementBalence?.jsonDict {
            temp["last_statement_balance"] = obj
        }
        
        if let obj = self.recentDebit?.jsonDict {
            temp["recent_debit"] = obj
        }
        
        if let obj = self.beforeAmountDue?.jsonDict {
            temp["before_amount_due"] = obj
        }
        
        return temp
    }
    
    init() {
        self.init(json: JSONDictionary())
    }
    
    init(json: JSONDictionary) {
        
        if let obj = json["id"] {
            self.id = "\(obj)".toInt ?? 0
        }
        
        if let obj = json["recent_credit"] {
            self.recentCredit = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["amount_due"] {
            self.amountDue = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["last_statement_balance"] as? JSONDictionary {
            self.lastStatementBalence = LastStatement(json: obj)
        }
        
        if let obj = json["recent_debit"] as? JSONDictionary {
            self.recentDebit = LastStatement(json: obj)
        }
        
        if let obj = json["before_amount_due"] as? JSONDictionary {
            self.beforeAmountDue = LastStatement(json: obj)
        }
    }
}

struct LastStatement {
    
    var amount : Double = 0.0
    var dates  : [Date] = []
    private var _dates  : [String] = []
    
    var jsonDict: JSONDictionary {
        return ["amount": self.amount,
                "date": self._dates]
    }
    
    init() {
        self.init(json: JSONDictionary())
    }
    
    init(json: JSONDictionary) {
        
        if let obj = json["amount"] {
            self.amount = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["date"] as? [String] {
            self._dates = obj
            for str in obj {
                if let dt = str.toDate(dateFormat: "YYYY-MM-dd") {
                    dates.append(dt)
                }
            }
        }
        else if let obj = json["date"] as? String {
            self._dates = [obj]
            if let dt = obj.toDate(dateFormat: "YYYY-MM-dd") {
                dates.append(dt)
            }
        }
    }
}

struct Credit {
    
    var creditLimit     : Double = 0.0
    var currentBalance  : Double = 0.0
    var availableCredit : Double = 0.0
    
    var jsonDict: JSONDictionary {
        return ["credit_limit": self.creditLimit,
         "current_balance": self.currentBalance,
         "available_credit": self.availableCredit]
    }
    
    init() {
        self.init(json: JSONDictionary())
    }
    
    init(json: JSONDictionary) {
        
        if let obj = json["credit_limit"] {
            self.creditLimit = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["current_balance"] {
            self.currentBalance = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["available_credit"] {
            self.availableCredit = "\(obj)".toDouble ?? 0.0
        }
    }
}
