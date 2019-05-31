//
//  BookingData+CoreDataClass.swift
//  AERTRIP
//
//  Created by apple on 27/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//
//

import Foundation
import CoreData

@objc(BookingData)
public class BookingData: NSManagedObject {
    
    class func insert(dataDict: JSONDictionary, into context: NSManagedObjectContext = CoreDataManager.shared.managedObjectContext) -> BookingData {
        var booking: BookingData?
        
        if let id = dataDict[APIKeys.bid.rawValue], !"\(id)".isEmpty {
            booking = BookingData.fetch(id: "\(id)")
        }
        
        if booking == nil {
            booking = NSEntityDescription.insertNewObject(forEntityName: "BookingData", into: context) as? BookingData
        }
        
        if let obj = dataDict[APIKeys.bid.rawValue] {
          booking?.bookingId = "\(obj)".removeNull
        }
        
        if let obj = dataDict[APIKeys.booking_date.rawValue] {
            booking?.bookingDate = "\(obj)".removeNull
        }
        
        
        // Function set product Type
        
        func setProductType(productType: String) -> Int {
            if productType == "flight" {
               booking?.eventType = 1
               return 1
            } else if productType == "hotel" {
                booking?.eventType = 2
                return 2
            } else if productType == "other" {
              booking?.eventType = 3
               return 3
            }
            
            return -1
        }
        
        if let obj = dataDict[APIKeys.booking_number.rawValue] {
            booking?.bookingNumber = "\(obj)".removeNull
        }
        
       
        if let obj = dataDict[APIKeys.product.rawValue] {
            booking?.product = "\(obj)".removeNull
            booking?.bookingProductType = Int16(setProductType(productType: obj as? String ?? ""))
        
        }
        
        if let obj = dataDict[APIKeys.bstatus.rawValue] {
            booking?.bookingStatus = "\(obj)".removeNull
            
        }
        
        if let obj = dataDict[APIKeys.requests.rawValue] as? [String] {
            booking?.requests = obj
        }
        
        if let obj = dataDict[APIKeys.description.rawValue] as? [String] {
            booking?.descriptions = obj
        }
        
        if let obj = dataDict[APIKeys.action_required.rawValue] as? Int {
            booking?.actionRequired = Int16(obj)
        }
        
    
        
        
        // function to get Set Booking Type
        
        func setBookingType(date: String) -> Int {
            if date.toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")?.isGreaterThan((Date())) ?? false {
              return 1
            } else if date.toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")?.isSmallerThan((Date())) ?? false {
              return 2
            } else {
               return 3
            }
        }
        
        if let obj = dataDict[APIKeys.bdetails.rawValue] as? JSONDictionary {
            booking?.origin = obj["origin"] as? String
            booking?.destination = obj["destination"] as? String
            booking?.tripType = obj["trip_type"] as? String
            booking?.pax  =  obj["pax"] as?  [String]
            booking?.tripCities = obj["trip_cities"] as? [String]
            booking?.travelledCities = obj["travelled_cities"] as? [String]
            booking?.disconnected = obj["disconnected"] as? Bool ?? false
            booking?.routes = obj["routes"] as? [[String]] ?? [[]]
            booking?.eventStartDate = obj["event_start_date"] as? String
            booking?.eventEndDate = obj["event_end_date"] as? String
            booking?.guestCount =  obj["guest_count"] as? Int16 ?? 0
            booking?.bookingTabType = Int16(setBookingType(date: obj["event_start_date"] as? String ?? ""))
       
            if let request = obj["requests"] as? JSONDictionary {
                booking?.reschedulingRequests = request["rescheduling"] as? [String]
                booking?.cancellationRequests = request["cancellation"] as? [String]
                booking?.addOnRequests = request["addOns"] as? [String]
            }
        }
        
        CoreDataManager.shared.saveContext(managedContext: context)
        
        return booking!
    }
    
    
    // MARK: - Insert Bulk Data
    
    // MARK: -
    
    class func insert(dataDictArray: [JSONDictionary], completionBlock: @escaping ([BookingData]) -> Void) {
        var dataArr = [BookingData]()
        var tempDataArr = [BookingData]()
        // set up a managed object context just for the insert. This is in addition to the managed object context you may have in your App Delegate.
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
//        managedObjectContext.persistentStoreCoordinator = CoreDataManager.shared.persistentStoreCoordinator
        managedObjectContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyObjectTrumpMergePolicyType)
        managedObjectContext.parent = CoreDataManager.shared.managedObjectContext
        
        managedObjectContext.perform { // runs asynchronously
            while true { // loop through each batch of inserts. Your implementation may vary.
                autoreleasepool { // auto release objects after the batch save
                    // insert new entity object
                    for dataDict in dataDictArray {
                        let dataTemp = BookingData.insert(dataDict: dataDict, into: managedObjectContext)
                            dataArr.append(dataTemp)
                    }
                }
                
                // only save once per batch insert
                do {
                    try managedObjectContext.save()
                }
                catch {
                    printDebug("Problem in saving the managedObjectContext while in bulk is: \(error.localizedDescription)")
                }
                
                CoreDataManager.shared.managedObjectContext.perform({
                    if CoreDataManager.shared.managedObjectContext.hasChanges {
                        do {
                            try CoreDataManager.shared.managedObjectContext.save()
                        }
                        catch {
                            printDebug("Problem in saving the managedObjectContext while in bulk is: \(error.localizedDescription)")
                        }
                    }
                    for dataTemp in dataArr {
                        let data = CoreDataManager.shared.managedObjectContext.object(with: dataTemp.objectID) as! BookingData
                        tempDataArr.append(data)
                    }
                    completionBlock(tempDataArr)
                })
                return
            }
        }
    }
    
    
    // MARK: - Check Whether Value Exist or Not
    
    // MARK: -
    
    class func fetch(id: String?) -> BookingData? {
        var predicateStr = ""
        if let id = id {
            predicateStr = "bookingId BEGINSWITH '\(id)'"
        }
        
        if let fetchResult = CoreDataManager.shared.fetchData("BookingData", predicate: predicateStr, sort: nil) {
            if !fetchResult.isEmpty {
                return fetchResult[0] as? BookingData
            }
            return nil
        }
        return nil
    }
}
