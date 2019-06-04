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
    @NSManaged public var hotelName: String?
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
}


//Computed properties
extension BookingData {
    var bookingTab: BookingTabCategory {
        get {
            return BookingTabCategory(rawValue: Int(self.bookingTabType))!
        }
        set {
            self.bookingTabType = Int16(newValue.rawValue)
        }
    }
    
    var productType: ProductType {
        return ProductType(rawValue: Int(self.bookingProductType)) ?? .other
    }
    
    var tripCitiesStr: String {
        if self.productType == .flight {
            if let cities = self.tripCities as? [String], !cities.isEmpty {
                return cities.joined(separator: " → ")
            }
            else {
                return self.origin ?? ""
            }
        }
        else if self.productType == .hotel {
            return self.hotelName ?? ""
        }
        return ""
    }
    
    var paxStr: String {
        func getStringForOthers(arr: [String]) -> String {
            
            var nameStr = ""
            var verbStr = (self.bookingTabType == 1) ? "are" : "were"
            
            switch arr.count {
            case 1:
                nameStr = arr.first ?? ""
                if nameStr.lowercased() != "you" {
                    verbStr = (self.bookingTabType == 1) ? "is" : "was"
                }
                
            case 2: nameStr = arr.joined(separator: " and ")
            case 3:
                nameStr = arr.first ?? ""
                nameStr += ", \(arr[1...2].joined(separator: " and "))"
                
            default:
                nameStr = arr.first ?? ""
                nameStr += " and \(arr.count-1) others"
            }
            
            return nameStr.isEmpty ? "N/A" : "\(nameStr) \(verbStr) \((self.productType == .flight) ? "flying" : "staying")"
        }
        
        if let pax = self.pax as? [String] {
            var temp: [String] = pax
            if let index = pax.firstIndex(where: { $0.lowercased().hasPrefix("you::") }){
                //you are included
                temp.remove(at: index)
                temp.insert("You", at: 0)
            }
            return getStringForOthers(arr: temp)
        }
        else {
            return LocalizedString.na.localized
        }
    }
}
