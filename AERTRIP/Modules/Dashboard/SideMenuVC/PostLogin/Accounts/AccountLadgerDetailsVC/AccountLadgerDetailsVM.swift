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
    
//    let amountDetailKeys = ["Date", "Voucher", "Voucher No.", "Amount", "Balance"]
//    private(set) var bookingDetailKeys = ["Check-in", "Check-out", "Room", "Inclusion", "Confirmation ID"]
//    let flightAmountDetailKeys = ["Date", "Bill Number", "Total Amount", "Pending Amount", "Due Date", "Over Due by days"]
//    let voucherDetailKeys = ["Voucher Date", "Voucher", "Voucher Number", "Amount"]
//    private(set) var flightDetailKeys = ["Travel Date", "Airline", "Sector", "PNR", "Ticket No."]
    
    var sectionArray = [[(title: String, value: String, age: String, isEmptyCell: Bool)]]()
    //MARK:- Private

    
    //MARK:- Methods
    //MARK:- Private
    private func parseDataForDefault() {
//        self.ladgerDetails.removeAll()
        
        //amount details
//        var amountDetails = JSONDictionary()
//        amountDetails["Date"] = self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY")
//        amountDetails["Voucher"] = self.ladgerEvent!.voucherName
//        amountDetails["Voucher No."] = self.ladgerEvent!.voucherNo
//        amountDetails["Amount"] = "\(self.ladgerEvent!.amount)"
//        amountDetails["Balance"] = "\(self.ladgerEvent!.balance)"
        
        var section1 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
        section1.append((title: "Date", value: self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "",  isEmptyCell: false))
        section1.append((title: "Voucher", value: self.ladgerEvent!.voucherName, age: "",  isEmptyCell: false))
        section1.append((title: "Voucher No.", value: self.ladgerEvent!.voucherNo, age: "",  isEmptyCell: false))
        section1.append((title: "Amount", value: "\(abs(self.ladgerEvent!.amount))", age: "", isEmptyCell: false))
        section1.append((title: "Balance", value: "\(self.ladgerEvent!.balance)", age: "", isEmptyCell: false))
        self.sectionArray.append(section1)

       // self.ladgerDetails["0"] = amountDetails
    }
    
    private func parseDataForFlightSales() {
        //flight amount details
        if self.ladgerEvent!.dueDate != nil{
            
//            fAmountDetails["Pending Amount"] = "\(self.ladgerEvent!.pendingAmount)"
//            fAmountDetails["Due Date"] = self.ladgerEvent!.dueDate?.toString(dateFormat: "dd-MM-YYYY")
            
            let days = self.ladgerEvent!.overDueDays
            let daysStr = (days > 1) ? "days" : "day"
            //fAmountDetails["Over Due by days"] = "\(abs(days)) \(daysStr)"
            var section1 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
            section1.append((title: "Pending Amount", value: "\(self.ladgerEvent!.pendingAmount)", age: "", isEmptyCell: false))
            section1.append((title: "Due Date", value: self.ladgerEvent!.dueDate?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
            section1.append((title: "Over Due by days", value: "\(abs(days)) \(daysStr)", age: "", isEmptyCell: false))
            section1.append((title: "", value: "", age: "", isEmptyCell: true))
            self.sectionArray.append(section1)
            
            
//            var fAmountDetails = JSONDictionary()
            var section2 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()

//            fAmountDetails["Date"] = self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY")
//            fAmountDetails["Bill Number"] = self.ladgerEvent!.billNumber
//            fAmountDetails["Total Amount"] = "\(self.ladgerEvent!.totalAmount)"
//            fAmountDetails["Pending Amount"] = "\(self.ladgerEvent!.pendingAmount)"
//            fAmountDetails["Due Date"] = self.ladgerEvent!.dueDate?.toString(dateFormat: "dd-MM-YYYY")
//
//            let days = self.ladgerEvent!.overDueDays
//            let daysStr = (days > 1) ? "days" : "day"
//            fAmountDetails["Over Due by days"] = "\(abs(days)) \(daysStr)"
            
            section2.append((title: "Date", value: self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
            section2.append((title: "Bill Number", value: self.ladgerEvent!.billNumber, age: "", isEmptyCell: false))
            section2.append((title: "Total Amount", value: "\(self.ladgerEvent!.totalAmount)", age: "", isEmptyCell: false))
            section2.append((title: "", value: "", age: "", isEmptyCell: true))
            self.sectionArray.append(section2)


//            self.ladgerDetails["0"] = fAmountDetails
            
            //voucher details
//            var voucherDetails = JSONDictionary()
//            voucherDetails["Voucher Date"] = self.ladgerEvent!.voucherDate?.toString(dateFormat: "dd-MM-YYYY")
//            voucherDetails["Voucher"] = self.ladgerEvent!.voucherName
//            voucherDetails["Voucher Number"] = self.ladgerEvent!.voucherNo
//            voucherDetails["Amount"] = "\(self.ladgerEvent!.amount)"
//
//            self.ladgerDetails["1"] = voucherDetails
            var section3 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
            section3.append((title: "Voucher Date", value: self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
            section3.append((title: "Voucher", value: self.ladgerEvent!.voucherName, age: "", isEmptyCell: false))
            section3.append((title: "Voucher Number", value: self.ladgerEvent!.voucherNo, age: "", isEmptyCell: false))
            section3.append((title: "Amount", value: "\(abs(self.ladgerEvent!.amount))", age: "", isEmptyCell: false))
            section3.append((title: "", value: "", age: "", isEmptyCell: true))
            self.sectionArray.append(section3)
            
            
            //flight details
           // var flightDetails = JSONDictionary()
            var section4 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
//            flightDetails["Travel Date"] = self.ladgerEvent!.travelDate?.toString(dateFormat: "dd-MM-YYYY")
//            flightDetails["Airline"] = self.ladgerEvent!.airline
//            flightDetails["Sector"] = self.ladgerEvent!.sector
//            flightDetails["PNR"] = self.ladgerEvent!.pnr
//            flightDetails["Ticket No."] = self.ladgerEvent!.ticketNo
//            for (idx, name) in self.ladgerEvent!.names.enumerated() {
//                if idx == 0 {
//                    flightDetails["Names"] = name
//                    self.flightDetailKeys.append("Names")
//                }
//                else {
//                    flightDetails["Names\(idx)"] = name
//                    self.flightDetailKeys.append("Names\(idx)")
//                }
//            }
            section4.append((title: "Travel Date", value: self.ladgerEvent!.travelDate?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
            section4.append((title: "Airline", value: self.ladgerEvent!.airline, age: "", isEmptyCell: false))
            section4.append((title: "Sector", age: "", value: self.ladgerEvent!.sector, isEmptyCell: false))
            section4.append((title: "PNR", value: self.ladgerEvent!.pnr, age: "", isEmptyCell: false))
            section4.append((title: "Ticket No.", value: self.ladgerEvent!.ticketNo, age: "", isEmptyCell: false))



            for (idx, name) in self.ladgerEvent!.names.enumerated() {
                var age = ""
                if !name.dob.isEmpty {
                    age = AppGlobals.shared.getAgeLastString(dob: name.dob, formatter: Date.DateFormat.yyyy_MM_dd.rawValue)
                }
                if idx == 0 {
                    //flightDetails["Names"] = name
                    //self.flightDetailKeys.append("Names")
                    section4.append((title: "Names", value: name.name, age: age, isEmptyCell: false))

                }
                else {
                    //flightDetails["Names\(idx)"] = name
                    //self.flightDetailKeys.append("Names\(idx)")
                    section4.append((title: "", value: name.name, age: age, isEmptyCell: false))

                }
            }
            
            //self.ladgerDetails["1"] = flightDetails
            //section4.append((title: "", value: "", age: "", isEmptyCell: true))
            self.sectionArray.append(section4)
            
           // self.ladgerDetails["2"] = flightDetails
            
        }else{
//            var amountDetails = JSONDictionary()
//            amountDetails["Date"] = self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY")
//            amountDetails["Voucher"] = self.ladgerEvent!.voucherName
//            amountDetails["Voucher No."] = self.ladgerEvent!.voucherNo
//            amountDetails["Amount"] = "\(self.ladgerEvent!.amount)"
//            amountDetails["Balance"] = "\(self.ladgerEvent!.balance)"
//            self.ladgerDetails["0"] = amountDetails
            
            var section1 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
            section1.append((title: "Date", value: self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
            section1.append((title: "Voucher", value: self.ladgerEvent!.voucherName, age: "", isEmptyCell: false))
            section1.append((title: "Voucher No.", value: self.ladgerEvent!.voucherNo, age: "", isEmptyCell: false))
            section1.append((title: "Amount", value: "\(abs(self.ladgerEvent!.amount))", age: "", isEmptyCell: false))
            section1.append((title: "Balance", value: "\(self.ladgerEvent!.balance)", age: "", isEmptyCell: false))
            section1.append((title: "", value: "", age: "", isEmptyCell: true))
            self.sectionArray.append(section1)
            
            //flight details
            var section2 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
//            var flightDetails = JSONDictionary()
//            flightDetails["Travel Date"] = self.ladgerEvent!.travelDate?.toString(dateFormat: "dd-MM-YYYY")
//            flightDetails["Airline"] = self.ladgerEvent!.airline
//            flightDetails["Sector"] = self.ladgerEvent!.sector
//            flightDetails["PNR"] = self.ladgerEvent!.pnr
//            flightDetails["Ticket No."] = self.ladgerEvent!.ticketNo
            
            section2.append((title: "Travel Date", value: self.ladgerEvent!.travelDate?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
            section2.append((title: "Airline", value: self.ladgerEvent!.airline, age: "", isEmptyCell: false))
            section2.append((title: "Sector", age: "", value: self.ladgerEvent!.sector, isEmptyCell: false))
            section2.append((title: "PNR", value: self.ladgerEvent!.pnr, age: "", isEmptyCell: false))
            section2.append((title: "Ticket No.", value: self.ladgerEvent!.ticketNo, age: "", isEmptyCell: false))



            for (idx, name) in self.ladgerEvent!.names.enumerated() {
                var age = ""
                if !name.dob.isEmpty {
                    age = AppGlobals.shared.getAgeLastString(dob: name.dob, formatter: Date.DateFormat.yyyy_MM_dd.rawValue)
                }
                if idx == 0 {
                    //flightDetails["Names"] = name
                    //self.flightDetailKeys.append("Names")
                    section2.append((title: "Names", value: name.name, age: age, isEmptyCell: false))

                }
                else {
                    //flightDetails["Names\(idx)"] = name
                    //self.flightDetailKeys.append("Names\(idx)")
                    section2.append((title: "", value: name.name, age: age, isEmptyCell: false))

                }
            }
            
            //self.ladgerDetails["1"] = flightDetails
            //section2.append((title: "", value: "", age: "", isEmptyCell: true))
            self.sectionArray.append(section2)

        }
        
        
    }
    
    private func parseDataForHotelSales() {
        //self.ladgerDetails.removeAll()

        //amount details
        if self.ladgerEvent!.dueDate == nil{
//            var amountDetails = JSONDictionary()
//            amountDetails["Date"] = self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY")
//            amountDetails["Voucher"] = self.ladgerEvent!.voucherName
//            amountDetails["Voucher No."] = self.ladgerEvent!.voucherNo
//            amountDetails["Amount"] = "\(self.ladgerEvent!.amount)"
//            amountDetails["Balance"] = "\(self.ladgerEvent!.balance)"
//            self.ladgerDetails["0"] = amountDetails
            var section1 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
            section1.append((title: "Date", value: self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
            section1.append((title: "Voucher", value: self.ladgerEvent!.voucherName, age: "", isEmptyCell: false))
            section1.append((title: "Voucher No.", value: self.ladgerEvent!.voucherNo, age: "", isEmptyCell: false))
            section1.append((title: "Amount", value: "\(abs(self.ladgerEvent!.amount))", age: "", isEmptyCell: false))
            section1.append((title: "Balance", value: "\(self.ladgerEvent!.balance)", age: "", isEmptyCell: false))
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
            
//            var hAmountDetails = JSONDictionary()
//            hAmountDetails["Date"] = self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY")
//            hAmountDetails["Bill Number"] = self.ladgerEvent!.billNumber
//            hAmountDetails["Total Amount"] = "\(self.ladgerEvent!.totalAmount)"
//            hAmountDetails["Pending Amount"] = "\(self.ladgerEvent!.pendingAmount)"
//            hAmountDetails["Due Date"] = self.ladgerEvent!.dueDate?.toString(dateFormat: "dd-MM-YYYY")
//            let days = self.ladgerEvent!.overDueDays
//            let daysStr = (days > 1) ? "days" : "day"
//            hAmountDetails["Over Due by days"] = "\(abs(days)) \(daysStr)"
//            self.ladgerDetails["0"] = hAmountDetails
            
            var section2 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
            section2.append((title: "Date", value: self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
            section2.append((title: "Bill Number", value: self.ladgerEvent!.billNumber, age: "", isEmptyCell: false))
            section2.append((title: "Total Amount", value: "\(self.ladgerEvent!.totalAmount)", age: "", isEmptyCell: false))
            section2.append((title: "", value: "", age: "", isEmptyCell: true))
            self.sectionArray.append(section2)

            
        }
        //booking details
        var section3 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
//        var bookingDetails = JSONDictionary()
//        bookingDetails["Check-in"] = self.ladgerEvent!.checkIn?.toString(dateFormat: "dd-MM-YYYY") ?? ""
//        bookingDetails["Check-out"] = self.ladgerEvent!.checkOut?.toString(dateFormat: "dd-MM-YYYY") ?? ""
//        bookingDetails["Room"] = self.ladgerEvent!.room
//        bookingDetails["Inclusion"] = self.ladgerEvent!.inclusion
//        bookingDetails["Confirmation ID"] = self.ladgerEvent!.confirmationId
        
        section3.append((title: "Check-in", value: self.ladgerEvent!.checkIn?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
        section3.append((title: "Check-out", value: self.ladgerEvent!.checkOut?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
        section3.append((title: "Room", value: self.ladgerEvent!.room, age: "", isEmptyCell: false))
        section3.append((title: "Inclusion", value: self.ladgerEvent!.inclusion, age: "", isEmptyCell: false))
        section3.append((title: "Confirmation ID", value: self.ladgerEvent!.confirmationId, age: "", isEmptyCell: false))


        for (idx, name) in self.ladgerEvent!.names.enumerated() {
            var age = ""
                           if !name.dob.isEmpty {
                               age = AppGlobals.shared.getAgeLastString(dob: name.dob, formatter: Date.DateFormat.yyyy_MM_dd.rawValue)
                           }
            if idx == 0 {
                //bookingDetails["Names"] = name
               // self.bookingDetailKeys.append("Names")
                section3.append((title: "Names", value: name.name, age: age, isEmptyCell: false))
            }
            else {
               // bookingDetails["Names\(idx)"] = name
               // self.bookingDetailKeys.append("Names\(idx)")
                section3.append((title: "", value: name.name, age: age, isEmptyCell: false))
            }
        }
        
        //self.ladgerDetails["1"] = bookingDetails
        //section3.append((title: "", value: "", age: "", isEmptyCell: true))
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
