//
//  HotelSearched+CoreDataClass.swift
//  AERTRIP
//
//  Created by apple on 08/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//
//

import CoreData
import Foundation

@objc(HotelSearched)
public class HotelSearched: NSManagedObject {
    // MARK: - Insert Single Data
    
    // MARK: -
    
    class func insert(dataDict: JSONDictionary) -> HotelSearched {
        
        let managedContext = CoreDataManager.shared.managedObjectContext

        var hotelSearched: HotelSearched?
        if let id = dataDict[APIKeys.hid.rawValue], !"\(id)".isEmpty {
            hotelSearched = HotelSearched.fetch(id: "\(id)")
        }
        
        if hotelSearched == nil {
            hotelSearched = NSEntityDescription.insertNewObject(forEntityName: "HotelSearched", into: managedContext) as? HotelSearched
        }
        
        if let obj = dataDict[APIKeys.acc_type.rawValue] {
            hotelSearched!.accountType = "\(obj)".removeNull
        }
        
        if let obj = dataDict[APIKeys.address.rawValue] {
            hotelSearched!.address = "\(obj)".removeNull
        }
        
        if let obj = dataDict[APIKeys.at_hotel_fares.rawValue] as? [Double] {
            hotelSearched!.atHotelFares = obj
        }
        
        if let obj = dataDict[APIKeys.bc.rawValue] {
            hotelSearched!.bc = "\(obj)".removeNull
        }
        
        if let obj = dataDict[APIKeys.city_code.rawValue] {
            hotelSearched!.cityCode = "\(obj)".removeNull
        }
        
        if let obj = dataDict[APIKeys.country.rawValue] {
            hotelSearched!.country = "\(obj)".removeNull
        }
        
        if let obj = dataDict[APIKeys.discount.rawValue] {
            hotelSearched!.discount = obj as! Double
        }
        
        if let obj = dataDict[APIKeys.distance.rawValue] as? String {
            let distance = Double(obj)?.roundTo(places: 2) ?? 0.0
            hotelSearched!.distance = distance
            switch distance {
            case 0..<2:
                hotelSearched?.sectionTitle = "a0 to 2"
            case 2..<4:
                hotelSearched?.sectionTitle = "b2 to 4"
            case 4..<10:
                hotelSearched?.sectionTitle = "c4 to 10"
            case 10..<15:
                hotelSearched?.sectionTitle = "d10 to 15"
            case 15..<20:
                hotelSearched?.sectionTitle = "e15 to 20"
            default:
                hotelSearched?.sectionTitle = "fBeyond 20"
                hotelSearched?.isHotelBeyondTwentyKm = true
            }
        }
        
        if let obj = dataDict[APIKeys.facilities.rawValue] {
            hotelSearched!.facilities = "\(obj)".removeNull
        }
        
        if let obj = dataDict[APIKeys.fav.rawValue] {
            hotelSearched!.fav = "\(obj)".removeNull.isEmpty ? "0" : "\(obj)".removeNull
        }
        
        if let obj = dataDict[APIKeys.hid.rawValue] {
            hotelSearched!.hid = "\(obj)".removeNull
            
            //update fav if it is locally saved for logged out user
            if UserInfo.loggedInUserId == nil, UserInfo.locallyFavHotels.contains("\(obj)".removeNull) {
                hotelSearched!.fav = "1"
            }
        }
        
        if let obj = dataDict[APIKeys.hname.rawValue] {
            hotelSearched!.hotelName = "\(obj)".removeNull
        }
        
        if let obj = dataDict[APIKeys.lat.rawValue] {
            hotelSearched!.lat = "\(obj)".removeNull
        }
        
        if let obj = dataDict[APIKeys.long.rawValue] {
            hotelSearched!.long = "\(obj)".removeNull
        }
        
        if let obj = dataDict[APIKeys.list_price.rawValue] {
            hotelSearched!.listPrice = obj as! Double
        }
        
        if let obj = dataDict[APIKeys.locid.rawValue] {
            hotelSearched!.locid = "\(obj)".removeNull
        }
        
        if let obj = dataDict[APIKeys.no_of_nights.rawValue] as? Int {
            hotelSearched!.numberOfNight = Int16(obj)
        }
        
        if let obj = dataDict[APIKeys.num_rooms.rawValue] as? Int {
            hotelSearched!.numberOfRooms = Int16(obj)
        }
        
        if let obj = dataDict[APIKeys.per_night_list_price.rawValue] {
            hotelSearched!.perNightListPrice = obj as! Double
        }
        if let obj = dataDict[APIKeys.per_night_price.rawValue] {
            hotelSearched!.perNightPrice = obj as! Double
        }
        
        if let obj = dataDict[APIKeys.price.rawValue] {
            hotelSearched!.price = obj as! Double
        }
        
       
        
        // function to get rounded value from string
        
        func getRoundedValue(value: Double) -> String {
            let difference = value - floor(value)
            if difference <= 0.5 {
                return "\(floor(value).toInt)"
            } else {
                return "\(ceil(value).toInt)"
            }
        }
        
        // trip Advisor rating value
        if let obj = dataDict[APIKeys.rating.rawValue] {
            let tripAdvisorRating = obj as! Double
            hotelSearched!.rating = tripAdvisorRating
            hotelSearched?.filterTripAdvisorRating = getRoundedValue(value: tripAdvisorRating)
        }
        
        // star rating value
        
        if let obj = dataDict[APIKeys.star.rawValue] {
            let star = "\(obj)".toDouble ?? 0.0
            hotelSearched!.star = star
            hotelSearched?.filterStar = getRoundedValue(value: star)
        }
        
        if let obj = dataDict[APIKeys.ta_reviews.rawValue] {
            hotelSearched!.taReviews = "\(obj)".removeNull
        }
        if let obj = dataDict[APIKeys.ta_web_url.rawValue] {
            hotelSearched!.taWebUrl = "\(obj)".removeNull
        }
        
        if let obj = dataDict[APIKeys.tax.rawValue] {
            hotelSearched!.tax = obj as! Double
        }
        
        if let obj = dataDict[APIKeys.temp_price.rawValue] {
            hotelSearched!.tempPrice = obj as! Double
        }
        
        if let obj = dataDict[APIKeys.thumbnail.rawValue] as? [String] {
            hotelSearched!.thumbnail = obj
        }
        
        if let obj = dataDict[APIKeys.vid.rawValue] {
            hotelSearched!.vid = "\(obj)".removeNull
        }
        
        if let obj = dataDict[APIKeys.amenities.rawValue] as? [String], !obj.isEmpty {
            let str = ",\(obj.joined(separator: ",")),"
            hotelSearched!.amenities = str
        }
        
        CoreDataManager.shared.saveContext()
        
        return hotelSearched!
    }
    
    // MARK: - Check Whether Value Exist or Not
    
    // MARK: -
    
    class func fetch(id: String?) -> HotelSearched? {
        var predicateStr = ""
        if let id = id {
            predicateStr = "hid BEGINSWITH '\(id)'"
        }
        
        if let fetchResult = CoreDataManager.shared.fetchData("HotelSearched", predicate: predicateStr, sort: nil) {
            if !fetchResult.isEmpty {
                return fetchResult[0] as? HotelSearched
            }
            return nil
        }
        return nil
    }
}
