//
//  RoomDetailModel.swift
//  AERTRIP
//
//  Created by apple on 07/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct RoomDetailModel {
    var rid: String = ""
    var roomType: String = ""
    var includes: Includes?
    var status: String = ""
    var roomImg: String = ""
    var guest: [GuestDetail] = []
    var amountPaid: String = ""
    var cancellationCharges: Double = 0
    var netRefund: String = ""
    var voucher: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["rid"] {
            self.rid = "\(obj)"
        }
        
        if let obj = json["roomType"] {
            self.roomType = "\(obj)"
        }
        
        if let obj = json["includes"] as? JSONDictionary {
            self.includes = Includes(json: obj)
        }
        if let obj = json["status"] {
            self.status = "\(obj)"
        }
        
        if let obj = json["roomImg"] {
            self.roomImg = "\(obj)"
        }
    }
}

struct Cancellation {}

struct Includes {
    var inclusions: [String] = []
    var notes: [String] = []
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["Inclusions"] as? [String] {
            self.inclusions = obj
        }
        
        if let obj = json["notes"] as? [String] {
            self.notes = obj
        }
    }
}

struct GuestDetail {
    var gender: String = ""
    var name: String = ""
    var salutation: String = ""
    var dob: String = ""
    var age: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["gender"] {
            self.gender = "\(obj)".removeNull
        }
        
        if let obj = json["name"] {
            self.name = "\(obj)".removeNull
        }
        
        if let obj = json["salutation"] {
            self.salutation = "\(obj)".removeNull
        }
        
        if let obj = json["dob"] {
            self.dob = "\(obj)".removeNull
        }
        
        if let obj = json["age"] {
            self.age = "\(obj)".removeNull
        }
    }
}

struct Traveller {
    var id: String = ""
    var bookingId: String = ""
    var refTable: String = ""
    var refTableId: String = ""
    var paxType: String = ""
    var paxId: String = ""
    var salutation: String = ""
    var firstName: String = ""
    var middleName: String = ""
    var lastName: String = ""
    var age: String = ""
    var dob: String = ""
    
    var gender: String = ""
    var paxStatus: String = ""
    var statusId: String = ""
    var leadPax: String = ""
    var pnr: String = ""
    var pnrSector: String = ""
    var ticketNo: String = ""
    var crsPnr: String = "" // where it wil be used , need to confirm with Yash
    var addedWhileBooking: String = ""
    var paxGroup: String = ""
    var addedOn: String = ""
    var updatedOn: String = ""
    var paxName: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["id"] {
            self.id = "\(obj)".removeNull
        }
        
        if let obj = json["booking_id"] {
            self.bookingId = "\(obj)".removeNull
        }
        
        if let obj = json["ref_table"] {
            self.refTable = "\(obj)".removeNull
        }
        
        if let obj = json["ref_table_id"] {
            self.refTableId = "\(obj)".removeNull
        }
        
        if let obj = json["pax_type"] {
            self.paxType = "\(obj)".removeNull
        }
        
        if let obj = json["pax_id"] {
            self.paxId = "\(obj)".removeNull
        }
        
        if let obj = json["salutation"] {
            self.salutation = "\(obj)".removeNull
        }
        
        if let obj = json["first_name"] {
            self.firstName = "\(obj)".removeNull
        }
        
        if let obj = json["middle_name"] {
            self.middleName = "\(obj)".removeNull
        }
        
        if let obj = json["last_name"] {
            self.lastName = "\(obj)".removeNull
        }
        
        if let obj = json["age"] {
            self.age = "\(obj)".removeNull
        }
        
        if let obj = json["dob"] {
            self.dob = "\(obj)".removeNull
        }
        
        if let obj = json["gender"] {
            self.gender = "\(obj)".removeNull
        }
        
        if let obj = json["pax_status"] {
            self.paxStatus = "\(obj)".removeNull
        }
        
        if let obj = json["status_id"] {
            self.statusId = "\(obj)".removeNull
        }
        
        if let obj = json["lead_pax"] {
            self.leadPax = "\(obj)".removeNull
        }
        
        if let obj = json["pnr"] {
            self.pnr = "\(obj)".removeNull
        }
        
        if let obj = json["pnr_sector"] {
            self.pnrSector = "\(obj)".removeNull
        }
        
        if let obj = json["ticket_no"] {
            self.ticketNo = "\(obj)".removeNull
        }
        
        if let obj = json["crs_pnr"] {
            self.crsPnr = "\(obj)".removeNull
        }
        
        if let obj = json["added_while_booking"] {
            self.addedWhileBooking = "\(obj)".removeNull
        }
        
        if let obj = json["pax_group"] {
            self.paxGroup = "\(obj)".removeNull
        }
        
        if let obj = json["added_on"] {
            self.addedOn = "\(obj)".removeNull
        }
        
        if let obj = json["updated_on"] {
            self.updatedOn = "\(obj)".removeNull
        }
        
        if let obj = json["pax_name"] {
            self.paxName = "\(obj)".removeNull
        }
    }
    
    static func retunsTravellerArray(jsonArr: [JSONDictionary]) -> [Traveller] {
        var traveller = [Traveller]()
        for element in jsonArr {
            traveller.append(Traveller(json: element))
        }
        return traveller
    }
}

struct Direction {
    var iataCode: String = ""
    var city: String = ""
    var airportName: String = ""
    var country_code: String = ""
    var latitude: String = ""
    var longitude: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["iata_code"] as? String {
            self.iataCode = "\(obj)".removeNull
        }
        
        if let obj = json["city"] as? String {
            self.city = "\(obj)".removeNull
        }
        
        if let obj = json["airportName"] as? String {
            self.airportName = "\(obj)".removeNull
        }
        
        if let obj = json["country_code"] as? String {
            self.country_code = "\(obj)".removeNull
        }
        if let obj = json["latitude"] as? String {
            self.latitude = "\(obj)".removeNull
        }
        
        if let obj = json["longitude"] as? String {
            self.longitude = "\(obj)".removeNull
        }
    }
    
    // get models
    static func getModels(json: [JSONDictionary]) -> [Direction] {
        return json.map { Direction(json: $0) }
    }
}
