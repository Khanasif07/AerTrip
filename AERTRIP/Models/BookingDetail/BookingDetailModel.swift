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
    var bookingDate: Date?
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
    
    var totalAmountPaid: Double = 0.0
    var vCode: String = ""
    var bookingStatus: String = ""
    var documents: [DocumentDownloadingModel] = []
    var additionalInformation: AdditionalInformation?
    var addOnRequestAllowed: Bool = false
    var cancellationRequestAllowed: Bool = false
    var rescheduleRequestAllowed: Bool = false
    var specialRequestAllowed: Bool = false
    var weatherInfo: [WeatherInfo] = []
    var tempDateTripCityArray: [WeatherInfo] = []
    var user: UserInfo?
    var tripWeatherData: [WeatherInfo] = []
    var weatherDisplayedWithin16Info: Bool = false
    
    var jsonDict: JSONDictionary {
        return [:]
    }
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["id"] {
            self.id = "\(obj)".removeNull
        }
        if let obj = json["booking_number"] {
            self.bookingNumber = "\(obj)".removeNull
        }
        if let obj = json["booking_date"] {
            self.bookingDate = "\(obj)".removeNull.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        if let obj = json["communication_number"] {
            self.communicationNumber = "\(obj)".removeNull
        }
        
        if let obj = json["depart"] {
            self.depart = "\(obj)".removeNull
        }
        
        if let obj = json["product"] {
            self.product = "\(obj)".removeNull
        }
        
        if let obj = json["category"] {
            self.category = "\(obj)".removeNull
        }
        
        if let obj = json["trip_type"] {
            self.tripType = "\(obj)".removeNull
        }
        
        if let obj = json["special_fares"] {
            self.specialFare = "\(obj)".removeNull
        }
        
        if let obj = json["bdetails"] as? JSONDictionary {
            self.bookingDetail = BookingDetail(json: obj, bookingId: self.id)
        }
        
        if let data = json["cases"] as? [JSONDictionary], !data.isEmpty {
            self.cases = Case.retunsCaseArray(jsonArr: data, bookindId: self.id)
        }
        
        if let obj = json["user"] as? UserInfo {
            self.user = obj
        }

        
        // M
        if let obj = json["receipt"] as? JSONDictionary {
            self.receipt = Receipt(json: obj, bookingId: self.id)
        }
        
        if let obj = json["total_amount_paid"] {
            self.totalAmountPaid = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["documents"] as? [JSONDictionary] {
            self.documents = DocumentDownloadingModel.getModels(json: obj)
        }
        
        // Additional information data like web checkins,directions, and  Airports , Airlines and Aertrip
        if let obj = json["additional_informations"] as? JSONDictionary {
            self.additionalInformation = AdditionalInformation(json: obj)
        }
        
        // other data parsing
        if let obj = json["billing_info"] as? JSONDictionary {
            self.billingInfo = BillingDetail(json: obj)
        }

        //receipt
        if let obj = json["receipt"] as? JSONDictionary {
            self.receipt = Receipt(json: obj, bookingId: self.id)
        }

        if let obj = json["addon_request_allowed"] {
            self.addOnRequestAllowed = "\(obj)".toBool
        }
        
        if let obj = json["cancellation_request_allowed"] {
            self.cancellationRequestAllowed = "\(obj)".toBool
        }
        
        if let obj = json["reschedule_request_allowed"] {
            self.rescheduleRequestAllowed = "\(obj)".toBool
        }
        
        if let obj = json["special_request_allowed"] {
            self.specialRequestAllowed = "\(obj)".toBool
        }
        
        let testData = [
            [
                "max_temperature": 27,
                "min_temperature": 17,
                "weather": "Moderate rain",
                "weather_icon": "501-moderate-rain",
                "temperature": 0,
                "date": "2019-07-01 22:35:00",
                "country_code": "DE",
                "city": "Munich"
            ],
            [
                "max_temperature": 34,
                "min_temperature": 33,
                "weather": "Clear sky",
                "weather_icon": "800-clear-sky",
                "temperature": 0,
                "date": "2019-07-02 06:35:00",
                "country_code": "AE",
                "city": "Abu Dhabi"
            ],
            [
                "max_temperature": 34,
                "min_temperature": 33,
                "weather": "Clear sky",
                "weather_icon": "800-clear-sky",
                "temperature": 0,
                "date": "2019-07-02 14:20:00",
                "country_code": "AE",
                "city": "Abu Dhabi"
            ],
            [
                "max_temperature": 29,
                "min_temperature": 29,
                "weather": "Heavy intensity rain",
                "weather_icon": "502-heavy-intensity-rain",
                "temperature": 0,
                "date": "2019-07-02 19:15:00",
                "country_code": "IN",
                "city": "Mumbai"
            ]
        ]
        
        self.weatherInfo = WeatherInfo.getModels(json: testData)
        
        if self.product == "flight" {
            for leg in self.bookingDetail?.leg ?? [] {
                for flight in leg.flight {
                    var weather = WeatherInfo()
                    weather.date = flight.departDate
                    weather.city = flight.departCity
                    weather.countryCode = flight.departureCountryCode
                    self.tripWeatherData.append(weather)
                }
            }
            
            if !self.weatherInfo.isEmpty {
                for (i, weatherInfoData) in self.weatherInfo.enumerated() {
                    for (_, weatherTripInfoData) in self.tripWeatherData.enumerated() {
                        if weatherInfoData.date == weatherTripInfoData.date, weatherInfoData.countryCode == weatherTripInfoData.countryCode, weatherInfoData.city == weatherTripInfoData.city {
                            self.tripWeatherData[i] = weatherInfoData
                        }
                    }
                }
            }
            
            for tripWeatherData in self.tripWeatherData {
                if tripWeatherData.temperature == 0 {
                    self.weatherDisplayedWithin16Info = true
                    break
                }
            }
        }
        else {
            let datesBetweenArray = Date.dates(from: self.bookingDetail?.checkIn ?? Date(), to: self.bookingDetail?.checkOut ?? Date())
            for date in datesBetweenArray {
                var weatherInfo = WeatherInfo()
                weatherInfo.date = date
                self.tripWeatherData.append(weatherInfo)
            }
            
            if !self.weatherInfo.isEmpty {
                for (i, weatherInfoData) in self.weatherInfo.enumerated() {
                    for (_, weatherTripInfoData) in self.tripWeatherData.enumerated() {
                        if weatherInfoData.date == weatherTripInfoData.date {
                            self.tripWeatherData[i] = weatherInfoData
                        }
                    }
                }
            }
            
            for tripWeatherData in self.tripWeatherData {
                if tripWeatherData.temperature == 0 {
                    self.weatherDisplayedWithin16Info = true
                    break
                }
            }
        }
    }
    
    var numberOfPassenger: Int {
        var count = 0
        for leg in self.bookingDetail?.leg ?? [] {
            count += leg.pax.count
        }
        return count
    }
}

//MARK: - extension for Calculation

//MARK: -

extension BookingDetailModel {
    func isReturnFlight(forArr: [String] = []) -> Bool {
        func checkByTripType() -> Bool {
            return (self.tripType.lowercased() == "return") || (self.tripType.lowercased() == "multi")
        }
        
        guard !forArr.isEmpty else { return checkByTripType() }
        
        if forArr.count == 3, let first = forArr.first, let last = forArr.last {
            return (first.lowercased() == last.lowercased())
        }
        else {
            return checkByTripType()
        }
    }
    
    var tripCitiesStr: NSMutableAttributedString? {
        func getNormalString(forArr: [String]) -> String {
            guard !forArr.isEmpty else { return LocalizedString.dash.localized }
            return forArr.joined(separator: " → ")
        }
        
        func getReturnString(forArr: [String]) -> String {
            guard forArr.count >= 2 else { return LocalizedString.dash.localized }
            return "\(forArr[0]) ⇋ \(forArr[1])"
        }
        
        guard let tripCts = self.bookingDetail?.tripCities else {
            return NSMutableAttributedString(string: LocalizedString.dash.localized)
        }
        
        if self.tripType.lowercased() == "single" {
            // single flight case
            let temp = getNormalString(forArr: tripCts)
            return NSMutableAttributedString(string: temp)
        }
        else if self.isReturnFlight(forArr: tripCts) {
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
            return NSMutableAttributedString(string: LocalizedString.dash.localized)
        }
    }
    
    /*
    Loop through the vouchers array, consider the object that has
    voucher.basic.voucher_type  = ‘sales’ (Must be only 1)
    voucher.transactions.Total.amount  gives the Booking Price.
    */
    
    var bookingPrice: Double {
        var price: Double = 0.0
        for voucher in self.receipt?.voucher ?? [] {
            if voucher.basic?.voucherType.lowercased() == ATVoucherType.sales.value, let totalTran = voucher.transactions.filter({ $0.ledgerName.lowercased() == "total" }).first {
                price = totalTran.amount
                break
            }
        }
        return price
    }
    
    /*
 Loop through vouchers array, consider the objects that have
 voucher.basic.voucher_type  = ‘sales_addon’ (Can be 0 or more)
     
 Sum of sales_addon’s voucher.transactions.Total.amount
 */
    
    var addOnAmount: Double {
        var price: Double = 0.0
        for voucher in self.receipt?.voucher ?? [] {

            if voucher.basic?.voucherType.lowercased() == ATVoucherType.salesAddon.value, let totalTran = voucher.transactions.filter({ $0.ledgerName.lowercased() == "total" }).first {
                price += totalTran.amount
            }
        }
        return price
    }
    
    /*
    Cancellation :
    Loop through vouchers array, consider the objects that have
    voucher.basic.voucher_type  = ‘sales_return_jv’ (Can be 0 or more)
     
    Sum of sales_return_jv’s voucher.transactions.Total.amount
    */
    
    var cancellationAmount: Double {
        var price: Double = 0.0
        for voucher in self.receipt?.voucher ?? [] {

            if voucher.basic?.voucherType.lowercased() == ATVoucherType.saleReturn.value, let totalTran = voucher.transactions.filter({ $0.ledgerName.lowercased() == "total" }).first {
                price += totalTran.amount
            }
        }
        return price
    }
    
    //TODO: Reschedule Amount Not coming in the Api , Already inform the same to Yash
    
    /*
    Reschedule :
    Loop through vouchers array, consider the objects that have
    voucher.basic.voucher_type  = ‘reschedule_sales_return_jv’ (Can be 0 or more)
     
    Sum of  reschedule_sales_return_jv’s  voucher.transactions.Total.amount
     */
    var rescheduleAmount: Double {
        var price: Double = 0.0
        for voucher in self.receipt?.voucher ?? [] {

            if voucher.basic?.voucherType.lowercased() == ATVoucherType.saleReschedule.value, let totalTran = voucher.transactions.filter({ $0.ledgerName.lowercased() == "total" }).first {
                price += totalTran.amount
            }
        }
        return price
    }
    
    // Paid :
    //Total_amount_paid
    
    var paid: Double {
        return self.totalAmountPaid
    }
    
    // Refund Amount: Total of cancellations + Total of Reschedules
    
    var refundAmount: Double {
        return self.rescheduleAmount + self.cancellationAmount
    }
    
    // Total cost of booking = Sale’s amount + sum(add-on)
    
    var totalCostOfBooking: Double {
        //TODO: need to disucss sale amount :
        let saleAmount: Double = self.bookingPrice
        return saleAmount + self.addOnAmount
    }
    
    // Total amount received = Total_amount_paid
    // Can be calculated by adding Total of all receipts
    
    var totalAmountReceived: Double {
        return self.totalAmountPaid
    }
    
//    Total outstanding = total_amount_due
//    Total cost of booking - Total amount received
    
    var totalOutStanding: Double {
        return self.receipt?.totalAmountDue ?? 0.0
    }
    
    // Web checking url
    
    var webCheckinUrl: String {
        
        return ""
        
//<<<<<<< HEAD
//        if let legs = self.bookingDetail?.leg, let index = legs.firstIndex(where: { $0.completed == 0 }) {
//            return (index < (self.additionalInformation?.webCheckins.count ?? 0)) ? (self.additionalInformation?.webCheckins[index] ?? "") : ""
//        }
//        else {
//            //TODO:- handeling for hotels
//            return self.additionalInformation?.webCheckins.first ?? ""
//=======
//        if self.bookingDetail?.journeyCompleted == 1 {
//            return ""
//        }
//        else {
//            if let index = self.bookingDetail?.leg.firstIndex(where: { (result) -> Bool in
//                (result.completed == 0)
//            }) {
//                if index < self.additionalInformation?.webCheckins.count ?? 0 {
//                    return self.additionalInformation?.webCheckins[index] ?? ""
//                }
//                else {
//                    return ""
//                }
//            }
//            return ""
//>>>>>>> a25d55e28d68e7d84892a879f26378ca8745255d
//        }
    }
}

struct BookingDetail {
    var tripCities: [String] = []
    var travelledCities: [String] = []
    var disconnected: Bool = false
    var routes: [[String]] = [[]]
    var leg: [Leg] = []
    var journeyCompleted: Int = 0
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
    var hotelName: String = ""
    var hotelImage: String = ""
    var hotelStarRating: Double = 0.0
    var taRating: Double = 0.0
    var taReviewCount: String = ""
    var hotelId: String = ""
    var nights: Int = 0
    var checkIn: Date?
    var checkOut: Date?
    
    // Product key  = other
    
    var bookingDate: String = ""
    var title: String = ""
    var details: String = ""
    
    var note: String = ""
    var eventStartDate: Date?
    var eventEndDate: Date?
    
    
    var bookingId: String = ""
    
    init() {
        self.init(json: [:], bookingId: "")
    }
    
    init(json: JSONDictionary, bookingId: String) {
        
        self.bookingId = bookingId
        
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
            self.bookingHotelId = "\(obj)".removeNull
        }
        
        if let obj = json["hotel_address"] {
            self.hotelAddress = "\(obj)".removeNull
        }
        
        if let obj = json["country"] {
            self.country = "\(obj)".removeNull
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
        
        if let obj = json["cancellation"] as? JSONDictionary {
            self.cancellation = Cancellation(json: obj)
        }
        
        if let obj = json["latitude"] {
            self.latitude = "\(obj)".removeNull
        }
        
        if let obj = json["longitude"] {
            self.longitude = "\(obj)".removeNull
        }
        
        if let obj = json["hotel_phone"] {
            self.hotelPhone = "\(obj)".removeNull
        }
        
        if let obj = json["hotel_emai"] {
            self.hotelEmail = "\(obj)".removeNull
        }
        
        if let obj = json["city"] {
            self.city = "\(obj)".removeNull
        }
        if let obj = json["hotel_name"] {
            self.hotelName = "\(obj)".removeNull
        }
        if let obj = json["hotel_img"] {
            self.hotelImage = "\(obj)".removeNull
        }
        if let obj = json["hotel_star_rating"] {
            self.hotelStarRating = "\(obj)".toDouble ?? 0.0
        }
        if let obj = json["ta_rating"] {
            self.taRating = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["ta_review_count"] {
            self.taReviewCount = "\(obj)".removeNull
        }
        if let obj = json["hotel_id"] {
            self.hotelId = "\(obj)".removeNull
        }
        if let obj = json["nights"] {
            self.nights = "\(obj)".toInt ?? 0
        }
        if let obj = json["check_in"] {
            //"2019-08-07 00:00:00"
            self.checkIn = "\(obj)".removeNull.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        if let obj = json["check_out"] {
            //"2019-08-07 00:00:00"
            self.checkOut = "\(obj)".removeNull.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        
        // Event start and end date and notes
        
        if let obj = json["note"] {
            self.note = "\(obj)".removeNull
        }
        
        if let obj = json["event_start_date"] {
            //"2019-07-27 23:55:00"
            self.eventStartDate = "\(obj)".removeNull.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        if let obj = json["event_end_date"] {
            //"2019-07-27 23:55:00"
            self.eventEndDate = "\(obj)".removeNull.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        
        // Product key other
        
        if let obj = json["title"] {
            self.title = "\(obj)".removeNull
        }
        
        if let obj = json["details"] {
            self.details = "\(obj)".removeNull
        }
        
        if let obj = json["booking_date"] {
            self.bookingDate = "\(obj)".removeNull
        }
        
        self.travellers = Traveller.retunsTravellerArray(jsonArr: json["travellers"] as? [JSONDictionary] ?? [])
        
        // room details
        if let obj = json["room_details"] as? [JSONDictionary] {
            self.roomDetails = RoomDetailModel.getModels(json: obj)
        }
        
        // leg parsing
        if let obj = json["leg"] as? [JSONDictionary] {
            self.leg = Leg.getModels(json: obj, eventStartDate: self.eventStartDate, bookingId: bookingId)
        }
        
        if let obj = json["journey_completed"] {
            self.journeyCompleted = "\(obj)".toInt ?? 0
        }
    }
    
    var paymentStatus: String {
        return self.isRefundable ? "Refundable" : " Non-Refundable"
    }
    
    // convert event start date into Date format
    
    var eventStartingDate: Date {
        return self.eventStartDate ?? Date()
    }
    
    // convert event end date into date format
    
    var evenEndingDate: Date {
        return self.eventEndDate ?? Date()
    }
}

// MARK: - Leg ,Flight and pax Details

struct Leg {
    var legId: String = ""
    var origin: String = ""
    var destination: String = ""
    var title: String = ""
    var stops: String = ""
    var refundable: Int = 0
    var reschedulable: Int = 0
    var fareName: String = ""
    var flight: [FlightDetail] = []
    var halts: String = ""
    var pax: [Pax] = []
    var completed: Int = 0
    var legStatus: String = ""
    var apc: String = ""
    
    var eventStartDate: Date? //will be passed from the booking details
    
    var rescheduledDate: Date? //will be set from new dates screen to refrenceing
    var prefredFlightNo: String = "" //will be set from new dates screen to refrenceing
    var selectedPaxs: [Pax] = [] //used while selecting paxes for rescheduling/cancelltaion request
    
    var bookingId: String = ""
    
    init() {}
    
    init(json: JSONDictionary, eventStartDate: Date?, bookingId: String) {
        
        self.eventStartDate = eventStartDate
        self.bookingId = bookingId
        
        if let obj = json["leg_id"] {
            self.legId = "\(obj)".removeNull
        }
        
        if let obj = json["origin"] {
            self.origin = "\(obj)".removeNull
        }
        if let obj = json["destination"] {
            self.destination = "\(obj)".removeNull
        }
        if let obj = json["ttl"] {
            self.title = "\(obj)".removeNull.replacingOccurrences(of: "-", with: "→")
        }
        if let obj = json["stops"] {
            self.stops = "\(obj)".removeNull
        }
        if let obj = json["refundable"] {
            self.refundable = "\(obj)".toInt ?? 0
        }
        if let obj = json["reschedulable"] {
            self.reschedulable = "\(obj)".toInt ?? 0
        }
        if let obj = json["fare_name"] {
            self.fareName = "\(obj)".removeNull
        }
        
        // other parsing
        if let obj = json["flights"] as? [JSONDictionary] {
            self.flight = FlightDetail.getModels(json: obj)
        }
        
        if let obj = json["pax"] as? [JSONDictionary] {
            self.pax = Pax.getModels(json: obj)
        }
        
        if let obj = json["completed"] {
            self.completed = "\(obj)".removeNull.toInt ?? 0
        }
        
        if let obj = json["leg_status"] {
            self.legStatus = "\(obj)".removeNull
        }
        
        if let obj = json["apc"] {
            self.apc = "\(obj)".removeNull
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
    
    var haltCount: Int {
        var count = 0
        for flight in self.flight {
            count += flight.halt.count
        }
        return count
    }
    
    var numberOfStop: Int {
        return self.flight.count - 1 + self.haltCount
    }
    
    static func getModels(json: [JSONDictionary], eventStartDate: Date?, bookingId: String) -> [Leg] {
        return json.map { Leg(json: $0, eventStartDate: eventStartDate, bookingId: bookingId) }
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
    
    var departDate: Date?
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
    var lcc: Int = 0
    // Weather data only will come if we are booking for less that 16 days from the travel data.
    var originWeather: Weather?
    var destinationWeather: Weather?
    var layoverTime: Double = 0.0
    var changeOfPlane: Int = 0
    var bookingClass: String = ""
    var fbn: String = ""
    var halt: [Halt] = []
    var amenities: [ATAmenity] = []
    var numberOfCellFlightInfo: Int {
        var temp: Int = 2
        
        if !self.amenities.isEmpty {
            temp += 1
        }
        
        if self.layoverTime > 0 {
            temp += 1
        }
        return temp
    }
    
    var numberOfCellBaggage: Int {
        var temp: Int = 1
        
        if let bg = self.baggage?.cabinBg {
            temp += 1
            
            if let _ = bg.adult {
                temp += 1
            }
            
            if let _ = bg.child {
                temp += 1
            }
            
            if let _ = bg.infant {
                temp += 1
            }
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
            self.flightId = "\(obj)".removeNull
        }
        
        if let obj = json["departure"] {
            self.departure = "\(obj)".removeNull
        }
        
        if let obj = json["departure_airport"] {
            self.departureAirport = "\(obj)".removeNull
        }
        
        if let obj = json["departure_terminal"] {
            self.departureTerminal = "\(obj)".removeNull
        }
        
        if let obj = json["departure_country"] {
            self.departureCountry = "\(obj)".removeNull
        }
        
        if let obj = json["departure_country_code"] {
            self.departureCountryCode = "\(obj)".removeNull
        }
        
        if let obj = json["depart_city"] {
            self.departCity = "\(obj)".removeNull
        }
        
        if let obj = json["depart_date"] {
            //"2019-02-01"
            self.departDate = "\(obj)".toDate(dateFormat: "yyyy-MM-dd")
        }
        
        if let obj = json["departure_time"] {
            self.departureTime = "\(obj)".removeNull
        }
        
        if let obj = json["arrival"] {
            self.arrival = "\(obj)".removeNull
        }
        
        if let obj = json["arrival_airport"] {
            self.arrivalAirport = "\(obj)".removeNull
        }
        
        if let obj = json["arrival_terminal"] {
            self.arrivalTerminal = "\(obj)".removeNull
        }
        
        if let obj = json["arrival_country"] {
            self.arrivalCountry = "\(obj)".removeNull
        }
        
        if let obj = json["arrival_city"] {
            self.arrivalCity = "\(obj)".removeNull
        }
        
        if let obj = json["arrival_country_code"] {
            self.arrivalCountryCode = "\(obj)"
        }
        
        if let obj = json["arrival_date"] {
            self.arrivalDate = "\(obj)".removeNull
        }
        if let obj = json["arrival_time"] {
            self.arrivalTime = "\(obj)".removeNull
        }
        if let obj = json["flight_time"] {
            self.flightTime = "\(obj)".toDouble ?? 0.0
        }
        if let obj = json["carrier"] {
            self.carrier = "\(obj)".removeNull
        }
        if let obj = json["carrier_code"] {
            self.carrierCode = "\(obj)".removeNull
        }
        if let obj = json["flight_number"] {
            self.flightNumber = "\(obj)".removeNull
        }
        if let obj = json["equipment"] {
            self.equipment = "\(obj)".removeNull
        }
        if let obj = json["equipment_description"] {
            self.equipmentDescription = "\(obj)".removeNull
        }
        
        if let obj = json["equipment_description_2"] {
            self.equipmentDescription2 = "\(obj)".removeNull
        }
        
        if let obj = json["equipment_layout"] {
            self.equipmentLayout = "\(obj)".removeNull
        }
        if let obj = json["qualiy"] {
            self.quality = "\(obj)".removeNull
        }
        if let obj = json["cabin_class"] {
            self.cabinClass = "\(obj)".removeNull
        }
        if let obj = json["operated_by"] {
            self.operatedBy = "\(obj)".removeNull
        }
        
        if let obj = json["lcc"] {
            self.lcc = "\(obj)".toInt ?? 0
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
            self.bookingClass = "\(obj)".removeNull
        }
        
        if let obj = json["fbn"] {
            self.fbn = "\(obj)".removeNull
        }
        
        // Parse the halt data
        if let obj = json["halt"] as? [JSONDictionary] {
            self.halt = Halt.getModels(json: obj)
        }
        
        // baggage
        if let obj = json["baggage"] as? JSONDictionary {
            self.baggage = Baggage(json: obj)
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

// This model will come only when we are booking the flight via some in-between station
struct Halt {
    var halt: String = ""
    var haltTime: String = ""
    var haltAirport: String = ""
    var haltCity: String = ""
    var haltCountry: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["halt"] {
            self.halt = "\(obj)".removeNull
        }
        
        if let obj = json["halt_time"] {
            self.haltTime = "\(obj)".removeNull
        }
        
        if let obj = json["halt_airport"] {
            self.haltAirport = "\(obj)".removeNull
        }
        
        if let obj = json["halt_city"] {
            self.haltCity = "\(obj)".removeNull
        }
        if let obj = json["halt_country"] {
            self.haltCountry = "\(obj)".removeNull
        }
    }
    
    static func getModels(json: [JSONDictionary]) -> [Halt] {
        return json.map { Halt(json: $0) }
    }
}

struct Baggage {
    var checkInBg: CheckInBg?
    var cabinBg: CabinBg?
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["bg"] as? JSONDictionary {
            self.checkInBg = CheckInBg(json: obj)
        }
        
        if let obj = json["cbg"] as? JSONDictionary {
            self.cabinBg = CabinBg(json: obj)
        }
    }
}

// Structure for baggage
struct CheckInBg {
    var infant: String?
    var child: String?
    var adult: String?
    var notes: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["ADT"] {
            self.adult = "\(obj)".removeNull
        }
        
        if let obj = json["CHD"] {
            self.child = "\(obj)".removeNull
        }
        
        if let obj = json["INF"] {
            self.infant = "\(obj)".removeNull
        }
        
        if let obj = json["notes"] {
            self.notes = "\(obj)".removeNull
        }
    }
}

// Structure for Cbg

struct CabinBg {
    var infant: CabinBgInfo?
    var child: CabinBgInfo?
    var adult: CabinBgInfo?
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["ADT"] as? JSONDictionary {
            self.adult = CabinBgInfo(json: obj)
        }
        
        if let obj = json["CHD"] as? JSONDictionary {
            self.child = CabinBgInfo(json: obj)
        }
        
        if let obj = json["INF"] as? JSONDictionary {
            self.infant = CabinBgInfo(json: obj)
        }
    }
}

struct CabinBgInfo {
    var weight: String = ""
    var piece: String = "" // Now its coming as null, what does this mean
    var dimension: Dimension?
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["weight"] {
            self.weight = "\(obj)".removeNull
        }
        
        if let obj = json["piece"] {
            self.piece = "\(obj)".removeNull
            self.piece = self.piece.isEmpty ? "1" : self.piece
        }
        
        if let obj = json["dimension"] as? JSONDictionary {
            self.dimension = Dimension(json: obj)
        }
    }
}

struct Dimension {
    var cm: CM?
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["cm"] as? JSONDictionary {
            self.cm = CM(json: obj)
        }
    }
}

struct CM {
    var width: Int = 0
    var height: Int = 0
    var depth: Int = 0
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["width"] {
            self.width = "\(obj)".toInt ?? 0
        }
        
        if let obj = json["height"] {
            self.height = "\(obj)".toInt ?? 0
        }
        if let obj = json["depth"] {
            self.depth = "\(obj)".toInt ?? 0
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
            self.email = self.email.isEmpty ? LocalizedString.dash.localized : self.email
        }
        if let obj = json["communication_number"] {
            self.communicationNumber = !"\(obj)".isEmpty ? "\(obj)" : "-"
            self.communicationNumber = self.communicationNumber.isEmpty ? LocalizedString.dash.localized : self.communicationNumber
        }
        if let obj = json["billing_name"] {
            self.billingName = !"\(obj)".isEmpty ? "\(obj)" : "-"
            self.billingName = self.billingName.isEmpty ? LocalizedString.dash.localized : self.billingName
        }
        
        if let obj = json["gst"] {
            self.gst = !"\(obj)".removeNull.isEmpty ? "\(obj)" : "-"
            self.gst = self.gst.isEmpty ? LocalizedString.dash.localized : self.gst
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
            self.addressLine1 = "\(obj)".removeNull
        }
        
        if let obj = json["address_line2"] {
            self.addressLine2 = "\(obj)".removeNull
        }
        
        if let obj = json["city"] {
            self.city = "\(obj)".removeNull
        }
        
        if let obj = json["state"] {
            self.state = "\(obj)".removeNull
        }
        
        if let obj = json["postal_code"] {
            self.postalCode = "\(obj)".removeNull
        }
        
        if let obj = json["country"] {
            self.country = "\(obj)".removeNull
        }
    }
    
    var completeAddress: String {
        var temp = self.addressLine1
        
        if !self.addressLine2.isEmpty {
            temp += "\(temp.isEmpty ? "" : ", ")\(self.addressLine2)"
        }
        
        if !self.city.isEmpty {
            temp += "\(temp.isEmpty ? "" : ", ")\(self.city)"
        }
        
        if !self.state.isEmpty {
            temp += "\(temp.isEmpty ? "" : ", ")\(self.state)"
        }
        
        if !self.postalCode.isEmpty {
            temp += "\(temp.isEmpty ? "" : " - ")\(self.postalCode)"
        }
        
        if !self.country.isEmpty {
            temp += "\(temp.isEmpty ? "" : ", ")\(self.country)"
        }
        
        return temp.isEmpty ? LocalizedString.dash.localized : temp
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
    var cancellationCharge: Double = 0.0
    var rescheduleCharge: Double = 0.0
    var ticket: String = ""
    var pnr: String = ""
    var inProcess: Bool = false
    var profileImage: String = ""
    var _seat: String = ""
    var _meal: String = ""
    var _baggage: String = ""
    var other: String = ""
    
    var netRefundForReschedule: Double {
        return self.amountPaid - self.rescheduleCharge
    }
    
    var fullNameWithSalutation: String {
        if salutation.isEmpty {
            return paxName
        }
        return "\(salutation) \(paxName)"
    }
    
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
        
        temp["0PNR"] = self.pnr.isEmpty ? LocalizedString.na.localized : self.pnr
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
            self.amountPaid = 270.0//"\(obj)".toDouble ?? 0.0
        }
        if let obj = json["cancellation_charge"] {
            self.cancellationCharge = 50.0//"\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["reschedule_charge"] {
            self.rescheduleCharge = 50.0//"\(obj)".toDouble ?? 0.0
        }
        if let obj = json["ticket"] {
            self.ticket = "\(obj)"
            self.ticket = self.ticket.isEmpty ? LocalizedString.na.localized : self.ticket
        }
        if let obj = json["pnr"] {
            self.pnr = "\(obj)"
        }
        if let obj = json["addons"] as? JSONDictionary, let addon = obj["addon"] as? JSONDictionary {
            self.addOns = addon
        }
        
        if let obj = json["in_process"] {
            self.inProcess = "\(obj)".toBool
        }
        
        if let obj = json["profile_image"] {
            self.profileImage = "\(obj)"
        }
    }
    
    static func getModels(json: [JSONDictionary]) -> [Pax] {
        return json.map { Pax(json: $0) }
    }
}

// Struct Case

struct Case {
    
    var bookingId = ""
    var id: String = ""
    var casedId: String = ""
    var caseType: String = ""
    var typeSlug: String = ""
    var caseName: String = ""
    var caseStatus: String = ""
    var resolutionStatusId: String = ""
    var resolutionStatusStr: String = ""
    var requestDate: Date?
    var csrName: String = ""
    var resolutionDate: String = ""
    var closedDate: String = ""
    var flag: String = ""
    var note: String = ""
    var amount: Double = 0.0
    
    var resolutionStatus: ResolutionStatus {
        return ResolutionStatus(rawValue: resolutionStatusStr) ?? ResolutionStatus.closed
    }
    
    init() {
        self.init(json: [:], bookindId: "")
    }
    
    init(json: JSONDictionary, bookindId: String) {
        
        self.bookingId = bookindId
        
        if let obj = json["id"] {
            self.id = "\(obj)".removeNull
        }
        
        if let obj = json["case_id"] {
            self.casedId = "\(obj)".removeNull
        }
        
        if let obj = json["resolution_status_id"] {
            self.resolutionStatusId = "\(obj)".removeNull
        }
        
        if let obj = json["resolution_status"] {
            self.resolutionStatusStr = "\(obj)".removeNull
        }
        
        if let obj = json["case_type"] {
            self.caseType = "\(obj)".removeNull
        }
        
        if let obj = json["type_slug"] {
            self.typeSlug = "\(obj)".removeNull
        }
        
        if let obj = json["case_name"] {
            self.caseName = "\(obj)".removeNull
        }
        
        if let obj = json["case_status"] {
            self.caseStatus = "\(obj)".removeNull
        }
        
        if let obj = json["request_date"] {
            //"2019-06-07 18:36:38"
            self.requestDate = "\(obj)".toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        if let obj = json["csr_name"] {
            self.csrName = "\(obj)".removeNull
        }
        if let obj = json["resolution_date"] {
            self.resolutionDate = "\(obj)".removeNull
        }
        
        if let obj = json["closed_date"] {
            self.closedDate = "\(obj)".removeNull
        }
        
        if let obj = json["flag"] {
            self.flag = "\(obj)".removeNull
        }
        if let obj = json["note"] {
            self.note = "\(obj)".removeNull
        }
        
        //TODO:- currently it is not comming.
        if let obj = json["amount"] {
            self.amount = "\(obj)".toDouble ?? 0.0
        }
    }
    
    static func retunsCaseArray(jsonArr: [JSONDictionary], bookindId: String) -> [Case] {
        var cases = [Case]()
        for element in jsonArr {
            cases.append(Case(json: element, bookindId: bookindId))
        }
        return cases
    }
}

struct Receipt {
    var voucher: [Voucher] = []
    var receiptVoucher: [Voucher] = []
    var otherVoucher: [Voucher] = []
    
    var totalAmountDue: Double = 0.0
    var totalAmountPaid: Double = 0.0
    
    init() {
        self.init(json: [:], bookingId: "")
    }
    
    init(json: JSONDictionary, bookingId: String) {
        if let obj = json["total_amount_due"] {
            self.totalAmountDue = "\(obj)".toDouble ?? 0.0
            self.totalAmountDue = 7631.0
        }
        
        if let obj = json["total_amount_paid"] {
            self.totalAmountPaid = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["vouchers"] as? [JSONDictionary] {
            let (all, receipt, others) = Voucher.getModels(json: obj, bookingId: bookingId)
            self.voucher = all
            self.receiptVoucher = receipt
            self.otherVoucher = others
        }
    }
}

struct Voucher {
    var basic: Basic?
    var transactions: [Transaction] = []
    var paymentInfo: BookingPaymentInfo?
    var bookingId: String = ""
    
    init() {
        self.init(json: [:], bookingId: "")
    }
    
    init(json: JSONDictionary, bookingId: String) {
        self.bookingId = bookingId
        if let obj = json["basic"] as? JSONDictionary {
            self.basic = Basic(json: obj)
        }
        
        if let obj = json["transactions"] as? [JSONDictionary] {
            self.transactions = Transaction.models(jsonArr: obj)
        }
        else if let obj = json["transactions"] as? JSONDictionary {
            self.transactions = Transaction.models(json: obj)
        }
        
        if let obj = json["paymentinfo"] as? JSONDictionary {
            self.paymentInfo = BookingPaymentInfo(json: obj)
        }
    }
    
    static func getModels(json: [JSONDictionary], bookingId: String) -> (all: [Voucher], receipt: [Voucher], others: [Voucher]) {
        
        var allVoucher = [Voucher]()
        var receiptVoucher = [Voucher]()
        var otherVoucher = [Voucher]()
        
        for data in json {
            let vchr = Voucher(json: data, bookingId: bookingId)
            if let basic = vchr.basic, basic.typeSlug == .receipt {
                receiptVoucher.append(vchr)
            }
            else {
                otherVoucher.append(vchr)
            }
            allVoucher.append(vchr)
        }
        
        return (allVoucher, receiptVoucher, otherVoucher)
    }
}

struct Basic {
    
    enum TypeSlug: String {
        case none
        
        case receipt = "receipt"
        case lockAmount = "lockAmount"
        case debitNote = "debitNote"
        case creditNote = "creditNote"
        case sales = "sales"
        case journal = "journal"
        
    }
    
    var id: String = ""
    var voucherType: String = ""
    var name: String = ""
    var event: String = ""
    var type: String = ""
    private var _typeSlug: String = ""
    var pattern: String = ""
    var lastNumber: String = ""
    var isActive: String = ""
    var voucherNo: String = ""
    var transactionDateTime: Date?
    var transactionId: String = ""
    
    var typeSlug: TypeSlug {
        get {
            return TypeSlug(rawValue: self._typeSlug) ?? TypeSlug.none
        }
        
        set {
            self._typeSlug = newValue.rawValue
        }
    }
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["id"] {
            self.id = "\(obj)".removeNull
        }
        if let obj = json["voucher_type"] {
            self.voucherType = "\(obj)".removeNull
        }
        if let obj = json["name"] {
            self.name = "\(obj)".removeNull
        }
        if let obj = json["event"] {
            self.event = "\(obj)".removeNull
        }
        if let obj = json["type"] {
            self.type = "\(obj)".removeNull
        }
        if let obj = json["type_slug"] {
            self._typeSlug = "\(obj)".removeNull
        }
        if let obj = json["pattern"] {
            self.pattern = "\(obj)".removeNull
        }
        if let obj = json["last_number"] {
            self.lastNumber = "\(obj)".removeNull
        }
        if let obj = json["is_active"] {
            self.isActive = "\(obj)".removeNull
        }
        if let obj = json["voucher_no"] {
            self.voucherNo = "\(obj)".removeNull
        }

        if let obj = json["transaction_id"] {
            self.transactionId = "\(obj)".removeNull
        }
        if let obj = json["transaction_datetime"] {
            //"2019-05-29 11:21:09"
            self.transactionDateTime = "\(obj)".toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
    }
}

struct Transaction {

    var ledgerName: String = ""
    var amount: Double = 0.0
    var codes: [Codes] = []
    
    init(json: JSONDictionary) {
        if let obj = json["amount"] {
            self.amount = "\(obj)".toDouble ?? 0.0
        }
        else if let obj = json["total"] {
            self.amount = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["ledger_name"] {
            self.ledgerName = "\(obj)"
        }
        if let obj = json["codes"] as? JSONDictionary {
            self.codes = Codes.models(json: obj)
        }
    }
    
    static func models(jsonArr: [JSONDictionary]) -> [Transaction] {
        return jsonArr.map { Transaction(json: $0) }
    }
    
    static func models(json: JSONDictionary) -> [Transaction] {
        var temp: [Transaction] = []
        for key in Array(json.keys) {
            if let data = json[key] as? JSONDictionary {
                var newData = data
                newData["ledger_name"] = key
                temp.append(Transaction(json: newData))
            }
        }
        return temp
    }
}

struct BookingPaymentInfo {
    
    enum Method: String {
        case none
        case netbanking = "netbanking"
        case card = "card"
        case upi = "upi"
    }
    
    var orderId: String = ""
    var pgFee: String = ""
    var pgTax: String = ""
    var transDate: String = ""
    var paymentId: String = ""
    private var _method: String = ""
    var bankName: String = ""
    var upiId: String = ""
    var cardNumber: String = ""
    
    var method: Method {
        get {
            return Method(rawValue: self._method) ?? Method.none
        }
        
        set {
            self._method = newValue.rawValue
        }
    }
    
    var paymentTitle: String {
        var titleStr = ""
        switch self.method {
        case .netbanking:
            titleStr = "\(self.method.rawValue.capitalizedFirst()): \(self.bankName)"
            
        case .upi:
            titleStr = "\(self.method.rawValue.capitalizedFirst()): \(self.upiId)"
            
        case .card:
            titleStr = (self.cardNumber.count <= 5) ? "XXXX XXXX XXXX \(self.cardNumber)" : self.cardNumber
            
        case .none:
            titleStr = LocalizedString.dash.localized
        @unknown default:
            titleStr = LocalizedString.dash.localized
        }
        
        return titleStr
    }
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["order_id"] {
            self.orderId = "\(obj)".removeNull
        }
        
        if let obj = json["pg_fee"] {
            self.pgFee = "\(obj)".removeNull
        }
        
        if let obj = json["pg_tax"] {
            self.pgTax = "\(obj)".removeNull
        }
        
        if let obj = json["trans_date"] {
            self.transDate = "\(obj)".removeNull
        }
        if let obj = json["payment_id"] {
            self.paymentId = "\(obj)".removeNull
        }
        if let obj = json["method"] {
            self._method = "\(obj)".removeNull
        }
        if let obj = json["bank_name"] {
            self.bankName = "\(obj)".removeNull
        }
        if let obj = json["upi_id"] {
            self.upiId = "\(obj)".removeNull
        }
        if let obj = json["card_number"] {
            self.cardNumber = "\(obj)".removeNull
        }
    }
}

struct Codes {
    var code: String = ""
    var ledgerName: String = ""
    var amount: Double = 0.0
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["id"] {
            self.code = "\(obj)".removeNull
        }
        
        if let obj = json["ledger_name"] {
            self.ledgerName = "\(obj)".removeNull
        }
        
        if let obj = json["amount"] {
            self.amount = "\(obj)".toDouble ?? 0.0
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

struct WeatherInfo {
    var maxTemperature: Int = 0
    var minTemperature: Int = 0
    var weather: String = ""
    var weatherIcon: String = ""
    var temperature: Int = 0
    var date: Date?
    var countryCode: String = ""
    var city: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["min_temperature"] {
            self.minTemperature = "\(obj)".toInt ?? 0
        }
        
        if let obj = json["max_temperature"] {
            self.maxTemperature = "\(obj)".toInt ?? 0
        }
        if let obj = json["weather"] {
            self.weather = "\(obj)"
        }
        if let obj = json["weather_icon"] {
            self.weatherIcon = "\(obj)"
        }
        if let obj = json["date"] {
            self.date = "\(obj)".toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        if let obj = json["country_code"] {
            self.countryCode = "\(obj)"
        }
        
        if let obj = json["city"] {
            self.city = "\(obj)"
        }
    }
    
    static func getModels(json: [JSONDictionary]) -> [WeatherInfo] {
        return json.map { WeatherInfo(json: $0) }
    }
}
