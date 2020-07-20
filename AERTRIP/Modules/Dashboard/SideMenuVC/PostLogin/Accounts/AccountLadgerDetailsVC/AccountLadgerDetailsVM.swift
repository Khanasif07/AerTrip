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
    var ladgerDetails: JSONDictionary = [:]
    var isDownloadingRecipt = false
    
    let amountDetailKeys = ["Date", "Voucher", "Voucher No.", "Amount", "Balance"]
    private(set) var bookingDetailKeys = ["Check-in", "Check-out", "Room", "Inclusion", "Confirmation ID"]
    let flightAmountDetailKeys = ["Date", "Bill Number", "Total Amount", "Pending Amount", "Due Date", "Over Due by days"]
    let voucherDetailKeys = ["Voucher Date", "Voucher", "Voucher Number", "Amount"]
    private(set) var flightDetailKeys = ["Travel Date", "Airline", "Sector", "PNR", "Ticket No."]
    
    //MARK:- Private

    
    //MARK:- Methods
    //MARK:- Private
    private func parseDataForDefault() {
        self.ladgerDetails.removeAll()
        
        //amount details
        var amountDetails = JSONDictionary()
        amountDetails["Date"] = self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY")
        amountDetails["Voucher"] = self.ladgerEvent!.voucherName
        amountDetails["Voucher No."] = self.ladgerEvent!.voucherNo
        amountDetails["Amount"] = "\(self.ladgerEvent!.amount)"
        amountDetails["Balance"] = "\(self.ladgerEvent!.balance)"
        
        self.ladgerDetails["0"] = amountDetails
    }
    
    private func parseDataForFlightSales() {
        //flight amount details
        if self.ladgerEvent!.dueDate != nil{
            var fAmountDetails = JSONDictionary()
            fAmountDetails["Date"] = self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY")
            fAmountDetails["Bill Number"] = self.ladgerEvent!.billNumber
            fAmountDetails["Total Amount"] = "\(self.ladgerEvent!.totalAmount)"
            fAmountDetails["Pending Amount"] = "\(self.ladgerEvent!.pendingAmount)"
            fAmountDetails["Due Date"] = self.ladgerEvent!.dueDate?.toString(dateFormat: "dd-MM-YYYY")
            
            let days = self.ladgerEvent!.overDueDays
            let daysStr = (days > 1) ? "days" : "day"
            fAmountDetails["Over Due by days"] = "\(abs(days)) \(daysStr)"
            
            self.ladgerDetails["0"] = fAmountDetails
            
            //voucher details
            var voucherDetails = JSONDictionary()
            voucherDetails["Voucher Date"] = self.ladgerEvent!.voucherDate?.toString(dateFormat: "dd-MM-YYYY")
            voucherDetails["Voucher"] = self.ladgerEvent!.voucherName
            voucherDetails["Voucher Number"] = self.ladgerEvent!.voucherNo
            voucherDetails["Amount"] = "\(self.ladgerEvent!.amount)"
            
            self.ladgerDetails["1"] = voucherDetails
            
            //flight details
            var flightDetails = JSONDictionary()
            flightDetails["Travel Date"] = self.ladgerEvent!.travelDate?.toString(dateFormat: "dd-MM-YYYY")
            flightDetails["Airline"] = self.ladgerEvent!.airline
            flightDetails["Sector"] = self.ladgerEvent!.sector
            flightDetails["PNR"] = self.ladgerEvent!.pnr
            flightDetails["Ticket No."] = self.ladgerEvent!.ticketNo
            for (idx, name) in self.ladgerEvent!.names.enumerated() {
                if idx == 0 {
                    flightDetails["Names"] = name
                    self.flightDetailKeys.append("Names")
                }
                else {
                    flightDetails["Names\(idx)"] = name
                    self.flightDetailKeys.append("Names\(idx)")
                }
            }
            
            self.ladgerDetails["2"] = flightDetails
            
        }else{
            var amountDetails = JSONDictionary()
            amountDetails["Date"] = self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY")
            amountDetails["Voucher"] = self.ladgerEvent!.voucherName
            amountDetails["Voucher No."] = self.ladgerEvent!.voucherNo
            amountDetails["Amount"] = "\(self.ladgerEvent!.amount)"
            amountDetails["Balance"] = "\(self.ladgerEvent!.balance)"
            self.ladgerDetails["0"] = amountDetails
            
            //flight details
            var flightDetails = JSONDictionary()
            flightDetails["Travel Date"] = self.ladgerEvent!.travelDate?.toString(dateFormat: "dd-MM-YYYY")
            flightDetails["Airline"] = self.ladgerEvent!.airline
            flightDetails["Sector"] = self.ladgerEvent!.sector
            flightDetails["PNR"] = self.ladgerEvent!.pnr
            flightDetails["Ticket No."] = self.ladgerEvent!.ticketNo
            for (idx, name) in self.ladgerEvent!.names.enumerated() {
                if idx == 0 {
                    flightDetails["Names"] = name
                    self.flightDetailKeys.append("Names")
                }
                else {
                    flightDetails["Names\(idx)"] = name
                    self.flightDetailKeys.append("Names\(idx)")
                }
            }
            
            self.ladgerDetails["1"] = flightDetails
        }
        
        
    }
    
    private func parseDataForHotelSales() {
        self.ladgerDetails.removeAll()

        //amount details
        if self.ladgerEvent!.dueDate == nil{
            var amountDetails = JSONDictionary()
            amountDetails["Date"] = self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY")
            amountDetails["Voucher"] = self.ladgerEvent!.voucherName
            amountDetails["Voucher No."] = self.ladgerEvent!.voucherNo
            amountDetails["Amount"] = "\(self.ladgerEvent!.amount)"
            amountDetails["Balance"] = "\(self.ladgerEvent!.balance)"
            self.ladgerDetails["0"] = amountDetails
        }else{
            var hAmountDetails = JSONDictionary()
            hAmountDetails["Date"] = self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY")
            hAmountDetails["Bill Number"] = self.ladgerEvent!.billNumber
            hAmountDetails["Total Amount"] = "\(self.ladgerEvent!.totalAmount)"
            hAmountDetails["Pending Amount"] = "\(self.ladgerEvent!.pendingAmount)"
            hAmountDetails["Due Date"] = self.ladgerEvent!.dueDate?.toString(dateFormat: "dd-MM-YYYY")
            let days = self.ladgerEvent!.overDueDays
            let daysStr = (days > 1) ? "days" : "day"
            hAmountDetails["Over Due by days"] = "\(abs(days)) \(daysStr)"
            self.ladgerDetails["0"] = hAmountDetails
        }
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
        
        self.ladgerDetails["1"] = bookingDetails
    }
    
    //MARK:- Public
    func fetchLadgerDetails() {
        self.delegate?.willFetchLadgerDetails()

        guard let event = self.ladgerEvent else {
            self.delegate?.fetchLadgerDetailsFail()
            return
        }
        
        if event.voucher == .sales || event.voucher == .journal {
            
            if event.productType == .hotel {
                self.parseDataForHotelSales()
            }
            else if event.productType == .flight {
                self.parseDataForFlightSales()
            }
        }
        else {
            self.parseDataForDefault()
        }
        
        delay(seconds: 0.8) { [weak self] in
            self?.delegate?.fetchLadgerDetailsSuccess()
        }
        self.delegate?.fetchLadgerDetailsSuccess()
    }
}
