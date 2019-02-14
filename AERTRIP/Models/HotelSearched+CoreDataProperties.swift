//
//  HotelSearched+CoreDataProperties.swift
//  AERTRIP
//
//  Created by apple on 08/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//
//

import Foundation
import CoreData


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
    @NSManaged public var sectionTitle:String?
    @NSManaged public var amentities:[Int]?

}
