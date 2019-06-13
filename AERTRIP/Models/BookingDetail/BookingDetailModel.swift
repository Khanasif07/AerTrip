//
//  BookingDetailModel.swift
//  AERTRIP
//
//  Created by apple on 06/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct BookingDetailModel {
    var id: String = ""
    var bookingNumber: String = ""
    var bookingDate: String = ""
    var communicationNumber: String = ""
    var depart: String = ""
    var billingInfo: BillingDetail?
    var product: String = ""
    var category: String = ""
    var tripType: String = ""
    var specialFare: String = ""
    var bookingDetail: BookingDetail?
    var itineraryId: String = ""
    var cases: [Case] = []
    var receipt: Receipt?
    
    var totalAmountPaid: String = ""
    var vCode: String = ""
    var bookingStatus: String = ""
    var documents: [DocumentDownloadingModel] = []
    var addOnRequestAllowed: Bool = false
    var cancellationRequestAllowed: Bool = false
    var rescheduleRequestAllowed: Bool = false
    var specialRequestAllowed: Bool = false
    var user: UserInfo?
    
    var jsonDict: JSONDictionary {
        return [:]
    }
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["id"] {
            self.id = "\(obj)"
        }
        if let obj = json["booking_number"] {
            self.bookingNumber = "\(obj)"
        }
        if let obj = json["booking_date"] {
            self.bookingDate = "\(obj)"
        }
        
        if let obj = json["communication_number"] {
            self.communicationNumber = "\(obj)"
        }
        
        if let obj = json["depart"] {
            self.depart = "\(obj)"
        }
        
        if let obj = json["product"] {
            self.product = "\(obj)"
        }
        
        if let obj = json["category"] {
            self.category = "\(obj)"
        }
        
        if let obj = json["trip_type"] {
            self.tripType = "\(obj)"
        }
        
        if let obj = json["special_fares"] {
            self.specialFare = "\(obj)"
        }
        
        if let obj = json["bdetails"] as? JSONDictionary {
            self.bookingDetail = BookingDetail(json: obj)
        }
        
        self.cases = Case.retunsCaseArray(jsonArr: json["cases"] as? [JSONDictionary] ?? [])
        if let obj = json["user"] as? UserInfo {
            self.user = obj
        }
        
        if let obj = json["documents"] as? [JSONDictionary] {
            self.documents = DocumentDownloadingModel.getModels(json: obj)
        }
        
        // other data parsing
        if let obj = json["billing_info"] as? JSONDictionary {
            self.billingInfo = BillingDetail(json: obj)
        }
        
        if let obj = json["bdetails"] as? JSONDictionary {
            self.bookingDetail = BookingDetail(json: obj)
        }
    }
}

extension BookingDetailModel {
    var tripCitiesStr: NSMutableAttributedString? {
        func isReturnFlight(forArr: [String]) -> Bool {
            guard !forArr.isEmpty else { return false }
            
            if forArr.count == 3, let first = forArr.first, let last = forArr.last {
                return (first.lowercased() == last.lowercased())
            }
            else {
                return (self.tripType.lowercased() == "return")
            }
        }
        
        func getNormalString(forArr: [String]) -> String {
            guard !forArr.isEmpty else { return "--" }
            return forArr.joined(separator: " → ")
        }
        
        func getReturnString(forArr: [String]) -> String {
            guard forArr.count >= 2 else { return "--" }
            return "\(forArr[0]) ⇋ \(forArr[1])"
        }
        
        guard let tripCts = self.bookingDetail?.tripCities else {
            return NSMutableAttributedString(string: "--")
        }
        
        if self.tripType.lowercased() == "single" {
            // single flight case
            let temp = getNormalString(forArr: tripCts)
            return NSMutableAttributedString(string: temp)
        }
        else if isReturnFlight(forArr: tripCts) {
            // return flight case
            let temp = getReturnString(forArr: tripCts)
            return NSMutableAttributedString(string: temp)
        }
        else {
            // multi flight case
            if let routes = self.bookingDetail?.routes, let travledCity = self.bookingDetail?.travelledCities {
                //travlled some where
                
                if (routes.first ?? []).isEmpty {
                    // still not travlled
                    let temp = getNormalString(forArr: tripCts)
                    return NSMutableAttributedString(string: temp)
                }
                else {
                    var routeStr = ""
                    var travLastIndex: Int = 0
                    var prevCount: Int = 0
                    for route in routes {
                        var temp = route.joined(separator: " → ")
                        
                        if !routeStr.isEmpty {
                            temp = ", \(temp)"
                        }
                        
                        for (idx, ct) in route.enumerated() {
                            let newIdx = idx + prevCount
                            if travledCity.count > newIdx, travledCity[newIdx] == ct {
                                //travelled through this city
                                var currentCityTemp = " \(ct) →"
                                if !routeStr.isEmpty, idx == 0 {
                                    currentCityTemp = ", \(ct) →"
                                }
                                travLastIndex = routeStr.count + currentCityTemp.count
                            }
                        }
                        routeStr += temp
                        prevCount = route.count
                    }
                    
                    let attributedStr1 = NSMutableAttributedString(string: routeStr)
                    if travLastIndex > 0 {
                        attributedStr1.addAttributes([NSAttributedString.Key.foregroundColor: AppColors.themeGray20], range: NSRange(location: 0, length: travLastIndex + 2))
                    }
                    return attributedStr1
                }
            }
            return NSMutableAttributedString(string: "--")
        }
    }
}

struct BookingDetail {
    var tripCities: [String] = []
    var travelledCities: [String] = []
    var disconnected: Bool = false
    var routes: [[String]] = [[]]
    var leg: [Leg] = []
    var journeyCompleted: Int16 = 0
    var travellers: [Traveller] = []
    
    // Keys for Product = Hotel
    
    var bookingHotelId: String = ""
    var hotelAddress: String = ""
    var country: String = ""
    var isRefundable: Bool = false
    var isRefundableKeyPresent: Bool = false
    var rooms: Int = 0
    var roomDetails: [RoomDetailModel] = []
    var pax: [String] = [] // Used for pax details array
    var latitude: String = ""
    var longitude: String = ""
    var cancellation: Cancellation?
    var hotelPhone: String = ""
    var hotelEmail: String = ""
    
    var city: String = ""
    var hotelImage: String = ""
    var hotelStarRating: String = ""
    var taRating: String = ""
    var taReviewCount: String = ""
    var hotelId: String = ""
    var nights: Int = 0
    var checkIn: String = ""
    var checkOut: String = ""
    
    // Product key  = other
    
    var bookingDate: String = ""
    var title: String = ""
    var details: String = ""
    
    var note: String = ""
    var eventStartDate: String = ""
    var eventEndDate: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["trip_cities"] as? [String] {
            self.tripCities = obj
        }
        
        if let obj = json["travelled_cities"] as? [String] {
            self.travelledCities = obj
        }
        
        if let obj = json["disconnected"] as? Bool {
            self.disconnected = obj
        }
        
        if let obj = json["routes"] as? [[String]] {
            self.routes = obj
        }
        
        // Initialising  for hotel
        if let obj = json["booking_hotel_id"] {
            self.bookingHotelId = "\(obj)"
        }
        
        if let obj = json["hotel_address"] {
            self.hotelAddress = "\(obj)"
        }
        
        if let obj = json["country"] {
            self.country = "\(obj)"
        }
        
        if let obj = json["is_refundable"] {
            self.isRefundable = "\(obj)".toBool
            self.isRefundableKeyPresent = true
        }
        else {
            self.isRefundableKeyPresent = false
        }
        
        if let obj = json["rooms"] {
            self.rooms = "\(obj)".toInt ?? 0
        }
        
        // TODO: For Room detail
        
        // TODO: For Cancellation
        
        if let obj = json["latitude"] {
            self.latitude = "\(obj)"
        }
        
        if let obj = json["longitude"] {
            self.longitude = "\(obj)"
        }
        
        if let obj = json["hotel_phone"] {
            self.hotelPhone = "\(obj)"
        }
        
        if let obj = json["hotel_emai"] {
            self.hotelEmail = "\(obj)"
        }
        
        if let obj = json["city"] {
            self.city = "\(obj)"
        }
        if let obj = json["hotel_img"] {
            self.hotelImage = "\(obj)"
        }
        if let obj = json["hotel_star_rating"] {
            self.hotelStarRating = "\(obj)"
        }
        if let obj = json["ta_rating"] {
            self.taRating = "\(obj)"
        }
        
        if let obj = json["ta_review_count"] {
            self.taReviewCount = "\(obj)"
        }
        if let obj = json["hotel_id"] {
            self.hotelId = "\(obj)"
        }
        if let obj = json["nights"] {
            self.nights = "\(obj)".toInt ?? 0
        }
        if let obj = json["check_in"] {
            self.checkIn = "\(obj)"
        }
        
        if let obj = json["check_out"] {
            self.checkOut = "\(obj)"
        }
        
        // Product key other
        
        if let obj = json["title"] {
            self.title = "\(obj)"
        }
        
        if let obj = json["details"] {
            self.details = "\(obj)"
        }
        
        if let obj = json["booking_date"] {
            self.bookingDate = "\(obj)"
        }
        
        self.travellers = Traveller.retunsTravellerArray(jsonArr: json["travellers"] as? [JSONDictionary] ?? [])
        
        // leg parsing
        if let obj = json["leg"] as? [JSONDictionary] {
            self.leg = Leg.getModels(json: obj)
        }
    }
    
    var paymentStatus: String {
        return self.isRefundable ? "Refundable" : " Non-Refundable"
    }
}

// MARK: - Leg ,Flight and pax Details

struct Leg {
    var legId: String = ""
    var origin: String = ""
    var destination: String = ""
    var title: String = ""
    var stops: String = ""
    var refundable: String = ""
    var reschedulable: String = ""
    var fareName: String = ""
    var flight: [FlightDetail] = []
    var halts: String = ""
    var pax: [Pax] = []
    
    init() {}
    
    init(json: JSONDictionary) {
        if let obj = json["leg_id"] {
            self.legId = "\(obj)"
        }
        
        if let obj = json["origin"] {
            self.origin = "\(obj)"
        }
        if let obj = json["destination"] {
            self.destination = "\(obj)"
        }
        if let obj = json["ttl"] {
            self.title = "\(obj)"
        }
        if let obj = json["stops"] {
            self.stops = "\(obj)"
        }
        if let obj = json["refundable"] {
            self.refundable = "\(obj)"
        }
        if let obj = json["reschedulable"] {
            self.reschedulable = "\(obj)"
        }
        if let obj = json["fare_name"] {
            self.fareName = "\(obj)"
        }
        
        // other parsing
        if let obj = json["flights"] as? [JSONDictionary] {
            self.flight = FlightDetail.getModels(json: obj)
        }
        
        if let obj = json["pax"] as? [JSONDictionary] {
            self.pax = Pax.getModels(json: obj)
        }
    }
    
    var flightNumbers: [String] {
        return self.flight.map({ $0.flightNumber })
    }
    
    var carrierCodes: [String] {
        return self.flight.map({ $0.carrierCode })
    }
    
    var carriers: [String] {
        return self.flight.map({ $0.carrier })
    }
    
    var cabinClass: String {
        return self.flight.map({ $0.cabinClass }).joined(separator: ",")
    }
    
    var legDuration: Double {
        var duration: Double = 0
        for flight in self.flight {
            let flightLayOverTime = flight.layoverTime + flight.flightTime
            duration += flightLayOverTime
        }
        return duration
    }
    
    // TODO: need to flight.halt key
    var numberOfStop: Int {
        return self.flight.count
    }
    
    static func getModels(json: [JSONDictionary]) -> [Leg] {
        return json.map { Leg(json: $0) }
    }
}

struct FlightDetail {
    var flightId: String = ""
    var departure: String = ""
    var departureAirport: String = ""
    var departureTerminal: String = ""
    var departureCountry: String = ""
    var departureCountryCode: String = ""
    var departCity: String = ""
    
    var departDate: String = ""
    var departureTime: String = ""
    var arrival: String = ""
    var arrivalAirport: String = ""
    var arrivalTerminal: String = ""
    var arrivalCountry: String = ""
    var arrivalCity: String = ""
    var arrivalCountryCode: String = ""
    var arrivalDate: String = ""
    var arrivalTime: String = ""
    var flightTime: Double = 0.0
    var carrier: String = ""
    var carrierCode: String = ""
    var flightNumber: String = ""
    var equipment: String = ""
    var equipmentDescription: String = ""
    var equipmentDescription2: String = ""
    var equipmentLayout: String = ""
    var quality: String = ""
    var cabinClass: String = ""
    var operatedBy: String = ""
    var baggage: Baggage?
    var icc: Int = 0
    var originWeather: Weather?
    var destinationWeather: Weather?
    var layoverTime: Double = 0.0
    var changeOfPlane: Int = 0
    var bookingClass: String = ""
    var fbn: String = ""
    var amenities: [ATAmenity] = []
    
    var numberOfCell: Int {
        var temp: Int = 2
        
        if !self.amenities.isEmpty {
            temp += 1
        }
        
        if self.layoverTime > 0 {
            temp += 1
        }
        return temp
    }
    
    let numberOfAmenitiesInRow: Double = 4.0
    var totalRowsForAmenities: Int {
        let cont: Double = Double(self.amenities.count)
        let val = Double(cont / numberOfAmenitiesInRow)
        let diff = val - floor(val)
        var total = Int(floor(val))
        if diff > 0.0, diff < 1.0 {
            total += 1
        }
        return total
    }
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["flight_id"] {
            self.flightId = "\(obj)"
        }
        
        if let obj = json["departure"] {
            self.departure = "\(obj)"
        }
        
        if let obj = json["departure_airport"] {
            self.departureAirport = "\(obj)"
        }
        
        if let obj = json["departure_terminal"] {
            self.departureTerminal = "\(obj)"
        }
        
        if let obj = json["departure_country"] {
            self.departureCountry = "\(obj)"
        }
        
        if let obj = json["departure_country_code"] {
            self.departureCountryCode = "\(obj)"
        }
        
        if let obj = json["depart_city"] {
            self.departCity = "\(obj)"
        }
        
        if let obj = json["depart_date"] {
            self.departDate = "\(obj)"
        }
        
        if let obj = json["departure_time"] {
            self.departureTime = "\(obj)"
        }
        
        if let obj = json["arrival"] {
            self.arrival = "\(obj)"
        }
        
        if let obj = json["arrival_airport"] {
            self.arrivalAirport = "\(obj)"
        }
        
        if let obj = json["arrival_terminal"] {
            self.arrivalTerminal = "\(obj)"
        }
        
        if let obj = json["arrival_country"] {
            self.arrivalCountry = "\(obj)"
        }
        
        if let obj = json["arrival_city"] {
            self.arrivalCity = "\(obj)"
        }
        
        if let obj = json["arrival_country_code"] {
            self.arrivalCountryCode = "\(obj)"
        }
        
        if let obj = json["arrival_date"] {
            self.arrivalDate = "\(obj)"
        }
        if let obj = json["arrival_time"] {
            self.arrivalTime = "\(obj)"
        }
        if let obj = json["flight_time"] {
            self.flightTime = "\(obj)".toDouble ?? 0.0
        }
        if let obj = json["carrier"] {
            self.carrier = "\(obj)"
        }
        if let obj = json["carrier_code"] {
            self.carrierCode = "\(obj)"
        }
        if let obj = json["flight_number"] {
            self.flightNumber = "\(obj)"
        }
        if let obj = json["equipment"] {
            self.equipment = "\(obj)"
        }
        if let obj = json["equipment_description"] {
            self.equipmentDescription = "\(obj)"
        }
        
        if let obj = json["equipment_description_2"] {
            self.equipmentDescription2 = "\(obj)"
        }
        
        if let obj = json["equipment_layout"] {
            self.equipmentLayout = "\(obj)"
        }
        if let obj = json["qualiy"] {
            self.quality = "\(obj)"
        }
        if let obj = json["cabin_class"] {
            self.cabinClass = "\(obj)"
        }
        if let obj = json["operated_by"] {
            self.operatedBy = "\(obj)"
        }
        
        if let obj = json["icc"] {
            self.icc = "\(obj)".toInt ?? 0
        }
        
        // origin weather
        if let obj = json["origin_weather"] as? JSONDictionary {
            self.originWeather = Weather(json: obj)
        }
        
        // destination weather
        
        if let obj = json["dest_weather"] as? JSONDictionary {
            self.destinationWeather = Weather(json: obj)
        }
        
        if let obj = json["layover_time"] {
            self.layoverTime = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["change_of_plane"] {
            self.changeOfPlane = "\(obj)".toInt ?? 0
        }
        
        if let obj = json["booking_class"] {
            self.bookingClass = "\(obj)"
        }
        
        if let obj = json["fbn"] {
            self.fbn = "\(obj)"
        }
        
        // TODO: parse the real data for amenities
        self.amenities = [ATAmenity.Wifi, ATAmenity.Gym, ATAmenity.Internet, ATAmenity.Pool, ATAmenity.RoomService]
    }
    
    static func getModels(json: [JSONDictionary]) -> [FlightDetail] {
        return json.map { FlightDetail(json: $0) }
    }
    
    // computed
    var equipmentDetails: String {
        var finalStr = ""
        if !self.equipment.isEmpty {
            finalStr = self.equipment
        }
        if !self.equipmentDescription.isEmpty {
            finalStr += "\n\(self.equipmentDescription)"
        }
        if !self.equipmentDescription2.isEmpty {
            finalStr += "\n\(self.equipmentDescription2)"
        }
        if !self.equipmentLayout.isEmpty {
            finalStr += "\n\(self.equipmentLayout)"
        }
        
        return finalStr
    }
}

struct Baggage {
    var bg: Bg?
    var cbg: Cbg?
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["bg"] as? JSONDictionary {
            self.bg = Bg(json: obj)
        }
        
        if let obj = json["cbg"] as? JSONDictionary {
            self.cbg = Cbg(json: obj)
        }
    }
}

// Structure for baggage
struct Bg {
    var adt: String = ""
    var notes: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["adt"] {
            self.adt = "\(obj)"
        }
        
        if let obj = json["notes"] {
            self.notes = "\(obj)"
        }
    }
}

// Structure for Cbg

struct Cbg {
    var adt: ADT?
    var dimension: Dimension?
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["ADT"] as? JSONDictionary {
            self.adt = ADT(json: obj)
        }
        
        if let obj = json["dimension"] as? JSONDictionary {
            self.dimension = Dimension(json: obj)
        }
    }
}

struct ADT {
    var weight: String = ""
    var piece: String = "" // Now its coming as null, what does this mean
    var dimension: Dimension?
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["weight"] {
            self.weight = "\(obj)"
        }
        
        if let obj = json["piece"] {
            self.piece = "\(obj)"
        }
        
        if let obj = json["dimension"] as? JSONDictionary {
            self.dimension = Dimension(json: obj)
        }
    }
}

struct Dimension {
    var cm: Cm?
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["cm"] as? JSONDictionary {
            self.cm = Cm(json: obj)
        }
    }
}

struct Cm {
    var width: String = ""
    var height: String = ""
    var depth: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["width"] {
            self.width = "\(obj)"
        }
        
        if let obj = json["height"] {
            self.height = "\(obj)"
        }
        if let obj = json["depth"] {
            self.depth = "\(obj)"
        }
    }
}

struct Weather {
    var maxTemperature: String = ""
    var minTemperature: String = ""
    var weather: String = ""
    var weatherIcon: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["min_temperature"] {
            self.minTemperature = "\(obj)"
        }
        
        if let obj = json["max_temperature"] {
            self.maxTemperature = "\(obj)"
        }
        if let obj = json["weather"] {
            self.weather = "\(obj)"
        }
        if let obj = json["weather_icon"] {
            self.weatherIcon = "\(obj)"
        }
    }
}

// Billing Details

struct BillingDetail {
    var email: String = ""
    var communicationNumber: String = ""
    var billingName: String = ""
    var gst: String = ""
    var address: BillingAddress?
    
    var jsonDict: JSONDictionary {
        return [:]
    }
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["email"] {
            self.email = !"\(obj)".isEmpty ? "\(obj)" : "-"
        }
        if let obj = json["communication_number"] {
            self.communicationNumber = !"\(obj)".isEmpty ? "\(obj)" : "-"
        }
        if let obj = json["billing_name"] {
            self.billingName = !"\(obj)".isEmpty ? "\(obj)" : "-"
        }
        
        if let obj = json["gst"] {
            self.gst = !"\(obj)".isEmpty ? "\(obj)" : "-"
        }
        
        if let obj = json["address"] as? JSONDictionary {
            self.address = BillingAddress(json: obj)
        }
    }
}

struct BillingAddress {
    var addressLine1: String = ""
    var addressLine2: String = ""
    var city: String = ""
    var state: String = ""
    var postalCode: String = ""
    var country: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["address_line1"] {
            self.addressLine1 = "\(obj)"
        }
        
        if let obj = json["address_line2"] {
            self.addressLine2 = "\(obj)"
        }
        
        if let obj = json["city"] {
            self.city = "\(obj)"
        }
        
        if let obj = json["state"] {
            self.state = "\(obj)"
        }
        
        if let obj = json["postal_code"] {
            self.postalCode = "\(obj)"
        }
        
        if let obj = json["country"] {
            self.country = "\(obj)"
        }
    }
    
    var completeAddress: String {
        return self.addressLine1 + "," + self.addressLine2 + "," + self.city + "," + self.state + "," + self.postalCode + "," + self.country
    }
}

// Passenger Detail

struct Pax {
    var paxId: String = ""
    var uPid: String = ""
    var salutation: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var paxName: String = ""
    var paxType: String = ""
    var status: String = ""
    var amountPaid: Double = 0.0
    var cancellationCharge: String = ""
    var rescheduleCharge: String = ""
    var ticket: String = ""
    var pnr: String = ""
    var inProcess: Bool = false
    
    var addOns: JSONDictionary = [:] // TODO: Need to confirm this with yash as always coming in array
    var seat: String {
        if let obj = addOns["seat"] as? String, !obj.isEmpty {
            return obj
        }
        return LocalizedString.na.localized
    }
    
    var meal: String {
        if let obj = addOns["meal"] as? String, !obj.isEmpty {
            return obj
        }
        return LocalizedString.na.localized
    }
    
    var baggage: String {
        if let obj = addOns["baggage"] as? String, !obj.isEmpty {
            return obj
        }
        return LocalizedString.na.localized
    }
    
    var others: String {
        return LocalizedString.na.localized
    }
    
    var fullName: String {
        return "\(self.salutation) \(self.paxName)"
    }
    
    var detailsToShow: JSONDictionary {
        var temp = JSONDictionary()
        
        temp["0PNR"] = pnr
        temp["1Ticket Number"] = ticket
        temp["2Seat"] = seat
        temp["3Meal"] = meal
        temp["4Baggage"] = baggage
        temp["5Others"] = others
        
        return temp
    }
    
    var salutationImage: UIImage {
        switch self.salutation {
        case "Mrs":
            return #imageLiteral(resourceName: "woman")
        case "Mr":
            return #imageLiteral(resourceName: "man")
        case "Mast":
            return #imageLiteral(resourceName: "man")
        case "Miss":
            return #imageLiteral(resourceName: "girl")
        case "Ms":
            return #imageLiteral(resourceName: "woman")
        default:
            return #imageLiteral(resourceName: "person")
        }
    }
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["pax_id"] {
            self.paxId = "\(obj)"
        }
        if let obj = json["upid"] {
            self.uPid = "\(obj)"
        }
        if let obj = json["salutation"] {
            self.salutation = "\(obj)"
        }
        if let obj = json["first_name"] {
            self.firstName = "\(obj)"
        }
        if let obj = json["last_name"] {
            self.lastName = "\(obj)"
        }
        if let obj = json["pax_name"] {
            self.paxName = "\(obj)"
        }
        if let obj = json["pax_type"] {
            self.paxType = "\(obj)"
        }
        if let obj = json["status"] {
            self.status = "\(obj)"
        }
        if let obj = json["amount_paid"] {
            self.amountPaid = "\(obj)".toDouble ?? 0.0
        }
        if let obj = json["cancellation_charge"] {
            self.cancellationCharge = "\(obj)"
        }
        
        if let obj = json["reschedule_charge"] {
            self.rescheduleCharge = "\(obj)"
        }
        if let obj = json["ticket"] {
            self.ticket = "\(obj)"
            self.ticket = self.ticket.isEmpty ? LocalizedString.na.localized : self.ticket
        }
        if let obj = json["pnr"] {
            self.pnr = "\(obj)"
            self.pnr = self.pnr.isEmpty ? LocalizedString.na.localized : self.pnr
        }
        if let obj = json["addons"] as? JSONDictionary, let addon = obj["addon"] as? JSONDictionary {
            self.addOns = addon
        }
        
        if let obj = json["in_process"] as? Bool {
            self.paxId = "\(obj)"
        }
    }
    
    static func getModels(json: [JSONDictionary]) -> [Pax] {
        return json.map { Pax(json: $0) }
    }
}

// Struct Case

struct Case {
    var id: String = ""
    var casedId: String = ""
    var caseType: String = ""
    var typeSlug: String = ""
    var caseName: String = ""
    var caseStatus: String = ""
    var resolutionStatusId: String = ""
    var resolutionStatus: String = ""
    var requestDate: String = ""
    var csrName: String = ""
    var resolutionDate: String = ""
    var closedDate: String = ""
    var flag: String = ""
    var note: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["id"] {
            self.id = "\(obj)"
        }
        
        if let obj = json["case_id"] {
            self.casedId = "\(obj)"
        }
        
        if let obj = json["case_type"] {
            self.caseType = "\(obj)"
        }
        
        if let obj = json["type_slug"] {
            self.typeSlug = "\(obj)"
        }
        
        if let obj = json["case_status"] {
            self.caseName = "\(obj)"
        }
        
        if let obj = json["resolution_status_id"] {
            self.resolutionStatusId = "\(obj)"
        }
        
        if let obj = json["resolution_status"] {
            self.resolutionStatus = "\(obj)"
        }
        if let obj = json["request_date"] {
            self.requestDate = "\(obj)"
        }
        
        if let obj = json["csr_name"] {
            self.csrName = "\(obj)"
        }
        if let obj = json["resolution_date"] {
            self.resolutionDate = "\(obj)"
        }
        
        if let obj = json["closed_date"] {
            self.closedDate = "\(obj)"
        }
        
        if let obj = json["flag"] {
            self.flag = "\(obj)"
        }
        if let obj = json["note"] {
            self.note = "\(obj)"
        }
    }
    
    static func retunsCaseArray(jsonArr: [JSONDictionary]) -> [Case] {
        var cases = [Case]()
        for element in jsonArr {
            cases.append(Case(json: element))
        }
        return cases
    }
}

struct Receipt {
    var voucher: [Voucher] = []
    var totalAmountDue: String = ""
    var totalAmountPaid: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["total_amount_due"] {
            self.totalAmountDue = "\(obj)"
        }
        
        if let obj = json["total_amount_paid"] {
            self.totalAmountPaid = "\(obj)"
        }
        
        if let obj = json["voucher"] as? [JSONDictionary] {
            self.voucher = Voucher.getModels(json: obj)
        }
    }
}

struct Voucher {
    var basic: Basic?
    var transaction: Transactions?
    var paymentInfo: BookingPaymentInfo?
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["basic"] as? JSONDictionary {
            self.basic = Basic(json: obj)
        }
        
        if let obj = json["transaction"] as? JSONDictionary {
            self.transaction = Transactions(json: obj)
        }
        
        if let obj = json["paymentinfo"] as? JSONDictionary {
            self.paymentInfo = BookingPaymentInfo(json: obj)
        }
    }
    
    static func getModels(json: [JSONDictionary]) -> [Voucher] {
        return json.map { Voucher(json: $0) }
    }
}

struct Basic {
    var id: String = ""
    var voucherType: String = ""
    var name: String = ""
    var event: String = ""
    var type: String = ""
    var typeSlug: String = ""
    var pattern: String = ""
    var lastNumber: String = ""
    var isActive: String = ""
    var voucherNo: String = ""
    var transactionDateTime: String = ""
    var transactionId: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["id"] {
            self.id = "\(obj)"
        }
        if let obj = json["voucher_type"] {
            self.voucherType = "\(obj)"
        }
        if let obj = json["name"] {
            self.name = "\(obj)"
        }
        if let obj = json["event"] {
            self.event = "\(obj)"
        }
        if let obj = json["type"] {
            self.type = "\(obj)"
        }
        if let obj = json["type_slug"] {
            self.typeSlug = "\(obj)"
        }
        if let obj = json["pattern"] {
            self.pattern = "\(obj)"
        }
        if let obj = json["last_number"] {
            self.lastNumber = "\(obj)"
        }
        if let obj = json["is_active"] {
            self.isActive = "\(obj)"
        }
        if let obj = json["voucher_no"] {
            self.voucherNo = "\(obj)"
        }
        if let obj = json["transaction_datetime"] {
            self.voucherType = "\(obj)"
        }
        if let obj = json["transaction_id"] {
            self.transactionId = "\(obj)"
        }
    }
}

struct Transactions {
    var taxesAndFees: TaxesAndFees?
    var baseFare: Amount?
    var grandTotal: Amount?
    var totalPayableNow: Amount?
    var total: Amount?
    var grossFare: Amount?
    var netFare: Amount?
    
    // TODO: need to Add after discussion with Nitesh
//    [
//    {
//    "amount": "-364238.00",
//    "ledger_name": "RazorPay"
//    }
//    ]
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["Taxes and Fees"] as? JSONDictionary {
            self.taxesAndFees = TaxesAndFees(json: obj)
        }
        
        if let obj = json["Base Fare"] as? JSONDictionary {
            self.baseFare = Amount(json: obj)
        }
        
        if let obj = json["Grand Total"] as? JSONDictionary {
            self.grandTotal = Amount(json: obj)
        }
        
        if let obj = json["Total Payable Now"] as? JSONDictionary {
            self.totalPayableNow = Amount(json: obj)
        }
        
        if let obj = json["total"] as? JSONDictionary {
            self.total = Amount(json: obj)
        }
        
        if let obj = json["grossFare"] as? JSONDictionary {
            self.grossFare = Amount(json: obj)
        }
        
        if let obj = json["Net Amount"] as? JSONDictionary {
            self.netFare = Amount(json: obj)
        }
    }
}

struct BookingPaymentInfo {
    var orderId: String = ""
    var pgFee: String = ""
    var pgTax: String = ""
    var transDate: String = ""
    var paymentId: String = ""
    var method: String = ""
    var bankName: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["order_id"] {
            self.orderId = "\(obj)"
        }
        
        if let obj = json["pg_fee"] {
            self.pgFee = "\(obj)"
        }
        
        if let obj = json["pg_tax"] {
            self.pgTax = "\(obj)"
        }
        
        if let obj = json["trans_date"] {
            self.transDate = "\(obj)"
        }
        if let obj = json["payment_id"] {
            self.paymentId = "\(obj)"
        }
        if let obj = json["method"] {
            self.method = "\(obj)"
        }
        if let obj = json["bank_name"] {
            self.bankName = "\(obj)"
        }
    }
}

struct TaxesAndFees {
    var codes: [Codes] = []
    var total: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["codes"] as? [String: Any] {
            self.codes = Codes.models(json: obj)
        }
        if let obj = json[total] {
            self.total = "\(obj)"
        }
    }
}

struct Amount {
    var amount: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["amount"] {
            self.amount = "\(obj)"
        }
    }
}

struct Codes {
    var code: String = ""
    var ledgerName: String = ""
    var amount: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["id"] {
            self.code = "\(obj)"
        }
        
        if let obj = json["ledger_name"] {
            self.ledgerName = "\(obj)"
        }
        
        if let obj = json["amount"] {
            self.amount = "\(obj)"
        }
    }
    
    static func models(json: JSONDictionary) -> [Codes] {
        var codes = [Codes]()
        
        let keyArr: [String] = Array(json.keys)
        for key in keyArr {
            if var temp = json[key] as? [String: Any] {
                temp["id"] = key
                codes.append(Codes(json: temp))
            }
        }
        return codes
    }
}
