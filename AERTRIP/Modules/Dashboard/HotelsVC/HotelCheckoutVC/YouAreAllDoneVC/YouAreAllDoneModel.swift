//
//  YouAreAllDoneModel.swift
//  AERTRIP
//
//  Created by Admin on 05/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

struct HotelReceiptModel {
    
    var hid: String = ""// "549143"
    var hname: String = "" //"Hotel Blue Sapphire"
    var address: String = ""// "3351-54 Bank Street, Christian Colony, Karol Bagh, New Delhi 110005, New Delhi - 110005, India"
    var city: String = "" // "New Delhi"
    var city_id: String = "" // "433564"
    var state: String = ""  //""
    var country: String = "" // "India"
    var country_code: String = "" // "IN"
    var star: Double = 0.0 // "2.5"
    var rating: Double = 0.0 // "0"
    var lat: String = "" // "28.652423708701"
    var long: String = "" //77.191346883774"
    var checkin_time: String = "" // "00:00:00"
    var checkout_time: String =  "" //00:00:00"
    var checkin: String = "" //"2019-04-09"
    var checkout: String = "" //"2019-04-10"
    var num_rooms: Int = 0
    var num_nights: Int = 0
    var booking_number: String = "" // "B/19-20/119"
    var rooms: [Room] = []
    var travellers: [[TravellersList]] = []
    var part_payment: JSONDictionaryArray = [[:]]
    //    var booking_params: BookingParams?
    var booking_status: String = ""
    var penalty_array: JSONDictionaryArray = [[:]]
//    var cancellation_penalty: String
    var isRefundable: Bool = false //is_refundable
    var support_sla_time: SupportSlaTime?
    var flight_link_param: JSONDictionary = [:]
    var payment_details: PaymentDetails?
    var trip_details: TripDetails?
    
    //Mark:- Initialization
    //=====================
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.hid.rawValue: self.hid,
                APIKeys.hname.rawValue: self.hname,
                APIKeys.address.rawValue: self.address,
                APIKeys.city.rawValue: self.city,
                APIKeys.city_id.rawValue: self.city_id,
                APIKeys.state.rawValue: self.state,
                APIKeys.country.rawValue: self.country,
                APIKeys.country_code.rawValue: self.country_code,
                APIKeys.star.rawValue: self.star,
                APIKeys.rating.rawValue: self.rating,
                APIKeys.lat.rawValue: self.lat,
                APIKeys.long.rawValue: self.long,
                APIKeys.checkin_time.rawValue: self.checkin_time,
                APIKeys.checkout_time.rawValue: self.checkout_time,
                APIKeys.checkin.rawValue: self.checkin,
                APIKeys.checkout.rawValue: self.checkout,
                APIKeys.num_rooms.rawValue: self.num_rooms,
                APIKeys.num_nights.rawValue: self.num_nights,
                APIKeys.booking_number.rawValue: self.booking_number,
                APIKeys.rooms.rawValue: self.rooms,
                APIKeys.travellers.rawValue: self.travellers,
                APIKeys.part_payment.rawValue: self.part_payment,
                //                APIKeys.booking_params.rawValue: self.booking_params,
                APIKeys.booking_status.rawValue: self.booking_status,
                APIKeys.penalty_array.rawValue: self.penalty_array,
                APIKeys.part_payment.rawValue: self.part_payment,
            //                APIKeys.cancellation_penalty.rawValue: self.cancellation_penalty,
                APIKeys.is_refundable.rawValue: self.isRefundable,
                APIKeys.support_sla_time.rawValue: self.support_sla_time ?? SupportSlaTime(),
                APIKeys.flight_link_param.rawValue: self.flight_link_param,
                APIKeys.payment_details.rawValue: self.payment_details ?? PaymentDetails(),
                APIKeys.trip_details.rawValue: self.trip_details ?? TripDetails()]
    }
    
    init(json: JSONDictionary) {
        
        if let obj = json[APIKeys.hid.rawValue] {
            self.hid = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.hname.rawValue] {
            self.hname = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.address.rawValue] {
            self.address = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.city.rawValue] {
            self.city = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.city_id.rawValue] {
            self.city_id = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.state.rawValue] {
            self.state = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.country.rawValue] {
            self.country = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.country_code.rawValue] {
            self.country_code = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.star.rawValue] {
            self.star = "\(obj)".toDouble ?? 0.0
        }
        if let obj = json[APIKeys.rating.rawValue] {
            self.rating = "\(obj)".toDouble ?? 0.0
        }
        if let obj = json[APIKeys.lat.rawValue] {
            self.lat = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.long.rawValue] {
            self.long = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.checkin_time.rawValue] {
            self.checkin_time = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.checkout_time.rawValue] {
            self.checkout_time = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.checkin.rawValue] {
            self.checkin = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.checkout.rawValue] {
            self.checkout = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.num_rooms.rawValue] {
            self.num_rooms = "\(obj)".toInt ?? 0
        }
        if let obj = json[APIKeys.num_nights.rawValue] {
            self.num_nights = "\(obj)".toInt ?? 0
        }
        if let obj = json[APIKeys.booking_number.rawValue] {
            self.booking_number = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.rooms.rawValue] as? JSONDictionaryArray {
            self.rooms = Room.getRoomData(response: obj)
        }
        if let obj = json[APIKeys.travellers.rawValue] as? [JSONDictionaryArray] {
            for jsonDict in obj {
                let trvlsData = TravellersList.getTravellersList(response: jsonDict)
                self.travellers.append(trvlsData)
            }
//            self.travellers = TravellersList.getTravellersList(response: obj)
        }
        if let obj = json[APIKeys.part_payment.rawValue] as? JSONDictionaryArray {
            self.part_payment = obj
        }
        if let obj = json[APIKeys.booking_params.rawValue] as? JSONDictionary , let bookingStatus = obj[APIKeys.booking_status.rawValue]{
            self.booking_status = "\(bookingStatus)".removeNull
        }
        if let obj = json[APIKeys.penalty_array.rawValue] as? JSONDictionaryArray {
            self.penalty_array = obj
        }
        if let obj = json[APIKeys.cancellation_penalty.rawValue] as? JSONDictionary , let isRefundable = obj[APIKeys.is_refundable.rawValue] {
            self.isRefundable = "\(isRefundable)".removeNull == "1" ? true : false
        }
        if let obj = json[APIKeys.support_sla_time.rawValue] as? JSONDictionary {
            self.support_sla_time = SupportSlaTime(json: obj)
        }
        if let obj = json[APIKeys.flight_link_param.rawValue] as? JSONDictionary {
            self.flight_link_param = obj
        }
        if let obj = json[APIKeys.payment_details.rawValue] as? JSONDictionary {
            self.payment_details = PaymentDetails(json: obj)
        }
        if let obj = json[APIKeys.trip_details.rawValue] as? JSONDictionary {
            self.trip_details = TripDetails(json: obj)
        }
    }

    //Mark:- Functions
    //================
    ///Static Function
//    static func getReceiptData(response: JSONDictionary) -> HotelReceiptModel {
//        let receiptData = HotelReceiptModel(json: response)
//        return receiptData
//    }
}

struct Room {
    
    var name: String = ""
    var thumbnail: String = ""
    var num_adult: Int = 0
    var num_child: Int = 0
    var inclusions: JSONDictionary = [:]
    //    Inclusions
    //    Notes
    var status: String = ""
    var cancellation_policy: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.name.rawValue: self.name,
                APIKeys.thumbnail.rawValue: self.thumbnail,
                APIKeys.num_adult.rawValue: self.num_adult,
                APIKeys.num_child.rawValue: self.num_child,
                APIKeys.inclusions.rawValue: self.inclusions,
                APIKeys.status.rawValue: self.status,
                APIKeys.cancellation_policy.rawValue: self.cancellation_policy]
    }
    
    init(json: JSONDictionary) {
        if let obj = json[APIKeys.name.rawValue] {
            self.name = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.thumbnail.rawValue] {
            self.thumbnail = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.num_adult.rawValue] as? Int {
            self.num_adult = obj
        }
        if let obj = json[APIKeys.description.rawValue] as? Int {
            self.num_child = obj
        }
        if let obj = json[APIKeys.inclusions.rawValue] as? JSONDictionary {
            self.inclusions = obj
        }
        if let obj = json[APIKeys.status.rawValue]{
            self.status = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.cancellation_policy.rawValue]{
            self.cancellation_policy = "\(obj)".removeNull
        }
    }
    
    //Mark:- Functions
    //================
    ///Static Function
    static func getRoomData(response: [JSONDictionary]) -> [Room] {
        var roomData = [Room]()
        for json in response {
            roomData.append( Room(json: json))
        }
        return roomData
    }
}

struct TravellersList {
    var id: String = ""
    var booking_id: String = ""
    var ref_table: String = ""
    var ref_table_id: String = ""
    var pax_type: String = ""
    var pax_id: String = ""
    var salutation: String = "" //Mrs
    var first_name: String = ""
    var middle_name: String = ""
    var last_name: String = ""
    var age: Int = 0
    var dob: String = ""
    var gender: String = ""
    var pax_status: String = ""
    var status_id: String = ""
    var lead_pax: String = ""
    var pnr: String = ""
    var pnr_sector: String = ""
    var ticket_no: String = ""
    var crs_pnr: String = ""
    var added_while_booking: String = "0"
    var pax_group: String = "0"
    var added_on: String = ""
    var updated_on: String = ""
    var email: JSONDictionaryArray = [[:]]
    var profile_image: String = ""
    
    
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.id.rawValue: self.id,
                APIKeys.booking_id.rawValue: self.booking_id,
                APIKeys.ref_table.rawValue: self.ref_table,
                APIKeys.ref_table_id.rawValue: self.ref_table_id,
                APIKeys.pax_type.rawValue: self.pax_type,
                APIKeys.paxId.rawValue: self.pax_id,
                APIKeys.salutation.rawValue: self.salutation,
                APIKeys.firstName.rawValue: self.first_name,
                APIKeys.middle_name.rawValue: self.middle_name,
                APIKeys.lastName.rawValue: self.last_name,
                APIKeys.age.rawValue: self.age,
                APIKeys.dob.rawValue: self.dob,
                APIKeys.gender.rawValue: self.gender,
                APIKeys.pax_status.rawValue: self.pax_status,
                APIKeys.status_id.rawValue: self.status_id,
                APIKeys.lead_pax.rawValue: self.lead_pax,
                APIKeys.pnr.rawValue: self.pnr,
                APIKeys.pnr_sector.rawValue: self.pnr_sector,
                APIKeys.ticket_no.rawValue: self.ticket_no,
                APIKeys.crs_pnr.rawValue: self.crs_pnr,
                APIKeys.added_while_booking.rawValue: self.added_while_booking,
                APIKeys.pax_group.rawValue: self.pax_group,
                APIKeys.added_on.rawValue: self.added_on,
                APIKeys.updated_on.rawValue: self.updated_on,
                APIKeys.email.rawValue: self.email,
                APIKeys.profileImage.rawValue: self.profile_image]
    }
    
    init(json: JSONDictionary) {
        if let obj = json[APIKeys.id.rawValue] {
            self.id = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.booking_id.rawValue] {
            self.booking_id = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.ref_table.rawValue] {
            self.ref_table = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.ref_table_id.rawValue] {
            self.ref_table_id = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.pax_type.rawValue] {
            self.pax_type = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.paxId.rawValue] {
            self.pax_id = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.salutation.rawValue] {
            self.salutation = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.firstName.rawValue] {
            self.first_name = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.middle_name.rawValue] {
            self.middle_name = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.lastName.rawValue] {
            self.last_name = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.age.rawValue] {
            self.age = "\(obj)".toInt ?? 0
        }
        if let obj = json[APIKeys.dob.rawValue] {
            self.dob = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.gender.rawValue] {
            self.gender = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.pax_status.rawValue] {
            self.pax_status = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.status_id.rawValue] {
            self.status_id = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.lead_pax.rawValue] {
            self.lead_pax = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.pnr.rawValue] {
            self.pnr = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.pnr_sector.rawValue] {
            self.pnr_sector = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.ticket_no.rawValue] {
            self.ticket_no = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.crs_pnr.rawValue] {
            self.crs_pnr = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.added_while_booking.rawValue] {
            self.added_while_booking = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.pax_group.rawValue] {
            self.pax_group = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.added_on.rawValue] {
            self.added_on = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.updated_on.rawValue] {
            self.updated_on = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.email.rawValue] as? JSONDictionaryArray {
            self.email = obj
        }
        if let obj = json[APIKeys.profileImage.rawValue] {
            self.profile_image = "\(obj)".removeNull
        }
    }
    
    //Mark:- Functions
    //================
    ///Static Function
    static func getTravellersList(response: JSONDictionaryArray) -> [TravellersList] {
        var travellersList = [TravellersList]()
        for json in response {
            travellersList.append( TravellersList(json: json))
        }
        return travellersList
    }
}

struct SupportSlaTime {
    var booking_ts: Int64 = 0
    var sla_ts: Int64 = 0
    
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.booking_ts.rawValue: self.booking_ts,
                APIKeys.sla_ts.rawValue: self.sla_ts]
    }
    
    init(json: JSONDictionary) {
        if let obj = json[APIKeys.booking_ts.rawValue] as? Int64{
            self.booking_ts = obj
        }
        if let obj = json[APIKeys.sla_ts.rawValue] as? Int64 {
            self.sla_ts = obj
        }
    }
}

struct PaymentDetails {
    var mode: String = ""
    var info: PaymentInfo?
    
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.mode.rawValue: self.mode,
                APIKeys.info.rawValue: self.info ?? PaymentInfo()]
    }
    
    init(json: JSONDictionary) {
        if let obj = json[APIKeys.mode.rawValue] {
            self.mode = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.info.rawValue] as? JSONDictionary {
            self.info = PaymentInfo(json: obj)
        }
    }
}

struct PaymentInfo {
    var transaction_id: String = ""
    var payment_amount: Double = 0.0
    
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.transaction_id.rawValue: self.transaction_id,
                APIKeys.payment_amount.rawValue: self.payment_amount]
    }
    
    init(json: JSONDictionary) {
        if let obj = json[APIKeys.transaction_id.rawValue] {
            self.transaction_id = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.payment_amount.rawValue] as? Double {
            self.payment_amount = obj
        }
    }
}

struct TripDetails {
    var booking_id: String = ""
    var trip_id: String = ""
    var event_id: String = ""
    var is_updated: String = ""
    var trip_key: String = ""
    var name: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.booking_id.rawValue: self.booking_id,
                APIKeys.trip_id.rawValue: self.trip_id,
                APIKeys.event_id.rawValue: self.event_id,
                APIKeys.is_updated.rawValue: self.is_updated,
                APIKeys.trip_key.rawValue: self.trip_key,
                APIKeys.name.rawValue: self.name]
    }
    
    init(json: JSONDictionary) {
        if let obj = json[APIKeys.booking_id.rawValue] {
            self.booking_id = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.trip_id.rawValue] {
            self.trip_id = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.event_id.rawValue] {
            self.event_id = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.is_updated.rawValue] {
            self.is_updated = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.trip_key.rawValue] {
            self.trip_key = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.name.rawValue] {
            self.name = "\(obj)".removeNull
        }
    }
}
