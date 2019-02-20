//
//  HotelsSearched.swift
//  AERTRIP
//
//  Created by Admin on 29/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct HotelsSearched: Codable {
    
    var facilities: String = ""
    var city_code: String = ""
    var address: String = ""
    var acc_type: String = ""
    var temp_price: Double = 0.0
    var price: Double = 0.0
    var at_hotel_fares: Double = 0
    var no_of_nights: Int = 0
    var num_rooms: Int = 0
    var list_price: Double = 0.0
    var tax: Double = 0.0
    var discount: Double = 0.0
    var hid: String = ""
    var vid:String = ""
    var hname: String = ""
    var lat: String = ""
    var long: String = ""
    var star: Double = 0.0
    var rating: Double = 0.0
    var locid: String = ""
    var bc: String = ""
    var fav: String = ""
    var distance: String = ""
    var thumbnail: [String] = [String]()
    var ta_reviews: String  = ""
    var ta_web_url: String = ""
    var per_night_price: String = ""
    var per_night_list_price: String = ""
    var country: String = ""
    var amenities : [String] = [String]()
    
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.facilities.rawValue: self.facilities,
                APIKeys.city_code.rawValue: self.city_code,
                APIKeys.address.rawValue: self.address,
                APIKeys.acc_type.rawValue: self.acc_type,
                APIKeys.temp_price.rawValue: self.temp_price,
                APIKeys.price.rawValue: self.price,
                APIKeys.at_hotel_fares.rawValue: self.at_hotel_fares,
                APIKeys.no_of_nights.rawValue: self.no_of_nights,
                APIKeys.num_rooms.rawValue: self.num_rooms,
                APIKeys.list_price.rawValue: self.list_price,
                APIKeys.tax.rawValue: self.tax,
                APIKeys.discount.rawValue: self.discount,
                APIKeys.hid.rawValue: self.hid,
                APIKeys.vid.rawValue: self.vid,
                APIKeys.hname.rawValue: self.hname,
                APIKeys.lat.rawValue: self.lat,
                APIKeys.long.rawValue: self.long,
                APIKeys.country.rawValue: self.country,
                APIKeys.star.rawValue: self.star,
                APIKeys.rating.rawValue: self.rating,
                APIKeys.locid.rawValue: self.locid,
                APIKeys.bc.rawValue: self.bc,
                APIKeys.fav.rawValue: self.fav,
                APIKeys.distance.rawValue: self.distance,
                APIKeys.thumbnail.rawValue: self.thumbnail,
                APIKeys.ta_reviews.rawValue: self.ta_reviews,
                APIKeys.ta_web_url.rawValue: self.ta_web_url,
                APIKeys.per_night_price.rawValue: self.per_night_price,
                APIKeys.per_night_list_price.rawValue: self.per_night_list_price]
    }
    
    init(json: JSONDictionary) {
        
        
        if let obj = json[APIKeys.facilities.rawValue] {
            self.facilities = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.city_code.rawValue] {
            self.city_code = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.address.rawValue] {
            self.address = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.acc_type.rawValue] {
            self.acc_type = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.temp_price.rawValue] as? Double {
            self.temp_price = obj
        }
        if let obj = json[APIKeys.price.rawValue] as? Double {
            self.price = obj
        }
        if let obj = json[APIKeys.at_hotel_fares.rawValue] as? Double {
            self.at_hotel_fares = obj
        }
        if let obj = json[APIKeys.no_of_nights.rawValue] as? Int {
            self.no_of_nights = obj
        }
        if let obj = json[APIKeys.num_rooms.rawValue] as? Int {
            self.num_rooms = obj
        }
        if let obj = json[APIKeys.list_price.rawValue] as? Double {
            self.list_price = obj
        }
        if let obj = json[APIKeys.tax.rawValue] as? Double {
            self.tax = obj
        }
        if let obj = json[APIKeys.discount.rawValue] as? Double {
            self.discount = obj
        }
        if let obj = json[APIKeys.hid.rawValue] {
            self.hid = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.vid.rawValue] {
            self.vid = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.hname.rawValue] {
            self.hname = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.lat.rawValue] {
            self.lat = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.long.rawValue] {
            self.long = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.country.rawValue] {
            self.country = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.star.rawValue] as? String {
            self.star = Double(obj.removeNull) ?? 0.0
        }
        if let obj = json[APIKeys.rating.rawValue] as? String {
            self.rating =   Double(obj.removeNull) ?? 0.0
        }
        if let obj = json[APIKeys.locid.rawValue] {
            self.locid = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.bc.rawValue] {
            self.bc = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.fav.rawValue] {
            self.fav = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.distance.rawValue] {
            self.distance = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.thumbnail.rawValue] as? [String] {
            self.thumbnail = obj
        }
        if let obj = json[APIKeys.ta_reviews.rawValue] {
            self.ta_reviews = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.ta_web_url.rawValue] {
            self.ta_web_url = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.per_night_price.rawValue] {
            self.per_night_price = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.per_night_list_price.rawValue] {
            self.per_night_list_price = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.amentities.rawValue] as? [String] {
            self.amenities = obj
        }
    }
    
    static func models(jsonArr: [JSONDictionary]) -> ([HotelsSearched]) {
        var arr = [HotelsSearched]()
        
        for json in jsonArr {
            let obj = HotelsSearched(json: json)
            arr.append(obj)
        }
        return (arr)
    }
}
