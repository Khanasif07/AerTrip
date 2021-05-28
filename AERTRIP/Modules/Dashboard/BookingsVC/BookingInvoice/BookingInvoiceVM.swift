//
//  BookingInvoiceVM.swift
//  AERTRIP
//
//  Created by Admin on 01/07/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol BookingInvoiceVMDelegate: class {
    func willGetBookingDetail()
    func getBookingDetailSucces(model: BookingDetailModel)
    func getBookingDetailFaiure(error: ErrorCodes)
}

class BookingInvoiceVM {
    
    enum BookingInvoiceTypes {
        case details
        case baseFare
        case taxes
        case grossFare
        case discount
        case netFare
        case grandTotal
        case totalPayableNow
        case total
        case cancellation
        case addons
        case rescheduling
        case none
    }
    
    
    var voucher: Voucher? = nil {
        didSet {
            self.fetchData()
            self.setupSectionHeaders()
        }
    }
    
    private(set) var transectionCodes: [Codes] = []
    private(set) var discountCodes: [Codes] = []
    private(set) var cancellationCodes: [Codes] = []
    private(set) var addonsCodes: [Codes] = []
    private(set) var reschedulingCodes: [Codes] = []

    weak var delegate: BookingInvoiceVMDelegate? = nil
    
    var isReciept = false
    var receiptIndex = 0
    var bookingId: String = ""
    var sectionHeader = [(section:BookingInvoiceTypes, rowCount: Int, amount: Double, title: String)]()
    var isBaseFareSectionExpanded: Bool = false
    var isGrossFareSectionExpanded: Bool = false
    var isCancellationSectionExpanded: Bool = false
    var isAddonsSectionExpanded:Bool = false
    var isReschedulingSectionExpanded = false
    var isForReceipt: Bool {
        if let basic = self.voucher?.basic {
            return basic.typeSlug == .receipt
        }
        return false
    }
    
    var conversionRate:CurrencyConversionRate?
    
    func fetchData() {
        guard let vchr = voucher else { return }
        
        if let trans = vchr.transactions.filter({ $0.ledgerName.lowercased().contains("taxes")}).first {
            self.transectionCodes = trans.codes
        }
        
        if let trans = vchr.transactions.filter({ $0.ledgerName.lowercased().contains("discounts")}).first {
            self.discountCodes = trans.codes
        }

        if let trans = vchr.transactions.filter({ $0.ledgerName.lowercased().contains("cancellation")}).first {
            self.cancellationCodes = trans.codes
        }
        
        if let trans = vchr.transactions.filter({ $0.ledgerName.lowercased().contains("add-ons")}).first {
            self.addonsCodes = trans.codes
        }
        
        if let trans = vchr.transactions.filter({ $0.ledgerName.lowercased().contains("rescheduling")}).first {
            self.reschedulingCodes = trans.codes
        }
        
        self.conversionRate = vchr.basic?.currencyRate

    }
    
    func setupSectionHeaders() {
        guard let vchr = voucher else { return }
        if isForReceipt {
            
        } else {
            sectionHeader.removeAll()
            
            var baseFare:Double = 0
            var taxes:Double = 0
            var grossFare:Double = 0
            var discount:Double = 0
            var netFare:Double = 0
            var addons:Double = 0
            var grandTotal:Double = 0
            var totalPayableNow:Double = 0
            var total:Double = 0
            var cancellation : Double = 0
            var rescheduling : Double = 0
            
            vchr.transactions.forEach { (object) in
                switch object.ledgerName.lowercased() {
                case "Base Fare".lowercased(): baseFare = object.amount
                case "Taxes and Fees".lowercased(): taxes = object.amount
                case "Gross Fare".lowercased(): grossFare = object.amount
                case "discounts".lowercased(): discount = object.amount
                case "Net Fare".lowercased(): netFare = object.amount
                case "Grand Total".lowercased(): grandTotal = object.amount
                case "Total Payable Now".lowercased(): totalPayableNow = object.amount
                case "Total".lowercased(): total = object.amount
                case "Cancellation Charges".lowercased():cancellation = object.amount
                case "Add-ons".lowercased(): addons = object.amount
                case "Rescheduling Charges".lowercased(): rescheduling = object.amount
                default: return
                }
            }
            printDebug(baseFare)
            printDebug(taxes)
            printDebug(grossFare)
            printDebug(discount)
            printDebug(netFare)
            printDebug(addons)
            printDebug(grandTotal)
            printDebug(totalPayableNow)
            printDebug(total)
            
            sectionHeader.append((section: .details, rowCount: 2, amount: 0, title: ""))
            let transC = self.transectionCodes.count //self.isBaseFareSectionExpanded ? self.transectionCodes.count : 0
            let disC = self.discountCodes.count //self.isGrossFareSectionExpanded ? self.discountCodes.count : 0
            let CancellationC = self.cancellationCodes.count //self.isCancellationSectionExpanded ? self.cancellationCodes.count : 0
            let addonsC = self.addonsCodes.count //self.isAddonsSectionExpanded ? self.addonsCodes.count : 0
            let reschedulingC = self.reschedulingCodes.count //self.isReschedulingSectionExpanded ? self.reschedulingCodes.count : 0
//            if baseFare > 0 {
            sectionHeader.append((section: .baseFare, rowCount: 0, amount: baseFare, title: "Base Fare"))
//            }
            

            if transC > 0 {
                sectionHeader.append((section: .taxes, rowCount: transC, amount: taxes, title: "Taxes and Fees"))
            }
            
            if grossFare > 0 {
            sectionHeader.append((section: .grossFare, rowCount: 0, amount: grossFare, title: "Gross Fare"))
            }
            
            if addonsC > 0{
                sectionHeader.append((section: .addons, rowCount: addonsC, amount: addons, title: "add-ons"))
            }
            
            
            if disC > 0 {
                sectionHeader.append((section: .discount, rowCount: disC, amount: discount, title: "Discounts"))
            }
            sectionHeader.append((section: .netFare, rowCount: 0, amount: netFare, title: "Net Fare"))
            
            if CancellationC > 0 {
                sectionHeader.append((section: .cancellation, rowCount: CancellationC, amount: cancellation, title: "Cancellation Charges"))
            }
            
            if reschedulingC > 0 {
                sectionHeader.append((section: .rescheduling, rowCount: reschedulingC, amount: rescheduling, title: "Rescheduling Charges"))
            }

            if grossFare != netFare && grossFare != grandTotal {
            
//            if grossFare != netFare, netFare > 0 {
//                sectionHeader.append((section: .netFare, rowCount: 0, amount: netFare, title: "Net Fare"))
//            }
            if netFare != grandTotal, grandTotal > 0 {
                sectionHeader.append((section: .grandTotal, rowCount: 0, amount: grandTotal, title: "Grand Total"))
            }
            }
            if grandTotal != totalPayableNow, totalPayableNow > 0 {
                sectionHeader.append((section: .totalPayableNow, rowCount: 0, amount: totalPayableNow, title: "Total Payable"))
            }
            sectionHeader.append((section: .total, rowCount: 3, amount: total, title: "Total"))
            
            printDebug(sectionHeader)
        }
    }
    
    func getBookingDetail() {
        var params: JSONDictionary = ["booking_id": bookingId]
        if UserInfo.loggedInUserId == nil{
            params["is_guest_user"] = true
        }
        //        if shouldCallWillDelegate {
        //            delegate?.willGetBookingDetail()
        //        }
        delegate?.willGetBookingDetail()
        APICaller.shared.getBookingDetail(params: params) { [weak self] success, errors, bookingDetail in
            guard let sSelf = self else { return }
            if success {
                if let object = bookingDetail {
                    if !sSelf.isReciept {
                        if let receipt =  object.receipt?.otherVoucher  {
                            sSelf.voucher = receipt[sSelf.receiptIndex]
                        }
                    } else {
                        if let receipt =  object.receipt?.receiptVoucher  {
                            sSelf.voucher = receipt[sSelf.receiptIndex]
                        }
                    }
                    
                    sSelf.delegate?.getBookingDetailSucces(model: object)
                }
            } else {
                sSelf.delegate?.getBookingDetailFaiure(error: errors)
                printDebug(errors)
            }
        }
    }
}
