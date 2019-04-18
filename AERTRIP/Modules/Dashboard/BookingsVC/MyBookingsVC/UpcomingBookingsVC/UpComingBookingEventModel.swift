//
//  UpComingBookingEventModel.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct UpComingBookingEvent {
    
    enum EventType: String {
        
        case none
        case flight
        case hotel
        case others
        
        var image: UIImage? {
            switch self {
            case .flight:
                return #imageLiteral(resourceName: "ic_acc_flight")
            case .hotel:
                return #imageLiteral(resourceName: "ic_acc_hotels")
            case .others:
                return #imageLiteral(resourceName: "others")
            default:
                return nil
            }
        }
    }
    
    enum StatusType: String {
        case done
        case pending
        case na
    }
    
    enum TableViewCellType {
        case eventTypeCell , spaceCell , queryCell
    }
    
    var creationDate: String = ""
    private var currentEvent : String = ""
    var eventType: EventType {
        get {
            return EventType(rawValue: self.currentEvent) ?? EventType.none
        }
        
        set {
            self.currentEvent = newValue.rawValue
        }
    }
    private var status: String = ""
    var statusType: StatusType {
        get {
            return StatusType(rawValue: self.status) ?? StatusType.na
        }
        set {
            self.status = newValue.rawValue
        }
    }
    var placeName: String = ""
    var travellersName: String = ""
    var queries: [String] = []
    var numbOfRows: Int {
        return self.queries.count + 1
    }
    
    init() {
        self.init(json: [:])
    }
    
    var jsonDict: JSONDictionary {
        return [APIKeys.placeName.rawValue: self.placeName,
                APIKeys.travellersName.rawValue: self.travellersName,
                APIKeys.queries.rawValue: self.queries,
                APIKeys.creationDate.rawValue: self.creationDate,
                APIKeys.currentEvent.rawValue: self.currentEvent,
                APIKeys.status.rawValue: self.status]
    }
    
    init(json: JSONDictionary) {
        
        if let obj = json[APIKeys.placeName.rawValue] {
            self.placeName = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.travellersName.rawValue] {
            self.travellersName = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.creationDate.rawValue] {
            self.creationDate = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.queries.rawValue] as? [String] {
            self.queries = obj
        }
        if let obj = json[APIKeys.creationDate.rawValue] {
            self.creationDate = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.currentEvent.rawValue] {
            self.currentEvent = "\(obj)".removeNull
        }
        if let obj = json[APIKeys.status.rawValue] {
            self.status = "\(obj)".removeNull
        }
        
    }
    
    func cellType() -> [TableViewCellType] {
        var currentSectionCells: [TableViewCellType] = []
        currentSectionCells.append(.eventTypeCell)
        for _ in self.queries {
            currentSectionCells.append(.queryCell)
        }
        currentSectionCells.append(.spaceCell)
        return currentSectionCells
    }
    
    static func getEventData(jsonDictArray: [JSONDictionary]) -> [UpComingBookingEvent] {
        var allEventData: [UpComingBookingEvent] = []
        for jsonDict in jsonDictArray {
            allEventData.append(UpComingBookingEvent(json: jsonDict))
        }
        return allEventData
    }
    
    static func getEventJsondict(jsonDictArray: [JSONDictionary]) -> JSONDictionary {
        var allEventData: JSONDictionary = [:]
        for jsonDict in jsonDictArray {
            let obj = UpComingBookingEvent(json: jsonDict)
            if var data = allEventData[obj.creationDate] as? [UpComingBookingEvent] {
                data.append(obj)
                allEventData[obj.creationDate] = data
            } else {
                allEventData[obj.creationDate] = [obj]
            }
        }
        return allEventData
    }
}
