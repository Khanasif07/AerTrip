//
//  RoomDetailModel.swift
//  AERTRIP
//
//  Created by apple on 07/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct RoomDetailModel {
    
    var bookingId: String = "" //will be used when requesting a cancellation for hotel
    
    var rid: String = ""
    var roomType: String = ""
   
    var includes: Includes?
    var status: String = ""
    var roomImg: String = ""
    var guest: [GuestDetail] = []
    
    var amountPaid: Double = 0
    var cancellationCharges: Double = 0
    var netRefund: Double = 0

    var voucher: String = ""
    var bedType: String = ""
    var description: String = ""
    
    init() {
        self.init(json: [:], bookingId: "")
    }
    
    init(json: JSONDictionary, bookingId: String) {
        
        self.bookingId = bookingId
        
        if let obj = json["rid"] {
            self.rid = "\(obj)".removeNull
        }
        
        if let obj = json["room_type"] {
            self.roomType = "\(obj)".removeNull
        }
        
        if let obj = json["includes"] as? JSONDictionary {
            self.includes = Includes(json: obj)
        }
        if let obj = json["status"] {
            self.status = "\(obj)".removeNull
        }
        
        if let obj = json["room_img"] {
            self.roomImg = "\(obj)".removeNull
        }
        
        if let obj = json["guests"] as? [JSONDictionary] {
            self.guest = GuestDetail.getModels(json: obj)
        }
        
        if let obj = json["desc"]  {
            self.description = "\(obj)".removeNull
        }
        
        if let obj = json["bed_types"] {
            self.bedType = "\(obj)".removeNull
        }
        
        if let obj = json["voucher"] {
            self.voucher = "\(obj)".removeNull
        }
        
        if let obj = json["amount_paid"] {
            self.amountPaid = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["cancellation_charges"] {
            self.cancellationCharges = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["net_refund"], let inDouble = "\(obj)".toDouble, inDouble != 0 {
            self.netRefund = inDouble
        }
        else {
            self.netRefund = self.amountPaid - self.cancellationCharges
        }
    }
    
    static func getModels(json: [JSONDictionary], bookingId: String) -> [RoomDetailModel] {
        return json.map { RoomDetailModel(json: $0, bookingId: bookingId) }
    }
    
}


struct CancellationCharges {
    
    var from: Date?
    var to: Date?
    var isRefundable: Bool = false
    var cancellationFee: Double = 0.0
    let dateFomat = "d MMM, HH:mm"//"EEE, dd MMM yyyy HH:mm"
    
    var fromStr: String {
        let str = self.from?.toString(dateFormat: dateFomat) ?? ""
        return str.isEmpty ? LocalizedString.dash.localized : str
    }
    
    var toStr: String {
        let str = self.to?.toString(dateFormat: dateFomat) ?? ""
        return str.isEmpty ? LocalizedString.dash.localized : str
    }
    
    var isFree: Bool {
        return cancellationFee == 0.0
    }
    
    init(json: JSONDictionary) {
        
        if let obj = json["from"] {
            //"2019-04-04 12:36:34"
            self.from = "\(obj)".toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        if let obj = json["to"] {
            //"2019-04-04 12:36:34"
            self.to = "\(obj)".toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        if let obj = json["is_refundable"] {
            self.isRefundable = "\(obj)".toBool
        }
        
        if let obj = json["cancellation_fee"] {
            self.cancellationFee = "\(obj)".toDouble ?? 0.0
        }
    }
    
    static func getModels(jsonArr: [JSONDictionary]) -> [CancellationCharges] {
        return jsonArr.map({ CancellationCharges(json: $0) })
    }
}

struct CancellationPenalty {
    
    var isRefundable: Bool = false
    var penaltyDescription: [String] = []
    
    init(json: JSONDictionary) {
        if let obj = json["is_refundable"] {
            self.isRefundable = "\(obj)".toBool
        }
        
        if let obj = json["cancellation_penalty"] as? [String] {
            self.penaltyDescription = obj
        }
    }
}

struct Cancellation {
    var charges: [CancellationCharges] = []
    var penalty: CancellationPenalty?
    
    init(json: JSONDictionary) {
        if let obj = json["cancellation_charges"] as? [JSONDictionary] {
            self.charges = CancellationCharges.getModels(jsonArr: obj)
        }
        
        if let obj = json["cancellation_penalty"] as? JSONDictionary {
            self.penalty = CancellationPenalty(json: obj)
        }
    }
}

struct Includes {
    var inclusions: [String] = []
    var notes: [String] = []
    var otherInclusion: [String] = []
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["Inclusions"] as? [String] {
            self.inclusions = obj
        }
        
        if let obj = json["Notes"] as? [String] {
            self.notes = obj
        }
        
        if let obj = json["Other Inclusions"] as? [String] {
            self.otherInclusion = obj
        }
    }
    
    var inclusionString: String {
        return self.inclusions.isEmpty ? "-" : self.inclusions.joined(separator: ",")
    }
    
    var otherInclsionString: String {
        return self.otherInclusion.isEmpty ? "-" : self.otherInclusion.joined(separator: ",")
    }
}

struct GuestDetail {
    var gender: String = ""
    var name: String = ""
    var salutation: String = ""
    var dob: String = ""
    var age: String = ""
    var profileImage: String = ""
    
    var fullName: String {
        return "\(self.salutation) \(self.name)"
    }
    
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
        
        if let obj = json["profile_image"] {
            self.profileImage = "\(obj)".removeNull
        }
    }
    
    static func getModels(json: [JSONDictionary]) -> [GuestDetail] {
        return json.map { GuestDetail(json: $0) }
    }
    
    var firstName: String {
        let name = self.name.split(separator: " ")
        if !name.isEmpty {
            return String(name[0])
        }
        return ""
    }
    
    var lastname: String {
        let name = self.name.split(separator: " ")
        if !name.isEmpty && name.count > 1 {
            return String(name[1])
        }
        return ""
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
    var profileImage: String = ""
    
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
        
        if let obj = json["profile_image"] {
            self.profileImage = "\(obj)".removeNull
        }
    }
    
    static func retunsTravellerArray(jsonArr: [JSONDictionary]) -> [Traveller] {
        var traveller = [Traveller]()
        for element in jsonArr {
            traveller.append(Traveller(json: element))
        }
        return traveller
    }
    
    var fullName: String {
        return "\(self.salutation) \(self.paxName)"
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
        
        if let obj = json["airport_name"] as? String {
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
