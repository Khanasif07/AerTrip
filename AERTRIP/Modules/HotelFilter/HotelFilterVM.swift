//
//  HotelFilterVM.swift
//  AERTRIP
//
//  Created by apple on 06/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

class HotelFilterVM {
    
    static let shared = HotelFilterVM()
    
    var ratingCount: [Int] = []
    var tripAdvisorRatingCount: [Int] = []
    var isIncludeUnrated: Bool = false
    var distanceRange: Int = 0
    var minimumPrice: Float = 0.0
    var maximumPrice: Float = 0.0
    var amenitites: [Int] = []
    var roomMeal : [Int] = []
    var roomCancelation: [Int] = []
    var roomOther: [Int] = []
    
    
    
    private init() {}
    
    
}
