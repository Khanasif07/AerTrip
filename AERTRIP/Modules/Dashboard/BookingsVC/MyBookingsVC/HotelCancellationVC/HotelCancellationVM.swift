//
//  HotelCancellationVM.swift
//  AERTRIP
//
//  Created by Admin on 05/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

class HotelCancellationVM {
    
    var bookingDetail: BookingDetailModel?
    
    var hotelName: String {
        return self.bookingDetail?.bookingDetail?.hotelName ?? LocalizedString.na.localized
    }
    var bookingDateAndRefundableStatus: String {
        // = "12 Oct 2018 | Non-refundable"
        var infoData = ""
        if let dateStr = self.bookingDetail?.bookingDetail?.eventStartDate?.toString(dateFormat: "dd MMM yyyy"), !dateStr.isEmpty {
            infoData += dateStr
        }
        
        let refundOrResch = (self.bookingDetail?.bookingDetail?.isRefundable ?? false) ? LocalizedString.Refundable.localized : LocalizedString.NonRefundable.localized

        infoData += infoData.isEmpty ? refundOrResch : " | \(refundOrResch)"
        
        return infoData
    }
    
    var selectedRooms: [RoomDetailModel] = [] //used when the select the guest for cancellation
}
