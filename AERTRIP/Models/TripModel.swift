//
//  TripModel.swift
//  AERTRIP
//
//  Created by Admin on 08/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

struct TripModel {
    var id: String = ""
    var name: String = ""
    var sdate: String = ""
    var edate: String = ""
    private var is_default: String = ""
    private var is_locked: String = ""
    private var is_owner: String = ""
    var owner_name: String = ""
    var imagePath: String = ""
    var image: UIImage?
    
    var isDefault: Bool {
        get {
            return is_default == "1"
        }
        
        set {
            is_default = isDefault ? "1" : "0"
        }
    }
    
    var isLocked: Bool {
        get {
            return is_locked == "1"
        }
        
        set{
            is_locked = isLocked ? "1" : "0"
        }
    }
    
    var isOwner: Bool {
        get {
            return is_owner == "1"
        }
        
        set{
            is_owner = isOwner ? "1" : "0"
        }
    }

    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        
        if let obj = json[APIKeys.id.rawValue] {
            self.id = "\(obj)"
        }
        if let obj = json[APIKeys.name.rawValue] {
            self.name = "\(obj)"
        }
        if let obj = json[APIKeys.sdate.rawValue] {
            self.sdate = "\(obj)"
        }
        if let obj = json[APIKeys.edate.rawValue] {
            self.edate = "\(obj)"
        }
        if let obj = json[APIKeys.is_default.rawValue] {
            self.is_default = "\(obj)"
        }
        if let obj = json[APIKeys.is_locked.rawValue] {
            self.is_locked = "\(obj)"
        }
        if let obj = json[APIKeys.is_owner.rawValue] {
            self.is_owner = "\(obj)"
        }
        if let obj = json[APIKeys.owner_name.rawValue] {
            self.owner_name = "\(obj)"
        }
    }
    
    static func models(jsonArr: [JSONDictionary]) -> ([TripModel], TripModel?) {
        var trips = [TripModel]()
        var defaultTrip: TripModel?
        for element in jsonArr {
            let trip = TripModel(json: element)
            if defaultTrip == nil, trip.isDefault {
                defaultTrip = trip
            }
            trips.append(trip)
        }
        return (trips, defaultTrip)
    }
}
