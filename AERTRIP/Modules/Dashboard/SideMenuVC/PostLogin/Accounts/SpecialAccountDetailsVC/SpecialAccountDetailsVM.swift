//
//  SpecialAccountDetailsVM.swift
//  AERTRIP
//
//  Created by Admin on 06/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

struct SpecialAccountEvent {
    var title: String = ""
    var description: String? = nil
    var amount: String = ""
    var symbol: String? = nil
    
    private var _height: CGFloat = 0.0
    var height: CGFloat {
        set {
            self._height = newValue
        }
        
        get {
            var newH = self._height
            
            if self.isDevider {
                newH += 7.0
                
                if let desc = self.description, !desc.isEmpty {
                    newH += 10.0
                }
            }
            return newH
        }
    }
    
    var isNext: Bool = false
    var isLastNext: Bool = false
    var isDevider: Bool = false
    var isForTitle: Bool = false
}

protocol SpecialAccountDetailsVMDelegate: class {
    func willFetchScreenDetails()
    func fetchScreenDetailsSuccess()
    func fetchScreenDetailsFail()
    
    func willGetOutstandingPayment()
    func getOutstandingPaymentSuccess()
    func getOutstandingPaymentFail()
}

class SpecialAccountDetailsVM {
    //MARK:- Properties
    //MARK:- Public

    weak var delegate: SpecialAccountDetailsVMDelegate? = nil
    private(set) var statementSummery: [SpecialAccountEvent] = []
    private(set) var topUpSummery: [SpecialAccountEvent] = []
    private(set) var bilWiseSummery: [SpecialAccountEvent] = []
    private(set) var creditSummery: [SpecialAccountEvent] = []
    private(set) var otherAction: [SpecialAccountEvent] = []

    private(set) var accVouchers: [String] = []
    
    private(set) var accountLadger: JSONDictionary = JSONDictionary()
    private(set) var periodicEvents: JSONDictionary = JSONDictionary()
    private(set) var outstandingLadger: AccountOutstanding = AccountOutstanding(json: [:])
    
    private(set) var itineraryData: DepositItinerary?
    
    let depositCellHeight: CGFloat = 99.0
    
    //MARK:- Private
    
    
    //MARK:- Methods
    //MARK:- Public
    func formatDataForScreen() {
        //************************//
        guard let usr = UserInfo.loggedInUser, let accoundData = usr.accountData else {
            return
        }
        let titleH: CGFloat = 40.0
        let detailH: CGFloat = 37.0
        let detailWithDescH: CGFloat = 40.0
        let grandTotalH: CGFloat = 41.0
        
        let stmtSummery = ["Statement Summery", "Opening Balance", "Recent Payments & Credits", "Recent Charges", "Total Outstanding"]
        let stmtSummeryHeight: [CGFloat] = [titleH, detailWithDescH, detailH, detailWithDescH, grandTotalH]
        
        self.statementSummery.removeAll()
        for (idx, str) in stmtSummery.enumerated() {
            var obj = SpecialAccountEvent()
            obj.title = str
            obj.height = stmtSummeryHeight[idx]
            
            if idx == 0 {
                obj.isForTitle = true
            }
            else if idx == 1 {
                if let event = accoundData.statements?.lastStatementBalence {
                    if let date = event.dates.last {
                        let dateStr = date.toString(dateFormat: "EE, dd MMM YYYY")
                        obj.description = dateStr.isEmpty ? "" : "Up to \(dateStr)"
                    }
                    obj.amount = abs(event.amount).amountInDelimeterWithSymbol
                }
            }
            else if idx == 2 {
                if let amount = accoundData.statements?.recentCredit {
                    obj.symbol = (amount < 0) ? "-" : "+"
                    obj.amount = abs(amount).amountInDelimeterWithSymbol
                }
            }
            else if idx == 3 {
                
                if let event = accoundData.statements?.recentDebit {
                    if let start = event.dates.first, let end = event.dates.last {
                        obj.description = "\(start.toString(dateFormat: "dd MMM")) - \(end.toString(dateFormat: "dd MMM"))"
                    }
                    
                    obj.symbol = (event.amount < 0) ? "-" : "+"
                    obj.amount = abs(event.amount).amountInDelimeterWithSymbol
                }
                obj.isDevider = true
            }
            else if idx == 4 {
                obj.symbol = "="
                obj.amount = (accoundData.statements?.amountDue ?? 0.0).amountInDelimeterWithSymbol
            }
            
            self.statementSummery.append(obj)
        }
        
        let tpupSummery = ["Top-up Summary", "Active Top-up Limit", "Used Credits", "Available Credits"]
        let tpupSummeryHeight: [CGFloat] = [titleH, detailH, detailH, grandTotalH]
        
        self.topUpSummery.removeAll()
        for (idx, str) in tpupSummery.enumerated() {
            var obj = SpecialAccountEvent()
            obj.title = str
            obj.height = tpupSummeryHeight[idx]
            
            if idx == 0 {
                obj.isForTitle = true
            }
            else if idx == 1 {
                obj.amount = (0.0).amountInDelimeterWithSymbol
                obj.height = tpupSummeryHeight[idx] - 13.0
            }
            else if idx == 2 {
                obj.symbol = "-"
                obj.amount = (5953.0).amountInDelimeterWithSymbol
                obj.height = tpupSummeryHeight[idx] - 4.0
                obj.isDevider = true
            }
            else if idx == 3 {
                obj.symbol = "="
                obj.amount = (-5953.0).amountInDelimeterWithSymbol
            }
            
            self.topUpSummery.append(obj)
        }
        
        
        let bwSummery = ["Billwise Statement", "Total Over Due", "Recent Charges", "Total Outstanding"]
        let bwSummeryHeight: [CGFloat] = [titleH, detailH, detailH, grandTotalH]
        
        self.bilWiseSummery.removeAll()
        for (idx, str) in bwSummery.enumerated() {
            var obj = SpecialAccountEvent()
            obj.title = str
            obj.height = bwSummeryHeight[idx]
            
            if idx == 0 {
                obj.isForTitle = true
            }
            else if idx == 1 {
                obj.amount = (0.0).amountInDelimeterWithSymbol
                obj.height = tpupSummeryHeight[idx] - 13.0
            }
            else if idx == 2 {
                obj.symbol = "-"
                obj.amount = (0.0).amountInDelimeterWithSymbol
                obj.isDevider = true
            }
            else if idx == 3 {
                obj.symbol = "="
                obj.amount = (0.0).amountInDelimeterWithSymbol
            }
            
            self.bilWiseSummery.append(obj)
        }
        
        let crdSummery = ["Credit Summery", "Credit Limit", "Current Balance", "Available Credits"]
        let crdSummeryHeight: [CGFloat] = [titleH, detailH, detailH, grandTotalH]
        
        self.creditSummery.removeAll()
        for (idx, str) in crdSummery.enumerated() {
            var obj = SpecialAccountEvent()
            obj.title = str
            obj.height = crdSummeryHeight[idx]
            
            if idx == 0 {
                obj.isForTitle = true
                obj.height = crdSummeryHeight[idx] - 8.0
            }
            else if idx == 1 {
                obj.amount = (accoundData.credit?.creditLimit ?? 0.0).amountInDelimeterWithSymbol
                obj.height = crdSummeryHeight[idx] - 10.0
            }
            else if idx == 2 {
                let amount = (accoundData.credit?.currentBalance ?? 0.0)
                obj.symbol = "-"
                obj.amount = abs(amount).amountInDelimeterWithSymbol
                obj.height = crdSummeryHeight[idx]
                obj.isDevider = true
            }
            else if idx == 3 {
                obj.symbol = "="
                obj.amount = (accoundData.credit?.availableCredit ?? 0.0).amountInDelimeterWithSymbol
            }
            
            self.creditSummery.append(obj)
        }
        
        
        var otrAction = ["Account Ledger", "Outstanding Ledger"]
        
        if usr.userCreditType == UserCreditType.statement {
            otrAction.append("Periodic statement")
        }
        
        self.otherAction.removeAll()
        for (idx, str) in otrAction.enumerated() {
            var obj = SpecialAccountEvent()
            obj.title = str
            obj.height = 40.0
            
            obj.isDevider = true
            obj.isNext = true
            obj.isLastNext = (idx == (otrAction.count - 1))
            self.otherAction.append(obj)
        }
        
        //************************//
        
        self.delegate?.fetchScreenDetailsSuccess()
    }
    
    func fetchScreenDetails() {
        self.delegate?.willFetchScreenDetails()
        
        //firstly show the saved data
        self.formatDataForScreen()
        
        //hit api to update the saved data and show it on screen
        APICaller.shared.getAccountDetailsAPI(params: [:]) { [weak self](success, accLad, accVchrs, outLad, periodic, errors) in
            if success {
                self?.accountLadger = accLad
                self?.periodicEvents = periodic
                
                if let obj = outLad {
                    self?.outstandingLadger = obj
                }
                
                self?.accVouchers = accVchrs
                
                self?.formatDataForScreen()
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
            }
        }
    }
    
    func getOutstandingPayment() {
        
        self.delegate?.willGetOutstandingPayment()
        APICaller.shared.outstandingPaymentAPI(params: [:]) { [weak self](success, errors, itiner) in
            if success {
                self?.itineraryData = itiner
                self?.delegate?.getOutstandingPaymentSuccess()
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
                self?.delegate?.getOutstandingPaymentFail()
            }
        }
    }
    
    //MARK:- Private
}
