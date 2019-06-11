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
            self.gender = "\(obj)"
        }
        
        if let obj = json["name"] {
            self.name = "\(obj)"
        }
        
        if let obj = json["salutation"] {
            self.salutation = "\(obj)"
        }
        
        if let obj = json["dob"] {
            self.dob = "\(obj)"
        }
        
        if let obj = json["age"] {
            self.age = "\(obj)"
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
            self.id = "\(obj)"
        }
        
        if let obj = json["booking_id"] {
            self.bookingId = "\(obj)"
        }
        
        if let obj = json["ref_table"] {
            self.refTable = "\(obj)"
        }
        
        if let obj = json["ref_table_id"] {
            self.refTableId = "\(obj)"
        }
        
        if let obj = json["pax_type"] {
            self.paxType = "\(obj)"
        }
        
        if let obj = json["pax_id"] {
            self.paxId = "\(obj)"
        }
        
        if let obj = json["salutation"] {
            self.salutation = "\(obj)"
        }
        
        if let obj = json["first_name"] {
            self.firstName = "\(obj)"
        }
        
        if let obj = json["middle_name"] {
            self.middleName = "\(obj)"
        }
        
        if let obj = json["last_name"] {
            self.lastName = "\(obj)"
        }
        
        if let obj = json["age"] {
            self.age = "\(obj)"
        }
        
        if let obj = json["dob"] {
            self.dob = "\(obj)"
        }
        
        if let obj = json["gender"] {
            self.gender = "\(obj)"
        }
        
        if let obj = json["pax_status"] {
            self.paxStatus = "\(obj)"
        }
        
        if let obj = json["status_id"] {
            self.statusId = "\(obj)"
        }
        
        if let obj = json["lead_pax"] {
            self.leadPax = "\(obj)"
        }
        
        if let obj = json["pnr"] {
            self.pnr = "\(obj)"
        }
        
        if let obj = json["pnr_sector"] {
            self.pnrSector = "\(obj)"
        }
        
        if let obj = json["ticket_no"] {
            self.ticketNo = "\(obj)"
        }
        
        if let obj = json["crs_pnr"] {
            self.crsPnr = "\(obj)"
        }
        
        if let obj = json["added_while_booking"] {
            self.addedWhileBooking = "\(obj)"
        }
        
        if let obj = json["pax_group"] {
            self.paxGroup = "\(obj)"
        }
        
        if let obj = json["added_on"] {
            self.addedOn = "\(obj)"
        }
        
        if let obj = json["updated_on"] {
            self.updatedOn = "\(obj)"
        }
        
        if let obj = json["pax_name"] {
            self.paxName = "\(obj)"
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
