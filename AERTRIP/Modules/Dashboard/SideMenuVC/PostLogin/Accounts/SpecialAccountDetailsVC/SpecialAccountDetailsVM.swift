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
    var height: CGFloat = 0.0
    
    var isNext: Bool = false
    var isDevider: Bool = false
    var isForTitle: Bool = false
}

protocol SpecialAccountDetailsVMDelegate: class {
    func willFetchScreenDetails()
    func fetchScreenDetailsSuccess()
    func fetchScreenDetailsFail()
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
    
    let depositCellHeight: CGFloat = 101.0
    
    //MARK:- Private
    
    
    //MARK:- Methods
    //MARK:- Public
    func fetchScreenDetails() {
        self.delegate?.willFetchScreenDetails()
        
        //************************//
        guard let usr = UserInfo.loggedInUser else {
            return
        }
        let titleH: CGFloat = 42.0
        let detailH: CGFloat = 30.0
        let detailWithDescH: CGFloat = 50.0
        let grandTotalH: CGFloat = 50.0
        
        let stmtSummery = ["Statement Summery", "Opening Balance", "Recent Payments & Credits", "Recent Charges", "Total Outstanding"]
        let stmtSummeryHeight: [CGFloat] = [titleH, detailWithDescH, detailH, detailWithDescH, grandTotalH]
        
        for (idx, str) in stmtSummery.enumerated() {
            var obj = SpecialAccountEvent()
            obj.title = str
            obj.height = stmtSummeryHeight[idx]
            
            if idx == 0 {
                obj.isForTitle = true
            }
            else if idx == 1 {
                obj.description = "Up to Tue, 31 Jul 2018"
                obj.amount = (-76641.0).amountInDelimeterWithSymbol
            }
            else if idx == 2 {
                obj.symbol = "-"
                obj.amount = (40211.0).amountInDelimeterWithSymbol
            }
            else if idx == 3 {
                obj.symbol = "+"
                obj.amount = (75599.0).amountInDelimeterWithSymbol
                obj.description = "01 Aug - 07 Aug"
                obj.isDevider = true
            }
            else if idx == 4 {
                obj.symbol = "="
                obj.amount = (-41253.0).amountInDelimeterWithSymbol
            }
            
            self.statementSummery.append(obj)
        }
        
        let tpupSummery = ["Top-up Summary", "Active Top-up Limit", "Used Credits", "Available Credits"]
        let tpupSummeryHeight: [CGFloat] = [titleH, detailH, detailH, grandTotalH]
        
        for (idx, str) in tpupSummery.enumerated() {
            var obj = SpecialAccountEvent()
            obj.title = str
            obj.height = tpupSummeryHeight[idx]
            
            if idx == 0 {
                obj.isForTitle = true
            }
            else if idx == 1 {
                obj.amount = (0.0).amountInDelimeterWithSymbol
            }
            else if idx == 2 {
                obj.symbol = "-"
                obj.amount = (5953.0).amountInDelimeterWithSymbol
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
        
        for (idx, str) in bwSummery.enumerated() {
            var obj = SpecialAccountEvent()
            obj.title = str
            obj.height = bwSummeryHeight[idx]
            
            if idx == 0 {
                obj.isForTitle = true
            }
            else if idx == 1 {
                obj.amount = (0.0).amountInDelimeterWithSymbol
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
        
        for (idx, str) in crdSummery.enumerated() {
            var obj = SpecialAccountEvent()
            obj.title = str
            obj.height = crdSummeryHeight[idx]
            
            if idx == 0 {
                obj.isForTitle = true
            }
            else if idx == 1 {
                obj.amount = ((usr.userType == UserInfo.UserType.statement) ? 2500000.0 : 0.0).amountInDelimeterWithSymbol
            }
            else if idx == 2 {
                obj.symbol = "-"
                obj.amount = ((usr.userType == UserInfo.UserType.statement) ? -41253.0 : 0.0).amountInDelimeterWithSymbol
                obj.isDevider = true
            }
            else if idx == 3 {
                obj.symbol = "="
                obj.amount = ((usr.userType == UserInfo.UserType.statement) ? 2541253.0 : 0.0).amountInDelimeterWithSymbol
            }
            
            self.creditSummery.append(obj)
        }
        
        
        var otrAction = ["Account Ledger", "Outstanding Ledger"]
        let otrActionHeight: [CGFloat] = [grandTotalH, grandTotalH, grandTotalH]
        
        if usr.userType == UserInfo.UserType.statement {
            otrAction.append("Periodic statement")
        }
        
        for (idx, str) in otrAction.enumerated() {
            var obj = SpecialAccountEvent()
            obj.title = str
            obj.height = otrActionHeight[idx]
            
            obj.isDevider = true
            obj.isNext = true
            self.otherAction.append(obj)
        }
        
        //************************//
        
        self.delegate?.fetchScreenDetailsSuccess()
    }
    
    //MARK:- Private
}
