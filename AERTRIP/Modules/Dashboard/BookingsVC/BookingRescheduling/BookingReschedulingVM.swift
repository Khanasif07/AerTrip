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
    var legsData: [BookingLeg] = []
    var bookingDetails:BookingDetailModel?
    var expendCellData = [Set<Int>]()
    
    var totRefundForRescheduling: Double {
        return legsData.reduce(0) { $0 + ($1.selectedPaxs.reduce(0, { $0 + $1.netRefundForReschedule })) }
    }
    
    var totalRefundForCancellation: Double {
         return legsData.reduce(0) { $0 + ($1.selectedPaxs.reduce(0, { $0 + $1.netRefundForCancellation })) }
    }
    
   
    var selectedLegs: [BookingLeg] {
        return legsData.filter( { $0.selectedPaxs.count > 0 })
    }
    
    var usingFor: BookingReschedulingVCUsingFor = .rescheduling
}

