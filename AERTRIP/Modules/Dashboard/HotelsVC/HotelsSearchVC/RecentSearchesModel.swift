//
//  RecentSearchesModel.swift
//  AERTRIP
//
//  Created by Admin on 25/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct RecentSearchesModel {
    var startDate: String = ""
    //Place
    var errorPlace: Bool = false
    var errorMsgPlace: String = ""
    var dest_id: String = ""
    var dest_type: String = ""
    var dest_name: String = ""
    //CheckInDate
    var checkInDate: String = ""//value
    //    var errorCheckInDate: Bool = false
    //    var errorMsgCheckInDate: String = ""
    //CheckOutData
    var checkOutDate: String = ""//value
    //    var errorCheckOutData: Bool = false
    //    var errorMsgCheckOutData: String = ""
    //Nights
    var totalNights: Int = 0//value
    //    var errorNightsMsg: String = ""
    //    var errorInNights:Bool = false
    //Guests
    var guestsValue:String = ""//value
    //    var guestValueError: Bool = false
    //    var guestErrorString: String = ""
    var room: [RecentRoom]?
    var filter: RecentSearchesFilter?
    var added_on:Int64 = 0
    var time_ago: String = ""
    var lat: String = ""
    var lng: String = ""
    var search_nearby: Bool = false
    var type = ChatVM.RecentSearchFor.hotel
    var flight: RecentSearchDisplayModel?
    
    
    var currentIndexInList:Int?//For checking selected index is first or not for ingnoring previouse applied filter.
    //Mark:- Initialization
    //=====================
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.startDate.rawValue: self.startDate,
                APIKeys.error.rawValue: self.errorPlace,
                APIKeys.errorMsg.rawValue: self.errorMsgPlace,
                APIKeys.dest_id.rawValue: self.dest_id,
                APIKeys.dest_type.rawValue: self.dest_type,
                APIKeys.dest_name.rawValue: self.dest_name,
                APIKeys.value.rawValue: self.checkInDate,
                APIKeys.value.rawValue: self.checkOutDate,
                APIKeys.value.rawValue: self.totalNights,
                APIKeys.value.rawValue: self.guestsValue,
                APIKeys.added_on.rawValue: self.added_on,
                APIKeys.time_ago.rawValue: self.time_ago,
                APIKeys.search_nearby.rawValue: self.search_nearby]
    }
    
    init(json: JSONDictionary) {
        
        if let obj = json[APIKeys.startDate.rawValue] {
            self.startDate = "\(obj)".removeNull.stringIn_yyyyMMdd
        }
        if let added_on = json[APIKeys.added_on.rawValue] as? Int64 {
            self.added_on = added_on
        }
        
        if let time_ago = json[APIKeys.time_ago.rawValue] {
            self.time_ago = "\(time_ago)".removeNull
        }
        if let obj = json[APIKeys.recentSearchQuery.rawValue] as? JSONDictionary {
            
            if let placeData = obj[APIKeys.place.rawValue] as? JSONDictionary {
                if let errorPlace = placeData[APIKeys.error.rawValue] as? Bool {
                    self.errorPlace = errorPlace
                }
                
                if let errorMsgPlace = placeData[APIKeys.errorMsg.rawValue] as? String {
                    self.errorMsgPlace = errorMsgPlace
                }
                
                if let dest_id = placeData[APIKeys.dest_id.rawValue] {
                    self.dest_id = "\(dest_id)".removeNull
                }
                
                if let dest_type = placeData[APIKeys.dest_type.rawValue] {
                    self.dest_type = "\(dest_type)".removeNull
                }
                
                if let dest_name = placeData[APIKeys.dest_name.rawValue] {
                    self.dest_name = "\(dest_name)".removeNull
                }
            }
            
            if let lat = obj[APIKeys.lat.rawValue] {
                self.lat = "\(lat)".removeNull
            }
            if let lng = obj[APIKeys.lng.rawValue] {
                self.lng = "\(lng)".removeNull
            }
            
            if let checkInDateData = obj[APIKeys.checkInDate.rawValue] as? JSONDictionary {
                if let checkInDate = checkInDateData[APIKeys.value.rawValue] {
                    self.checkInDate = "\(checkInDate)".removeNull
                }
            }
            
            if let checkOutDateData = obj[APIKeys.checkOutDate.rawValue] as? JSONDictionary {
                if let checkOutDate = checkOutDateData[APIKeys.value.rawValue] {
                    self.checkOutDate = "\(checkOutDate)".removeNull
                }
            }
            
            if let nightsData = obj[APIKeys.nights.rawValue] as? JSONDictionary {
                if let totalNights = nightsData[APIKeys.value.rawValue] as? Int {
                    self.totalNights = totalNights
                }
            }
            
            if let guestData = obj[APIKeys.guests.rawValue] as? JSONDictionary {
                if let guestsValue = guestData[APIKeys.value.rawValue] {
                    self.guestsValue = "\(guestsValue)".removeNull
                }
            }
            
            if let roomData = obj[APIKeys.room.rawValue] as? [JSONDictionary] {
                self.room = RecentRoom.recentRoomsData(jsonArr: roomData)
            }
            
            if let filterData = obj[APIKeys.filter.rawValue] as? JSONDictionary {
                self.filter = RecentSearchesFilter.filterData(json: filterData)
            }
            
            if let search_nearby = obj[APIKeys.search_nearby.rawValue] as? Bool {
                self.search_nearby = search_nearby
            }
            
        }
    }
    
    //Mark:- Functions
    //================
    ///Static Function
    static func recentSearchData(jsonArr: [JSONDictionary]) -> [RecentSearchesModel] {
        var recentSearchesData = [RecentSearchesModel]()
        for json in jsonArr {
            let obj = RecentSearchesModel(json: json)
            recentSearchesData.append(obj)
        }
        return recentSearchesData
    }
    
    static func recentSearchDataWithType(type : ChatVM.RecentSearchFor ,jsonArr: [JSONDictionary], extraData: JSONDictionary? = nil) -> [RecentSearchesModel] {
        var recentSearchesData = [RecentSearchesModel]()
        for json in jsonArr {
            var obj = RecentSearchesModel(json: json)
            if type == .flight {
                obj.flight = RecentSearchDisplayModel(dictionary: json)
                obj.flight?.quary[APIKeys.extra_data.rawValue] = extraData
            }
            obj.type = type
            recentSearchesData.append(obj)
        }
        return recentSearchesData
    }
    
    func getTextWidth(_ height: CGFloat) -> CGFloat {
        var titleWidth: CGFloat = 0
        var dateWidth: CGFloat = 0
        var title = ""
        // var textWidth = width + 86
        //        if recentSearchesData.search_nearby {
        //
        var date = ""
        if let checkInDate = self.checkInDate.toDate(dateFormat: "E, dd MMM yy"), let checkOutDate = self.checkOutDate.toDate(dateFormat: "E, dd MMM yy") {
            date = checkInDate.toString(dateFormat: "dd MMM") + " - " + checkOutDate.toString(dateFormat: "dd MMM")
        }
        dateWidth = date.widthOfText(height, font: AppFonts.Regular.withSize(14.0))
        //            textWidth = width + 78
        //        } else {
        let cityName = self.dest_name.split(separator: ",").first ?? ""
        let countryCode = self.dest_name.split(separator: ",").last ?? ""
        //        self.cityNameLabel.text = "\(cityName)"
        let prefix: String = cityName.isEmpty ? "" : "\(cityName),"
        let suffix: String = countryCode.isEmpty ? "" : ",\(countryCode)"
        
        var stateText = self.dest_name.deletingPrefix(prefix: prefix).removeSpaceAsSentence
        //stateText = stateText.deletingSuffix(suffix: suffix).removeSpaceAsSentence
        
        title = "\(cityName) " + stateText
        titleWidth = AppGlobals.shared.AttributedFontAndColorForText(text: title, atributedText: "\(cityName)", textFont: AppFonts.SemiBold.withSize(18.0), textColor: AppColors.themeBlack).width(withConstrainedHeight: height)
        // textWidth = width + 86
        
        //        }
        printDebug(title)
        return titleWidth > dateWidth ? titleWidth : dateWidth
    }
}

struct RecentRoom {
    var adultCounts: String = ""//adults
    var child: [Child] = []
    var isPresent: Bool = false //show
    
    //Mark:- Initialization
    //=====================
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.adults.rawValue: self.adultCounts,
                APIKeys.child.rawValue: self.child,
                APIKeys.show.rawValue: self.isPresent]
    }
    
    init(json: JSONDictionary) {
        
        if let obj = json[APIKeys.adults.rawValue] {
            self.adultCounts = "\(obj)".removeNull
        }
        if let childData = json[APIKeys.child.rawValue] as? [JSONDictionary] {
            self.child = Child.childRoomsData(jsonArr: childData)
        }
        if let obj = json[APIKeys.show.rawValue] as? Int {
            self.isPresent = (obj == 0 ? false : true)
        }
    }
    
    //Mark:- Functions
    //================
    ///Static Function
    static func recentRoomsData(jsonArr: [JSONDictionary]) -> [RecentRoom] {
        var roomsData = [RecentRoom]()
        for json in jsonArr {
            let obj = RecentRoom(json: json)
            roomsData.append(obj)
        }
        return roomsData
    }
}

struct Child {
    var isPresent: Bool = false//show
    var childAge: Int = -1//age
    var error: Bool = false //error
    
    //Mark:- Initialization
    //=====================
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.show.rawValue: self.isPresent,
                APIKeys.age.rawValue: self.childAge,
                APIKeys.error.rawValue: self.error]
    }
    
    init(json: JSONDictionary) {
        if let obj = json[APIKeys.show.rawValue] as? Int {
            self.isPresent = (obj == 0 ? false : true)
        }
        if let obj = json[APIKeys.age.rawValue] as? Int {
            self.childAge = obj
        }
        if let error = json[APIKeys.error.rawValue] as? Bool {
            self.error = error
        }
    }
    
    //Mark:- Functions
    //================
    ///Static Function
    static func childRoomsData(jsonArr: [JSONDictionary]) -> [Child] {
        var childData = [Child]()
        for json in jsonArr {
            let obj = Child(json: json)
            childData.append(obj)
        }
        return childData
    }
}

struct RecentSearchesFilter {
    //star
    var stars: [Int] = []
    
    //tripAdvisorRatings
    var noTripAdvisorStar: Bool = false
    var firstTripAdvisorStar: Bool = false
    var secondTripAdvisorStar: Bool = false
    var thirdTripAdvisorStar: Bool = false
    var fourthTripAdvisorStar: Bool = false
    var fifthTripAdvisorStar: Bool = false
    
    //Amenities
    var amenities: JSONDictionary = [:]
    //var amenities: RecentAmenities?
    
    //PriceRange
    var boundaryMinPrice: Int = 0//boundaryMin
    var boundaryMaxPrice: Int = 0//boundaryMax
    var minPrice: Int = 0//min
    var maxPrice: Int = 0//max
    
    //Meals //meals
    var no_meals: Bool = false//no_meals
    var breakfast: Bool = false
    var half_board: Bool = false
    var full_board: Bool = false
    var otherMeals: Bool = false//others
    
    //Cancellation Policy
    var refundable: Bool = false//rfdble
    var partiallyRefundable: Bool = false//part_refdble
    var nonRefundable: Bool = false//non_refundable
    
    //Others
    var others: [String : Any] = [:]//others
    
    //Distance
    var distance: Int = 0
    var sort: SortUsing = .BestSellers
    var priceType: Price = .Total
    
    //Mark:- Initialization
    //=====================
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        
        if let starData = json[APIKeys.star.rawValue] as? JSONDictionary {
            self.stars.removeAll()
            for index in 1...5 {
                if let isInclude = starData["\(index)\(APIKeys.star.rawValue.lowercased())"] as? Bool, isInclude {
                    self.stars.append(index)
                }
            }
        }
        
        if let starData = json[APIKeys.tripAdvisorRatings.rawValue] as? JSONDictionary {
            if let noTripAdvisorStar = starData["\(0)\(APIKeys.star.rawValue)"] as? Bool {
                self.noTripAdvisorStar = noTripAdvisorStar
            }
            if let firstTripAdvisorStar = starData["\(1)\(APIKeys.star.rawValue)"] as? Bool {
                self.firstTripAdvisorStar = firstTripAdvisorStar
            }
            if let secondTripAdvisorStar = starData["\(2)\(APIKeys.star.rawValue)"] as? Bool {
                self.secondTripAdvisorStar = secondTripAdvisorStar
            }
            if let thirdTripAdvisorStar = starData["\(3)\(APIKeys.star.rawValue)"] as? Bool {
                self.thirdTripAdvisorStar = thirdTripAdvisorStar
            }
            if let fourthTripAdvisorStar = starData["\(4)\(APIKeys.star.rawValue)"] as? Bool {
                self.fourthTripAdvisorStar = fourthTripAdvisorStar
            }
            if let fifthTripAdvisorStar = starData["\(5)\(APIKeys.star.rawValue)"] as? Bool {
                self.fifthTripAdvisorStar = fifthTripAdvisorStar
            }
        }
        
        if let amenities = json[APIKeys.amenities.rawValue] as? JSONDictionary {
            self.amenities = amenities
        }
        
        if let priceData = json[APIKeys.priceRange.rawValue] as? JSONDictionary {
            if let obj = priceData[(APIKeys.boundaryMin.rawValue)] as? Int {
                self.boundaryMinPrice = obj
            }
            if let obj = priceData[APIKeys.boundaryMax.rawValue] as? Int {
                self.boundaryMaxPrice = obj
            }
            if let obj = priceData[APIKeys.minPrice.rawValue] as? Int {
                self.minPrice = obj
            }
            if let obj = priceData[APIKeys.minPrice.rawValue] as? String {
                self.minPrice = obj.toInt ?? 0
            }
            if let obj = priceData[APIKeys.maxPrice.rawValue] as? Int {
                self.maxPrice = obj
            }
            if let obj = priceData[APIKeys.maxPrice.rawValue] as? String {
                self.maxPrice = obj.toInt ?? 0
            }
        }
        
        if let mealsData = json[APIKeys.meals.rawValue] as? JSONDictionary {
            if let obj = mealsData[(APIKeys.no_meals.rawValue)] as? Bool {
                self.no_meals = obj
            }
            if let obj = mealsData[APIKeys.breakfast.rawValue] as? Bool {
                self.breakfast = obj
            }
            if let obj = mealsData[APIKeys.half_board.rawValue] as? Bool {
                self.half_board = obj
            }
            if let obj = mealsData[APIKeys.full_board.rawValue] as? Bool {
                self.full_board = obj
            }
            if let obj = mealsData[APIKeys.others.rawValue] as? Bool {
                self.otherMeals = obj
            }
        }
        
        if let cancellationPolicy = json[APIKeys.cancellation_policy.rawValue] as? JSONDictionary {
            if let obj = cancellationPolicy[(APIKeys.refundable.rawValue)] as? Bool {
                self.refundable = obj
            }
            if let obj = cancellationPolicy[APIKeys.partiallyRefundable.rawValue] as? Bool {
                self.partiallyRefundable = obj
            }
            if let obj = cancellationPolicy[APIKeys.nonRefundable.rawValue] as? Bool {
                self.nonRefundable = obj
            }
        }
        
        if let othersData = json[APIKeys.others.rawValue] as? JSONDictionary {
            self.others = othersData
        }
        
        let jsonData = JSON(json)
        
        distance = jsonData[APIKeys.distance.rawValue].intValue
        priceType = jsonData[APIKeys.priceType.rawValue].stringValue == Price.Total.stringValue() ? .Total : .PerNight
        
        let sortType = jsonData[APIKeys.sort.rawValue][APIKeys.sortType.rawValue].stringValue
        let isAscending = jsonData[APIKeys.sort.rawValue][APIKeys.orderAscending.rawValue].boolValue
        
        switch sortType {
        case "bestSellers":
            sort = .BestSellers
        case "priceLowToHigh":
            sort = .PriceLowToHigh(ascending: isAscending)
        case "taRatingHighToLow":
            sort = .TripAdvisorRatingHighToLow(ascending: isAscending)
        case "starRatingHighToLow":
            sort = .StartRatingHighToLow(ascending: isAscending)
        case "distanceNearestFirst":
            sort = .DistanceNearestFirst(ascending: isAscending)
        default:
            sort = .BestSellers
        }
        
    }
    
    //Mark:- Functions
    //================
    ///Static Function
    static func filterData(json: JSONDictionary) -> RecentSearchesFilter {
        let filterArray = RecentSearchesFilter(json: json)
        return filterArray
    }
}

struct RecentAmenities {
    
    var isAvailable: Bool = false//show
    var isChecked: Int = 0
    var id: Int = 0
    
    //Mark:- Initialization
    //=====================
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.show.rawValue: self.isAvailable,
                APIKeys.isChecked.rawValue: self.isChecked,
                APIKeys.id.rawValue: self.id]
    }
    
    init(json: JSONDictionary) {
        
        if let obj = json[APIKeys.show.rawValue] as? Int {
            self.isAvailable = (obj == 0 ? false : true)
        }
        if let obj = json[APIKeys.isChecked.rawValue] as? Int {
            self.isChecked = obj
        }
        if let obj = json[APIKeys.id.rawValue] as? Int {
            self.id = obj
        }
    }
    
    //Mark:- Functions
    //================
    ///Static Function
    static func recentAmenities(json: JSONDictionary) -> RecentAmenities {
        let amenitiesData = RecentAmenities(json: json)
        return amenitiesData
    }
}
