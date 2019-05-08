//
//  AccountLadgerDetailsVM.swift
//  AERTRIP
//
//  Created by Admin on 07/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol AccountLadgerDetailsVMDelegate: class {
    func willFetchLadgerDetails()
    func fetchLadgerDetailsSuccess()
    func fetchLadgerDetailsFail()
}

class AccountLadgerDetailsVM {
    //MARK:- Properties
    //MARK:- Public
    weak var delegate:AccountLadgerDetailsVMDelegate?
    var ladgerEvent: AccountDetailEvent?
    var ladgerDetails: [JSONDictionary] = [[:]]
    
    let amountDetailKeys = ["Date", "Voucher", "Voucher No.", "Amount", "Balance"]
    private(set) var bookingDetailKeys = ["Check-in", "Check-out", "Room", "Inclusion", "Confirmation ID"]
    
    //MARK:- Private

    
    //MARK:- Methods
    //MARK:- Private
    private func parseDataForCredit() {
        self.ladgerDetails.removeAll()
        
        //amount details
        var amountDetails = JSONDictionary()
        amountDetails["Date"] = self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY")
        amountDetails["Voucher"] = self.ladgerEvent!.voucher.title
        amountDetails["Voucher No."] = self.ladgerEvent!.voucherNo
        amountDetails["Amount"] = self.ladgerEvent!.amount.amountInDelimeterWithSymbol
        amountDetails["Balance"] = self.ladgerEvent!.balance.amountInDelimeterWithSymbol
        
        self.ladgerDetails.append(amountDetails)
    }
    
    private func parseDataForFlight() {
        
    }
    
    private func parseDataForOther() {
        self.ladgerDetails.removeAll()

        //amount details
        var amountDetails = JSONDictionary()
        amountDetails["Date"] = self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY")
        amountDetails["Voucher"] = self.ladgerEvent!.voucher.title
        amountDetails["Voucher No."] = self.ladgerEvent!.voucherNo
        amountDetails["Amount"] = self.ladgerEvent!.amount.amountInDelimeterWithSymbol
        amountDetails["Balance"] = self.ladgerEvent!.balance.amountInDelimeterWithSymbol
        
        self.ladgerDetails.append(amountDetails)
        
        //booking details
        var bookingDetails = JSONDictionary()
        bookingDetails["Check-in"] = self.ladgerEvent!.checkIn?.toString(dateFormat: "dd-MM-YYYY") ?? ""
        bookingDetails["Check-out"] = self.ladgerEvent!.checkOut?.toString(dateFormat: "dd-MM-YYYY") ?? ""
        bookingDetails["Room"] = self.ladgerEvent!.room
        bookingDetails["Inclusion"] = self.ladgerEvent!.inclusion
        bookingDetails["Confirmation ID"] = self.ladgerEvent!.confirmationId
        for (idx, name) in self.ladgerEvent!.names.enumerated() {
            if idx == 0 {
                bookingDetails["Names"] = name
                self.bookingDetailKeys.append("Names")
            }
            else {
                bookingDetails["Names\(idx)"] = name
                self.bookingDetailKeys.append("Names\(idx)")
            }
        }
        
        self.ladgerDetails.append(bookingDetails)
    }
    
    //MARK:- Public
    func fetchLadgerDetails() {
        self.delegate?.willFetchLadgerDetails()

        guard let event = self.ladgerEvent else {
            self.delegate?.fetchLadgerDetailsFail()
            return
        }
        
        if event.voucher == .creditNote {
            self.parseDataForCredit()
        }
        else if event.voucher == .flight {
            self.parseDataForFlight()
        }
        else {
            self.parseDataForOther()
        }
        
        self.delegate?.fetchLadgerDetailsSuccess()
    }
}
