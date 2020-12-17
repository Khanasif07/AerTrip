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
    
    func willFetchAccountDetail()
    func fetchAccountDetailSuccess(model: AccountDetailPostModel)
    func fetchAccountDetailFail()
}

class AccountLadgerDetailsVM {
    
    enum AccountLadgerDetailType {
        case accountLadger
        case outstandingLadger
        
    }
    
    //MARK:- Properties
    //MARK:- Public
    var detailType: AccountLadgerDetailType = .accountLadger
    weak var delegate:AccountLadgerDetailsVMDelegate?
    var ladgerEvent: AccountDetailEvent?
    //  var ladgerDetails: JSONDictionary = [:]
    var isDownloadingRecipt = false
    var sectionArray = [[(title: String, value: String, age: String, isEmptyCell: Bool)]]()
    //OnAccountDetais Model
    var onAccountEvent:OnAccountLedgerEvent?
    var isForOnAccount:Bool = false
    var cellTitleLabelWidth:CGFloat = 0.0
    
    
    //MARK:- Methods
    //MARK:- Private
    private func parseDataForDefault() {
        guard self.ladgerEvent != nil else {return}
        if self.ladgerEvent!.dueDate != nil{
            let days = self.ladgerEvent!.overDueDays
            let daysStr = (days > 1) ? "days" : "day"
            //fAmountDetails["Over Due by days"] = "\(abs(days)) \(daysStr)"
            var section1 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
//            section1.append((title: "Pending Amount", value: "\(self.ladgerEvent!.pendingAmount.amountInDelimeterWithSymbol)", age: "", isEmptyCell: false))
            let suffix = self.ladgerEvent!.pendingAmount < 0 ? LocalizedString.CreditShort.localized : LocalizedString.DebitShort.localized
            section1.append((title: "Pending Amount", value: "\(abs(self.ladgerEvent!.pendingAmount).amountInDelimeterWithSymbol) \(suffix)", age: "", isEmptyCell: false))
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
        let suffix = self.ladgerEvent!.amount > 0 ? LocalizedString.CreditShort.localized : LocalizedString.DebitShort.localized
        section1.append((title: "Amount", value: "\(abs(self.ladgerEvent!.amount).amountInDelimeterWithSymbol) \(suffix)", age: "", isEmptyCell: false))
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
        self.calculateMaxWidth()
    }
    
    private func parseDataForFlightSales() {
        //flight amount details
        guard self.ladgerEvent != nil else {return}
        if self.ladgerEvent!.dueDate != nil{
            let days = self.ladgerEvent!.overDueDays
            let daysStr = (days > 1) ? "days" : "day"
            //fAmountDetails["Over Due by days"] = "\(abs(days)) \(daysStr)"
            var section1 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
            let suffix = self.ladgerEvent!.pendingAmount < 0 ? LocalizedString.CreditShort.localized : LocalizedString.DebitShort.localized
            section1.append((title: "Pending Amount", value: "\(abs(self.ladgerEvent!.pendingAmount).amountInDelimeterWithSymbol) \(suffix)", age: "", isEmptyCell: false))
//            section1.append((title: "Pending Amount", value: "\(self.ladgerEvent!.pendingAmount.amountInDelimeterWithSymbol)", age: "", isEmptyCell: false))
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
            let suff = self.ladgerEvent!.amount > 0 ? LocalizedString.CreditShort.localized : LocalizedString.DebitShort.localized
            section2.append((title: "Total Amount", value: "\(abs(self.ladgerEvent!.amount).amountInDelimeterWithSymbol) \(suff)", age: "", isEmptyCell: false))
//            section2.append((title: "Total Amount", value: "\(self.ladgerEvent!.amount.amountInDelimeterWithSymbol)", age: "", isEmptyCell: false))
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
            let suffix = self.ladgerEvent!.amount > 0 ? LocalizedString.CreditShort.localized : LocalizedString.DebitShort.localized
            section1.append((title: "Amount", value: "\(abs(self.ladgerEvent!.amount).amountInDelimeterWithSymbol) \(suffix)", age: "", isEmptyCell: false))
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
        self.calculateMaxWidth()
        
    }
    
    private func parseDataForHotelSales() {
        //self.ladgerDetails.removeAll()
        guard self.ladgerEvent != nil else {return}
        //amount details
        if self.ladgerEvent!.dueDate == nil{
            var section1 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
            section1.append((title: "Date", value: self.ladgerEvent!.date?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
            section1.append((title: "Voucher", value: self.ladgerEvent!.voucherName, age: "", isEmptyCell: false))
            if  !self.ladgerEvent!.voucherNo.isEmpty{
                section1.append((title: "Voucher No.", value: self.ladgerEvent!.voucherNo, age: "", isEmptyCell: false))
            }
            let suffix = self.ladgerEvent!.amount > 0 ? LocalizedString.CreditShort.localized : LocalizedString.DebitShort.localized
            section1.append((title: "Amount", value: "\(abs(self.ladgerEvent!.amount).amountInDelimeterWithSymbol) \(suffix)", age: "",
                             isEmptyCell: false))
            //            section1.append((title: "Balance", value: "\(self.ladgerEvent!.balance)", age: "", isEmptyCell: false))
            section1.append((title: "", value: "", age: "", isEmptyCell: true))
            self.sectionArray.append(section1)
            
            
        }else{
            let days = self.ladgerEvent!.overDueDays
            let daysStr = (days > 1) ? "days" : "day"
            //fAmountDetails["Over Due by days"] = "\(abs(days)) \(daysStr)"
            var section1 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
//            section1.append((title: "Pending Amount", value: "\(self.ladgerEvent!.pendingAmount.amountInDelimeterWithSymbol)", age: "", isEmptyCell: false))
            let suffix = self.ladgerEvent!.pendingAmount < 0 ? LocalizedString.CreditShort.localized : LocalizedString.DebitShort.localized
            section1.append((title: "Pending Amount", value: "\(abs(self.ladgerEvent!.pendingAmount).amountInDelimeterWithSymbol) \(suffix)", age: "", isEmptyCell: false))
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
            
            let suff = self.ladgerEvent!.amount > 0 ? LocalizedString.CreditShort.localized : LocalizedString.DebitShort.localized
            section2.append((title: "Total Amount", value: "\(abs(self.ladgerEvent!.amount).amountInDelimeterWithSymbol) \(suff)", age: "", isEmptyCell: false))
            
//            section2.append((title: "Total Amount", value: "\(self.ladgerEvent!.amount.amountInDelimeterWithSymbol)", age: "", isEmptyCell: false))
            section2.append((title: "", value: "", age: "", isEmptyCell: true))
            self.sectionArray.append(section2)
            
            
        }
        //booking details
        var section3 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
        section3.append((title: "Check-in", value: self.ladgerEvent!.checkIn?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
        section3.append((title: "Check-out", value: self.ladgerEvent!.checkOut?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "", isEmptyCell: false))
//        section3.append((title: "Room", value: self.ladgerEvent!.room, age: "", isEmptyCell: false))
        for (index, value) in self.ladgerEvent!.roomNamesArray.enumerated(){
            if index == 0 {
                section3.append((title: "Room", value: value, age: "", isEmptyCell: false))
            }
            else {
                section3.append((title: " ", value: value, age: "", isEmptyCell: false))
            }
        }
        
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
        self.calculateMaxWidth()
        
    }
    
    //MARK:- Public
    func fetchLadgerDetails() {
        self.delegate?.willFetchLadgerDetails()
        if !self.isForOnAccount{
            guard let event = self.ladgerEvent else {
                self.delegate?.fetchLadgerDetailsFail()
                return
            }
            self.sectionArray.removeAll()
            
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
        }else{
            guard let event = self.onAccountEvent else {
                self.delegate?.fetchLadgerDetailsFail()
                return
            }
            self.sectionArray.removeAll()
            self.setDataFromOnAccountDetails()
        }
        delay(seconds: 0.0) { [weak self] in
            self?.delegate?.fetchLadgerDetailsSuccess()
        }
        self.delegate?.fetchLadgerDetailsSuccess()
    }
    
    func fetchAccountDetails() {
        
        self.delegate?.willFetchAccountDetail()
        
        
        //hit api to update the saved data and show it on screen
        APICaller.shared.getAccountDetailsAPI(params: [:]) { [weak self](success, accLad, accVchrs, outLad, periodic, errors) in
            guard let self = self else {return}
            if success {
                let model = AccountDetailPostModel()
                model.accountLadger = accLad
                model.periodicEvents = periodic
                if let obj = outLad {
                    model.outstandingLadger = obj
                }
                model.accVouchers = accVchrs
                if !self.isForOnAccount{
                    if self.detailType == .accountLadger {
                        self.updateFethedData(onData: model.accountLadger)
                    } else {
                        self.updateFethedData(onData: model.outstandingLadger.ladger)
                    }
                }else{
                    self.updateDataForOnAccount(onData: model.outstandingLadger.onAccountLadger)
                }
                self.fetchLadgerDetails()
                self.delegate?.fetchAccountDetailSuccess(model: model)
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .profile)
                self.delegate?.fetchAccountDetailFail()
            }
        }
    }
    
    func setDataFromOnAccountDetails(){
        guard let event =  self.onAccountEvent else {return}
        var section1 = [(title: String, value: String, age: String, isEmptyCell: Bool)]()
        section1.append((title: "Date", value: event.onAccountDate?.toString(dateFormat: "dd-MM-YYYY") ?? "", age: "",  isEmptyCell: false))
        section1.append((title: "Voucher", value: event.voucherName, age: "",  isEmptyCell: false))
        if  !event.voucherNo.isEmpty{
            section1.append((title: "Voucher No.", value: event.voucherNo, age: "",  isEmptyCell: false))
        }
        let suffix = event.amount > 0 ? LocalizedString.CreditShort.localized : LocalizedString.DebitShort.localized
        section1.append((title: "Amount", value: "\(abs(event.amount).amountInDelimeterWithSymbol) \(suffix)", age: "", isEmptyCell: false))
        section1.append((title: "", value: "", age: "", isEmptyCell: true))
        self.sectionArray.append(section1)
        self.calculateMaxWidth()
        
    }
    
    func updateDataForOnAccount(onData: JSONDictionary){
       
        
    }
    
    func calculateMaxWidth(){
        let keys = self.sectionArray.flatMap({$0.map({$0.title})})
        let label = UILabel()
        label.numberOfLines = 1
        label.font = AppFonts.Regular.withSize(16)
        for key in keys{
            label.sizeToFit()
            label.text = key
            label.sizeToFit()
            if cellTitleLabelWidth < label.size.width{
                cellTitleLabelWidth = label.size.width
            }
        }
    }
    
    func updateFethedData(onData: JSONDictionary) {
        
        for date in Array(onData.keys) {
            if let events = onData[date] as? [AccountDetailEvent] {
                //                    let fltrd = events.filter({ $0.title.lowercased().contains(forText.lowercased())})
                if let firstEvent = events.first(where: { (event) -> Bool in
                    return event.transactionId == (self.ladgerEvent?.transactionId ?? "")
                }) {
                    self.ladgerEvent = firstEvent
                    break
                }
            }
        }
    }
}
