//
//  HotelFormPreviosSearchData.swift
//  AERTRIP
//
//  Created by Admin on 01/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

class HotelFormPreviosSearchData: NSObject, NSCoding {
    var roomNumber: Int = 0
    var adultsCount: [Int] = []
    var childrenCounts: [Int] = []
    var childrenAge: [[Int]] = [[]]
    var checkInDate = ""
    var checkOutDate = ""
    var destId: String = ""
    var destName: String = ""
    var destType: String = ""
    var stateName: String = ""
    var cityName: String = ""
    var ratingCount: [Int] = []
    
    override init() {
        self.roomNumber     =  0
        self.adultsCount    = []
        self.childrenCounts = []
        self.childrenAge    = [[]]
        self.checkInDate    = ""
        self.checkOutDate   = ""
        self.destId         = ""
        self.destType       = ""
        self.destName       = ""
        self.stateName      = ""
        self.cityName       = ""
        self.ratingCount    = []
    }

    required init(coder decoder: NSCoder) {
        self.roomNumber     = decoder.decodeObject(forKey: "roomNumber") as? Int ?? 0
        self.adultsCount    = decoder.decodeObject(forKey: "adultsCount") as? [Int] ?? []
        self.childrenCounts = decoder.decodeObject(forKey: "adultsCount") as? [Int] ?? []
        self.childrenAge    = decoder.decodeObject(forKey: "childrenAge") as? [[Int]] ?? [[]]
        self.checkInDate    = decoder.decodeObject(forKey: "checkInDate") as? String ?? ""
        self.checkOutDate   = decoder.decodeObject(forKey: "checkOutDate") as? String ?? ""
        self.destId         = decoder.decodeObject(forKey: "destId") as? String ?? ""
        self.destType       = decoder.decodeObject(forKey: "destType") as? String ?? ""
        self.destName       = decoder.decodeObject(forKey: "destName") as? String ?? ""
        self.stateName      = decoder.decodeObject(forKey: "stateName") as? String ?? ""
        self.cityName       = decoder.decodeObject(forKey: "cityName") as? String ?? ""
        self.ratingCount    = decoder.decodeObject(forKey: "ratingCount") as? [Int] ?? []
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(roomNumber, forKey: "roomNumber")
        coder.encode(adultsCount, forKey: "adultsCount")
        coder.encode(childrenCounts, forKey: "childrenCounts")
        coder.encode(childrenAge, forKey: "childrenAge")
        coder.encode(checkInDate, forKey: "checkInDate")
        coder.encode(checkOutDate, forKey: "checkOutDate")
        coder.encode(destId, forKey: "destId")
        coder.encode(destId, forKey: "destType")
        coder.encode(destId, forKey: "destName")
        coder.encode(stateName, forKey: "stateName")
        coder.encode(cityName, forKey: "cityName")
        coder.encode(ratingCount, forKey: "ratingCount")
    }
}
