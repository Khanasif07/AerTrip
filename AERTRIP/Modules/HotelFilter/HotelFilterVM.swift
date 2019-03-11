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
    
    var ratingCount: [Int] = []
    var tripAdvisorRatingCount: [Int] = []
    var isIncludeUnrated: Bool = false
    var distanceRange: Double = 0.0
    var minimumPrice: Double = 0.0
    var maximumPrice: Double = 0.0
    var leftRangePrice: Double = 0.0
    var rightRangePrice : Double = 0.0
    var amenitites: [String] = []
    var roomMeal: [Int] = []
    var roomCancelation: [Int] = []
    var roomOther: [Int] = []
    var sortUsing: SortUsing = .BestSellers
    var totalHotelCount : Int  = 0
    var filterHotelCount : Int = 0 
    
    func saveDataToUserDefaults() {
        var filter = UserInfo.HotelFilter()
        filter.ratingCount = ratingCount
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
        
        UserInfo.loggedInUser?.hotelFilter = filter
        
        if let filter = UserInfo.loggedInUser?.hotelFilter {
            printDebug(filter)
        }
    }
    
    private init() {}
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
