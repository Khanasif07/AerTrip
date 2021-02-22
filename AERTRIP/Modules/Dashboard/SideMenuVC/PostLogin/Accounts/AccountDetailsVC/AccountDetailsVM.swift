//
//  AccountDetailsVM.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol AccountDetailsVMDelegate: class {
    func willGetAccountDetails(showProgres: Bool)
    func getAccountDetailsSuccess(model: AccountDetailPostModel, showProgres: Bool)
    func getAccountDetailsFail(showProgres: Bool)
    
    func searchEventsSuccess()
    func applyFilterSuccess()
    func applyFilterFail()
}

class AccountDetailsVM: NSObject {
    //MARK:- Properties
    //MARK:- Public
    var walletAmount: Double = 0.0
    private(set) var _accountDetails: JSONDictionary = JSONDictionary() {
        didSet {
            self.fetchLedgerStartDate()
        }
    }
    private(set) var accountDetails: JSONDictionary = JSONDictionary()
    private(set) var allDates = [String]()
    private(set) var searchedAccountDetails: JSONDictionary = JSONDictionary()
    private(set) var searchedAllDates = [String]()
    
    var allVouchers: [String] = []
    
    weak var delegate: AccountDetailsVMDelegate? = nil
    
    var ledgerStartDate: Date = Date()
    var deepLinkParams:[String:String] = [:]
    
    //MARK:- Private
    
    
    
    //MARK:- Methods
    //MARK:- Public
    func setAccountDetails(data: JSONDictionary) {
        self.accountDetails = data
        var arr = Array(data.keys)
        arr.sort { ($0.toDate(dateFormat: "YYYY-MM-dd")?.timeIntervalSince1970 ?? 0) > ($1.toDate(dateFormat: "YYYY-MM-dd")?.timeIntervalSince1970 ?? 0)}
        self.allDates =  arr
    }
    
    func setSearchedAccountDetails(data: JSONDictionary) {
        self.searchedAccountDetails = data
        var arr = Array(data.keys)
        arr.sort { ($0.toDate(dateFormat: "YYYY-MM-dd")?.timeIntervalSince1970 ?? 0) > ($1.toDate(dateFormat: "YYYY-MM-dd")?.timeIntervalSince1970 ?? 0)}
        self.searchedAllDates =  arr
    }
    func searchEvent(forText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(self.callSearchEvent(_:)), with: forText, afterDelay: 0.5)
    }
    
    @objc private func callSearchEvent(_ forText: String) {
        printDebug("search text for: \(forText)")
        DispatchQueue.main.async{
            let value = self.getDataApplySearch(forText: forText, onData: self._accountDetails) ?? [:]
            self.setSearchedAccountDetails(data: value)
            self.delegate?.searchEventsSuccess()
        }
    }
    
    private func fetchLedgerStartDate() {
        var arr = Array(_accountDetails.keys)
        arr.sort { ($0.toDate(dateFormat: "YYYY-MM-dd")?.timeIntervalSince1970 ?? 0) > ($1.toDate(dateFormat: "YYYY-MM-dd")?.timeIntervalSince1970 ?? 0)}
        if let lastD = arr.last, let dataArr = _accountDetails[lastD] as? [AccountDetailEvent] {
            self.ledgerStartDate = dataArr.last?.date ?? Date()
        }
    }
    
    private func getDataApplySearch(forText: String, onData: JSONDictionary) -> JSONDictionary? {
        if forText.isEmpty {
            return [:]
        }
        else {
            
            var newData = JSONDictionary()
            
            for date in Array(onData.keys) {
                if let events = onData[date] as? [AccountDetailEvent] {
                    //                    let fltrd = events.filter({ $0.title.lowercased().contains(forText.lowercased())})
                    let fltrd = events.filter { event in
                        return ((event.title.lowercased().contains(forText.lowercased())) || (event.voucherNo.lowercased().contains(forText.lowercased())) ||
                                    (event.bookingNumber.lowercased().contains(forText.lowercased())) ||
                                    (event.airline.lowercased().contains(forText.lowercased())) ||
                                    (self.removeSpecialChar(from:event.flightNumber).contains(self.removeSpecialChar(from: forText))))
//                                    ||
//                                    (event.bookingId.lowercased().contains(forText.lowercased())))
                        
                        
                    }
                    if !fltrd.isEmpty {
                        newData[date] = fltrd
                    }
                }
            }
            return newData
        }
    }
    
    private func removeSpecialChar(from str: String)->String{
        let newStr = str.lowercased()
        let okayChars = Set("abcdefghijklmnopqrstuvwxyz1234567890")
        return newStr.filter {okayChars.contains($0) }
    }
    
//    private func filterForVoucher(voucher: String, onData: JSONDictionary) -> JSONDictionary? {
//
//        guard !voucher.isEmpty, voucher.lowercased() != "all", let vchr = VoucherType(rawValue: voucher) else {
//            return [:]
//        }
//
//        var newData = JSONDictionary()
//
//        for date in Array(onData.keys) {
//            if let events = onData[date] as? [AccountDetailEvent] {
//                let fltrd = events.filter({ $0.voucher == vchr})
//                if !fltrd.isEmpty {
//                    newData[date] = fltrd
//                }
//            }
//        }
//
//        return newData
//    }
    
    func setAccountDetails(details: JSONDictionary) {
        self._accountDetails = details
        self.setAccountDetails(data: details)
        //self.delegate?.getAccountDetailsSuccess()
    }
    
    func getAccountDetails(showProgres: Bool) {
        self.delegate?.willGetAccountDetails(showProgres: showProgres)
        
//        guard self._accountDetails.isEmpty else {
//            //because the data has been send from previous screen
//            self.delegate?.getAccountDetailsSuccess(model: AccountDetailPostModel(), showProgres: showProgres)
//            return
//        }
        
        //hit api to update the saved data and show it on screen
        APICaller.shared.getAccountDetailsAPI(params: [:]) { [weak self](success, accLad, accVchrs, outLad, periodic, errors) in
            
            guard let sSelf = self else {
                return
            }
            
            if success {
                sSelf._accountDetails = accLad
                sSelf.setAccountDetails(data: accLad)
                sSelf.allVouchers = accVchrs
                
                let model = AccountDetailPostModel()
                model.accountLadger = accLad
                model.periodicEvents = periodic
                if let obj = outLad {
                    model.outstandingLadger = obj
                }
                model.accVouchers = accVchrs
                
                sSelf.delegate?.getAccountDetailsSuccess(model: model, showProgres: showProgres)

            }
            else {
                sSelf.delegate?.getAccountDetailsFail(showProgres: showProgres)
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
            }
        }
    }
    
    func applyFilter(searchText: String) {
        let filtr = ADEventFilterVM.shared
        if !ADEventFilterVM.shared.isFilterAplied {
            setAccountDetails(data: _accountDetails)
        } else {
            var newData = JSONDictionary()
            for date in Array(_accountDetails.keys) {
                if let events = _accountDetails[date] as? [AccountDetailEvent] {
                    var fltrd = [AccountDetailEvent]()
                    if filtr.fromDate == nil && filtr.toDate == nil {
                        fltrd = events
                    } else {
                        fltrd = events.filter { event in
                            
                            var status = false
                            if let frmDate = filtr.fromDate, let toDate = filtr.toDate, let creationDate = event._creationDate, frmDate <= toDate {
                                if (frmDate...toDate).contains(creationDate) || Date.compareDate(date1: frmDate, date2: creationDate) || Date.compareDate(date1: creationDate, date2: toDate)  {
                                    printDebug("toDate: \(toDate)")
                                    printDebug("frmDate: \(frmDate)")
                                    printDebug("creationDate: \(creationDate)")
                                    status = true
                                }
                            } else if let frmDate = filtr.fromDate, let creationDate = event._creationDate {
                                if creationDate >= frmDate || Date.compareDate(date1: frmDate, date2: creationDate) {
                                    status = true
                                }
                            }else if let toDate = filtr.toDate, let creationDate = event._creationDate {
                                if creationDate <= toDate || Date.compareDate(date1: creationDate, date2: toDate) {
                                    status = true
                                }
                            }
                            
                            return status
                        }
                    }
                    fltrd = fltrd.filter { event in
                        var status = false
                        if !filtr.selectedVoucherType.isEmpty {
                            if filtr.selectedVoucherType.contains(where: { (voucher) -> Bool in
                                return voucher.lowercased() == "all"
                            }) {
                                status = true
                            }
                            else if filtr.selectedVoucherType.contains(where: { (voucher) -> Bool in
                                return voucher.lowercased() == event.voucherName.lowercased()
                            }) {
                                status = true
                            }else {
                                status = false
                            }
                        } else {
                            status = true
                        }
                        return status
                    }
                    
                    if !fltrd.isEmpty {
                        newData[date] = fltrd
                    }
                }
            }
            
            setAccountDetails(data: newData)
        }
        
        self.delegate?.applyFilterSuccess()
        /*
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
         sSelf.setAccountDetails(data: data)
         sSelf.delegate?.applyFilterSuccess()
         }
         else {
         sSelf.setAccountDetails(data: searched)
         sSelf.delegate?.applyFilterSuccess()
         }
         }
         }
         else {
         sSelf.delegate?.applyFilterFail()
         AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
         }
         }
         */
    }
    
    func sendEmailForLedger(onVC: UIViewController) {
        var param = JSONDictionary()
        param["action"] = "email"
        param["type"] = "ledger"
        
        //AppToast.default.showToastMessage(message: LocalizedString.SendingEmail.localized, onViewController: onVC, duration: 10.0)
        APICaller.shared.accountReportActionAPI(params: param) { (success, errors) in
            if success {
                AppToast.default.hideToast(onVC, animated: false)
                AppToast.default.showToastMessage(message: LocalizedString.LedgerSentToYourEmail.localized, onViewController: onVC)
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
            }
        }
    }
    
    //MARK:- Private
    
    func getEventFromAccountLadger(with id:String)-> AccountDetailEvent?{
        let trans = (Array(self.accountDetails.values) as? [[AccountDetailEvent]] ?? []).flatMap{$0}
        if let event  = trans.first(where: {$0.voucherNo == id}){
            return event
        }
        return nil
    }

}
