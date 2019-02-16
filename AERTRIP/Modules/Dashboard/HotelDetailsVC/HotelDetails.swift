//
//  HotelDetails.swift
//  AERTRIP
//
//  Created by Admin on 14/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct HotelDetails: Codable {
    
    //Mark:- Variables
    //================
    
    var hid: String = ""
    var vid:String = ""
    var list_price: Double = 0.0
    var price: Double = 0.0
    var tax: Double = 0.0
    var discount: Double = 0.0
    var hname: String = ""
    var lat: String = ""
    var long: String = ""
    var star: Double = 0.0
    var rating: Double = 0.0
    var locid: String = ""
    var fav: String = ""
    var address: String = ""
    var photos: [String] = []
    var amenities: Amenities? = nil //
//    var amenities_group: AmenitiesGroup//
    var checkin_time: String = "" //
    var checkout_time: String = ""//
    var checkin: String = ""//
    var checkout: String = ""//
    var num_rooms: Int = 0
//    var rates: Rates//
//    var combine_rates: CombineRates//
    var info: String = ""//
    var ta_reviews: String  = ""
    var ta_web_url: String = ""
    var city: String = ""//
    var country: String = ""
    var is_refetch_cp: String = ""//
    var per_night_price: String = ""
    var per_night_list_price: String = ""
//    var occupant: Occupant//
    
    
    var facilities: String = ""
    var city_code: String = ""
    var acc_type: String = ""
    var temp_price: Double = 0.0
    var at_hotel_fares: Double = 0
    var no_of_nights: Int = 0
    var bc: String = ""
    var distance: String = ""
    var thumbnail: [String] = [String]()
    

    
    
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
                APIKeys.per_night_list_price.rawValue: self.per_night_list_price,
        
        
                APIKeys.photos.rawValue: self.photos,
                APIKeys.amenities.rawValue: self.amenities,
                //APIKeys.amenities_group.rawValue: self.amenities_group,
                APIKeys.checkin_time.rawValue: self.checkin_time,
                APIKeys.checkout_time.rawValue: self.checkout_time,
                APIKeys.checkin.rawValue: self.checkin,
                APIKeys.checkout.rawValue: self.checkout,
                //APIKeys.rates.rawValue: self.rates,
                //APIKeys.combine_rates.rawValue: self.combine_rates,
                APIKeys.info.rawValue: self.info,
                APIKeys.city.rawValue: self.city,
                APIKeys.is_refetch_cp.rawValue: self.is_refetch_cp
                //APIKeys.occupant.rawValue: self.occupant
        ]
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
            self.rating = Double(obj.removeNull) ?? 0.0
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
        if let obj = json[APIKeys.photos.rawValue] as? [String] {
            self.photos = obj
        }
        if let obj = json[APIKeys.checkin_time.rawValue] {
            self.checkin_time = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.checkout_time.rawValue] {
            self.checkout_time = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.checkin.rawValue] {
            self.checkin = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.checkout.rawValue] {
            self.checkout = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.info.rawValue] {
            self.info = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.city.rawValue] {
            self.city = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.is_refetch_cp.rawValue] {
            self.is_refetch_cp = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.amenities.rawValue] as? JSONDictionary {
            
            if let otherData = obj[APIKeys.other.rawValue] as? [String] {
                for  (index,data) in otherData.enumerated() {
                    self.amenities?.other[index] = data
                }
                //self.amenities?.other = otherData
            }
            if let basicData = obj[APIKeys.basic.rawValue] as? [String] {
                for data in basicData {
                    self.amenities?.basic.append(data)
                }
//                for  (index,data) in basicData.enumerated() {
//                    self.amenities?.basic[index] = data
//                }
                //self.amenities?.basic = basicData
            }
            
            if let mainData = obj[APIKeys.main.rawValue] as? [JSONDictionary], var mainAmenities = self.amenities {
                for (index,main) in mainData.enumerated() {
                    mainAmenities.main?[index].name = "\(main[APIKeys.name.rawValue] ?? "")"
                        mainAmenities.main?[index].classType = "\(main[APIKeys.classType.rawValue] ?? "")"
                        mainAmenities.main?[index].available = (main[APIKeys.name.rawValue] as? Int ?? 0)
                }
            }
        }


        //APIKeys.amenities.rawValue: self.amenities,
        //APIKeys.amenities_group.rawValue: self.amenities_group,
        //APIKeys.rates.rawValue: self.rates,
        //APIKeys.combine_rates.rawValue: self.combine_rates,
        //APIKeys.occupant.rawValue: self.occupant
    }
    
    /*

    
    struct AmenitiesGroup {
        <#fields#>
    }
    
    struct Rates {
        <#fields#>
    }
    
    struct CombineRates {
        <#fields#>
    }
    
    struct Occupant {
        <#fields#>
    } */
    
    static func hotelInfo(response: JSONDictionary) -> HotelDetails {
        let hotelInfo = HotelDetails(json: response)
        return hotelInfo
    }
}

struct Amenities: Codable {
    var main: [Main]? = nil
    var basic: [String] = []
    var other: [String] = []
    
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.main.rawValue: self.main,
                APIKeys.basic.rawValue: self.basic,
                APIKeys.other.rawValue: self.other]
    }
    
    init(json: JSONDictionary) {
        if let otherData = json[APIKeys.other.rawValue] as? [String] {
            for  (index,data) in otherData.enumerated() {
                self.other[index] = data
            }
        }
    }
    
}

struct Main: Codable {
    var available: Int = 0
    var name: String = ""
    var classType: String = ""
}
