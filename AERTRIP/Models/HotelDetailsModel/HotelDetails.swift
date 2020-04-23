//
//  HotelDetails.swift
//  AERTRIP
//
//  Created by Admin on 14/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

//Mark:- HotelDetails
//===================
struct HotelDetails {
    
    //Mark:- Variables
    //================
    var hid: String = ""
    var vid:String = ""
    var list_price: Double = 0.0
    var price: Double = 0.0
    var tax: Double = 0.0
    var discount: Double = 0.0
    var hname: String = ""
    var lat: String = ""
    var long: String = ""
    var star: Double = 0.0
    var rating: Double = 0.0
    var locid: String = ""
    var fav: String = ""
    var address: String = ""
    var photos: [String] = []
    var amenities: Amenities? = nil
    var amenitiesGroups : [String : Any] = [:]
    var checkin_time: String = ""
    var checkout_time: String = ""
    var checkin: String = ""
    var checkout: String = ""
    var num_rooms: Int = 0
    var rates: [Rates]? = nil
    var info: String = ""
    var ta_reviews: String  = ""
    var ta_web_url: String = ""
    var city: String = ""
    var country: String = ""
    var is_refetch_cp: String = ""
    var per_night_price: String = ""
    var per_night_list_price: String = ""
    var facilities: String = ""
    var city_code: String = ""
    var acc_type: String = ""
    var temp_price: Double = 0.0
    var at_hotel_fares: Double = 0
    var no_of_nights: Int = 0
    var bc: String = ""
    var distance: String = ""
    var thumbnail: [String] = [String]()
    var totalOccupant: Int = 0
    var pan_required: Bool = false

    
    //Mark:- Initialization
    //=====================
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.facilities.rawValue: self.facilities,
                APIKeys.city_code.rawValue: self.city_code,
                APIKeys.address.rawValue: self.address,
                APIKeys.acc_type.rawValue: self.acc_type,
                APIKeys.temp_price.rawValue: self.temp_price,
                APIKeys.price.rawValue: self.price,
                APIKeys.at_hotel_fares.rawValue: self.at_hotel_fares,
                APIKeys.no_of_nights.rawValue: self.no_of_nights,
                APIKeys.num_rooms.rawValue: self.num_rooms,
                APIKeys.list_price.rawValue: self.list_price,
                APIKeys.tax.rawValue: self.tax,
                APIKeys.discount.rawValue: self.discount,
                APIKeys.hid.rawValue: self.hid,
                APIKeys.vid.rawValue: self.vid,
                APIKeys.hname.rawValue: self.hname,
                APIKeys.lat.rawValue: self.lat,
                APIKeys.long.rawValue: self.long,
                APIKeys.country.rawValue: self.country,
                APIKeys.star.rawValue: self.star,
                APIKeys.rating.rawValue: self.rating,
                APIKeys.locid.rawValue: self.locid,
                APIKeys.bc.rawValue: self.bc,
                APIKeys.fav.rawValue: self.fav,
                APIKeys.distance.rawValue: self.distance,
                APIKeys.thumbnail.rawValue: self.thumbnail,
                APIKeys.ta_reviews.rawValue: self.ta_reviews,
                APIKeys.ta_web_url.rawValue: self.ta_web_url,
                APIKeys.per_night_price.rawValue: self.per_night_price,
                APIKeys.per_night_list_price.rawValue: self.per_night_list_price,
                APIKeys.photos.rawValue: self.photos,
                APIKeys.amenities.rawValue: self.amenities ?? Amenities(),
                APIKeys.amenities_group.rawValue: self.amenitiesGroups,
                APIKeys.checkin_time.rawValue: self.checkin_time,
                APIKeys.checkout_time.rawValue: self.checkout_time,
                APIKeys.checkin.rawValue: self.checkin,
                APIKeys.checkout.rawValue: self.checkout,
                APIKeys.rates.rawValue: self.rates ?? [Rates()],
                //APIKeys.combine_rates.rawValue: self.combine_rates,
            APIKeys.info.rawValue: self.info,
            APIKeys.city.rawValue: self.city,
            APIKeys.is_refetch_cp.rawValue: self.is_refetch_cp,
            APIKeys.occupant.rawValue: self.totalOccupant,
            APIKeys.pan_required.rawValue: self.pan_required

        ]
    }
    
    init(json: JSONDictionary) {
        
        if let obj = json[APIKeys.facilities.rawValue] {
            self.facilities = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.city_code.rawValue] {
            self.city_code = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.address.rawValue] {
            self.address = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.acc_type.rawValue] {
            self.acc_type = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.temp_price.rawValue] {
            self.temp_price = "\(obj)".toDouble ?? 0.0
        }
        if let obj = json[APIKeys.price.rawValue] {
            self.price = "\(obj)".toDouble ?? 0.0
        }
        if let obj = json[APIKeys.at_hotel_fares.rawValue] {
            self.at_hotel_fares = "\(obj)".toDouble ?? 0.0
        }
        if let obj = json[APIKeys.no_of_nights.rawValue] {
            self.no_of_nights = "\(obj)".toInt ?? 0
        }
        if let obj = json[APIKeys.num_rooms.rawValue] {
            self.num_rooms = "\(obj)".toInt ?? 0
        }
        if let obj = json[APIKeys.list_price.rawValue] {
            self.list_price = "\(obj)".toDouble ?? 0.0
        }
        if let obj = json[APIKeys.tax.rawValue] as? Double {
            self.tax = obj
        }
        if let obj = json[APIKeys.discount.rawValue] as? Double {
            self.discount = obj
        }
        if let obj = json[APIKeys.hid.rawValue] {
            self.hid = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.vid.rawValue] {
            self.vid = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.hname.rawValue] {
            self.hname = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.lat.rawValue] {
            self.lat = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.long.rawValue] {
            self.long = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.country.rawValue] {
            self.country = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.star.rawValue] as? String {
            self.star = Double(obj.removeNull) ?? 0.0
        }
        if let obj = json[APIKeys.rating.rawValue] as? String {
            self.rating =   Double(obj.removeNull) ?? 0.0
        }
        if let obj = json[APIKeys.locid.rawValue] {
            self.locid = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.bc.rawValue] {
            self.bc = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.fav.rawValue] {
            self.fav = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.distance.rawValue] {
            self.distance = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.thumbnail.rawValue] as? [String] {
            self.thumbnail = obj
        }
        if let obj = json[APIKeys.ta_reviews.rawValue] {
            self.ta_reviews = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.ta_web_url.rawValue] {
            self.ta_web_url = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.per_night_price.rawValue] {
            self.per_night_price = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.per_night_list_price.rawValue] {
            self.per_night_list_price = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.photos.rawValue] as? [String] {
            self.photos = obj
        }
        else if let dict = json[APIKeys.photos.rawValue] as? JSONDictionary {
            self.photos = dict.map {"\($0.1)"}
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
        if let obj = json[APIKeys.info.rawValue] {
            self.info = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.city.rawValue] {
            self.city = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.is_refetch_cp.rawValue] {
            self.is_refetch_cp = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.amenities.rawValue] as? JSONDictionary {
            self.amenities = Amenities.getAmenitiesData(response: obj)
        }
        if let obj = json[APIKeys.rates.rawValue] as? [JSONDictionary] {
            self.rates = Rates.getRatesData(response: obj)
        }
        if let arrObj = json[APIKeys.amenities_group.rawValue] as? [JSONDictionary], let firstObj = arrObj.first {
            self.amenitiesGroups = firstObj
        }
        
        if let obj = json[APIKeys.occupant.rawValue] as? [JSONDictionary] {
            for dict in obj {
                if let adults = dict["a"] {
                    self.totalOccupant += ("\(adults)".toInt ?? 0)
                }
                if let childs = dict["c"] as? [String] {
                    self.totalOccupant += childs.count
                }
            }
        }
        
        if let obj = json[APIKeys.pan_required.rawValue] as? Bool {
            self.pan_required = obj
        }
        
    }
    
    //Mark:- Functions
    //================
    ///Static Function
    static func hotelInfo(response: JSONDictionary) -> HotelDetails {
        let hotelInfo = HotelDetails(json: response)
        return hotelInfo
    }
}


//Mark:- Amenities
//================
struct Amenities {
    
    //Mark:- Variables
    //================
    var main: [AmenitiesMain]? = nil
    var basic: [String] = []
    var other: [String] = []
    
    //Mark:- Initialization
    //=====================
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.main.rawValue: self.main ?? [AmenitiesMain()],
                APIKeys.basic.rawValue: self.basic,
                APIKeys.other.rawValue: self.other]
    }
    
    init(json: JSONDictionary) {
        if let mainData = json[APIKeys.main.rawValue] as? [JSONDictionary] {
            self.main = AmenitiesMain.getMainData(response: mainData)
        }
        
        if let otherData = json[APIKeys.other.rawValue] as? [String] {
            for data in otherData {
                self.other.append(data)
            }
        }
        
        if let basicData = json[APIKeys.basic.rawValue] as? [String] {
            for data in basicData {
                self.basic.append(data)
            }
        }
    }
    
    //Mark:- Functions
    //================
    ///Static Function
    static func getAmenitiesData(response: JSONDictionary) -> Amenities {
        let amenities = Amenities(json: response)
        return amenities
    }
}


//Mark:- Main
//===========

//Mark:- Variables
//================
struct AmenitiesMain {
    var available: Bool = false
    var name: String = ""
    var classType: String = ""
    
    var image: UIImage? {
        return UIImage(named: self.classType)
    }
    
    //Mark:- Initialization
    //=====================
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.available.rawValue: self.available,
                APIKeys.name.rawValue: self.name,
                APIKeys.classType.rawValue: self.classType]
    }
    
    init(json: JSONDictionary) {
        if let obj = json[APIKeys.name.rawValue] {
            self.name = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.available.rawValue] as? Int {
            self.available = (obj == 1) ? true : false
        }
        if let obj = json[APIKeys.classType.rawValue] {
            self.classType = "\(obj)".removeNull
        }
    }
    
    //Mark:- Functions
    //================
    ///Static Function
    static func getMainData(response: [JSONDictionary]) -> [AmenitiesMain] {
        var mainDataArray = [AmenitiesMain]()
        for json in response {
            let obj = AmenitiesMain(json: json)
            mainDataArray.append(obj)
        }
        return mainDataArray
    }
}


//Mark:- Enums
//============
enum TableCellType {
    case imageSlideCell , hotelRatingCell , addressCell , checkInOutDateCell , overViewCell , amenitiesCell , tripAdvisorRatingCell , searchTagCell , ratesEmptyStateCell , roomBedsTypeCell , inclusionCell , otherInclusionCell, cancellationPolicyCell , paymentPolicyCell , notesCell , checkOutCell , roomDetailsCell
}

//Mark:- Rates
//============
struct Rates: Hashable {
    
    //    //Mark:- Enums
    //    //============
    //    enum TableCellType {
    //        case roomBedsType, inclusion, otherInclusion, cancellationPolicy, paymentPolicy, notes, checkOut
    //    }
    
    var hashValue: Int {
        return qid.hashValue
    }
    
    static func == (lhs: Rates, rhs: Rates) -> Bool {
        return lhs.qid == rhs.qid
    }
    
    //Mark:- Variables
    //================
    
    var qid: String = ""
    var can_combine: Bool = false
    var price: Double = 0.0   //  checkout row 1
    var list_price: Double = 0.0
    var tax: Double = 0.0
    var discount: Double = 0.0
    var hotel_code: String = ""
    var group_rooms: String = ""
    var payment_info: String = ""
    var part_payment_last_date: String = ""
    var roomsRates: [RoomsRates]? = nil   /// x count row
    var roomData: [RoomsRates: Int] {
        var tempData = [RoomsRates: Int] ()
        guard let roomsRates = self.roomsRates else { return tempData }
        for currentRoom in roomsRates {
            var count = 1
            for otherRoom in roomsRates {
                if (otherRoom.uuRid != currentRoom.uuRid) && (!self.alreadyExist(arrRooms: Array(tempData.keys), room: otherRoom)) {
                    if otherRoom == currentRoom {
                        count = count + 1
                    }
                }
            }
            if !self.alreadyExist(arrRooms: Array(tempData.keys), room: currentRoom) {
                tempData[currentRoom] = count
            } else {
                printDebug("Already Exist in Array")
            }
            
        }
        return tempData
    }
    var terms: RatesTerms? = nil
    var cancellation_penalty: CancellationPenaltyRates? = nil  ///  cancel row 1
    var penalty_array: [PenaltyRates]? = nil          /// payment info row 1
    var inclusion_array: [String : Any] = [:]    /// 3 row
    var tableViewRowCell: [TableCellType] {
        var presentedCell = [TableCellType]()
        presentedCell.removeAll()
        if self.roomData.count > 0 {
            for _ in self.roomData {
                presentedCell.append(.roomBedsTypeCell)
            }
        }
        if let boardInclusion =  self.inclusion_array[APIKeys.boardType.rawValue] as? [Any], !boardInclusion.isEmpty {
            presentedCell.append(.inclusionCell)
        } else if let internetData =  self.inclusion_array[APIKeys.internet.rawValue] as? [Any], !internetData.isEmpty {
            presentedCell.append(.inclusionCell)
        }
        if let otherInclusion =  self.inclusion_array[APIKeys.other_inclusions.rawValue] as? [Any], !otherInclusion.isEmpty {
            presentedCell.append(.otherInclusionCell)
        }
        if self.cancellation_penalty != nil {
            presentedCell.append(.cancellationPolicyCell)
        }
        presentedCell.append(.paymentPolicyCell)
        if let notesData =  self.inclusion_array[APIKeys.notes_inclusion.rawValue] as? [Any], !notesData.isEmpty {
            presentedCell.append(.notesCell)
        }
        presentedCell.append(.checkOutCell)
        return presentedCell
    }
        
    //Mark:- Initialization
    //=====================
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.qid.rawValue: self.qid,
                APIKeys.can_combine.rawValue: self.can_combine,
                APIKeys.price.rawValue: self.price,
                APIKeys.list_price.rawValue: self.list_price,
                APIKeys.tax.rawValue: self.tax,
                APIKeys.discount.rawValue: self.discount,
                APIKeys.hotel_code.rawValue: self.hotel_code,
                APIKeys.group_rooms.rawValue: self.group_rooms,
                APIKeys.payment_info.rawValue: self.payment_info,
                APIKeys.part_payment_last_date.rawValue: self.part_payment_last_date,
                APIKeys.rooms.rawValue: self.roomsRates ?? [RoomsRates()],
                APIKeys.terms.rawValue: self.terms ?? RatesTerms(),
                APIKeys.cancellation_penalty.rawValue: self.cancellation_penalty ?? CancellationPenaltyRates(),
                APIKeys.penalty_array.rawValue: self.penalty_array ?? [PenaltyRates()],
                APIKeys.inclusion_array.rawValue: self.inclusion_array
        ]
    }
    
    func alreadyExist(arrRooms:  [RoomsRates], room: RoomsRates) -> Bool {
        for otherRoom in arrRooms {
            if otherRoom == room {
                if let lhsRoomBeds = otherRoom.roomBedTypes, let rhsRoomBeds = room.roomBedTypes {
                    if lhsRoomBeds.count == rhsRoomBeds.count {
                        var index = -1
                        for bedType in lhsRoomBeds {
                            if rhsRoomBeds.contains(bedType) {
                                index = index + 1
                            }
                        }
                        if index == lhsRoomBeds.count - 1 {
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    init(json: JSONDictionary) {
        if let obj = json[APIKeys.qid.rawValue] {
            self.qid = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.can_combine.rawValue] {
            self.can_combine = ("\(obj)".removeNull == "1" ? true : false)
        }
        if let obj = json[APIKeys.price.rawValue] as? Double {
            self.price = obj
        }
        if let obj = json[APIKeys.list_price.rawValue] as? Double {
            self.list_price = obj
        }
        if let obj = json[APIKeys.tax.rawValue] as? Double {
            self.tax = obj
        }
        if let obj = json[APIKeys.discount.rawValue] as? Double {
            self.discount = obj
        }
        if let obj = json[APIKeys.hotel_code.rawValue]{
            self.hotel_code = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.group_rooms.rawValue] {
            self.group_rooms = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.payment_info.rawValue] {
            self.payment_info = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.part_payment_last_date.rawValue] {
            self.part_payment_last_date = "\(obj)".removeNull
        }
        if let roomsData = json[APIKeys.rooms.rawValue] as? [JSONDictionary] {
            self.roomsRates = RoomsRates.getRoomsData(response: roomsData)
        }
        if let termsData = json[APIKeys.terms.rawValue] as? JSONDictionary {
            self.terms = RatesTerms.getRatesTermsData(response: termsData)
        }
        if let cancellationPenaltyData = json[APIKeys.cancellation_penalty.rawValue] as? JSONDictionary {
            self.cancellation_penalty = CancellationPenaltyRates.getCancellationPenaltyData(response: cancellationPenaltyData)
        }
        if let penaltyData = json[APIKeys.penalty_array.rawValue] as? [JSONDictionary] {
            self.penalty_array = PenaltyRates.getPenaltyRatesData(response: penaltyData)
        }
        if let inclusionData = json[APIKeys.inclusion_array.rawValue] as? JSONDictionary {
            self.inclusion_array = inclusionData
        }
    }
    
    //Mark:- Functions
    //================
    ///Get Full Refundable Data
    func getFullRefundableData() -> PenaltyRates {
        var penaltyRates = PenaltyRates()
        if let penaltyArray = self.penalty_array {
            for currentPenaltyRates in penaltyArray {
                if currentPenaltyRates.penalty == 0 {
                    penaltyRates = currentPenaltyRates
                }
            }
        }
        return penaltyRates
    }
    
    ///Static Function
    static func getRatesData(response: [JSONDictionary]) -> [Rates] {
        var ratesDataArray = [Rates]()
        for json in response {
            let obj = Rates(json: json)
            ratesDataArray.append(obj)
        }
        return ratesDataArray
    }
}


//Mark:- RoomsRates
//=================

struct RoomsRates: Hashable {
    
    var hashValue: Int {
        return uuRid.hashValue
    }
   
    static func == (lhs: RoomsRates, rhs: RoomsRates) -> Bool {
        // Bedtypes
        if lhs.name == rhs.name {
            if let lhsRoomBeds = lhs.roomBedTypes, let rhsRoomBeds = rhs.roomBedTypes {
                if lhsRoomBeds.count == rhsRoomBeds.count {
                    var index = -1
                    for bedType in lhsRoomBeds {
                        if rhsRoomBeds.contains(bedType) {
                            index = index + 1
                        }
                    }
                    if index == lhsRoomBeds.count - 1 {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    //Mark:- Variables
    //================
    var uuRid: String = ""
    var rid: String = ""
    var thumbnail: String = ""
    var name: String = ""
    var desc: String = ""
    var roomBedTypes: [RoomsBedTypes]? = nil
    var type: String = ""
    var id: String = ""
    var max_adult: String = ""
    var max_child: String = ""
    var room_reference: String = ""
    var per_night_price: String = ""
    var guests: Guest?
    var bedtype_id: String = ""
    
    
    //Mark:- Initialization
    //=====================
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.rid.rawValue: self.rid,
                APIKeys.thumbnail.rawValue: self.thumbnail,
                APIKeys.name.rawValue: self.name,
                APIKeys.desc.rawValue: self.desc,
                APIKeys.bed_types.rawValue: self.roomBedTypes ?? [RoomsBedTypes()],
                APIKeys.type.rawValue: self.type,
                APIKeys.id.rawValue: self.id,
                APIKeys.max_adult.rawValue: self.max_adult,
                APIKeys.max_child.rawValue: self.max_child,
                APIKeys.room_reference.rawValue: self.room_reference,
                APIKeys.per_night_price.rawValue: self.per_night_price,
                APIKeys.guests.rawValue: self.guests ?? Guest(),
                APIKeys.bedtype_id.rawValue: self.bedtype_id]
    }
    
    init(json: JSONDictionary) {
        self.uuRid = UUID().uuidString
        if let obj = json[APIKeys.rid.rawValue] {
            self.rid = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.thumbnail.rawValue] {
            self.thumbnail = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.name.rawValue] {
            self.name = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.desc.rawValue] {
            self.desc = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.bed_types.rawValue] as? [JSONDictionary] {
            self.roomBedTypes = RoomsBedTypes.getBedTypesData(response: obj)
        }
        if let obj = json[APIKeys.type.rawValue] {
            self.type = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.id.rawValue] {
            self.id = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.max_adult.rawValue] {
            self.max_adult = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.max_child.rawValue] {
            self.max_child = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.room_reference.rawValue] {
            self.room_reference = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.per_night_price.rawValue] {
            self.per_night_price = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.guests.rawValue] as? JSONDictionary {
            self.guests = Guest(json: obj)
        }
        if let obj = json[APIKeys.bedtype_id.rawValue] {
            self.bedtype_id = "\(obj)".removeNull
        }

    }
    
    //Mark:- Functions
    //================
    ///Static Function
    static func getRoomsData(response: [JSONDictionary]) -> [RoomsRates] {
        var roomsDataArray = [RoomsRates]()
        for json in response {
            let obj = RoomsRates(json: json)
            roomsDataArray.append(obj)
        }
        return roomsDataArray
    }
}


//Mark:- RoomsBedTypes
//====================
struct  RoomsBedTypes: Hashable {
    
    var hashValue: Int {
        return id.hashValue
    }
    
    static func == (lhs: RoomsBedTypes, rhs: RoomsBedTypes) -> Bool {
        return (lhs.id == rhs.id) && (lhs.type == rhs.type)
    }
    
    //Mark:- Variables
    //================
    var type: String = ""
    var id: String = ""
    
    //Mark:- Initialization
    //=====================
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.type.rawValue: self.type,
                APIKeys.id.rawValue: self.id
        ]
    }
    
    init(json: JSONDictionary) {
        if let obj = json[APIKeys.type.rawValue] {
            self.type = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.id.rawValue] {
            self.id = "\(obj)".removeNull
        }
    }
    
    //Mark:- Functions
    //================
    ///Static Function
    static func getBedTypesData(response: [JSONDictionary]) -> [RoomsBedTypes] {
        var bedDataArray = [RoomsBedTypes]()
        for json in response {
            let obj = RoomsBedTypes(json: json)
            bedDataArray.append(obj)
        }
        return bedDataArray
    }
}


//Mark:- RatesTerms
//=================
struct  RatesTerms {
    
    //Mark:- Variables
    //================
    var meals: String = ""
    var cancellation: String = ""
    
    //Mark:- Initialization
    //=====================
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.meals.rawValue: self.meals,
                APIKeys.cancellation.rawValue: self.cancellation
        ]
    }
    
    init(json: JSONDictionary) {
        if let obj = json[APIKeys.meals.rawValue] {
            self.meals = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.cancellation.rawValue] {
            self.cancellation = "\(obj)".removeNull
        }
    }
    
    //Mark:- Functions
    //================
    ///Static Function
    static func getRatesTermsData(response: JSONDictionary) -> RatesTerms {
        let termsData = RatesTerms(json: response)
        return termsData
    }
}


//Mark:- CancellationPenaltyRates
//===============================
struct CancellationPenaltyRates {
    
    //Mark:- Variables
    //================
    var is_refundable : Bool = false
    
    //Mark:- Initialization
    //=====================
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.is_refundable.rawValue: self.is_refundable
        ]
    }
    
    init(json: JSONDictionary) {
        if let obj = json[APIKeys.is_refundable.rawValue] {
            self.is_refundable = "\(obj)".removeNull == "1" ? true : false
        }
    }
    
    //Mark:- Functions
    //================
    ///Static Function
    static func getCancellationPenaltyData(response: JSONDictionary) -> CancellationPenaltyRates {
        let cancellationPenaltyData = CancellationPenaltyRates(json: response)
        return cancellationPenaltyData
    }
}

//Mark:- PenaltyRates
//===================
struct PenaltyRates {
    
    //Mark:- Variables
    //================
    var to: String = ""
    var from: String = ""
    var penalty: Int = 0
    var tz: String = ""
    var is_refundable: Bool = false
    
    //Mark:- Initialization
    //=====================
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.to.rawValue: self.to,
                APIKeys.penalty.rawValue: self.penalty,
                APIKeys.tz.rawValue: self.tz,
                APIKeys.is_refundable.rawValue: self.is_refundable,
                APIKeys.from.rawValue: self.from
        ]
    }
    
    init(json: JSONDictionary) {
        if let obj = json[APIKeys.to.rawValue] {
            self.to = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.penalty.rawValue] as? Int {
            self.penalty = obj
        }
        if let obj = json[APIKeys.tz.rawValue] {
            self.tz = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.is_refundable.rawValue] {
            self.is_refundable = "\(obj)".removeNull == "1" ? true : false
        }
        if let obj = json[APIKeys.from.rawValue] {
            self.from = "\(obj)".removeNull
        }
    }
    
    //Mark:- Functions
    //================
    ///Static Function
    static func getPenaltyRatesData(response: [JSONDictionary]) -> [PenaltyRates] {
        var penaltyRatesArray = [PenaltyRates]()
        for json in response {
            let obj = PenaltyRates(json: json)
            penaltyRatesArray.append(obj)
        }
        return penaltyRatesArray
    }
}

struct Guest {
    
    //Mark:- Variables
    //================
    var max_adult: String = ""
    var max_child: String = ""
    
    //Mark:- Initialization
    //=====================
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.max_adult.rawValue: self.max_adult,
                APIKeys.max_child.rawValue: self.max_child
        ]
    }
    
    init(json: JSONDictionary) {
        if let obj = json[APIKeys.max_adult.rawValue] {
            self.max_adult = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.max_child.rawValue] {
            self.max_child = "\(obj)".removeNull
        }
    }
}
