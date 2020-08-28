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
  //  var ladgerDetails: JSONDictionary = [:]
    var isDownloadingRecipt = false
    var sectionArray = [[(title: String, value: String, age: String, isEmptyCell: Bool)]]()
    //MARK:- Private

    
    //MARK:- Methods
    //MARK:- Private
    private func parseDataForDefault() {
        if self.ladgerEvent!.dueDate != nil{
            let days = self.ladgerEvent!.overDueDays
            let daysStr = (days > 1) ? "days" : "day"
            //fAmountDetails["Over Due by days"] = "\(abs(days)) \(daysStr)"
            var section1 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
            section1.append((title: "Pending Amount", value: "\(self.ladgerEvent!.pendingAmount)", age: "", isEmptyCell: false))
            section1.append((title: "Due Date", value: self.ladgerEvent!.dueDate?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
            section1.append((title: "Over Due by days", value: "\(abs(days)) \(daysStr)", age: "", isEmptyCell: false))
            section1.append((title: "", value: "", age: "", isEmptyCell: true))
            self.sectionArray.append(section1)
        }
        
        var section1 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
        section1.append((title: "Date", value: self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "",  isEmptyCell: false))
        section1.append((title: "Voucher", value: self.ladgerEvent!.voucherName, age: "",  isEmptyCell: false))
        if  !self.ladgerEvent!.voucherNo.isEmpty{
            section1.append((title: "Voucher No.", value: self.ladgerEvent!.voucherNo, age: "",  isEmptyCell: false))
        }
        section1.append((title: "Amount", value: "\(abs(self.ladgerEvent!.amount))", age: "", isEmptyCell: false))
//        section1.append((title: "Balance", value: "\(self.ladgerEvent!.balance)", age: "", isEmptyCell: false))
        section1.append((title: "", value: "", age: "", isEmptyCell: true))
        self.sectionArray.append(section1)

       // self.ladgerDetails["0"] = amountDetails
        
        if self.ladgerEvent!.receiptMethod == .offline{
            var section2 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
            
            if !self.ladgerEvent!.chequeNumber.isEmpty{
                section2.append((title: "Cheque Number", value: "\(self.ladgerEvent!.chequeNumber)", age: "", isEmptyCell: false))
            }
            if let date  = self.ladgerEvent!.chequeDate.toDate(dateFormat: "yyyy-MM-dd")?.toString(dateFormat: "dd-MM-yyyy"){
                section2.append((title: "Cheque date", value: date, age: "", isEmptyCell: false))
            }
            if !self.ladgerEvent!.utrNumner.isEmpty{
                section2.append((title: "UTR Number", value: "\(self.ladgerEvent!.utrNumner)", age: "", isEmptyCell: false))
            }
            if let dDate  = self.ladgerEvent!.depositDate.toDate(dateFormat: "yyyy-MM-dd")?.toString(dateFormat: "dd-MM-yyyy"){
                section2.append((title: "Deposit Date", value: dDate, age: "", isEmptyCell: false))
            }
            if !self.ladgerEvent!.offlineBankName.isEmpty{
                section2.append((title: "Bank Name", value: "\(self.ladgerEvent!.offlineBankName)", age: "", isEmptyCell: false))
            }
            if !self.ladgerEvent!.offlineAccountName.isEmpty{
                section2.append((title: "Account Name", value: "\(self.ladgerEvent!.offlineAccountName)", age: "", isEmptyCell: false))
            }
            if !section2.isEmpty{
                section2.append((title: "", value: "", age: "", isEmptyCell: true))
                self.sectionArray.append(section2)
            }
            
        }
        
    }
    
    private func parseDataForFlightSales() {
        //flight amount details
        if self.ladgerEvent!.dueDate != nil{
            let days = self.ladgerEvent!.overDueDays
            let daysStr = (days > 1) ? "days" : "day"
            //fAmountDetails["Over Due by days"] = "\(abs(days)) \(daysStr)"
            var section1 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
            section1.append((title: "Pending Amount", value: "\(self.ladgerEvent!.pendingAmount)", age: "", isEmptyCell: false))
            section1.append((title: "Due Date", value: self.ladgerEvent!.dueDate?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
            section1.append((title: "Over Due by days", value: "\(abs(days)) \(daysStr)", age: "", isEmptyCell: false))
            section1.append((title: "", value: "", age: "", isEmptyCell: true))
            self.sectionArray.append(section1)
            
            var section2 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
            section2.append((title: "Date", value: self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
            section2.append((title: "Voucher", value: self.ladgerEvent!.voucherName, age: "",  isEmptyCell: false))
            if  !self.ladgerEvent!.voucherNo.isEmpty{
                section2.append((title: "Voucher No.", value: self.ladgerEvent!.voucherNo, age: "", isEmptyCell: false))
            }
            section2.append((title: "Total Amount", value: "\(self.ladgerEvent!.amount)", age: "", isEmptyCell: false))
            section2.append((title: "", value: "", age: "", isEmptyCell: true))
            self.sectionArray.append(section2)
            
            var section4 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
            if  !(self.ladgerEvent!.travelDate?.toString(dateFormat: "dd-MM-YYYY") ?? "").isEmpty{
                section4.append((title: "Travel Date", value: self.ladgerEvent!.travelDate?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
            }
            if  !self.ladgerEvent!.airline.isEmpty{
                section4.append((title: "Airline", value: self.ladgerEvent!.airline, age: "", isEmptyCell: false))
            }
            if  !self.ladgerEvent!.sector.isEmpty{
                section4.append((title: "Sector", age: "", value: self.ladgerEvent!.title, isEmptyCell: false))
            }
            if  !self.ladgerEvent!.pnr.isEmpty{
                section4.append((title: "PNR", value: self.ladgerEvent!.pnr, age: "", isEmptyCell: false))
            }
            if  !self.ladgerEvent!.ticketNo.isEmpty{
            section4.append((title: "Ticket No.", value: self.ladgerEvent!.ticketNo, age: "", isEmptyCell: false))
            }


            for (idx, name) in self.ladgerEvent!.names.enumerated() {
                var age = ""
                if !name.dob.isEmpty {
                    age = AppGlobals.shared.getAgeLastString(dob: name.dob, formatter: Date.DateFormat.yyyy_MM_dd.rawValue)
                }
                if idx == 0 {
                    section4.append((title: "Names", value: name.name, age: age, isEmptyCell: false))
                }
                else {
                    section4.append((title: "", value: name.name, age: age, isEmptyCell: false))
                }
            }
            if !section4.isEmpty{
                section4.append((title: "", value: "", age: "", isEmptyCell: true))
                self.sectionArray.append(section4)
            }
            
        }else{
            var section1 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
            section1.append((title: "Date", value: self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
            section1.append((title: "Voucher", value: self.ladgerEvent!.voucherName, age: "", isEmptyCell: false))
            if  !self.ladgerEvent!.voucherNo.isEmpty{
                section1.append((title: "Voucher No.", value: self.ladgerEvent!.voucherNo, age: "", isEmptyCell: false))
            }
            section1.append((title: "Amount", value: "\(abs(self.ladgerEvent!.amount))", age: "", isEmptyCell: false))
//            section1.append((title: "Balance", value: "\(self.ladgerEvent!.balance)", age: "", isEmptyCell: false))
            section1.append((title: "", value: "", age: "", isEmptyCell: true))
            self.sectionArray.append(section1)
            
            //flight details
            var section2 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
            if  !(self.ladgerEvent!.travelDate?.toString(dateFormat: "dd-MM-YYYY") ?? "").isEmpty{
                section2.append((title: "Travel Date", value: self.ladgerEvent!.travelDate?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
            }
            if  !self.ladgerEvent!.airline.isEmpty{
                section2.append((title: "Airline", value: self.ladgerEvent!.airline, age: "", isEmptyCell: false))
            }
            if  !self.ladgerEvent!.sector.isEmpty{
            section2.append((title: "Sector", age: "", value: self.ladgerEvent!.title, isEmptyCell: false))
            }
            if  !self.ladgerEvent!.pnr.isEmpty{
                section2.append((title: "PNR", value: self.ladgerEvent!.pnr, age: "", isEmptyCell: false))
            }
            if  !self.ladgerEvent!.ticketNo.isEmpty{
                section2.append((title: "Ticket No.", value: self.ladgerEvent!.ticketNo, age: "", isEmptyCell: false))
            }
            for (idx, name) in self.ladgerEvent!.names.enumerated() {
                var age = ""
                if !name.dob.isEmpty {
                    age = AppGlobals.shared.getAgeLastString(dob: name.dob, formatter: Date.DateFormat.yyyy_MM_dd.rawValue)
                }
                if idx == 0 {
                    section2.append((title: "Names", value: name.name, age: age, isEmptyCell: false))
                }
                else {
                    section2.append((title: "", value: name.name, age: age, isEmptyCell: false))
                }
            }
            
            //self.ladgerDetails["1"] = flightDetails
            if !section2.isEmpty{
                section2.append((title: "", value: "", age: "", isEmptyCell: true))
                self.sectionArray.append(section2)
            }
        }
        
        
    }
    
    private func parseDataForHotelSales() {
        //self.ladgerDetails.removeAll()

        //amount details
        if self.ladgerEvent!.dueDate == nil{
            var section1 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
            section1.append((title: "Date", value: self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
            section1.append((title: "Voucher", value: self.ladgerEvent!.voucherName, age: "", isEmptyCell: false))
            if  !self.ladgerEvent!.voucherNo.isEmpty{
                section1.append((title: "Voucher No.", value: self.ladgerEvent!.voucherNo, age: "", isEmptyCell: false))
            }
            section1.append((title: "Amount", value: "\(abs(self.ladgerEvent!.amount))", age: "",
                             isEmptyCell: false))
//            section1.append((title: "Balance", value: "\(self.ladgerEvent!.balance)", age: "", isEmptyCell: false))
            section1.append((title: "", value: "", age: "", isEmptyCell: true))
            self.sectionArray.append(section1)

            
        }else{
            let days = self.ladgerEvent!.overDueDays
            let daysStr = (days > 1) ? "days" : "day"
            //fAmountDetails["Over Due by days"] = "\(abs(days)) \(daysStr)"
            var section1 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
            section1.append((title: "Pending Amount", value: "\(self.ladgerEvent!.pendingAmount)", age: "", isEmptyCell: false))
            section1.append((title: "Due Date", value: self.ladgerEvent!.dueDate?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
            section1.append((title: "Over Due by days", value: "\(abs(days)) \(daysStr)", age: "", isEmptyCell: false))
            section1.append((title: "", value: "", age: "", isEmptyCell: true))
            self.sectionArray.append(section1)
            var section2 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
            section2.append((title: "Date", value: self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
            section2.append((title: "Voucher", value: self.ladgerEvent!.voucherName, age: "", isEmptyCell: false))
            if  !self.ladgerEvent!.voucherNo.isEmpty{
                section2.append((title: "Voucher No.", value: self.ladgerEvent!.voucherNo, age: "", isEmptyCell: false))
            }
            section2.append((title: "Total Amount", value: "\(self.ladgerEvent!.amount)", age: "", isEmptyCell: false))
            section2.append((title: "", value: "", age: "", isEmptyCell: true))
            self.sectionArray.append(section2)

            
        }
        //booking details
        var section3 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
        section3.append((title: "Check-in", value: self.ladgerEvent!.checkIn?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
        section3.append((title: "Check-out", value: self.ladgerEvent!.checkOut?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
        section3.append((title: "Room", value: self.ladgerEvent!.room, age: "", isEmptyCell: false))
        section3.append((title: "Inclusion", value: self.ladgerEvent!.inclusion, age: "", isEmptyCell: false))
        if !self.ladgerEvent!.confirmationId.isEmpty{
            section3.append((title: "Confirmation ID", value: self.ladgerEvent!.confirmationId, age: "", isEmptyCell: false))
        }

        for (idx, name) in self.ladgerEvent!.names.enumerated() {
            var age = ""
                           if !name.dob.isEmpty {
                               age = AppGlobals.shared.getAgeLastString(dob: name.dob, formatter: Date.DateFormat.yyyy_MM_dd.rawValue)
                           }
            if idx == 0 {
                section3.append((title: "Names", value: name.name, age: age, isEmptyCell: false))
            }
            else {
                section3.append((title: "", value: name.name, age: age, isEmptyCell: false))
            }
        }
        
        //self.ladgerDetails["1"] = bookingDetails
        section3.append((title: "", value: "", age: "", isEmptyCell: true))
        self.sectionArray.append(section3)

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
            }else{
                self.parseDataForDefault()
            }
        }
        else {
            self.parseDataForDefault()
        }
        
        delay(seconds: 0.0) { [weak self] in
            self?.delegate?.fetchLadgerDetailsSuccess()
        }
        self.delegate?.fetchLadgerDetailsSuccess()
    }
}
