//
//  BookingDetailModel.swift
//  AERTRIP
//
//  Created by apple on 06/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//
import Foundation

struct BookingDetailModel {
    
    enum BookingStatusType: String {
        case pending
        case booked
    }
    
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
    var shareUrl : String = ""

    
    var totalAmountPaid: Double = 0.0
    var vCode: String = ""
    //var bookingStatus: String = ""
    var documents: [DocumentDownloadingModel] = []
    var tripInfo: TripInfo?
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
    var frequentFlyerData: [FrequentFlyerData] = []
    var displaySeatMap:Bool = false
    var bookingStatus: BookingStatusType = .pending
    var bookinAddons:[BookingAddons]?

    var jsonDict: JSONDictionary {
        return [:]
    }
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary)
    {
        if let obj = json["search_url"]
        {
            self.shareUrl = "\(obj)".removeNull
        }

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
        
        if let obj = json["display_seat_map"] as? Bool {
            self.displaySeatMap = obj
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
        
        if let obj = json["trip_info"] as? JSONDictionary {
            self.tripInfo = TripInfo(json: obj)
        }
        
        // Additional information data like web checkins,directions, and  Airports , Airlines and Aertrip
        if let obj = json["additional_informations"] as? JSONDictionary {
            self.additionalInformation = AdditionalInformation(json: obj)
        }
        
        // other data parsing
        if let obj = json["billing_info"] as? JSONDictionary {
            self.billingInfo = BillingDetail(json: obj)
        }

        // receipt
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
        
        if let obj = json["weather_info"] as? [JSONDictionary] {
//            let testData =   [
//                [
//                    "max_temperature": 28,
//                    "min_temperature": 28,
//                    "weather": "Light rain",
//                    "weather_icon": "500-light-rain",
//                    "temperature": 0,
//                    "date": "2019-07-12",
//                    "country_code": "IN",
//                    "city": "Goa"
//                ],
//                [
//                    "max_temperature": 28,
//                    "min_temperature": 28,
//                    "weather": "Light rain",
//                    "weather_icon": "500-light-rain",
//                    "temperature": 0,
//                    "date": "2019-07-12",
//                    "country_code": "IN",
//                    "city": "Mumbai"
//                ],
//                [
//                    "max_temperature": 28,
//                    "min_temperature": 28,
//                    "weather": "Light rain",
//                    "weather_icon": "500-light-rain",
//                    "temperature": 0,
//                    "date": "2019-07-12",
//                    "country_code": "IN",
//                    "city": "Goa"
//                ]
//
//            ]
            self.weatherInfo = WeatherInfo.getModels(json: obj)
            let filtered = self.weatherInfo.filter({$0.maxTemperature != nil || $0.minTemperature != nil || $0.temperature != nil})
            if filtered.count == 0{
                self.weatherInfo = []
            }

        }
        
        if self.product.lowercased() == "flight" {
            
            
            if !self.weatherInfo.isEmpty {
                
                for leg in self.bookingDetail?.leg ?? [] {
                    for flight in leg.flight {
                        var departureWeather = WeatherInfo()
                        departureWeather.date = flight.departDate
                        departureWeather.city = flight.departCity
                        departureWeather.countryCode = flight.departureCountryCode
                        if let lastWeather = self.tripWeatherData.last {
                            if lastWeather.city != departureWeather.city || !(lastWeather.date ?? Date()).isEqualTo((departureWeather.date ?? Date())) {
                                self.tripWeatherData.append(departureWeather)
                            }
                        } else {
                            self.tripWeatherData.append(departureWeather)
                        }
                        
                        var arrivalWeather = WeatherInfo()
                        arrivalWeather.date = flight.arrivalDate
                        arrivalWeather.city = flight.arrivalCity
                        arrivalWeather.countryCode = flight.arrivalCountryCode
                        if let lastWeather = self.tripWeatherData.last {
                            if lastWeather.city != arrivalWeather.city || !(lastWeather.date ?? Date()).isEqualTo((arrivalWeather.date ?? Date())) {
                                self.tripWeatherData.append(arrivalWeather)
                            }
                        } else {
                            self.tripWeatherData.append(arrivalWeather)
                        }
                    }
                }
                
                for (_, weatherInfoData) in self.weatherInfo.enumerated() {
                    for (j, weatherTripInfoData) in self.tripWeatherData.enumerated() {
                        if weatherInfoData.date?.isEqualTo(weatherTripInfoData.date ?? Date()) ?? false, weatherInfoData.countryCode == weatherTripInfoData.countryCode, weatherInfoData.city == weatherTripInfoData.city {
                            self.tripWeatherData[j] = weatherInfoData
                        }
                    }
                }
            }
            
            for tripWeatherData in self.tripWeatherData {
                if tripWeatherData.minTemperature == nil || tripWeatherData.maxTemperature == nil {
                    self.weatherDisplayedWithin16Info = true
                    break
                }
            }
        }
        else {
            
            
            if !self.weatherInfo.isEmpty {
                // set trip Weather Data for Hotel
                let datesBetweenArray = Date.dates(from: self.bookingDetail?.checkIn ?? Date(), to: self.bookingDetail?.checkOut ?? Date())
                for date in datesBetweenArray {
                    var weatherInfo = WeatherInfo()
                    weatherInfo.date = date
                    self.tripWeatherData.append(weatherInfo)
                }
                
                for (_, weatherInfoData) in self.weatherInfo.enumerated() {
                    for (j, weatherTripInfoData) in self.tripWeatherData.enumerated() {
                        if weatherInfoData.date == weatherTripInfoData.date {
                            self.tripWeatherData[j] = weatherInfoData
                        }
                    }
                }
            }
            
            for tripWeatherData in self.tripWeatherData {
                if tripWeatherData.temperature == nil {
                    self.weatherDisplayedWithin16Info = true
                    break
                }
            }
        }
        
        if let bookingStatus = json[APIKeys.bstatus.rawValue]{
            self.bookingStatus = BookingStatusType(rawValue: "\(bookingStatus)".removeNull) ?? .pending
        }
        if let addons = json["booking_addons"]{
            self.bookinAddons = JSON(addons).arrayValue.map({BookingAddons($0, leg: self.bookingDetail?.leg.first)})
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

// MARK: - extension for Calculation

// MARK: -

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
    
    
    func isMultipleFlight() -> Bool  {
        // MUltiple leg Detail
        return (self.bookingDetail?.leg ?? []).count > 1 && self.specialFare == "0"
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
        else if self.tripType.lowercased() == "return" {//self.isReturnFlight(forArr: tripCts)
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
                    return self.createNameForMulticity(routes: routes, travelledCity: travledCity)
                }
            }
            return NSMutableAttributedString(string: LocalizedString.dash.localized)
        }
    }
    
    func createNameForMulticity(routes: [[String]], travelledCity:[String]) -> NSMutableAttributedString{
        
//        let routes = self.bookingDetail?.routes ?? []
        var routeStr = ""
        var grayString = ""
        
        for route in routes{
            if routeStr.isEmpty{
                routeStr += route.joined(separator: " → ")
            }else{
                routeStr += ", \(route.joined(separator: " → "))"
            }
        }
        
        var totalCityCount = 0
        
        for (upperIndex, route) in routes.enumerated(){
            var newRoutes = route
            if upperIndex != 0{
                totalCityCount += routes[upperIndex - 1].count - 1
            }
            newRoutes.removeLast()
            for (index, _) in newRoutes.enumerated(){
                let travelledCityIndex = index + totalCityCount
                if travelledCity.count > travelledCityIndex{
                    grayString += "\(travelledCity[travelledCityIndex]) → "
                    if (index == newRoutes.count - 1){
                        if (upperIndex != (routes.count - 1)){
                            grayString += "\(route.last ?? ""), "
                        }else{
                            grayString += "\(route.last ?? "")"
                        }
                    }
                }else{
                    continue
                }
            }
        }
        let attributedStr1 = NSMutableAttributedString(string: routeStr)
        if grayString != routeStr{
            let range = NSString(string: routeStr).range(of: grayString)
            attributedStr1.addAttributes([.foregroundColor: AppColors.themeGray20], range: range)
        }
        return attributedStr1
    }
    
    
    
    /*
     Loop through the vouchers array, consider the object that has
     voucher.basic.voucher_type  = ‘sales’ (Must be only 1)
     voucher.transactions.Total.amount  gives the Booking Price.
     */
    
    var bookingPrice: Double {
        var price: Double = 0.0
        // TODO: Recheck all price logic as transaction key not coming
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
    
    // TODO: Reschedule Amount Not coming in the Api , Already inform the same to Yash
    
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
    // Total_amount_paid
    
    var paid: Double {
        return self.totalAmountPaid
//        return 0.0
    }
    
    // Refund Amount: Total of cancellations + Total of Reschedules
    
    var refundAmount: Double {
        return self.rescheduleAmount + self.cancellationAmount
    }
    
    // Total cost of booking = Sale’s amount + sum(add-on)
    
    var totalCostOfBooking: Double {
        // TODO: need to disucss sale amount :
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
//        return 0.0
    }
    
    // Web checking url
    
    var webCheckinUrl: String {
        if let legs = self.bookingDetail?.leg, let index = legs.firstIndex(where: { $0.completed == 0 }) {
            
            var departDateTimeStr = ""
            if let departDate = self.bookingDetail?.leg.first?.flight.first?.departDate{
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "dd-MM-yyyy"
                departDateTimeStr = inputFormatter.string(from: departDate)
            }
            
            if let departureTime = self.bookingDetail?.leg.first?.flight.first?.departureTime{
                departDateTimeStr.append(" \(departureTime)")
            }


            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            let currDateTimeStr = inputFormatter.string(from: Date())

            if let currDate = inputFormatter.date(from:currDateTimeStr), let depDate = inputFormatter.date(from:departDateTimeStr)
            {
                if depDate.isSmallerThan(currDate)  || depDate.isEqualTo(currDate){
                    return ""
                }else{
                    return (index < (self.additionalInformation?.webCheckins.count ?? 0)) ? (self.additionalInformation?.webCheckins[index] ?? "") : ""
                }
            }else{
                return (index < (self.additionalInformation?.webCheckins.count ?? 0)) ? (self.additionalInformation?.webCheckins[index] ?? "") : ""
            }
        }
        return ""
    }
    
    var frequentFlyerDatas: [FrequentFlyerData] {
        var temp: [FrequentFlyerData] = []
        let totalFlight = (self.bookingDetail?.leg ?? []).flatMap({$0.flight})
        let pax = (self.bookingDetail?.leg ?? []).first?.pax ?? []
        
        for px in pax{
            var newFF = FrequentFlyerData(passenger: px, flights: [])
            for flight in totalFlight{
                if !newFF.flights.contains(where: {$0.carrier == flight.carrier}){
                    newFF.flights.append(flight)
                }
            }
            temp.append(newFF)
        }
        
//        for leg in self.bookingDetail?.leg ?? [] {
//            for pax in leg.pax {
//                // need to remove duplicates
//                if !temp.contains(where: { (object) -> Bool in
//                    if  pax.paxId == object.passenger?.paxId {
//                        return true
//                    }
//                    return false
//                }) {
//                    temp.append(FrequentFlyerData(passenger: pax, flights: leg.flight))
//                }
//            }
//        }
        
        return temp
    }
}

struct BookingDetail {
    var tripCities: [String] = []
    var travelledCities: [String] = []
    var disconnected: Bool = false
    var routes: [[String]] = [[]]
    var leg: [BookingLeg] = []
    
    var journeyCompleted: Int = 0
    var travellers: [Traveller] = []
    var refundable: Int = 0
    
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
    
    var photos: [String] = []
    var amenitiesGroups: [String: Any] = [:]
    var amenities: Amenities?
    var overview: String = ""
    var taLocationID: String = ""
    var website: String = ""
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
    
    var amenities_group_order: [String : String] = [:]
    var bookingId: String = ""
    var atImageData = [ATGalleryImage]()
    
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
        
        // final Hotel details
        
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
        
        if let jsonData = json[APIKeys.amenities_group.rawValue] as? JSONDictionary {
            self.amenitiesGroups = jsonData
        }
        
        
        if let obj = json[APIKeys.amenities.rawValue] as? JSONDictionary {
            self.amenities = Amenities.getAmenitiesData(response: obj)
        }
        
        if let obj = json["overview"] {
            self.overview = "\(obj)".removeNull
        }
        
        if let obj = json["ta_location_id"] {
            self.taLocationID = "\(obj)".removeNull
        }
        
        if let obj = json["website"] {
            self.website = "\(obj)".removeNull
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
        if let obj = json["photos"] as? [String] {
            self.photos = obj + [self.hotelImage]
            self.atImageData = self.photos.map{img in
                var imgData = ATGalleryImage()
                imgData.imagePath = img
                return imgData
            }
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
            // "2019-08-07 00:00:00"
            self.checkIn = "\(obj)".removeNull.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        if let obj = json["check_out"] {
            // "2019-08-07 00:00:00"
            self.checkOut = "\(obj)".removeNull.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        // Event start and end date and notes
        
        if let obj = json["note"] {
            self.note = "\(obj)".removeNull
        }
        
        if let obj = json["event_start_date"] {
            // "2019-07-27 23:55:00"
            self.eventStartDate = "\(obj)".removeNull.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        if let obj = json["event_end_date"] {
            // "2019-07-27 23:55:00"
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
        
        if let obj = json["travellers"] as? [JSONDictionary] {
            self.travellers = Traveller.retunsTravellerArray(jsonArr: obj)
        }
        
        if let obj = json["refundable"] {
            self.refundable = "\(obj)".toInt ?? 0
        }
        
        // room details
        if let obj = json["room_details"] as? [JSONDictionary] {
            self.roomDetails = RoomDetailModel.getModels(json: obj, bookingId: bookingId)
        }
        
        // leg parsing
        if let obj = json["leg"] as? [JSONDictionary] {
            self.leg = BookingLeg.getModels(json: obj, eventStartDate: self.eventStartDate, bookingId: bookingId)
        }
        
        if let obj = json["journey_completed"] {
            self.journeyCompleted = "\(obj)".toInt ?? 0
        }
        
        // Event start and end date and notes
        
        if let obj = json["note"] {
            self.note = "\(obj)".removeNull
        }
        
        if let obj = json["event_start_date"] {
            self.eventStartDate = "\(obj)".removeNull.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        if let obj = json["event_end_date"] {
            self.eventEndDate = "\(obj)".removeNull.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
        
        if let obj = json[APIKeys.amenities_group_order.rawValue] as? [String : String] {
            self.amenities_group_order = obj
        }
    }
    
    var paymentStatus: String {
        return self.isRefundable ? "Refundable" : " Non-Refundable"
    }
    
    var otherPrductDetailStatus: String {
        return self.refundable == 0 ? "Non-Refundable" : "Refundable"
    }
    
    // completePhotos
    var completePhotos: [String] {
        return self.photos + [self.hotelImage]
    }
    
    // Website Details
    
    var websiteDetail: String {
//        return self.website.isEmpty ? LocalizedString.SpaceWithHiphen.localized : self.website
        
        return (self.website != "somedummywebsite.com") ? self.website : ""
    }
    
    // Phone Details
    var phoneDetail: String {
       // return self.hotelPhone.isEmpty ? LocalizedString.SpaceWithHiphen.localized : self.hotelPhone
        return self.hotelPhone

    }
    
    // Over view Details
    
    var overViewData: String {
//        return self.overview.isEmpty ? LocalizedString.SpaceWithHiphen.localized : self.info
         return self.overview
    }
    
    // hotel Address
    
    var hotelAddressDetail: String {
       // return self.hotelAddress.isEmpty ? LocalizedString.SpaceWithHiphen.localized : self.hotelAddress
        return self.hotelAddress

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

// MARK: - BookingLeg ,Flight and pax Details

struct BookingLeg {
    var legId: String = ""
    var origin: String = ""
    var destination: String = ""
    var title: String = ""
    var stops: String = ""
    var refundable: Int = 0
    var reschedulable: Int = 0
    var fareName: String = ""
    var flight: [BookingFlightDetail] = []
    var halts: String = ""
    var pax: [Pax] = []
    var completed: Int = 0
    var legStatus: String = ""
    var apc: String = ""
    
    var eventStartDate: Date? // will be passed from the booking details
    
    var rescheduledDate: Date? //will be set from new dates screen to refrenceing
    var prefredFlightNo: String = "" //will be set from new dates screen to refrenceing
    var selectedPaxs: [Pax] = [] //used while selecting paxes for rescheduling/cancelltaion request
    
    var bookingId: String = ""
    
    //For book same flight
    var parentOrigin:String = ""
    var parentDestination:String = ""
    
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
            self.flight = BookingFlightDetail.getModels(json: obj)
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
        if let obj = json["parent_origin"] {
            self.parentOrigin = "\(obj)".removeNull
        }
        
        if let obj = json["parent_destination"] {
            self.parentDestination = "\(obj)".removeNull
        }
    }
    
    var flightNumbers: [String] {
        return self.flight.map { $0.flightNumber }
    }
    
    var carrierCodes: [String] {
        return self.flight.map { $0.carrierCode }
    }
    
    var carriers: [String] {
        return self.flight.map { $0.carrier }
    }
    
    var cabinClass: String {
        return self.flight.map { $0.cabinClass }.removeDuplicates().joined(separator: ", ")
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
    
    static func getModels(json: [JSONDictionary], eventStartDate: Date?, bookingId: String) -> [BookingLeg] {
        return json.map { BookingLeg(json: $0, eventStartDate: eventStartDate, bookingId: bookingId) }
    }
}

struct BookingFlightDetail {
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
    var arrivalDate: Date?
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
    var frequentFlyerNumber: String = ""
    var baggage: Baggage?
    var lcc: Int = 0
    // Weather data only will come if we are booking for less that 16 days from the travel data.
    var originWeather: Weather?
    var destinationWeather: Weather?
    var layoverTime: Double = 0.0
    var changeOfPlane: Int = 0
    var bookingClass: String = ""
    var fbn: String = ""
    var cc: String = ""
    var bc: String = ""
    var halt: [Halt] = []
    var amenities: [ATAmenity] = []
    var ovgtf:Bool = false
    var ovgtlo:Bool = false
    var numberOfCellFlightInfo: Int {
        var temp: Int = 2
        
        if !self.amenities.isEmpty {
            temp += 1
        }
        
        if self.layoverTime > 0 {
//            if ovgtlo {
            temp += 1
//            }
        }
        return temp
    }
    
    var numberOfCellBaggage: Int {
        var temp: Int = 1 //flight detail cell
        
        if let bg = self.baggage?.cabinBg {
            temp += 1 //info title cell
            
            if let _ = bg.adult {
                temp += 1 //adult details cell
            }

            if let _ = bg.child {
                temp += 1 //child details cell
            }

            if let _ = bg.infant {
                temp += 1 //adult details cell
            }
        }
        
        if self.layoverTime > 0 {
            if ovgtlo {
                temp += 1
            }
        }
        
        if let nt = self.baggage?.checkInBg?.notes, !nt.isEmpty {
            //temp += 1
        }
        
        return temp
    }
    
    let numberOfAmenitiesInRow: Double = 4.0
    var totalRowsForAmenities: Int {
        let cont: Double = Double(self.amenities.count)
        let val = Double(cont / self.numberOfAmenitiesInRow)
        let diff = val - floor(val)
        var total = Int(floor(val))
        if diff > 0.0, diff < 1.0 {
            total += 1
        }
        return total
    }
    var calendarDepartDate: Date?
    var calendarArivalDate: Date?

    
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
            // "2019-02-01"
            self.departDate = "\(obj)".toDate(dateFormat: "yyyy-MM-dd")
        }
        
        if let obj = json["departure_time"] {
            self.departureTime = "\(obj)".removeNull
        }
        
        if  let date = json["depart_date"], let time = json["departure_time"]{
            // "2019-02-01"
            self.calendarDepartDate = "\(date) \(time)".toDate(dateFormat: "yyyy-MM-dd HH:mm")
        }
        
        if  let date = json["arrival_date"], let time = json["arrival_time"]{
            // "2019-02-01"
            self.calendarArivalDate = "\(date) \(time)".toDate(dateFormat: "yyyy-MM-dd HH:mm")
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
            self.arrivalDate = "\(obj)".toDate(dateFormat: "yyyy-MM-dd")
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
        
        if let obj = json["cabin_class"] {
            self.cc = "\(obj)".removeNull
        }
        
        if let obj = json["booking_class"] {
            self.bc = "\(obj)".removeNull
        }
        
        // Parse the halt data
        if let obj = json["halt"] as? [JSONDictionary] {
            self.halt = Halt.getModels(json: obj)
        }
        
        // baggage
        if let obj = json["baggage"] as? JSONDictionary {
            self.baggage = Baggage(json: obj)
        }
        if let obj = json["ovgtf"] as? Bool{
            self.ovgtf = obj
        }
        
        if let obj = json["ovgtlo"] as? Bool{
            self.ovgtlo = obj
        }
        
        // TODO: parse the real data for amenities
        self.amenities = [ATAmenity.Wifi, ATAmenity.Gym, ATAmenity.Internet, ATAmenity.Pool, ATAmenity.RoomService]
    }
    
    static func getModels(json: [JSONDictionary]) -> [BookingFlightDetail] {
        return json.map { BookingFlightDetail(json: $0) }
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
            finalStr += "\n(\(self.equipmentDescription2))"
        }
        if !self.equipmentLayout.isEmpty {
            finalStr += "\n\(self.equipmentLayout)"
        }
        
        return finalStr //+ " >"
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
    var infant: BaggageInfo?
    var child: BaggageInfo?
    var adult: BaggageInfo?
    var notes: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["ADT"] as? JSONDictionary {
            self.adult = BaggageInfo(json: obj)
        }
        
        if let obj = json["CHD"] as? JSONDictionary {
            self.child = BaggageInfo(json: obj)
        }
        
        if let obj = json["INF"] as? JSONDictionary {
            self.infant = BaggageInfo(json: obj)
        }
        
        if let obj = json["notes"] {
            self.notes = "\(obj)".removeNull
        }
    }
}

// Structure for Cbg

struct CabinBg {
    var infant: BaggageInfo?
    var child: BaggageInfo?
    var adult: BaggageInfo?
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["ADT"] as? JSONDictionary {
            self.adult = BaggageInfo(json: obj)
        }
        
        if let obj = json["CHD"] as? JSONDictionary {
            self.child = BaggageInfo(json: obj)
        }
        
        if let obj = json["INF"] as? JSONDictionary {
            self.infant = BaggageInfo(json: obj)
        }
    }
}

struct BaggageInfo {
    var weight: String = ""
    var piece: String = "" // Now its coming as null, what does this mean
    var maxPieces: String = ""
    var maxWeight: String = ""
    var note: String = ""
    var dimension: Dimension?

    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["weight"] {
            self.weight = "\(obj)".removeNull
        }
        if let obj = json["pieces"] {
            self.piece = "\(obj)".removeNull
//            self.piece = self.piece.isEmpty ? "1" : self.piece
        }
        if let obj = json["max_weight"] {
            self.maxWeight = "\(obj)".removeNull
        }
        if let obj = json["max_pieces"] {
            self.maxPieces = "\(obj)".removeNull
        }
        if let obj = json["note"] {
            self.note = "\(obj)".removeNull
        }
        
        if let obj = json["dimension"] as? JSONDictionary {
            self.dimension = Dimension(json: obj)
        }
    }
}

struct Dimension {
    var cm: CM?
    var inch: CM?
    var weight = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["cm"] as? JSONDictionary {
            self.cm = CM(json: obj)
        }
        if let inch = json["in"] as? JSONDictionary{
            self.inch = CM(json: inch)
        }
        if let weight = json["weight"]{
            self.weight = "\(weight)".removeNull
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
            self.gst = !"\(obj)".removeNull.isEmpty ? "\(obj)" : ""
            //self.gst = self.gst.isEmpty ? LocalizedString.dash.localized : self.gst
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
       
        if !self.postalCode.isEmpty {
            temp += "\(temp.isEmpty ? "" : " - ")\(self.postalCode)"
        }
        
        if !self.state.isEmpty {
            temp += "\(temp.isEmpty ? "" : ", ")\(self.state)"
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
    var addOns: AddOns?
    var flight: [BookingFlightDetail] = []
    var inProcess: Bool = false
    var profileImage: String = ""
    var seat: String = ""
    var meal: String = ""
    var baggage: String = ""
    var other: String = ""
    var seatPreferences: String = ""
    var mealPreferenes: String = ""
    var dob: String = ""
    var reversalMFPax:Double = 0.0

    
    var netRefundForReschedule: Double {
        return self.amountPaid - (self.rescheduleCharge > 0 ? self.rescheduleCharge : 0)
    }
    
    var netRefundForCancellation: Double {
        return self.amountPaid - (self.cancellationCharge > 0 ? self.cancellationCharge : 0 )
    }
    
    var fullNameWithSalutation: String {
        if self.salutation.isEmpty {
            return self.paxName
        }
        return "\(self.salutation) \(self.paxName)"
    }
    
//    var addOns: JSONDictionary = [:] // TODO: Need to confirm this with yash as always coming in array
    
    var _pnr: String {
        return self.pnr.isEmpty ? (self.status.lowercased() == "pending" ? self.status.capitalized : LocalizedString.dash.localized ): self.pnr + "-" + self.status
    }
    
    var _seat: String {
        if let obj = self.addOns?.addOn?.seat, !obj.isEmpty {
            return obj
        }
        return LocalizedString.dash.localized
    }
    
    var _seatPreferences: String {
        if let obj = self.addOns?.preferences?.seat, !obj.isEmpty {
            return obj
        }
        
        return LocalizedString.dash.localized
    }
    
    var _meal: String {
        if let obj = self.addOns?.addOn?.meal, !obj.isEmpty {
            return obj
        }
        return LocalizedString.dash.localized
    }
    
    var _mealPreferences: String {
        if let obj = self.addOns?.preferences?.meal, !obj.isEmpty {
            return obj
        }
        return LocalizedString.dash.localized
    }
    
    

    
    var _baggage: String {
        if let obj = self.addOns?.addOn?.baggage, !obj.isEmpty {
            return obj
        }
        return LocalizedString.dash.localized
    }
    
    var _others: String {
        if let obj = self.addOns?.addOn?.others, !obj.isEmpty {
            return obj
        }
        return LocalizedString.dash.localized
    }
    
    var fullName: String {
        return "\(self.salutation) \(self.paxName)"
    }
    
    
    var detailsToShow: JSONDictionary {
        var temp = JSONDictionary()
        
        temp["0PNR"] = self._pnr
        temp["1Ticket Number"] = self.ticket
        temp["2Seat"] = self._seat
        temp["3Seat Preference"] = self._seatPreferences
        temp["4Meal"] = self._meal
        temp["5Meal Preferences"] = self._mealPreferences
        temp["6Baggage"] = self._baggage
        temp["7Others"] = self._others
        //temp["8Frequent Flyer"] = self._ff
        
        var objectIndex = 8
        if let obj = self.addOns?.ff, !obj.isEmpty {
            obj.forEach { (ff) in
                temp["\(objectIndex)Frequent Flyer"] = ff
                objectIndex += 1
            }
        }
        
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
            self.paxId = "\(obj)".removeNull
        }
        if let obj = json["upid"] {
            self.uPid = "\(obj)".removeNull
        }
        if let obj = json["salutation"] {
            self.salutation = "\(obj)".removeNull
        }
        if let obj = json["first_name"] {
            self.firstName = "\(obj)".removeNull
        }
        if let obj = json["last_name"] {
            self.lastName = "\(obj)".removeNull
        }
        if let obj = json["pax_name"] {
            self.paxName = "\(obj)".removeNull
        }
        if let obj = json["pax_type"] {
            self.paxType = "\(obj)".removeNull
        }
        if let obj = json["status"] {
            self.status = "\(obj)".removeNull
        }
        if let obj = json["amount_paid"] {
            self.amountPaid = "\(obj)".toDouble ?? 0.0
        }
        if let obj = json["cancellation_charge"] {
            self.cancellationCharge = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["reschedule_charge"] {
            self.rescheduleCharge = "\(obj)".toDouble ?? 0.0
        }
        if let obj = json["ticket"] {
            self.ticket = "\(obj)".removeNull
            self.ticket = self.ticket.isEmpty ? LocalizedString.dash.localized : self.ticket
        }
        if let obj = json["pnr"] {
            self.pnr = "\(obj)".removeNull
        }
        if let obj = json["addons"] as? JSONDictionary {
            self.addOns = AddOns(json: obj)
        }
        
        if let obj = json["in_process"] {
            self.inProcess = "\(obj)".toBool
        }
        
        if let obj = json["profile_image"] {
            self.profileImage = "\(obj)".removeNull
        }
        
        if let obj = json["dob"] {
            self.dob = "\(obj)".removeNull
        }
        if let obj = json["reversalMF_pax"]{
            self.reversalMFPax = "\(obj)".toDouble ?? 0.0
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
    private var _resolutionStatusStr: String = ""
    var requestDate: Date?
    var csrName: String = ""
    var resolutionDate: String = ""
    var closedDate: String = ""
    var flag: String = ""
    var note: String = ""
    var amount: Double = 0.0
        
    var resolutionStatus: ResolutionStatus {
        get {
            return ResolutionStatus(rawValue: self._resolutionStatusStr) ?? ResolutionStatus.closed
        }
        
        set {
            self._resolutionStatusStr = newValue.rawValue
        }
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
            self._resolutionStatusStr = "\(obj)".removeNull
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
            // "2019-06-07 18:36:38"
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
        
        // TODO: - currently it is not comming.
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
    var reversalMF:Double = 0.0
    
    init() {
        self.init(json: [:], bookingId: "")
    }
    
    init(json: JSONDictionary, bookingId: String) {
        if let obj = json["total_amount_due"] {
            self.totalAmountDue = "\(obj)".toDouble ?? 0.0
        }
        
        if let obj = json["total_amount_paid"] {
            self.totalAmountPaid = "\(obj)".toDouble ?? 0.0
        }
        if let obj = json["reversalMF"]{
            self.reversalMF = "\(obj)".toDouble ?? 0.0
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
        
        case receipt
        case lockAmount
        case debitNote
        case creditNote
        case sales
        case journal
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
            // "2019-05-29 11:21:09"
            self.transactionDateTime = "\(obj)".toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
        }
    }
}

struct Transaction {
    var ledgerName: String = ""
    var amount: Double = 0.0
    var codes: [Codes] = []
    
    init(json: JSONDictionary) {
        if let amt = (json["Total"] as? JSONDictionary)?["amount"]{
            self.amount = "\(amt)".toDouble ?? 0.0
            self.ledgerName = "total"
        }else{
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
    }
    
    static func models(jsonArr: [JSONDictionary]) -> [Transaction] {
        if let firstObject = jsonArr.first {
            if let firstKey = firstObject.keys.first, let _ = firstObject[firstKey] as? JSONDictionary {
                var temp: [Transaction] = []
                _ = jsonArr.map {
                    for key in Array($0.keys) {
                    if let data = $0[key] as? JSONDictionary {
                        var newData = data
                        newData["ledger_name"] = key
                        temp.append(Transaction(json: newData))
                    }
                    }
                }
                return temp
            } else {
                return jsonArr.map { Transaction(json: $0) }

            }
        }
        return []
//        if jsonArr.count == 1 {
//        return jsonArr.map { Transaction(json: $0) }
//        } else {
//        var temp: [Transaction] = []
//        _ = jsonArr.map {
//            for key in Array($0.keys) {
//            if let data = $0[key] as? JSONDictionary {
//                var newData = data
//                newData["ledger_name"] = key
//                temp.append(Transaction(json: newData))
//            }
//            }
//        }
//        return temp
//        }
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
        case netbanking
        case card
        case upi
        case wallet
    }
    
    enum Wallets:String{
        case mobikwik
        case freecharge
        case payzapp
        case airtelmoney
        case jiomoney
        case olamoney
        case phonepe
        case phonepeswitch
        case paypal
        case amazonpay
        case none
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
    var walletName : String = ""
    
    var method: Method {
        get {
            return Method(rawValue: self._method) ?? Method.none
        }
        
        set {
            self._method = newValue.rawValue
        }
    }
    
    
    var wallet: Wallets {
        get {
            return Wallets(rawValue: self.walletName.lowercased()) ?? Wallets.none
        }
        
        set {
            self.walletName = newValue.rawValue
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
        if let obj = json["wallet_name"] {
            self.walletName = "\(obj)".removeNull
        }
    }
}

struct Codes {
    var code: Int = 0
    var ledgerName: String = ""
    var amount: Double = 0.0
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["id"] {
            self.code = "\(obj)".toInt ?? 0
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
        codes.sort { $0.code < $1.code }
        printDebug(codes)
        return codes
    }
}

struct WeatherInfo {
    var maxTemperature: Int?
    var minTemperature: Int?
    var weather: String = ""
    var weatherIcon: String = ""
    var temperature: Int?
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
            let date = String("\(obj)".split(separator: " ").first ?? "")
            self.date = date.toDate(dateFormat: "yyyy-MM-dd")
        }
        
        if let obj = json["country_code"] {
            self.countryCode = "\(obj)"
        }
        
        if let obj = json["city"] {
            self.city = "\(obj)"
        }
        
        if let obj = json["temperature"] {
            self.temperature = "\(obj)".toInt ?? 0
        }
        
    }
    
    static func getModels(json: [JSONDictionary]) -> [WeatherInfo] {
        return json.map { WeatherInfo(json: $0) }
    }
}

struct TripInfo {
    var bookingId: String = ""
    var tripId: String = ""
    var eventId: String = ""
    var isUpdated: String = ""
    var name: String = ""

    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["booking_id"] {
            self.bookingId = "\(obj)".removeNull
        }
        
        if let obj = json["trip_id"] {
            self.tripId = "\(obj)".removeNull
        }
        
        if let obj = json["event_id"] {
            self.eventId = "\(obj)".removeNull
        }
        
        if let obj = json["is_updated"] {
            self.isUpdated = "\(obj)".removeNull
        }
        
        if let obj = json["name"] {
            self.name = "\(obj)".removeNull
        }
    }
}




struct AddOns {
    var addOn: AddOn?
    var preferences: Preference?
    var ff: [FF]?
    
    init() {
        self.init(json: [:])
    }
    
    
    init(json: JSONDictionary) {
        if let obj = json["addon"] as? JSONDictionary {
            self.addOn = AddOn(json: obj)
        }
        
        if let obj = json["preferences"] as? JSONDictionary {
            self.preferences = Preference(json: obj)
        }
        
        if let obj = json["ff"] as? JSONDictionary {
            self.ff = FF.models(json: obj)
        }
    }
}





struct AddOn {
    var seat: String = ""
    var meal: String = ""
    var baggage: String = ""
    var others: String = ""
    var amount: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["seat"] {
            self.seat = "\(obj)".removeNull
        }
        
        if let obj = json["meal"] {
            self.meal = "\(obj)".removeNull
        }
        
        if let obj = json["baggage"] {
            self.baggage = "\(obj)".removeNull
        }
        
        if let obj = json["others"] {
            self.others = "\(obj)".removeNull
        }
        
        if let obj = json["amount"] {
            self.amount = "\(obj)".removeNull
        }
    }
}


struct Preference {
    var seat: String = ""
    var meal: String = ""
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json["seat"] {
            self.seat = "\(obj)".removeNull
        }
        
        if let obj = json["meal"] {
            self.meal = "\(obj)".removeNull
        }
    }
    
    
    
}


struct FF {
    var key: String = ""
    var value: String = ""

    init() {
        self.init(json: [:])
    }

    init(json: JSONDictionary) {
        if let obj = json["key"] {
            self.key = "\(obj)".removeNull
        }
        if let obj = json["value"] {
            self.value = "\(obj)".removeNull
        }
    }

    static func models(json: JSONDictionary) -> [FF] {
        var ff = [FF]()

        let keyArr: [String] = Array(json.keys)
        for key in keyArr {
            let temp = ["key": key , "value": json[key] ?? ""]
            ff.append(FF(json: temp as JSONDictionary))
        }
        return ff
    }
}

struct BookingAddons{
    var serviceName:String = ""
    var paxId:String = ""
    var addonType:String = ""
    var legId:String = ""
    var flightId:String = ""
    var ssrCode:String = ""
    var addonId:String = ""
    var extraDetails:String = ""
    var bookingId:String = ""
    var price:String = ""
    var status:String = ""
    var pax:Pax?
    init(_ json:JSON = JSON(), leg:BookingLeg? = nil) {
        serviceName = json["service_name"].stringValue
        paxId = json["pax_id"].stringValue
        addonType = json["addon_type"].stringValue
        legId = json["leg_id"].stringValue
        flightId = json["flight_id"].stringValue
        ssrCode = json["ssr_code"].stringValue
        addonId = json["addon_id"].stringValue
        extraDetails = json["extra_details"].stringValue
        bookingId = json["booking_id"].stringValue
        price = json["price"].stringValue
        status = json["status"].stringValue
        if let leg = leg{
            self.pax = leg.pax.first(where: {$0.paxId == self.paxId})
        }
    }
    
}
