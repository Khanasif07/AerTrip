//
//  BookingModel.swift
//  AERTRIP
//
//  Created by apple on 24/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct BookingModel {
    var bookingId: String = ""
    var bookingNumber: String = ""
    var bookingDate: String = ""
    var product: String = ""
    var bookingDetails: BookingDetail?
    var bookingStatus: String = ""
    var requests: [String] = []
    var description: [String] = []
    var actionRequired: Int = 0
    var user: UserInfo?
    
    init() {
        self.init(json: [:])
    }
    
    
    var jsonDict: JSONDictionary {
        return ["bid": self.bookingId,
                "booking_number": self.bookingNumber,
                "booking_date": self.bookingDate,
                "product": self.product,
                "bdetails": self.bookingDetails,
                "bstatus" : self.bookingStatus,
            "requests" : self.requests,
            "description" : self.description,
            "action_required" : self.actionRequired ]
    }
    
    init(json: JSONDictionary) {
        if let obj = json["id"] {
            self.bookingId = "\(obj)"
        }
        
        if let obj = json["booking_number"] {
            self.bookingId = "\(obj)"
        }
        
        if let obj = json["booking_date"] {
            self.bookingDate = "\(obj)"
        }
        
        if let obj = json["product"] {
            self.bookingDate = "\(obj)"
        }
        
        if let obj = json["bdetails"] as? JSONDictionary {
            self.bookingDetails = BookingDetail(json: obj)
        }
        
        if let obj = json["bsstatus"] {
            self.bookingDate = "\(obj)"
        }
        
        if let obj = json["requests"] as? [String] {
            for str in obj {
                self.requests.append(str)
            }
        }
        
        if let obj = json["description"] as? [String] {
            for str in obj {
                self.description.append(str)
            }
        }
        
        if let obj = json["action_required"] {
            self.actionRequired = "\(obj)".toInt ?? 0
        }
    }
    
    static func getModels(data: [JSONDictionary]) -> [BookingModel] {
        var temp: [BookingModel] = []
        
        for item in data {
            temp.append(BookingModel(json: item))
        }
        
        return temp
    }
}

struct BookingDetail {
    var hotelName: String = ""
    var guestCount: String = ""
    var passengerDetail: [String] = []
    var eventStartDate: String = ""
    var eventEndDate: String = ""
    
    var jsonDict: JSONDictionary {
        return ["hotel_name": self.hotelName,
                "guest_count": self.guestCount,
                "pax": self.passengerDetail,
                "event_start_date": self.eventStartDate,
                "event_end_date": self.eventEndDate]
    }
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["hotel_name"] {
            self.hotelName = "\(obj)"
        }
        
        if let obj = json["guest_count"] {
            self.guestCount = "\(obj)"
        }
        
        if let obj = json["pax"] as? [String] {
            for str in obj {
                self.passengerDetail.append(str)
            }
        }
        
        if let obj = json["event_start_date"] {
            self.eventStartDate = "\(obj)"
        }
        
        if let obj = json["event_end_date"] {
            self.eventEndDate = "\(obj)"
        }
    }
}
