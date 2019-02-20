//
//  HotelFilterVM.swift
//  AERTRIP
//
//  Created by apple on 06/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

enum SortUsing {
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
    var distanceRange: Double = 2.0
    var minimumPrice: Double = 0.0
    var maximumPrice: Double = 0.0
    var amenitites: [Int] = []
    var roomMeal : [Int] = []
    var roomCancelation: [Int] = []
    var roomOther: [Int] = []
    var sortUsing: SortUsing = .BestSellers
    
    
    private init() {}
    
    
}
