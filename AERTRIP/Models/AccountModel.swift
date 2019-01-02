//
//  AccountModel.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 14/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

struct AccountModel {
    
    let statements : Statements
    let credit     : Credit
    
    var jsonDict: [String:Any] {
        return ["statement": self.statements.jsonDict,
                "credit": self.credit.jsonDict]
    }
    
    init() {
        
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        
        self.statements = Statements(json: json["statement"])
        self.credit   = Credit(json: json["credit"])
    }
}

struct Statements {
    
    let id          : Int
    let recentCredit: Double
    let amountDue   : Double
    let lastStatementBalence: LastStatement
    let recentDebit         : LastStatement
    let beforeAmountDue     : LastStatement
    
    var jsonDict: [String:Any] {
        return ["id": self.id,
                "recent_credit": self.recentCredit,
                "amount_due": self.amountDue,
                "last_statement_balance": self.lastStatementBalence.jsonDict,
                "recent_debit": self.recentDebit.jsonDict,
                "before_amount_due": self.beforeAmountDue.jsonDict]
    }
    
    init() {
        
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        
        self.id     = json["id"].intValue
        self.recentCredit = json["recent_credit"].doubleValue
        self.amountDue   = json["amount_due"].doubleValue
        self.lastStatementBalence   = LastStatement(json: json["last_statement_balance"])
        self.recentDebit   = LastStatement(json: json["recent_debit"])
        self.beforeAmountDue   = LastStatement(json: json["before_amount_due"])
        
    }
}

struct LastStatement {
    
    var amount : String
    var dates  : [String]
    
    var jsonDict: [String:Any] {
        return ["amount": self.amount,
                "date": self.dates]
    }
    
    init() {
        
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        
        self.amount  = json["amount"].stringValue
        self.dates   = AppGlobals.retunsStringArray(jsonArr: json["date"].arrayValue) 
        
    }
}

struct Credit {
    
    let creditLimit     : Double
    let currentBalance  : Double
    let availableCredit : Double
    
    var jsonDict: [String:Any] {
        return ["credit_limit": self.creditLimit,
         "current_balance": self.currentBalance,
         "available_credit": self.availableCredit]
    }
    
    init() {
        
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        
        self.creditLimit = json["credit_limit"].doubleValue
        self.currentBalance   = json["current_balance"].doubleValue
        self.availableCredit  = json["available_credit"].doubleValue
        
    }
}
