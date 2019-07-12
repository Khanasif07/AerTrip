//
//  BookingInvoiceVM.swift
//  AERTRIP
//
//  Created by Admin on 01/07/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

class BookingInvoiceVM {
    
    var voucher: Voucher? = nil {
        didSet {
            self.fetchData()
        }
    }
    
    private(set) var transectionCodes: [Codes] = []
    private(set) var discountCodes: [Codes] = []
    
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
}
