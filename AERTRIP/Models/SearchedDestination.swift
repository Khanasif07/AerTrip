//
//  SearchedDestination.swift
//  AERTRIP
//
//  Created by Admin on 23/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct SearchedDestination: Codable {

    var dest_id: String = ""
    var dest_type: String = ""
    var category: String = ""
    var dest_name: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var city: String = ""
    var country: String = ""
    var label: String = ""
    var value: String = ""
    var isHotelNearMeSelected = false
    
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.dest_id.rawValue: self.dest_id,
                APIKeys.dest_type.rawValue: self.dest_type,
                APIKeys.category.rawValue: self.category,
                APIKeys.dest_name.rawValue: self.dest_name,
                APIKeys.latitude.rawValue: self.latitude,
                APIKeys.longitude.rawValue: self.longitude,
                APIKeys.city.rawValue: self.city,
                APIKeys.country.rawValue: self.country,
                APIKeys.label.rawValue: self.label,
                APIKeys.value.rawValue: self.value]
    }
    
    init(json: JSONDictionary) {
        if let obj = json[APIKeys.dest_id.rawValue] {
            self.dest_id = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.dest_type.rawValue] {
            self.dest_type = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.category.rawValue] {
            self.category = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.dest_name.rawValue] {
            self.dest_name = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.latitude.rawValue] {
            self.latitude = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.longitude.rawValue] {
            self.longitude = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.city.rawValue] {
            self.city = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.country.rawValue] {
            self.country = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.label.rawValue] {
            self.label = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.value.rawValue] {
            self.value = "\(obj)".removeNull
        }
    }
    
    init(wirh recentSerarchData: RecentSearchesModel) {
        self.dest_id = recentSerarchData.dest_id
        self.dest_type = recentSerarchData.dest_type
//        self.category = ""
        self.dest_name = recentSerarchData.dest_name
        self.latitude = recentSerarchData.lat
        self.longitude = recentSerarchData.lng
//        self.city = recentSerarchDat
//        self.country = recentSerarchData.dest_id
        self.label = recentSerarchData.dest_name
        self.value = recentSerarchData.dest_name
    }
    
    static func modelsDict(jsonArr: [JSONDictionary]) -> JSONDictionary {
        
        var temp: JSONDictionary = JSONDictionary()
        var showDidYouMean = false
        
        for json in jsonArr {
            let obj = SearchedDestination(json: json)
            if obj.category.lowercased() == SelectDestinationVM.DestinationType.didYouMean.rawValue {
                showDidYouMean = true
            }
            // Commented code as section were needed to be shown based on destination type and not category - as reported by Akshay
//            if obj.category.lowercased() == SelectDestinationVM.DestinationType.didYouMean.rawValue {
//
//                if var arr = temp[obj.category.lowercased()] as? [SearchedDestination], !arr.isEmpty {
//                    arr.append(obj)
//                    temp[obj.category.lowercased()] = arr
//                }
//                else {
//                    temp[obj.category.lowercased()] = [obj]
//                }
//            }else if !obj.category.isEmpty{
//                //Added for asana issue https://app.asana.com/0/1199093003059613/1199676600669600
//                if var arr = temp[obj.category.lowercased()] as? [SearchedDestination], !arr.isEmpty {
//                    arr.append(obj)
//                    temp[obj.category.lowercased()] = arr
//                }
//                else {
//                    temp[obj.category.lowercased()] = [obj]
//                }
//
//            }else {
                if var arr = temp[obj.dest_type.lowercased()] as? [SearchedDestination], !arr.isEmpty {
                    arr.append(obj)
                    temp[obj.dest_type.lowercased()] = arr
                }
                else {
                    temp[obj.dest_type.lowercased()] = [obj]
                }
//            }
        }
        if showDidYouMean {
            temp["showDidYouMean"] = true
        }
        return temp
    }
    
    static func models(jsonArr: [JSONDictionary]) -> ([SearchedDestination], [String]) {
        var arr = [SearchedDestination]()
        var allType = [String]()
        
        for json in jsonArr {
            let obj = SearchedDestination(json: json)
            
            if !allType.contains(obj.dest_type) {
                allType.append(obj.dest_type)
            }
            
            arr.append(obj)
        }
        return (arr, allType)
    }
}
