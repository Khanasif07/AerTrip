//
//  AccountOutstandingLadgerVM.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol AccountOutstandingLadgerVMDelegate: class {
    func willGetAccountDetails(showProgres: Bool)
    func getAccountDetailsSuccess(model: AccountDetailPostModel, showProgres: Bool)
    func getAccountDetailsFail(showProgres: Bool)
    
    func searchEventsSuccess()
    func willGetOutstandingPayment()
    func getOutstandingPaymentSuccess()
    func getOutstandingPaymentFail()
}

class AccountOutstandingLadgerVM: NSObject {
    //MARK:- Properties
    //MARK:- Public
    private(set) var _accountDetails: JSONDictionary = JSONDictionary()
    private(set) var accountDetails: JSONDictionary = JSONDictionary()
    private(set) var allDates = [String]()
    private(set)var searchedAccountDetails: JSONDictionary = JSONDictionary()
    private(set) var searchedAllDates = [String]()
    
    var selectedEvent: [AccountDetailEvent] = []
    
    weak var delegate: AccountOutstandingLadgerVMDelegate? = nil
    
    var totalAmountForSelected: Double {
        return self.selectedEvent.reduce(0.0) { $0 + $1.pendingAmount}
    }
    
    var isSearching:Bool = false
    
    private(set) var itineraryData: DepositItinerary?
    
    var accountOutstanding: AccountOutstanding? {
        didSet {
            if let obj = accountOutstanding {
                self._accountDetails = obj.ladger
                self.setAccountDetails(data: obj.ladger)
            }
        }
    }
    
    var accountLadegerDetails:JSONDictionary?
    
    //MARK:- Private
    
    
    //MARK:- Methods
    //MARK:- Public
    func setAccountDetails(data: JSONDictionary) {
        self.accountDetails = data
        var arr = Array(data.keys)
        arr.sort { ($0.toDate(dateFormat: "YYYY-MM-dd")?.timeIntervalSince1970 ?? 0) < ($1.toDate(dateFormat: "YYYY-MM-dd")?.timeIntervalSince1970 ?? 0)}
        self.allDates =  arr
    }
    
    func setSearchedAccountDetails(data: JSONDictionary) {
        self.searchedAccountDetails = data
        var arr = Array(data.keys)
        arr.sort { ($0.toDate(dateFormat: "YYYY-MM-dd")?.timeIntervalSince1970 ?? 0) < ($1.toDate(dateFormat: "YYYY-MM-dd")?.timeIntervalSince1970 ?? 0)}
        self.searchedAllDates =  arr
    }
    
    func selectedArrayIndex(forEvent: AccountDetailEvent) -> Int?{
        return self.selectedEvent.firstIndex { $0.id == forEvent.id}
    }
    func searchEvent(forText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(self.callSearchEvent(_:)), with: forText, afterDelay: 0.5)
    }
    
    @objc private func callSearchEvent(_ forText: String) {
        printDebug("search text for: \(forText)")
        
        let value = self.getDataApplySearch(forText: forText, onData: self._accountDetails) ?? [:]
        self.setSearchedAccountDetails(data: value)
        self.delegate?.searchEventsSuccess()
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
                            (self.removeSpecialChar(from:event.flightNumber).contains(self.removeSpecialChar(from: forText))) ||
                            (event.bookingId.lowercased().contains(forText.lowercased()))  || (self.removeSpecialChar(from:event.voucher.rawValue).contains(self.removeSpecialChar(from: forText))) ||  (self.removeSpecialChar(from:"\(event.amount)").contains(self.removeSpecialChar(from: forText)))  ||  (self.removeSpecialChar(from:"\(event.pendingAmount)").contains(self.removeSpecialChar(from: forText))))
                        
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
    
    func sendEmailForLedger(onVC: UIViewController) {
        var param = JSONDictionary()
        param["action"] = "email"
        param["type"] = "outstanding"
        
        //AppToast.default.showToastMessage(message: LocalizedString.SendingEmail.localized, onViewController: onVC, duration: 10.0)
        APICaller.shared.accountReportActionAPI(params: param) { (success, errors) in
            if success {
                AppToast.default.hideToast(onVC, animated: false)
                AppToast.default.showToastMessage(message: LocalizedString.OutstandingSentToYourEmail.localized, onViewController: onVC)
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
            }
        }
    }
    
    func getOutstandingPayment() {
        
        self.delegate?.willGetOutstandingPayment()
        
        var allIds: [String] = []
        var param:JSONDictionary = [:]
        ///Commented as per discussion with Luvkesh regarding outstanding payment.
        if self.selectedEvent.isEmpty {
//            for key in Array(self._accountDetails.keys) {
//                if let arr = self._accountDetails[key] as? [AccountDetailEvent] {
//                    for event in arr {
//                        allIds.append(event.transactionId)
//                    }
//                }
//            }
//            param = ["txn_ids": allIds]
        }
        else {
            for event in self.selectedEvent {
                allIds.append(event.transactionId)
            }
            param = ["txn_ids": allIds]
        }
        
        APICaller.shared.outstandingPaymentAPI(params: param) { [weak self](success, errors, itiner) in
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
                if let obj = outLad {
                    sSelf.accountOutstanding = obj
                }
                let model = AccountDetailPostModel()
                model.accountLadger = accLad
                model.periodicEvents = periodic
                self?.accountLadegerDetails = accLad
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
}
