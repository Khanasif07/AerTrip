//
//  HotelCancellationVM.swift
//  AERTRIP
//
//  Created by Admin on 05/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

class HotelCancellationVM {
    
    var hotelName: String = "Grand Hyatt Mumbai"
    var bookingDateAndRefundableStatus: String = "12 Oct 2018 | Non-refundable"
    var bookedHotelData: [BookedHotelRoomData] = []
    var isAllRoomSelected: Bool = false
    
    func getHotelData() {
        for i in 0...1 {
            var roomData = BookedHotelRoomData()
            roomData.id = "\(i)"
            roomData.roomNumber = (i + 1)
            roomData.roomName = "Premier King Bed Ocean View"
            roomData.isChecked = false
            roomData.isExpanded = false
            roomData.roomGuest = ["Mrs. Julian Delgado", "Mr. Clifford Hudson", "Mr. Clifford Hudson"]
            self.bookedHotelData.append(roomData)
        }
    }
    
}


//struct BookedHotelData {
//    var id: String = "0"
//    var hotelName: String = ""
//    var roomNumber: Int = 0
//    var roomData: [BookedHotelRoomData] = []
//    var jsonDict: [String: Any] {
//        return ["id": self.id,
//                "name": self.roomName,
//                "isExpanded": self.isExpanded,
//                "passengerDetails": self.passengerDetails,
//                "isChecked": self.isChecked]
//    }
//
//    init() {
//        let json = JSON()
//        self.init(json: json)
//    }
//
//    init(json: JSON) {
//        self.id = json["id"].stringValue
//        self.passengerDetails = json["passengerDetails"].arrayObject as? [String] ?? []
//    }
//}

struct BookedHotelRoomData {
    
    var id: String = "0"
    var roomName: String = ""
    var roomNumber: Int = 0
    var roomGuest: [String] = []
    var isChecked: Bool = false
    var isExpanded: Bool = false
    var chargesDetails: [String] = []
    var jsonDict: [String: Any] {
        return ["id": self.id,
                "roomName": self.roomName,
                "roomNumber": self.roomNumber,
                "isChecked": self.isChecked,
                "isExpanded": self.isExpanded,
                "roomGuest": self.roomGuest,
                "chargesDetails": self.chargesDetails]
    }
    
    init() {
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        self.id = json["id"].stringValue.removeNull
        self.roomName = json["roomName"].stringValue.removeNull
        self.roomNumber = json["roomNumber"].intValue
        self.isChecked = json["isChecked"].boolValue
        self.isExpanded = json["isExpanded"].boolValue
        self.chargesDetails = json["chargesDetails"].arrayObject as? [String] ?? []
        self.roomGuest = json["roomGuest"].arrayObject as? [String] ?? []
    }
}

