//
//  ADEventFilterViewModel.swift
//  AERTRIP
//
//  Created by Admin on 22/07/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class ADEventFilterVM {
    
    // shared instance
    static let shared = ADEventFilterVM()
    
    var fromDate: Date? = nil
    var toDate: Date? = nil
    var selectedVoucherType: [String] = []
    var currentIndex: Int = 0
    
    var voucherTypes: [String] = []
    var minFromDate: Date?

    var paymentMethodArray:JSONDictionary = [:]
    
    var isFilterAplied: Bool {
        if self.fromDate == nil && self.toDate == nil && self.selectedVoucherType.isEmpty {
            return false
        }
        return true
    }
    
    private init() {
    }
    
    func setToDefault() {
        fromDate = nil
        toDate = nil
        selectedVoucherType = []
    }
    
    
    
}
