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
    
    private init() {}
    
    
}
