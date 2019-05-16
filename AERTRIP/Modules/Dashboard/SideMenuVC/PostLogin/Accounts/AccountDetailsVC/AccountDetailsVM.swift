//
//  AccountDetailsVM.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

struct AccountOutstanding {
    var ladger: JSONDictionary = JSONDictionary()
    var vouchers: [String] = []
    var grossAmount: Double = 0.0
    var onAccountAmount: Double = 0.0
    var netAmount: Double = 0.0
    
    private var _onAccountDate: String = ""
    var onAccountDate: Date? {
        //"2019-05-15 16:39:11"
        return _onAccountDate.toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")
    }
    
    init(json: JSONDictionary) {
        if let transactions = json["transactions"] as? [JSONDictionary] {
            let (lad, vchr) = AccountDetailEvent.modelsDict(data: transactions)
            self.ladger = lad
            self.vouchers = vchr
        }
        
        if let onAccount = json["on_account"] as? JSONDictionary {
            if let obj = onAccount["amount"] {
                self.onAccountAmount = "\(obj)".toDouble ?? 0.0
            }
            
            if let obj = onAccount["transaction_datetime"] as? String {
                self._onAccountDate = obj
            }
        }
    }
}

protocol AccountDetailsVMDelegate: class {
    func willGetAccountDetails()
    func getAccountDetailsSuccess()
    func getAccountDetailsFail()
    
    func searchEventsSuccess()
    func applyFilterSuccess()
    func applyFilterFail()
}

class AccountDetailsVM: NSObject {
    //MARK:- Properties
    //MARK:- Public
    var oldFilter: AccountSelectedFilter?
    var walletAmount: Double = 0.0
    var _accountDetails: JSONDictionary = JSONDictionary()
    var accountDetails: JSONDictionary = JSONDictionary()
    var allDates: [String] {
        var arr = Array(accountDetails.keys)
        arr.sort { ($0.toDate(dateFormat: "EEE dd MMM")?.timeIntervalSince1970 ?? 0) > ($1.toDate(dateFormat: "EEE dd MMM")?.timeIntervalSince1970 ?? 0)}
        return arr
    }
    var searchedAccountDetails: JSONDictionary = JSONDictionary()
    var searchedAllDates: [String] {
        var arr = Array(searchedAccountDetails.keys)
        arr.sort { ($0.toDate(dateFormat: "EEE dd MMM")?.timeIntervalSince1970 ?? 0) > ($1.toDate(dateFormat: "EEE dd MMM")?.timeIntervalSince1970 ?? 0)}
        return arr
    }
    
    var allVouchers: [String] = []
    
    weak var delegate: AccountDetailsVMDelegate? = nil
    
    //MARK:- Private
    
    
    
    //MARK:- Methods
    //MARK:- Public
    func searchEvent(forText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(self.callSearchEvent(_:)), with: forText, afterDelay: 0.5)
    }
    
    @objc private func callSearchEvent(_ forText: String) {
        printDebug("search text for: \(forText)")
        self.searchedAccountDetails = self.getDataApplySearch(forText: forText, onData: self._accountDetails) ?? [:]
        
        self.delegate?.searchEventsSuccess()
    }
    
    private func getDataApplySearch(forText: String, onData: JSONDictionary) -> JSONDictionary? {
        if forText.isEmpty {
            return onData
        }
        else {
            
            var newData = JSONDictionary()
            
            for date in Array(onData.keys) {
                if let events = onData[date] as? [AccountDetailEvent] {
                    let fltrd = events.filter({ $0.title.lowercased().contains(forText.lowercased())})
                    if !fltrd.isEmpty {
                        newData[date] = fltrd
                    }
                }
            }
            return newData
        }
    }
    
    private func filterForVoucher(voucher: String, onData: JSONDictionary) -> JSONDictionary? {
        
        guard !voucher.isEmpty, voucher.lowercased() != "all", let vchr = AccountDetailEvent.Voucher(rawValue: voucher) else {
            return onData
        }
        
        var newData = JSONDictionary()
        
        for date in Array(onData.keys) {
            if let events = onData[date] as? [AccountDetailEvent] {
                let fltrd = events.filter({ $0.voucher == vchr})
                if !fltrd.isEmpty {
                    newData[date] = fltrd
                }
            }
        }
        
        return newData
    }
    
    func setAccountDetails(details: JSONDictionary) {
        self._accountDetails = details
        self.accountDetails = details
        self.delegate?.getAccountDetailsSuccess()
    }
    
    func getAccountDetails() {
        self.delegate?.willGetAccountDetails()
        
        guard self._accountDetails.isEmpty else {
            //because the data has been send from previous screen
            self.delegate?.getAccountDetailsSuccess()
            return
        }
        
        
        delay(seconds: 0.8) { [weak self] in
            guard let sSelf = self else {
                self?.delegate?.getAccountDetailsFail()
                return
            }
            
            let allData = [[
                            "id":"1",
                            "title":"Ramada Powai Hotel And Convention Centre",
                            "creationDate":"Tue 30 Apr",
                            "voucher":"hotels",
                            "amount":-2314.51,
                            "balance":-345,
                            "names": ["Mr. Pratik Choudhary", "Mr. Om Prakash Bairwal", "Mr. Pratik Choudhary", "Mr. Om Prakash Bairwal"]
                           ],
                           [
                            "id":"11",
                            "title":"11 Ramada Powai Hotel And Convention Centre",
                            "creationDate":"Tue 30 Apr",
                            "voucher":"hotelCancellation",
                            "amount":-2314.51,
                            "balance":-345
                            ],
                           [
                            "id":"12",
                            "title":"12 Ramada Powai Hotel And Convention Centre",
                            "creationDate":"Tue 30 Apr",
                            "voucher":"journalVoucher",
                            "amount":-2314.51,
                            "balance":-345
                            ],
                           [
                            "id":"2",
                            "title":"DEL → BOM → DEL → GOA",
                            "creationDate":"Mon 29 Apr",
                            "voucher":"flight",
                            "amount":-3452.2,
                            "balance":-7856.2,
                            "names": ["Mrs. Shashi Poddar"]
                           ],
                           [
                            "id":"3",
                            "title":"Credit Card",
                            "creationDate":"Sat 27 Apr",
                            "voucher":"creditNote",
                            "amount":-645.2,
                            "balance":-6354.0
                           ]
                          ]
            
            sSelf._accountDetails = AccountDetailEvent.modelsDict(data: allData).data
            sSelf.accountDetails = sSelf._accountDetails
            
            sSelf.delegate?.getAccountDetailsSuccess()
        }
        
    }
    
    func applyFilter(filter: AccountSelectedFilter?, searchText: String) {
        
        //filters are changed filter according dates and voucher
        var param = JSONDictionary()
        param["limit"] = 20
        param["type"] = "ledger"
        
        if let date = filter?.fromDate {
            param["end_date"] = date.toString(dateFormat: "YYYY-MM-dd")
        }
        if let date = filter?.toDate {
            param["start_date"] = date.toString(dateFormat: "YYYY-MM-dd")
        }
        
        self.oldFilter = filter
        //hit api to update the saved data and show it on screen
        APICaller.shared.getAccountDetailsAPI(params: param) { [weak self](success, accLad, accVchrs, outLad, errors) in
            
            guard let sSelf = self else {return}
            if success {
                if let searched = sSelf.getDataApplySearch(forText: searchText, onData: accLad) {
                    
                    if let vchr = filter?.voucherType, let data = sSelf.filterForVoucher(voucher: vchr, onData: searched) {
                        sSelf.accountDetails = data
                        sSelf.delegate?.applyFilterSuccess()
                    }
                    else {
                        sSelf.accountDetails = searched
                        sSelf.delegate?.applyFilterSuccess()
                    }
                }
            }
            else {
                sSelf.delegate?.applyFilterFail()
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
            }
        }
    }
    
    func sendEmailForLedger() {
        var param = JSONDictionary()
        param["action"] = "email"
        param["type"] = "ledger"
        param["limit"] = 20
        
        APICaller.shared.accountReportActionAPI(params: param) { (success, errors) in
            if success {
                AppToast.default.showToastMessage(message: "Ledger has been sent to your registered email-id.")
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
            }
        }
    }
    
    //MARK:- Private
}
