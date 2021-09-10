//
//  HotelModel.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 19/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
//import SwiftyJSON

struct HotelsModel {
    
    var hotelMinStar  : Double
    var hotelMaxStar  : Double
    let hotelId       : String
    let name          : String
    let cityId        : String
    let stars         : Double
    let rating        : Double
    let taRating      : Double
    let photo         : String
    let city          : String
    let preferenceId  : String
    var isFavourite   : Bool
    
    
    init() {
        
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        
        self.hotelMinStar = json[APIKeys.hotel_min_star.rawValue].doubleValue
        self.hotelMaxStar = json[APIKeys.hotel_max_star.rawValue].doubleValue
        self.hotelId      = json[APIKeys.hid.rawValue].stringValue.removeNull
        self.name         = json[APIKeys.name.rawValue].stringValue.removeNull
        self.cityId       = json[APIKeys.city_id.rawValue].stringValue.removeNull
        self.stars        = json[APIKeys.stars.rawValue].doubleValue
        self.rating       = json[APIKeys.rating.rawValue].doubleValue
        self.taRating     = json[APIKeys.ta_rating.rawValue].doubleValue
        self.photo        = json[APIKeys.photo.rawValue].stringValue.removeNull
        self.city         = json[APIKeys.city.rawValue].stringValue.removeNull
        self.preferenceId = json[APIKeys.preference_id.rawValue].stringValue.removeNull
        self.isFavourite  = json[APIKeys.is_favourite.rawValue].intValue == 1 ? true : false
    }
    
    static func models(json: JSON) -> [HotelsModel] {
        
        var hotels = [HotelsModel]()
        
        for (_ , value) in json {
            hotels.append(HotelsModel(json: value))
        }
        
        return hotels
    }
}

struct CityHotels {
    
    var holetList: [HotelsModel]
    var cityName: String
    
    init() {
        cityName = ""
        holetList = [HotelsModel]()
    }
    
    static func models(json:JSON) -> [CityHotels] {
        
        var hotels = [CityHotels]()
        
        for (key, value) in json {
            var object = CityHotels()
            object.cityName = key.isEmpty ? "Uncategorized" : key
            object.holetList = HotelsModel.models(json: value)
            hotels.append(object)
        }
        
        return hotels
    }
}
