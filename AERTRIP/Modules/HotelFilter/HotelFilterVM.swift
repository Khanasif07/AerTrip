//
//  HotelFilterVM.swift
//  AERTRIP
//
//  Created by apple on 06/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

enum SortUsing: Equatable {
    private enum CodingKeys: CodingKey {
        case bestSellers, priceLowToHigh, tripAdvisorRatingHighToLow, starRatingHighToLow, distanceNearestFirst
    }
    
    case BestSellers
    case PriceLowToHigh(ascending: Bool)
    case TripAdvisorRatingHighToLow(ascending: Bool)
    case StartRatingHighToLow(ascending: Bool)
    case DistanceNearestFirst(ascending: Bool)
}

protocol HotelFilterVMDelegate: class {
    func updateFiltersTabs()
    func updateHotelsCount()
}


class HotelFilterVM {
    static let shared = HotelFilterVM()
    
    var defaultRatingCount: [Int] = [1,2,3,4,5]
    var defaultTripAdvisorRatingCount: [Int] = [1,2,3,4,5]
    var defaultIsIncludeUnrated: Bool = true
    var defaultIsIncludeTAUnrated = true
    var defaultDistanceRange: Double = 25
    var defaultLeftRangePrice: Double = 0.0
    var defaultRightRangePrice: Double = 0.0
    var defaultAmenitites: [String] = []
    var defaultRoomMeal: [String] = []
    var defaultRoomCancelation: [String] = []
    var defaultRoomOther: [String] = []
    var defaultSortUsing: SortUsing = .BestSellers
    var defaultPriceType: Price = .PerNight
    
    var ratingCount: [Int] = [1,2,3,4,5]
    var tripAdvisorRatingCount: [Int] = [1,2,3,4,5]
    var isIncludeUnrated: Bool = true
    var isIncludeTAUnrated = true
    var distanceRange: Double = 25
    var minimumPrice: Double = 0.0
    var maximumPrice: Double = 0.0
    var leftRangePrice: Double = 0.0
    var rightRangePrice: Double = 0.0
    var amenitites: [String] = []
    var roomMeal: [String] = []
    var roomCancelation: [String] = []
    var roomOther: [String] = []
    var sortUsing: SortUsing = .BestSellers
    var priceType: Price = .PerNight
    var totalHotelCount: Int = 0
    var showIncludeUnrated: Bool = true
    var showIncludeTAUnrated = true
    
    var filterHotelCount: Int = 0
    var lastSelectedIndex: Int = 0
    var isSortingApplied: Bool = false
    let allTabsStr: [String] = [LocalizedString.Sort.localized, LocalizedString.Distance.localized, LocalizedString.Price.localized, LocalizedString.Ratings.localized, LocalizedString.Amenities.localized,LocalizedString.Room.localized]
    
    weak var delegate: HotelFilterVMDelegate?
    var isFilterAppliedForDestinetionFlow = false
    var availableAmenities: [String] = []

    var isFilterApplied: Bool {
        var isSorstingChanged = false
        var isRatingChanged = true
        var isTARatingChanged = true
        
        if HotelFilterVM.shared.isFilterAppliedForDestinetionFlow {
            isSorstingChanged = (HotelFilterVM.shared.sortUsing == .DistanceNearestFirst(ascending: true)) ? true : false
        } else {
            isSorstingChanged = (HotelFilterVM.shared.sortUsing == HotelFilterVM.shared.defaultSortUsing) ? true : false
        }
        
        let diff = HotelFilterVM.shared.ratingCount.difference(from: HotelFilterVM.shared.defaultRatingCount)
        let taDiff = HotelFilterVM.shared.tripAdvisorRatingCount.difference(from: HotelFilterVM.shared.defaultTripAdvisorRatingCount)
        
        if 1...4 ~= diff.count {
            isRatingChanged = false
        }
        
        if 1...4 ~= taDiff.count {
            isTARatingChanged = false
        }
        
        
        return !(isSorstingChanged && HotelFilterVM.shared.distanceRange == HotelFilterVM.shared.defaultDistanceRange && HotelFilterVM.shared.leftRangePrice == HotelFilterVM.shared.defaultLeftRangePrice && HotelFilterVM.shared.rightRangePrice == HotelFilterVM.shared.defaultRightRangePrice && isRatingChanged &&  isTARatingChanged && HotelFilterVM.shared.isIncludeUnrated == HotelFilterVM.shared.defaultIsIncludeUnrated && HotelFilterVM.shared.isIncludeTAUnrated == HotelFilterVM.shared.defaultIsIncludeTAUnrated && HotelFilterVM.shared.priceType == HotelFilterVM.shared.defaultPriceType && HotelFilterVM.shared.amenitites.difference(from: HotelFilterVM.shared.defaultAmenitites).isEmpty && HotelFilterVM.shared.roomMeal.difference(from: HotelFilterVM.shared.defaultRoomMeal).isEmpty && HotelFilterVM.shared.roomCancelation.difference(from: HotelFilterVM.shared.defaultRoomCancelation).isEmpty && HotelFilterVM.shared.roomOther.difference(from: HotelFilterVM.shared.defaultRoomOther).isEmpty)
    }
    
    func setData(from: UserInfo.HotelFilter) {
        ratingCount = from.ratingCount
        tripAdvisorRatingCount = from.tripAdvisorRatingCount
        isIncludeUnrated = from.isIncludeUnrated
        isIncludeTAUnrated = from.isIncludeTAUnrated
        distanceRange = from.distanceRange
        minimumPrice = from.minimumPrice
        maximumPrice = from.maximumPrice
        leftRangePrice = from.leftRangePrice
        rightRangePrice = from.rightRangePrice
        amenitites = from.amentities
        roomMeal = from.roomMeal
        roomCancelation = from.roomCancelation
        roomOther = from.roomOther
        sortUsing = from.sortUsing
        priceType = from.priceType
        
        delay(seconds: 0.3) { [weak self] in
            self?.delegate?.updateFiltersTabs()
        }
        
    }
    
    func saveDataToUserDefaults() {
        var filter = UserInfo.HotelFilter()
        if 1...4 ~= ratingCount.count {
            filter.ratingCount = ratingCount
        }
        else {
            filter.ratingCount = defaultRatingCount
        }
        if 1...4 ~= tripAdvisorRatingCount.count {
            filter.tripAdvisorRatingCount = tripAdvisorRatingCount
        }
        else {
            filter.tripAdvisorRatingCount = defaultTripAdvisorRatingCount
        }
        //        filter.tripAdvisorRatingCount = tripAdvisorRatingCount
        filter.isIncludeUnrated = isIncludeUnrated
        filter.isIncludeTAUnrated = isIncludeTAUnrated
        filter.distanceRange = distanceRange
        filter.minimumPrice = minimumPrice
        filter.maximumPrice = maximumPrice
        filter.leftRangePrice = leftRangePrice
        filter.rightRangePrice = rightRangePrice
        filter.amentities = amenitites
        filter.roomMeal = roomMeal
        filter.roomCancelation = roomCancelation
        filter.roomOther = roomOther
        filter.sortUsing = sortUsing
        filter.priceType = priceType
        filter.isFilterAppliedForDestinetionFlow = isFilterAppliedForDestinetionFlow
        
        if self.isFilterApplied {
            UserInfo.hotelFilter = filter
        } else {
            UserInfo.hotelFilter = nil
        }
        if let filter = UserInfo.hotelFilter {
            printDebug(filter)
        }
    }
    
    func resetToDefault() {
        self.ratingCount = defaultRatingCount
        self.tripAdvisorRatingCount = defaultTripAdvisorRatingCount
        self.isIncludeUnrated = defaultIsIncludeUnrated
        self.isIncludeTAUnrated = defaultIsIncludeTAUnrated
        self.distanceRange = defaultDistanceRange
        self.leftRangePrice = defaultLeftRangePrice
        self.rightRangePrice = defaultRightRangePrice
        self.amenitites = defaultAmenitites
        self.roomMeal = defaultRoomMeal
        self.roomCancelation = defaultRoomCancelation
        self.roomOther = defaultRoomOther
        self.sortUsing = defaultSortUsing
        self.priceType = defaultPriceType
        if self.isFilterAppliedForDestinetionFlow  {
            self.sortUsing = .DistanceNearestFirst(ascending: true)
        }
        //self.isFilterAppliedForDestinetionFlow = false
    }
    
    private init() {
        resetToDefault()
    }
    
    func filterAppliedFor(filterName: String, appliedFilter:  UserInfo.HotelFilter) -> Bool {
        
        switch filterName.lowercased() {
        case LocalizedString.Sort.localized.lowercased():
            if HotelFilterVM.shared.isFilterAppliedForDestinetionFlow {
                return (appliedFilter.sortUsing == .DistanceNearestFirst(ascending: true)) ? false : true
            } else {
                return (appliedFilter.sortUsing == HotelFilterVM.shared.defaultSortUsing) ? false : true
            }
        case LocalizedString.Distance.localized.lowercased():
            return (appliedFilter.distanceRange == HotelFilterVM.shared.defaultDistanceRange) ? false : true
            
        case LocalizedString.Price.localized.lowercased():
            if appliedFilter.rightRangePrice <= 0 {
                return  false
            }else if appliedFilter.leftRangePrice != HotelFilterVM.shared.defaultLeftRangePrice {
                return true
            }
            else if appliedFilter.rightRangePrice != HotelFilterVM.shared.defaultRightRangePrice {
                return  true
            }
            else if appliedFilter.priceType != HotelFilterVM.shared.defaultPriceType {
                return  true
            }
            return  false
        case LocalizedString.Ratings.localized.lowercased():
            
            var appliedRating = appliedFilter.ratingCount
            if appliedRating.contains(0) {
                appliedRating.remove(object: 0)
            }
            
            var appliedTARating = appliedFilter.tripAdvisorRatingCount
            if appliedTARating.contains(0) {
                appliedTARating.remove(object: 0)
            }
            
            let diff = appliedRating.difference(from: HotelFilterVM.shared.defaultRatingCount)
            let taDiff = appliedTARating.difference(from: HotelFilterVM.shared.defaultTripAdvisorRatingCount)
            
            if 1...4 ~= diff.count {
                return true
            }
            else if 1...4 ~= taDiff.count {
                return true
            }
            else if appliedFilter.isIncludeUnrated != HotelFilterVM.shared.defaultIsIncludeUnrated {
                return  true
            } else if appliedFilter.isIncludeTAUnrated != HotelFilterVM.shared.defaultIsIncludeTAUnrated {
                return true
            }
            return  false
        case LocalizedString.Amenities.localized.lowercased():
            if !appliedFilter.amentities.difference(from: HotelFilterVM.shared.defaultAmenitites).isEmpty {
                return  true
            }
            return  false
        case LocalizedString.Room.localized.lowercased():
            if !appliedFilter.roomMeal.difference(from: HotelFilterVM.shared.defaultRoomMeal).isEmpty {
                return  true
            }
            else if !appliedFilter.roomCancelation.difference(from: HotelFilterVM.shared.defaultRoomCancelation).isEmpty {
                return  true
            }
            else if !appliedFilter.roomOther.difference(from: HotelFilterVM.shared.defaultRoomOther).isEmpty {
                return  true
            }
            return  false
        default:
            printDebug("not useable case")
            return false
        }
    }
}

extension SortUsing: Codable {
    enum Key: CodingKey {
        case rawValue
        case bestSellers, priceLowToHigh, tripAdvisorRatingHighToLow, starRatingHighToLow, distanceNearestFirst
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .BestSellers
        case 1:
            let value = try container.decode(Bool.self, forKey: .priceLowToHigh)
            self = .PriceLowToHigh(ascending: value)
        case 2:
            let value = try container.decode(Bool.self, forKey: .tripAdvisorRatingHighToLow)
            self = .TripAdvisorRatingHighToLow(ascending: value)
        case 3:
            let value = try container.decode(Bool.self, forKey: .starRatingHighToLow)
            self = .StartRatingHighToLow(ascending: value)
        case 4:
            let value = try container.decode(Bool.self, forKey: .distanceNearestFirst)
            self = .DistanceNearestFirst(ascending: value)
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .BestSellers:
            try container.encode(0, forKey: .rawValue)
        case .PriceLowToHigh:
            try container.encode(1, forKey: .rawValue)
            try container.encode(self == .PriceLowToHigh(ascending: true), forKey: .priceLowToHigh)
        case .TripAdvisorRatingHighToLow:
            try container.encode(2, forKey: .rawValue)
            try container.encode(self == .TripAdvisorRatingHighToLow(ascending: true), forKey: .tripAdvisorRatingHighToLow)
        case .StartRatingHighToLow:
            try container.encode(3, forKey: .rawValue)
            try container.encode(self == .StartRatingHighToLow(ascending: true), forKey: .starRatingHighToLow)
        case .DistanceNearestFirst:
            try container.encode(4, forKey: .rawValue)
            try container.encode(self == .DistanceNearestFirst(ascending: true), forKey: .distanceNearestFirst)
        }
    }
}

extension Price: Codable {
    enum Key: CodingKey {
        case rawValue
    }
    
    enum CodingError: Error {
        case unknownValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .PerNight
        case 1:
            self = .Total
        default:
            throw CodingError.unknownValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Key.self)
        switch self {
        case .PerNight:
            try container.encode(0, forKey: .rawValue)
        case .Total:
            try container.encode(1, forKey: .rawValue)
        }
    }
}
