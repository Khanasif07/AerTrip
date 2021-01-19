//
//  HotelsResultVM+RecentSearches.swift
//  AERTRIP
//
//  Created by Rishabh on 05/01/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import Foundation

extension HotelsResultVM {
    
    func updateRecentSearch() {
        guard let latestSearchParams = getRecentSearchParams() else { return }
        
        APICaller.shared.setRecentHotelsSearchesApi(params: latestSearchParams) {(success, response, errors) in
            if success {
                printDebug(response)
            } else {
                printDebug(errors)
            }
        }
    }
    
    private func getRecentSearchParams() -> JSONDictionary? {
        let place: JSONDictionary = [APIKeys.error.rawValue : false , APIKeys.errorMsg.rawValue : "" , APIKeys.dest_id.rawValue : self.searchedFormData.destId , APIKeys.dest_type.rawValue : self.searchedFormData.destType , APIKeys.dest_name.rawValue : self.searchedFormData.destName]
        let checkInDate: JSONDictionary = [APIKeys.value.rawValue : self.searchedFormData.checkInDateWithDay, APIKeys.error.rawValue : false , APIKeys.errorMsg.rawValue : ""]
        let checkOutDate: JSONDictionary = [APIKeys.value.rawValue : self.searchedFormData.checkOutDateWithDay, APIKeys.error.rawValue : false , APIKeys.errorMsg.rawValue : ""]
        let nights: JSONDictionary = [APIKeys.value.rawValue : self.searchedFormData.totalNights, APIKeys.error.rawValue : false , APIKeys.errorMsg.rawValue : ""]
        let roomStr = searchedFormData.adultsCount.count < 2 ? "Room" : "Rooms"
        let guestStr = searchedFormData.totalGuestCount < 2 ? "Guest" : "Guests"
        let guests: JSONDictionary = [APIKeys.value.rawValue : "\(self.searchedFormData.adultsCount.count) \(roomStr), \(self.searchedFormData.totalGuestCount) \(guestStr)", APIKeys.error.rawValue : false , APIKeys.errorMsg.rawValue : ""]
        
        var room: JSONDictionaryArray = []
        for (index,adultData) in self.searchedFormData.adultsCount.enumerated() {
            var childArrayData: JSONDictionaryArray = []
            
            if index < self.searchedFormData.childrenAge.count {
                for (childIndex,child) in self.searchedFormData.childrenAge[index].enumerated() {
                    if  childIndex < self.searchedFormData.childrenCounts[index] {
                    
                    let show: Int = child >= 0 ? 1 : 0
                    let childData: JSONDictionary = [APIKeys.show.rawValue : show , APIKeys.age.rawValue : child , APIKeys.error.rawValue : false]
                    childArrayData.append(childData)
                    }
                }
            }
            let roomData: JSONDictionary = [APIKeys.adults.rawValue : adultData , APIKeys.child.rawValue : childArrayData , APIKeys.show.rawValue : 1]
            room.append(roomData)
        }
        
        let filter = getFilterParams()
        
        let query: JSONDictionary = [APIKeys.place.rawValue : place , APIKeys.checkInDate.rawValue : checkInDate , APIKeys.checkOutDate.rawValue : checkOutDate , APIKeys.nights.rawValue : nights , APIKeys.guests.rawValue : guests, APIKeys.room.rawValue : room , APIKeys.filter.rawValue : filter, APIKeys.lat.rawValue : self.searchedFormData.lat, APIKeys.lng.rawValue : self.searchedFormData.lng, APIKeys.search_nearby.rawValue : self.searchedFormData.isHotelNearMeSelected ]
        
        let params: JSONDictionary = [
            APIKeys.product.rawValue : "hotel",
            "data[start_date]" : self.searchedFormData.checkInDate.stringIn_ddMMyyyy,
            "data[query]" : AppGlobals.shared.json(from: query) ?? ""
        ]
        printDebug(params)
        
        return  params
        
    }
    
    func getFilterParams() -> JSONDictionary {
        
        guard let _ = UserInfo.hotelFilter else { return [:] }
        
        var filterParams = JSONDictionary()
        
        // Price
        var priceRange = JSONDictionary()
        priceRange[APIKeys.boundaryMin.rawValue] = filterApplied.minimumPrice.toInt
        priceRange[APIKeys.boundaryMax.rawValue] = filterApplied.maximumPrice.toInt
        priceRange[APIKeys.minPrice.rawValue] = filterApplied.leftRangePrice.toInt
        priceRange[APIKeys.maxPrice.rawValue] = filterApplied.rightRangePrice.toInt
        filterParams[APIKeys.priceRange.rawValue] = priceRange
        
        //Ratings
        var star = JSONDictionary()
        for count in 0...5 {
            star["\(count)"+APIKeys.star.rawValue] = filterApplied.ratingCount.contains(count)
        }
        filterParams[APIKeys.star.rawValue] = star
        
        //TA Ratings
        var taStar = JSONDictionary()
        for count in 0...5 {
            taStar["\(count)"+APIKeys.star.rawValue] = filterApplied.tripAdvisorRatingCount.contains(count)
        }
        filterParams[APIKeys.tripAdvisorRatings.rawValue] = taStar
        
        //Amenities
        var amenities = JSONDictionary()
        ATAmenity.allCases.forEach { (amenity) in
            var amenityName = ""
            switch amenity {
            case .Wifi: amenityName = "ame-wi-fi"
            case .RoomService: amenityName = "ame-room-service"
            case .Internet: amenityName = "ame-internet"
            case .AirConditioner: amenityName = "ame-air-conditioner"
            case .RestaurantBar: amenityName = "ame-restaurant-bar"
            case .Gym: amenityName = "ame-gym"
            case .BusinessCenter: amenityName = "ame-business-center"
            case .Pool: amenityName = "ame-pool"
            case .Spa: amenityName = "ame-spa"
            case .Coffee_Shop: amenityName = "ame-coffee-shop"
            }
            var isChecked = false
            if filterApplied.amentities.contains(amenity.rawValue) {
                isChecked = true
            }
            var amenityDict = JSONDictionary()
            amenityDict[APIKeys.id.rawValue] = amenity.rawValue
            amenityDict[APIKeys.show.rawValue] = 1
            amenityDict[APIKeys.isChecked.rawValue] = isChecked
            amenities[amenityName] = amenityDict
        }
        filterParams[APIKeys.amenities.rawValue] = amenities
        
        //Meals
        var meals = JSONDictionary()
                
        meals[APIKeys.no_meals.rawValue] = filterApplied.roomMeal.contains(LocalizedString.RoomOnly.localized)
        meals[APIKeys.breakfast.rawValue] = filterApplied.roomMeal.contains(LocalizedString.Breakfast.localized)
        meals[APIKeys.full_board.rawValue] = filterApplied.roomMeal.contains(LocalizedString.FullBoard.localized)
        meals[APIKeys.half_board.rawValue] = filterApplied.roomMeal.contains(LocalizedString.HalfBoard.localized)
        meals[APIKeys.others.rawValue] = filterApplied.roomMeal.contains(LocalizedString.Others.localized)
        filterParams[APIKeys.meals.rawValue] = meals
        
        //Cancellation Policy
        var cancellationPolicy = JSONDictionary()
        cancellationPolicy[APIKeys.nonRefundable.rawValue] = filterApplied.roomCancelation.contains(LocalizedString.NonRefundable.localized)
        cancellationPolicy[APIKeys.refundable.rawValue] = filterApplied.roomCancelation.contains(LocalizedString.FreeCancellation.localized)
        cancellationPolicy[APIKeys.partiallyRefundable.rawValue] = filterApplied.roomCancelation.contains(LocalizedString.PartRefundable.localized)
        filterParams[APIKeys.cancellation_policy.rawValue] = cancellationPolicy
        
        //Others
        var others = JSONDictionary()
        others[APIKeys.transfer.rawValue] = filterApplied.roomOther.contains(LocalizedString.TransferInclusive.localized)
        others[APIKeys.wifi.rawValue] = filterApplied.roomOther.contains(LocalizedString.FreeWifi.localized)
        filterParams[APIKeys.others.rawValue] = others
        
        //Distance
        filterParams[APIKeys.distance.rawValue] = filterApplied.distanceRange.toInt
        
        //Price Type
        filterParams[APIKeys.priceType.rawValue] = filterApplied.priceType.stringValue()
        
        //Sort
        var sortType = ""
        var sortAcending = true
        switch filterApplied.sortUsing {
        case .BestSellers:
            sortType = "bestSellers"
        case .PriceLowToHigh(let isAscending):
            sortType = "priceLowToHigh"
            sortAcending = isAscending
        case .TripAdvisorRatingHighToLow(let isAscending):
            sortType = "taRatingHighToLow"
            sortAcending = isAscending
        case .StartRatingHighToLow(let isAscending):
            sortType = "starRatingHighToLow"
            sortAcending = isAscending
        case .DistanceNearestFirst(let isAscending):
            sortType = "distanceNearestFirst"
            sortAcending = isAscending
        }
        var sort = JSONDictionary()
        sort[APIKeys.sortType.rawValue] = sortType
        sort[APIKeys.orderAscending.rawValue] = sortAcending
        
        // Removed after discussion with Mahak and Girish
//        filterParams[APIKeys.sort.rawValue] = sort
        
        return filterParams
    }
}
