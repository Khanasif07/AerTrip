//
//  BookingInvoiceVM.swift
//  AERTRIP
//
//  Created by Admin on 01/07/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

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
    
    var sectionHeader = [(section:BookingInvoiceTypes, rowCount: Int, amount: Double, title: String)]()
    var isBaseFareSectionExpanded: Bool = true
    var isGrossFareSectionExpanded: Bool = true
    var isForReceipt: Bool {
        if let basic = self.voucher?.basic {
            return basic.typeSlug == .receipt
        }
        return false
    }
    
    func fetchData() {
        guard let vchr = voucher else { return }
        
        if let trans = vchr.transactions.filter({ $0.ledgerName.lowercased().contains("taxes")}).first {
            self.transectionCodes = trans.codes
        }
        
        if let trans = vchr.transactions.filter({ $0.ledgerName.lowercased().contains("discounts")}).first {
            self.discountCodes = trans.codes
        }
    }
    
    func setupSectionHeaders() {
        guard let vchr = voucher else { return }
        if isForReceipt {
            
        } else {
            
            
            var baseFare:Double = 0
            var taxes:Double = 0
            var grossFare:Double = 0
            var discount:Double = 0
            var netFare:Double = 0
            var grandTotal:Double = 0
            var totalPayableNow:Double = 0
            var total:Double = 0
            
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
                    
                default: return
                }
            }
            printDebug(baseFare)
            printDebug(taxes)
            printDebug(grossFare)
            printDebug(discount)
            printDebug(netFare)
            printDebug(grandTotal)
            printDebug(totalPayableNow)
            printDebug(total)
            
            sectionHeader.append((section: .details, rowCount: 2, amount: 0, title: ""))
            let transC = self.isBaseFareSectionExpanded ? self.transectionCodes.count : 0
            let disC = self.isGrossFareSectionExpanded ? self.discountCodes.count : 0
            
            sectionHeader.append((section: .baseFare, rowCount: 0, amount: baseFare, title: "Base Fare"))
            if transC > 0 {
                sectionHeader.append((section: .taxes, rowCount: transC, amount: taxes, title: "Taxes and Fees"))
            }
            
            sectionHeader.append((section: .grossFare, rowCount: 0, amount: grossFare, title: "Gross Fare"))
            if disC > 0 {
                sectionHeader.append((section: .discount, rowCount: disC, amount: discount, title: "Discounts"))
            }
            
            if grossFare != netFare {
                sectionHeader.append((section: .netFare, rowCount: 0, amount: netFare, title: "Net Fare"))
            }
            sectionHeader.append((section: .grandTotal, rowCount: 0, amount: grandTotal, title: "Grand Total"))
            
            if grandTotal != totalPayableNow {
                sectionHeader.append((section: .totalPayableNow, rowCount: 0, amount: totalPayableNow, title: "Total Payable"))
            }
            sectionHeader.append((section: .total, rowCount: 3, amount: total, title: "Total"))
            
            printDebug(sectionHeader)
        }
    }
}
