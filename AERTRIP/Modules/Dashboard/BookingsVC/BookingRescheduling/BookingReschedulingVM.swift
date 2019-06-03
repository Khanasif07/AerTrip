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

    var usingFor: BookingReschedulingVCUsingFor = .rescheduling

    var sectionData: [(title: String, info: String)] = [(title: "Mumbai → Delhi", info: "12 Oct 2018 | Non-refundable"), (title: "Delhi → Mumbai", info: "12 Oct 2018 | Non-refundable")]

    var passengers: [BookingPassenger] = []
    var airlinesDetail: [String] = ["", ""]
    var selectedPassenger: [String] = []
}

struct BookingPassenger {
    var id: String = "0"
    var name: String = ""
    var isExpanded: Bool = false
    var passengerDetails: [String] = []
    var isChecked: Bool = false
    var jsonDict: [String: Any] {
        return ["id": self.id,
                "name": self.name,
                "isExpanded": self.isExpanded,
                "passengerDetails": self.passengerDetails,
                "isChecked": self.isChecked]
    }

    init() {
        let json = JSON()
        self.init(json: json)
    }

    init(json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["type"].stringValue.removeNull
        self.isExpanded = json["isExpanded"].boolValue
        self.passengerDetails = json["passengerDetails"].arrayObject as? [String] ?? []
        self.isChecked = json["isChecked"].boolValue
    }
}
