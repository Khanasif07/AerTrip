//
//  AccountModel.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 14/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

struct AccountModel {
    
    var statements : StatementsSummery? = nil
    var credit     : CreditSummery? = nil
    var topup      : TopupSummery? = nil
    var billwise   : BilwiseSummery? = nil
    
    var openingBalance: Double = 0.0
    var currentBalance: Double = 0.0
    var runningBalance: Double = 0.0
    //Added For regular user
    var walletAmount: Double = 0.0
    
    var jsonDict: JSONDictionary {
        var temp: JSONDictionary = JSONDictionary()
        
        guard let usr = UserInfo.loggedInUser else {
            return temp
        }
        
        switch usr.userCreditType {
        case .billwise:
            if let obj = self.billwise?.jsonDict {
                temp["bill"] = obj
            }
            
            if let obj = self.credit?.jsonDict {
                temp["credit"] = obj
            }
            
        case .topup:
            if let obj = self.topup?.jsonDict {
                temp = obj
            }
            
        case .statement:
            if let obj = self.statements?.jsonDict {
                temp["statement"] = obj
            }
            
            if let obj = self.credit?.jsonDict {
                temp["credit"] = obj
            }
            
        case .regular:
            temp["wallet_balance"] = self.walletAmount
        }
        
        temp["opening_balance"] = self.openingBalance
        temp["current_total"] = self.currentBalance
        temp["running_balance"] = self.runningBalance
        
        return temp
    }
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        
        if let obj = json["opening_balance"] {
            self.openingBalance = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["current_total"] {
            self.currentBalance = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["running_balance"] {
            self.runningBalance = "\(obj)".toDouble ?? 0.0
        }
        guard let usr = UserInfo.loggedInUser else {
            return
        }

        switch usr.userCreditType {
        case .billwise:
            if let obj = json["bill"] as? JSONDictionary {
                self.billwise   = BilwiseSummery(json: obj)
            }
            if let obj = json["credit"] as? JSONDictionary {
                self.credit   = CreditSummery(json: obj)
            }
            
        case .topup:
            self.topup = TopupSummery(json: json)
            
        case .statement:
            if let obj = json["statement"] as? JSONDictionary {
                self.statements = StatementsSummery(json: obj)
            }
            
            if let obj = json["credit"] as? JSONDictionary {
                self.credit   = CreditSummery(json: obj)
            }
            
        case .regular:
            if let jsn = json["amount"] {
                self.walletAmount   = JSON(jsn).doubleValue
            }else if let jsn = json["wallet_balance"]{
                self.walletAmount = JSON(jsn).doubleValue
            }
        }
    }
}

struct TopupSummery {
    
    var topupLimit: Double = 0.0
    var usedCredit   : Double = 0.0
    var availableCredit: Double = 0.0
    var beforeAmountDue     : LastStatement? = nil
    
    var jsonDict: JSONDictionary {
        
        var temp: JSONDictionary = ["active_topup_limit": ["amount":self.topupLimit],
                                    "current_balance": self.usedCredit,
                                    "available_credit": self.availableCredit]
        
        if let obj = self.beforeAmountDue?.jsonDict {
            temp["total_amount_due"] = obj
        }
        
        return temp
    }
    
    init() {
        self.init(json: JSONDictionary())
    }
    
    init(json: JSONDictionary) {

        if let limit = json["active_topup_limit"] as? JSONDictionary, let obj = limit["amount"] {
            self.topupLimit = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["current_balance"] {
            self.usedCredit = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["available_credit"] {
            self.availableCredit = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["total_amount_due"] as? JSONDictionary {
            self.beforeAmountDue = LastStatement(json: obj)
        }
    }
}

struct BilwiseSummery {
    
    var totalOverDue: Double = 0.0
    var recentCharges   : Double = 0.0
    var totalOutstanding: Double = 0.0
    var totalBills: Int = 0
    
    var jsonDict: JSONDictionary {
        
        let temp: JSONDictionary = ["total_overdue": ["amount":self.totalOverDue, "number": self.totalBills],
                                    "recent_charges": self.recentCharges,
                                    "total_outstanding": self.totalOutstanding]
        
        return temp
    }
    
    init() {
        self.init(json: JSONDictionary())
    }
    
    init(json: JSONDictionary) {
        
        if let limit = json["total_overdue"] as? JSONDictionary {
            if let obj = limit["amount"] {
                self.totalOverDue = "\(obj)".toDouble ?? 0.0
            }
            
            if let obj = limit["number"] {
                self.totalBills = "\(obj)".toInt ?? 0
            }
        }
        
        if let obj = json["recent_charges"] {
            self.recentCharges = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["total_outstanding"] {
            self.totalOutstanding = "\(obj)".toDouble ?? 0.0
        }
    }
}


struct StatementsSummery {
    
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

struct CreditSummery {
    
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
