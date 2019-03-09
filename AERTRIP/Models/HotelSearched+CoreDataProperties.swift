//
//  HotelSearched+CoreDataProperties.swift
//  AERTRIP
//
//  Created by apple on 08/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//
//

import CoreData
import Foundation

extension HotelSearched {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<HotelSearched> {
        return NSFetchRequest<HotelSearched>(entityName: "HotelSearched")
    }
    
    @NSManaged public var accountType: String?
    @NSManaged public var address: String?
    @NSManaged public var atHotelFares: [Double]
    @NSManaged public var bc: String?
    @NSManaged public var cityCode: String?
    @NSManaged public var country: String?
    @NSManaged public var discount: Double
    @NSManaged public var distance: Double
    @NSManaged public var facilities: String?
    @NSManaged public var fav: String?
    @NSManaged public var hid: String?
    @NSManaged public var hotelName: String?
    @NSManaged public var lat: String?
    @NSManaged public var listPrice: Double
    @NSManaged public var locid: String?
    @NSManaged public var long: String?
    @NSManaged public var numberOfNight: Int16
    @NSManaged public var numberOfRooms: Int16
    @NSManaged public var perNightListPrice: Double
    @NSManaged public var perNightPrice: Double
    @NSManaged public var price: Double
    @NSManaged public var rating: Double
    @NSManaged public var star: Double
    @NSManaged public var taReviews: String?
    @NSManaged public var taWebUrl: String?
    @NSManaged public var tax: Double
    @NSManaged public var tempPrice: Double
    @NSManaged public var thumbnail: [String]?
    @NSManaged public var vid: String?
    @NSManaged public var sectionTitle: String?
    @NSManaged public var amenities: [String]?
    @NSManaged public var isHotelBeyondTwentyKm: Bool
    
    
    var dict: JSONDictionary {
        var temp = JSONDictionary()
        temp[APIKeys.acc_type.rawValue] = self.accountType ?? ""
        temp[APIKeys.address.rawValue] = self.address
        temp[APIKeys.at_hotel_fares.rawValue] = self.atHotelFares
        temp[APIKeys.bc.rawValue] = self.bc
        temp[APIKeys.city_code.rawValue] = self.cityCode
        temp[APIKeys.country.rawValue] = self.country
        temp[APIKeys.discount.rawValue] = self.discount
        temp[APIKeys.distance.rawValue] = self.distance
        temp[APIKeys.facilities.rawValue] = self.facilities
        temp[APIKeys.fav.rawValue] = self.fav
        temp[APIKeys.hid.rawValue] = self.hid
        temp[APIKeys.hname.rawValue] = self.hotelName
        temp[APIKeys.lat.rawValue] = self.lat
        temp[APIKeys.list_price.rawValue] = self.listPrice
        temp[APIKeys.locid.rawValue] = self.locid
        temp[APIKeys.long.rawValue] = self.long
        temp[APIKeys.no_of_nights.rawValue] = self.numberOfNight
        temp[APIKeys.num_rooms.rawValue] = self.numberOfRooms
        temp[APIKeys.per_night_price.rawValue] = self.perNightPrice
        temp[APIKeys.per_night_list_price.rawValue] = self.perNightListPrice
        temp[APIKeys.price.rawValue] = self.price
        temp[APIKeys.rating.rawValue] = self.rating
        temp[APIKeys.star.rawValue] = self.star
        temp[APIKeys.ta_reviews.rawValue] = self.taReviews
        temp[APIKeys.ta_web_url.rawValue] = self.taWebUrl
        temp[APIKeys.tax.rawValue] = self.tax
        temp[APIKeys.temp_price.rawValue] = self.tempPrice
        temp[APIKeys.thumbnail.rawValue] = self.thumbnail
        temp[APIKeys.vid.rawValue] = self.vid
        temp[APIKeys.amenities.rawValue] = self.amenities
        
        return temp
    }
    
    public var afterUpdate: HotelSearched {
        return HotelSearched.insert(dataDict: self.dict)
    }
    
  
}
