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
    @NSManaged public var requests: Dictionary<String, Any>?
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
    @NSManaged public var dateHeader: String?
    @NSManaged public var dateToSort: String?
    @NSManaged public var bookingDate: String?
    @NSManaged public var bookingNumber: String?
    @NSManaged public var bookingId: String?
    
    @NSManaged public var routesArrStr: String?
    @NSManaged public var travelledCitiesArrStr: String?
    @NSManaged public var tripCitiesArrStr: String?
    @NSManaged public var paxArrStr: String?
    @NSManaged public var stepsArrayStr: String?
    
    @NSManaged public var isContainsPending: Int16
    @NSManaged public var bookingTabType: Int16
    @NSManaged public var bookingProductType: Int16
    @NSManaged public var eventType: Int16
    @NSManaged public var serviceType: String?
    @NSManaged public var cases: Array<Any>?

    
    //Requests
    @NSManaged public var stepsArray: Array<String>?
    
    //Searched By Flight number
    @NSManaged public var flightNumbers: String?
    @NSManaged public var airlines: String?
}


//Computed properties
extension BookingData {
    var bookingTab: BookingTabCategory {
        get {
            return BookingTabCategory(rawValue: Int(self.bookingTabType)) ?? .completed
        }
        set {
            self.bookingTabType = Int16(newValue.rawValue)
        }
    }
    
    var productType: ProductType {
        return ProductType(rawValue: Int(self.bookingProductType)) ?? .other
    }
    
    var tripCitiesStr: NSMutableAttributedString?
    {
        let sourceSansPRO18 = UIFont(name: AppFonts.Regular.rawValue, size: 18)?.capHeight ?? 0

        if self.productType == .flight {

            func isReturnFlight(forArr: [String]) -> Bool {
                guard !forArr.isEmpty else {return false}
                
                if forArr.count == 3, let first = forArr.first, let last = forArr.last {
                    return (first.lowercased() == last.lowercased())
                }
                else {
                    return ((self.tripType ?? "").lowercased() == "return")
                }
            }
            
            func getNormalString(forArr: [String]) -> String {
                guard !forArr.isEmpty else {return LocalizedString.dash.localized}
                return forArr.joined(separator: " → ")
            }
            
            func getNormalStringWithImg(forArr: [String]) -> NSAttributedString {
                
                guard !forArr.isEmpty else {return NSMutableAttributedString(string: LocalizedString.dash.localized)}
                
                var outputAttributedString = NSMutableAttributedString()

                for i in 0..<forArr.count{
                    let originAttributedString = NSAttributedString(string: forArr[i])
                    var join: NSAttributedString = NSAttributedString()
                    let textAttachment = NSTextAttachment()
                    let iconImage = UIImage(named: "oneway")
                    textAttachment.bounds = CGRect(x: 0, y: CGFloat(roundf(Float(sourceSansPRO18 - (iconImage?.size.height ?? 0.0))) / 2.0), width: iconImage?.size.width ?? 0.0, height: iconImage?.size.height ?? 0.0)
                    textAttachment.image = iconImage
                    join = NSAttributedString(attachment: textAttachment)
//                    let outputAttributedString = NSMutableAttributedString(attributedString: originAttributedString)
                    outputAttributedString.append(originAttributedString)
                    if i != forArr.count-1{
                        outputAttributedString.append(join)
                    }


                }
                return outputAttributedString

                
//                return NSMutableAttributedString(string: LocalizedString.dash.localized)
            }
            
            func getReturnString(forArr: [String]) -> String {
                guard forArr.count >= 2 else {return LocalizedString.dash.localized}
                return "\(forArr[0]) ⇋ \(forArr[1])"
            }
            
            guard let tripCts = self.tripCities as? [String] else {
                return NSMutableAttributedString(string: self.origin ?? LocalizedString.dash.localized)
            }
            

            if ((self.tripType ?? "").lowercased() == "single") {
                //single flight case
//                let temp = getNormalString(forArr: tripCts)
//                return NSMutableAttributedString(string: temp)
                guard !tripCts.isEmpty else {return NSMutableAttributedString(string: LocalizedString.dash.localized)}

                let originAttributedString = NSAttributedString(string: tripCts[0])
                let destinatinAttributedString = NSAttributedString(string: tripCts[1])
                var join: NSAttributedString = NSAttributedString()
                let textAttachment = NSTextAttachment()
                let iconImage = UIImage(named: "oneway")
                textAttachment.bounds = CGRect(x: 0, y: CGFloat(roundf(Float(sourceSansPRO18 - (iconImage?.size.height ?? 0.0))) / 2.0), width: iconImage?.size.width ?? 0.0, height: iconImage?.size.height ?? 0.0)
                textAttachment.image = iconImage
                join = NSAttributedString(attachment: textAttachment)
                let outputAttributedString = NSMutableAttributedString(attributedString: originAttributedString)
                outputAttributedString.append(join)
                outputAttributedString.append(destinatinAttributedString)
                return outputAttributedString

            }
            else if ((self.tripType ?? "").lowercased() == "return"){//isReturnFlight(forArr: tripCts)
                //return flight case
//                let temp = getReturnString(forArr: tripCts)
//                return NSMutableAttributedString(string: temp)
                
                
                if tripCts.count >= 2{
                    let originAttributedString = NSAttributedString(string: tripCts[0])
                    let destinatinAttributedString = NSAttributedString(string: tripCts[1])
                    var join: NSAttributedString = NSAttributedString()
                    let textAttachment = NSTextAttachment()
                    let iconImage = UIImage(named: "return")
                    textAttachment.bounds = CGRect(x: 0, y: CGFloat(roundf(Float(sourceSansPRO18 - (iconImage?.size.height ?? 0.0))) / 2.0), width: iconImage?.size.width ?? 0.0, height: iconImage?.size.height ?? 0.0)
                    textAttachment.image = iconImage
                    join = NSAttributedString(attachment: textAttachment)
                    let outputAttributedString = NSMutableAttributedString(attributedString: originAttributedString)
                    outputAttributedString.append(join)
                    outputAttributedString.append(destinatinAttributedString)
                    return outputAttributedString
                }
                
                return NSMutableAttributedString(string: LocalizedString.dash.localized)

                
            }
            else {
                //multi flight case
                if let routes = self.routes as? [[String]], let _ = self.travelledCities as? [String] {
                    //travlled some where
                    
                    if (routes.first ?? []).isEmpty {
                        //still not travlled
//                        let str = getNormalStringWithImg(forArr: tripCts)

                        let temp = getNormalString(forArr: tripCts)
                        return NSMutableAttributedString(string: temp)
                        
                        
                    }
                    else {
                        return self.createNameForMulticity()
                        
//                        var routeStr = ""
//                        var travLastIndex: Int = 0
//                        var prevCount: Int = 0
//                        for route in routes {
//                            var temp = route.joined(separator: " → ")
//
//                            if !routeStr.isEmpty {
//                                temp = ", \(temp)"
//                            }
//
//                            for (idx, ct) in route.enumerated() {
//                                let newIdx = idx + prevCount
//                                if travledCity.count > newIdx, travledCity[newIdx] == ct {
//                                    //travelled through this city
//                                    var currentCityTemp = " \(ct) →"
//                                    if !routeStr.isEmpty, idx == 0 {
//                                        currentCityTemp = ", \(ct) →"
//                                    }
//                                    travLastIndex = routeStr.count + currentCityTemp.count
//                                }
//                            }
//                            routeStr += temp
//                            prevCount = route.count
//                        }
//
//                        let attributedStr1 = NSMutableAttributedString(string: routeStr)
//                        if travLastIndex > 0 && self.bookingTabType == 1{
////                            attributedStr1.addAttributes([NSAttributedString.Key.foregroundColor: AppColors.themeGray20], range: NSRange(location: 0, length: travLastIndex+3))
//                            attributedStr1.addAttributes([NSAttributedString.Key.foregroundColor: AppColors.themeGray20], range: NSRange(location: 0, length: travLastIndex))
//                        }
//                        return attributedStr1
                    }
                }
                return NSMutableAttributedString(string: LocalizedString.dash.localized)
            }
        }
        else if self.productType == .hotel {
            return NSMutableAttributedString(string: self.hotelName ?? LocalizedString.dash.localized)
        } else {
            return NSMutableAttributedString(string: self.serviceType ?? LocalizedString.dash.localized)
        }
    }
    
    
    func createNameForMulticity() -> NSMutableAttributedString{
        
        let routes = self.routes as? [[String]] ?? []
        var routeStr = ""
        var grayString = ""
        
        for route in routes{
            if routeStr.isEmpty{
                routeStr += route.joined(separator: " → ")
            }else{
                routeStr += ", \(route.joined(separator: " → "))"
            }
        }
        
        var totalCityCount = 0
        
        for (upperIndex, route) in routes.enumerated(){
            var newRoutes = route
            if upperIndex != 0{
                totalCityCount += routes[upperIndex - 1].count - 1
            }
            newRoutes.removeLast()
            for (index, _) in newRoutes.enumerated(){
                let travelledCityIndex = index + totalCityCount
                if (self.travelledCities ?? []).count > travelledCityIndex{
                    grayString += "\((self.travelledCities ?? [])[travelledCityIndex]) → "
                    if (index == newRoutes.count - 1){
                        if (upperIndex != (routes.count - 1)){
                            grayString += "\(route.last ?? ""), "
                        }else{
                            grayString += "\(route.last ?? "")"
                        }
                    }
                }else{
                    continue
                }
            }
        }
        let attributedStr1 = NSMutableAttributedString(string: routeStr)
        if grayString != routeStr{
            let range = NSString(string: routeStr).range(of: grayString)
            attributedStr1.addAttributes([.foregroundColor: AppColors.themeGray20], range: range)
        }
        return attributedStr1
    }
    
    var flightBookingTitle:NSMutableAttributedString?{
        
        func isReturnFlight(forArr: [String]) -> Bool {
                guard !forArr.isEmpty else {return false}
                
                if forArr.count == 3, let first = forArr.first, let last = forArr.last {
                    return (first.lowercased() == last.lowercased())
                }
                else {
                    return ((self.tripType ?? "").lowercased() == "return")
                }
            }
            
            func getNormalString(forArr: [String]) -> String {
                guard !forArr.isEmpty else {return LocalizedString.dash.localized}
                return "\(self.origin ?? "") → \(self.destination ?? "")"
            }
            
            func getReturnString(forArr: [String]) -> String {
                guard forArr.count >= 2 else {return LocalizedString.dash.localized}
                return "\(self.origin ?? "") ⇋ \(self.destination ?? "")"
            }
            
            guard let tripCts = self.tripCities as? [String] else {
                return NSMutableAttributedString(string: self.origin ?? LocalizedString.dash.localized)
            }
            
            if ((self.tripType ?? "").lowercased() == "single") {
                //single flight case
                let temp = getNormalString(forArr: tripCts)
                return NSMutableAttributedString(string: temp)
            }
            else if isReturnFlight(forArr: tripCts){
                //return flight case
                let temp = getReturnString(forArr: tripCts)
                return NSMutableAttributedString(string: temp)
            }
            else {
                //multi flight case
                if let routes = self.routes as? [[String]], let travledCity = self.travelledCities as? [String] {
                    //travlled some where
                    
                    if (routes.first ?? []).isEmpty {
                        //still not travlled
                        let temp = getNormalString(forArr: tripCts)
                        return NSMutableAttributedString(string: temp)
                    }
                    else {
                        
                        var routeStr = ""
                        var travLastIndex: Int = 0
                        var prevCount: Int = 0
                        for route in routes {
                            var temp = route.joined(separator: " → ")
                            
                            if !routeStr.isEmpty {
                                temp = ", \(temp)"
                            }
                            
                            for (idx, ct) in route.enumerated() {
                                let newIdx = idx + prevCount
                                if travledCity.count > newIdx, travledCity[newIdx] == ct {
                                    //travelled through this city
                                    var currentCityTemp = " \(ct) →"
                                    if !routeStr.isEmpty, idx == 0 {
                                        currentCityTemp = ", \(ct) →"
                                    }
                                    travLastIndex = routeStr.count + currentCityTemp.count
                                }
                            }
                            routeStr += temp
                            prevCount = route.count
                        }
                        
                        let attributedStr1 = NSMutableAttributedString(string: routeStr)
                        if travLastIndex > 0 {
//                            attributedStr1.addAttributes([NSAttributedString.Key.foregroundColor: AppColors.themeGray20], range: NSRange(location: 0, length: travLastIndex+3))
                            attributedStr1.addAttributes([NSAttributedString.Key.foregroundColor: AppColors.themeGray20], range: NSRange(location: 0, length: travLastIndex))
                        }
                        return attributedStr1
                    }
                }
                return NSMutableAttributedString(string: LocalizedString.dash.localized)
            }
    }
    
    var paxStr: String {
        func getStringForOthers(arr: [String]) -> String {
            
            var nameStr = ""
            //var verbStr = (self.bookingTabType == 1) ? "are" : "were"
            
           // var actionStr = "staying"
//            if (self.productType == .flight) {
//                actionStr = (self.bookingTabType == 1) ? "flying" : "flown"
//            }
            
            switch arr.count {
            case 1: //nameStr = arr.first ?? ""
//                if nameStr.lowercased() != "you" {
//                    verbStr = (self.bookingTabType == 1) ? "is" : "was"
//                }
            
            
                if let name = arr.first{
                    var components = name.components(separatedBy: " ")
                    if components.count > 0 {
                        nameStr = components.removeFirst()
                    }
                }

                
            case 2: //nameStr = arr.joined(separator: " and ")
                
//            case 3:
//                nameStr = arr.first ?? ""
//                nameStr += ", \(arr[1...2].joined(separator: " and "))"
            
                
            var firstNameArr = [String]()
                for i in 0..<arr.count{
                    var components = arr[i].components(separatedBy: " ")
                    if components.count > 0 {
                        firstNameArr.append(components.removeFirst())
                    }
                }
                
                nameStr = firstNameArr.joined(separator: " and ")
                
            default: //nameStr = arr.first ?? ""
                if let name = arr.first{
                    var components = name.components(separatedBy: " ")
                    if components.count > 0 {
                        nameStr = components.removeFirst()
                    }
                }
                nameStr += " and \(arr.count-1) More"
//                let last = arr.last ?? ""
//                nameStr = arr.joined(separator: ", ") + " and \(last)"
            }
            
            return nameStr.isEmpty ? "N/A" : "For \(nameStr)" // \(verbStr) \(actionStr)
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
