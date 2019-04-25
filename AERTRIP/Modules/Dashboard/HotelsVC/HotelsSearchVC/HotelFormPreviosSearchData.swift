//
//  HotelFormPreviosSearchData.swift
//  AERTRIP
//
//  Created by Admin on 01/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct HotelFormPreviosSearchData: Codable {
    var roomNumber: Int = 0
    var adultsCount: [Int] = []
    var childrenCounts: [Int] = []
    var childrenAge: [[Int]] = [[]] // [[1,2,3,4], []]
    var checkInDate = ""
    var checkOutDate = ""
    var destId: String = ""
    var destName: String = ""
    var destType: String = ""
    var stateName: String = ""
    var cityName: String = ""
    var ratingCount: [Int] = []
    var totalGuestCount: Int {
        let totalAd = adultsCount.reduce(0) { $0 + $1 }
        let totalCh =  childrenCounts.reduce(0) { $0 + $1 }
        return totalAd + totalCh
    }
    var totalNights: Int {
        if !self.checkInDate.isEmpty , !self.checkOutDate.isEmpty {
            return self.checkOutDate.toDate(dateFormat: "yyyy-MM-dd")!.daysFrom(self.checkInDate.toDate(dateFormat: "yyyy-MM-dd")!)
        }
        return 0
    }
    var checkInDateWithDay: String {
        let checkInDate = self.checkInDate.toDate(dateFormat: "yyyy-MM-dd")
        return checkInDate?.toString(dateFormat: "E, dd MMM yy") ?? ""
    }
    var checkOutDateWithDay: String {
        let checkOutDate = self.checkOutDate.toDate(dateFormat: "yyyy-MM-dd")
        return checkOutDate?.toString(dateFormat: "E, dd MMM yy") ?? ""
    }


    
    var totalGuestCount: Int {
        let totalAd = adultsCount.reduce(0) { $0 + $1 }
        let totalCh =  childrenCounts.reduce(0) { $0 + $1 }
        return totalAd + totalCh
    }
    
    init() {
        self.roomNumber     =  1
        self.adultsCount    = [1]
        self.childrenCounts = [0]
        self.childrenAge    = [[0,0,0,0]]
        self.checkInDate    = Date().addDay(days: 0) ?? ""
        self.checkOutDate   = (self.checkInDate.toDate(dateFormat: "yyyy-MM-dd") ?? Date()).addDay(days: 5) ?? ""
        self.destId         = ""
        self.destType       = ""
        self.destName       = ""
        self.stateName      = ""
        self.cityName       = ""
        self.ratingCount    = [1,2,3,4,5]
    }
    
    private enum CodingKeys: String, CodingKey {
        case roomNumber
        case adultsCount
        case childrenCounts
        case childrenAge
        case checkInDate
        case checkOutDate
        case destId
        case destName
        case destType
        case stateName
        case cityName
        case ratingCount
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        roomNumber = try values.decode(Int.self, forKey: .roomNumber)
        adultsCount = try values.decode([Int].self, forKey: .adultsCount)
        childrenCounts = try values.decode([Int].self, forKey: .childrenCounts)
        childrenAge = try values.decode([[Int]].self, forKey: .childrenAge)
        checkInDate = try values.decode(String.self, forKey: .checkInDate)
        checkOutDate = try values.decode(String.self, forKey: .checkOutDate)
        destId = try values.decode(String.self, forKey: .destId)
        destName = try values.decode(String.self, forKey: .destName)
        destType = try values.decode(String.self, forKey: .destType)
        stateName = try values.decode(String.self, forKey: .stateName)
        cityName = try values.decode(String.self, forKey: .cityName)
        ratingCount = try values.decode([Int].self, forKey: .ratingCount)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(roomNumber, forKey: .roomNumber)
        try container.encode(adultsCount, forKey: .adultsCount)
        try container.encode(childrenCounts, forKey: .childrenCounts)
        try container.encode(childrenAge, forKey: .childrenAge)
        try container.encode(checkInDate, forKey: .checkInDate)
        try container.encode(checkOutDate, forKey: .checkOutDate)
        try container.encode(destId, forKey: .destId)
        try container.encode(destName, forKey: .destName)
        try container.encode(destType, forKey: .destType)
        try container.encode(stateName, forKey: .stateName)
        try container.encode(cityName, forKey: .cityName)
        try container.encode(ratingCount, forKey: .ratingCount)
    }
}
