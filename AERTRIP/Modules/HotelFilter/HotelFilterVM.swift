//
//  HotelFilterVM.swift
//  AERTRIP
//
//  Created by apple on 06/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

enum SortUsing {
    private enum CodingKeys: CodingKey {
        case bestSellers, priceLowToHigh, tripAdvisorRatingHighToLow, starRatingHighToLow, distanceNearestFirst
    }
    
    case BestSellers
    case PriceLowToHigh
    case TripAdvisorRatingHighToLow
    case StartRatingHighToLow
    case DistanceNearestFirst
}

class HotelFilterVM {
    static let shared = HotelFilterVM()
    
    var defaultRatingCount: [Int] = [1,2,3,4,5]
    var defaultTripAdvisorRatingCount: [Int] = [1,2,3,4,5]
    var defaultIsIncludeUnrated: Bool = true
    var defaultDistanceRange: Double = 20.0
    var defaultLeftRangePrice: Double = 0.0
    var defaultRightRangePrice: Double = 0.0
    var defaultAmenitites: [String] = []
    var defaultRoomMeal: [String] = []
    var defaultRoomCancelation: [String] = []
    var defaultRoomOther: [String] = []
    var defaultSortUsing: SortUsing = .BestSellers
    var defaultPriceType: Price = .Total
    
    var ratingCount: [Int] = [1,2,3,4,5]
    var tripAdvisorRatingCount: [Int] = [1,2,3,4,5]
    var isIncludeUnrated: Bool = true
    var distanceRange: Double = 20.0
    var minimumPrice: Double = 0.0
    var maximumPrice: Double = 0.0
    var leftRangePrice: Double = 0.0
    var rightRangePrice: Double = 0.0
    var amenitites: [String] = []
    var roomMeal: [String] = []
    var roomCancelation: [String] = []
    var roomOther: [String] = []
    var sortUsing: SortUsing = .BestSellers
    var priceType: Price = .Total
    var totalHotelCount: Int = 0
    var filterHotelCount: Int = 0
    var lastSelectedIndex: Int = 0
    
    func saveDataToUserDefaults() {
        var filter = UserInfo.HotelFilter()
        filter.ratingCount =  ratingCount
        filter.tripAdvisorRatingCount = tripAdvisorRatingCount
        filter.isIncludeUnrated = isIncludeUnrated
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
        
        UserInfo.hotelFilter = filter
        
        if let filter = UserInfo.hotelFilter {
            printDebug(filter)
        }
    }
    
    func resetToDefault() {
        self.ratingCount = defaultRatingCount
        self.tripAdvisorRatingCount = defaultTripAdvisorRatingCount
        self.isIncludeUnrated = defaultIsIncludeUnrated
        self.distanceRange = defaultDistanceRange
        self.leftRangePrice = defaultLeftRangePrice
        self.rightRangePrice = defaultRightRangePrice
        self.amenitites = defaultAmenitites
        self.roomMeal = defaultRoomMeal
        self.roomCancelation = defaultRoomCancelation
        self.roomOther = defaultRoomOther
        self.sortUsing = defaultSortUsing
        self.priceType = defaultPriceType
    }
    
    private init() {
        resetToDefault()
    }
}

extension SortUsing: Codable {
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
            self = .BestSellers
        case 1:
            self = .PriceLowToHigh
        case 2:
            self = .TripAdvisorRatingHighToLow
        case 3:
            self = .StartRatingHighToLow
        case 4:
            self = .DistanceNearestFirst
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
        case .TripAdvisorRatingHighToLow:
            try container.encode(2, forKey: .rawValue)
        case .StartRatingHighToLow:
            try container.encode(3, forKey: .rawValue)
        case .DistanceNearestFirst:
            try container.encode(4, forKey: .rawValue)
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
