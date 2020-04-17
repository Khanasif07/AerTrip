//
//  AccountOutstandingLadgerVM.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol AccountOutstandingLadgerVMDelegate: class {
    func willGetAccountDetails()
    func getAccountDetailsSuccess()
    func getAccountDetailsFail()
    
    func searchEventsSuccess()
    func willGetOutstandingPayment()
    func getOutstandingPaymentSuccess()
    func getOutstandingPaymentFail()
}

class AccountOutstandingLadgerVM: NSObject {
    //MARK:- Properties
    //MARK:- Public
    var _accountDetails: JSONDictionary = JSONDictionary()
    var accountDetails: JSONDictionary = JSONDictionary()
    var allDates: [String] {
        var arr = Array(accountDetails.keys)
        arr.sort { ($0.toDate(dateFormat: "EEE dd MMM")?.timeIntervalSince1970 ?? 0) < ($1.toDate(dateFormat: "EEE dd MMM")?.timeIntervalSince1970 ?? 0)}
        return arr
    }
    var searchedAccountDetails: JSONDictionary = JSONDictionary()
    var searchedAllDates: [String] {
        var arr = Array(searchedAccountDetails.keys)
        arr.sort { ($0.toDate(dateFormat: "EEE dd MMM")?.timeIntervalSince1970 ?? 0) < ($1.toDate(dateFormat: "EEE dd MMM")?.timeIntervalSince1970 ?? 0)}
        return arr
    }
    
    var selectedEvent: [AccountDetailEvent] = []
    
    weak var delegate: AccountOutstandingLadgerVMDelegate? = nil
    
    var totalAmountForSelected: Double {
        return self.selectedEvent.reduce(0.0) { $0 + $1.pendingAmount}
    }
    
    
    private(set) var itineraryData: DepositItinerary?
    
    var accountOutstanding: AccountOutstanding? {
        didSet {
            if let obj = accountOutstanding {
                self._accountDetails = obj.ladger
                self.accountDetails = obj.ladger
            }
        }
    }
    
    //MARK:- Private
    
    
    //MARK:- Methods
    //MARK:- Public
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
        print("value: \(value)")
        print("forText: \(forText)")

        self.searchedAccountDetails = value
        
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
                    let fltrd = events.filter({ $0.title.lowercased().contains(forText.lowercased())})
                    if !fltrd.isEmpty {
                        newData[date] = fltrd
                    }
                }
            }
            return newData
        }
    }
    
    func sendEmailForLedger(onVC: UIViewController) {
        var param = JSONDictionary()
        param["action"] = "email"
        param["type"] = "outstanding"
        
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
    
    func getOutstandingPayment() {
        
        self.delegate?.willGetOutstandingPayment()
        
        var allIds: [String] = []
        if self.selectedEvent.isEmpty {
            for key in Array(self._accountDetails.keys) {
                if let arr = self._accountDetails[key] as? [AccountDetailEvent] {
                    for event in arr {
                        allIds.append(event.transactionId)
                    }
                }
            }
        }
        else {
            for event in self.selectedEvent {
                allIds.append(event.transactionId)
            }
        }

        APICaller.shared.outstandingPaymentAPI(params: ["txn_ids": allIds]) { [weak self](success, errors, itiner) in
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
