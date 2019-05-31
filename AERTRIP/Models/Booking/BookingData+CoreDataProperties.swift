//
//  BookingData+CoreDataProperties.swift
//  AERTRIP
//
//  Created by apple on 27/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//
//

import Foundation
import CoreData


enum BookingTabCategory: Int {
    case upcoming = 1
    case completed = 2
    case cancelled = 3
}



extension BookingData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookingData> {
        return NSFetchRequest<BookingData>(entityName: "BookingData")
    }

    @NSManaged public var actionRequired: Int16
    
    // bdetails
    
    @NSManaged public var guestCount: Int16
    @NSManaged public var descriptions: Array<Any>?
    @NSManaged public var requests: Array<Any>?
    @NSManaged public var bookingStatus: String? // Booking status - Pending and Other
    @NSManaged public var eventStartDate: String? // event Start Date
    @NSManaged public var eventEndDate: String?  // event end Date
    @NSManaged public var routes: Array<Array<Any>> //
    @NSManaged public var disconnected: Bool // Check for disconnected
    @NSManaged public var travelledCities: Array<Any>?
    @NSManaged public var tripCities: Array<Any>? // Trip Citties array
    @NSManaged public var pax: Array<Any>? // Passenger Array
    @NSManaged public var tripType: String? // return
    @NSManaged public var destination: String? // Destination station
    @NSManaged public var origin: String? // Source origin station
    @NSManaged public var depart: String? // departure date
    @NSManaged public var product: String? // It stores type of product like hotel , flight or Others
    @NSManaged public var bookingDate: String?
    @NSManaged public var bookingNumber: String?
    @NSManaged public var bookingId: String?
    
    @NSManaged public var bookingTabType: Int16
    @NSManaged public var bookingProductType: Int16
    @NSManaged public var eventType: Int16
    
    
    
    //Requests
    @NSManaged public var reschedulingRequests: Array<Any>?
    
    @NSManaged public var cancellationRequests: Array<Any>?
    
    @NSManaged public var addOnRequests: Array<Any>?

    

    
    var bookingTab: BookingTabCategory {
        get {
            return BookingTabCategory(rawValue: Int(self.bookingTabType))!
        }
        set {
            self.bookingTabType = Int16(newValue.rawValue)
        }
    }
    
    var productType: ProductType {
        get {
            return ProductType(rawValue: Int(self.bookingProductType))!
        }
        set {
            self.bookingProductType = Int16(newValue.rawValue)
        }
    }
    
    
}
