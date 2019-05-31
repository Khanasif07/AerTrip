//
//  AccountDetailsVM.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

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
    var _accountDetails: JSONDictionary = JSONDictionary() {
        didSet {
            self.fetchLedgerStartDate()
        }
    }
    
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
    
    var ledgerStartDate: Date = Date()
    
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
    
    private func fetchLedgerStartDate() {
        var arr = Array(_accountDetails.keys)
        arr.sort { ($0.toDate(dateFormat: "EEE dd MMM")?.timeIntervalSince1970 ?? 0) > ($1.toDate(dateFormat: "EEE dd MMM")?.timeIntervalSince1970 ?? 0)}
        if let lastD = arr.last, let dataArr = _accountDetails[lastD] as? [AccountDetailEvent] {
            self.ledgerStartDate = dataArr.last?.date ?? Date()
        }
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
        
        //hit api to update the saved data and show it on screen
        APICaller.shared.getAccountDetailsAPI(params: [:]) { [weak self](success, accLad, accVchrs, outLad, periodic, errors) in
            
            guard let sSelf = self else {
                return
            }
            
            if success {
                sSelf._accountDetails = accLad
                sSelf.accountDetails = sSelf._accountDetails
                sSelf.delegate?.getAccountDetailsSuccess()
            }
            else {
                sSelf.delegate?.getAccountDetailsFail()
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
            }
        }
    }
    
    func applyFilter(filter: AccountSelectedFilter?, searchText: String) {
        
        //filters are changed filter according dates and voucher
        var param = JSONDictionary()
        param["type"] = "ledger"
        
        if let fromDate = filter?.fromDate, let toDate = filter?.toDate {
            param["start_date"] = fromDate.toString(dateFormat: "YYYY-MM-dd")
            param["end_date"] = toDate.toString(dateFormat: "YYYY-MM-dd")
        }

        self.oldFilter = filter
        //hit api to update the saved data and show it on screen
        APICaller.shared.getAccountDetailsAPI(params: param) { [weak self](success, accLad, accVchrs, outLad, periodic, errors) in
            
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
