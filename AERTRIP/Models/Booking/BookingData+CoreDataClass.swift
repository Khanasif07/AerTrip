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
    
    class func insert(dataDict: JSONDictionary) -> BookingData? {

        let managedContext = CoreDataManager.shared.managedObjectContext
        
        var booking: BookingData?
        
        if let id = dataDict[APIKeys.bid.rawValue], !"\(id)".isEmpty {
            booking = BookingData.fetch(id: "\(id)")
        }
        
        if booking == nil {
            booking = NSEntityDescription.insertNewObject(forEntityName: "BookingData", into: managedContext) as? BookingData
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
            } else  {
                booking?.eventType = 3
                return 3
            }
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
        
        /*
        //for seting the steps array anf pending status
        
        func setStepsArrayAndPendingStatus(forData: JSONDictionary) {
            
            var steps: [String] = []
            
            if let addOnSteps = forData["addon"] as? [String] {
                let title = "Add-ons"
                for step in addOnSteps {
                    if step.lowercased().contains(AppConstants.kPending) {
                        steps.append("\(title) payment pending")
                        booking?.isContainsPending = 1
                    }
                    else {
                        steps.append("\(title) \(step.lowercased())")
                    }
                }
            }
            
            if let cancellationSteps = forData["cancellation"] as? [String] {
                let title = "Cancellation"
                for step in cancellationSteps {
                    if step.lowercased().contains(AppConstants.kPending) {
                        steps.append("\(title) action required")
                        booking?.isContainsPending = 1
                    }
                    else {
                        steps.append("\(title) \(step.lowercased())")
                    }
                }
            }
            
            if let reschedulingSteps = forData["rescheduling"] as? [String] {
                let title = "Rescheduling"
                for step in reschedulingSteps {
                    if step.lowercased().contains(AppConstants.kPending) {
                        steps.append("\(title) payment required")
                        booking?.isContainsPending = 1
                    }
                    else {
                        steps.append("\(title) \(step.lowercased())")
                    }
                }
            }
            
           // booking?.stepsArray = steps
           // booking?.stepsArrayStr = (booking?.stepsArray ?? [String]()).joined(separator: ",")
        }
    
        
        if let obj = dataDict[APIKeys.requests.rawValue] as? JSONDictionary {
            booking?.requests = obj
            //setStepsArrayAndPendingStatus(forData: obj)
        }
        */
        
        if let obj = dataDict[APIKeys.description.rawValue] as? [String] {
            booking?.descriptions = obj
            booking?.stepsArray = obj
            booking?.stepsArrayStr = (booking?.stepsArray ?? [String]()).joined(separator: ",")
        }
        
        if let obj = dataDict[APIKeys.action_required.rawValue] as? Int {
            booking?.actionRequired = Int16(obj)
            booking?.isContainsPending = Int16(obj)
        }
        
        // function to get Set Booking Type
        func bookingType(forDate startDate: String,date endDate: String, bstatus: String) -> Int16 {
            let todayDate = Date()
            if ((bstatus.lowercased() == "cancelled") || (bstatus.lowercased() == "rescheduled") ) {
                return 3 // cancelled booking
            } else if endDate.toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")?.isSmallerThan((todayDate)) ?? false {
                return 2 // Completed booking
            }
            else if startDate.toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")?.isGreaterThan((todayDate)) ?? false ||
                startDate.toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")?.isToday ?? false ||
                endDate.toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")?.isToday ?? false ||
                (startDate.toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")?.isSmallerThan((todayDate)) ?? false && endDate.toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")?.isGreaterThan((todayDate)) ?? false ) {
                return 1 // Upcoming
            } else {
                return 3 // Cancelled
            }
            //            else if enDate.toDate(dateFormat: "YYYY-MM-dd HH:mm:ss")?.isSmallerThan((Date())) ?? false, ((bstatus.lowercased() == "pending")) || (bstatus.lowercased() == "successful") || (bstatus.lowercased() == "booked") || (bstatus.lowercased() == "successful") || (bstatus.lowercased() == "booked") {
            //                return 2 // Complete
            //            }
            
        }
        
        if let obj = dataDict[APIKeys.bdetails.rawValue] as? JSONDictionary {
            booking?.hotelName = obj["hotel_name"] as? String
            booking?.origin = obj["origin"] as? String
            booking?.destination = obj["destination"] as? String
            booking?.tripType = obj["trip_type"] as? String
            booking?.depart = obj["depart"] as? String
            
            booking?.pax = obj["pax"] as?  [String]
            booking?.paxArrStr = (booking?.pax ?? [String]()).joined(separator: ",")
            
            booking?.tripCities = obj["trip_cities"] as? [String]
            booking?.tripCitiesArrStr = (booking?.tripCities ?? [String]()).joined(separator: ",")
            
            booking?.travelledCities = obj["travelled_cities"] as? [String]
            booking?.travelledCitiesArrStr = (booking?.travelledCities ?? [String]()).joined(separator: ",")
            
            booking?.disconnected = obj["disconnected"] as? Bool ?? false
            booking?.serviceType = obj["service_type"] as? String
            booking?.routes = obj["routes"] as? [[String]] ?? [[]]
            booking?.routesArrStr = (booking?.routes ?? [[String]]()).joined(separator: ",")
            
            booking?.eventStartDate = obj["event_start_date"] as? String
            booking?.eventEndDate = obj["event_end_date"] as? String
            booking?.guestCount =  obj["guest_count"] as? Int16 ?? 0
            if let date = obj["event_start_date"] as? String, let endDate = obj["event_end_date"] as? String ,let status = booking?.bookingStatus {
                booking?.bookingTabType = bookingType(forDate: date, date: endDate, bstatus: status)
            }
            //Searched By Flight number
//            booking?.flightNumbers = (obj["flight_number"] as? [String])?.joined(separator: ",")
            if let airlines = obj["airlines"] as? [String:String] {
                booking?.airlines = airlines.map({"\($0.0) \($0.1 as? String ?? "")"}).joined(separator: ",")
                booking?.flightNumbers = self.createFlightNumber(with: (obj["flight_number"] as? [String] ?? []), airlines: airlines)
            }
        }
        
        //manage the header date
        func getDateStr(dateNTime: String) -> String {
            //"2019-07-08 16:09:08"
            if let str = dateNTime.components(separatedBy: " ").first {
                return "\(str) 00:00:00"
            }
            
            return dateNTime
        }
        
        if let type = booking?.productType, type == .flight {
            booking?.dateHeader = getDateStr(dateNTime: booking?.depart ?? "")
        }
        else {
            booking?.dateHeader = getDateStr(dateNTime: booking?.eventStartDate ?? "")
        }
        //manage the header date
        
        if let obj = dataDict[APIKeys.cases.rawValue] as? [String] {
            booking?.cases = obj
        }
        
        CoreDataManager.shared.saveContext()
        
        return booking!
    }
    
    // MARK: - Insert Bulk Data
    
    // MARK: -
    
    class func insert(dataDictArray: [JSONDictionary], completionBlock: @escaping ([BookingData]) -> Void) {
        
        for dataDict in dataDictArray {
            let _ = BookingData.insert(dataDict: dataDict)
        }
        completionBlock([])
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
    
    class func createFlightNumber(with flightNumber: [String], airlines : [String:String])-> String{
        var flightsNumbers = [String]()
        for code in flightNumber{
            let codes = code.components(separatedBy: " ")
            let numbers = "\(Int(codes.last ?? "0") ?? 0)"
            let airLineCode = codes.first ?? ""
            let airline = airlines[airLineCode] ?? ""
            var fisibleNumbers = [String]()
            if numbers.count >= 4{
                fisibleNumbers = [numbers]
            }else{
                fisibleNumbers = [numbers]
                for i in 0..<(4 - numbers.count){
                    let str = String(repeating: "0", count: i+1)
                    fisibleNumbers.append(str + numbers)
                }
            }
            for number in fisibleNumbers{
                flightsNumbers.append((airLineCode + number).lowercased().replacingOccurrences(of: " ", with: ""))
                flightsNumbers.append((airline + number).lowercased().replacingOccurrences(of: " ", with: ""))
                flightsNumbers.append("\(airline)\(airLineCode + number)".lowercased().replacingOccurrences(of: " ", with: ""))
                
            }
        }
        return flightsNumbers.joined(separator: ",")
    }
}
