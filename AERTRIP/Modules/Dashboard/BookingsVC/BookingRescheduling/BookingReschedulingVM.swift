//
//  BookingReschedulingVM.swift
//  AERTRIP
//
//  Created by apple on 23/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

enum BookingReschedulingVCUsingFor {
    case rescheduling
    case cancellation
    case none
}

class BookingReschedulingVM {
    // MARK: - Variables
    var legsData: [Leg] = []
    
    var totRefundForRescheduling: Double {
        return legsData.reduce(0) { $0 + ($1.selectedPaxs.reduce(0, { $0 + $1.netRefundForReschedule })) }
    }
    
    var totalRefundForCancellation: Double {
         return legsData.reduce(0) { $0 + ($1.selectedPaxs.reduce(0, { $0 + $1.netRefundForCancellation })) }
    }
    
    var usingFor: BookingReschedulingVCUsingFor = .rescheduling
}
