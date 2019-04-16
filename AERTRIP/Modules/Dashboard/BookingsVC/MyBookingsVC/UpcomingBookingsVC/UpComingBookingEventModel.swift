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
        case flight
        case hotel
        case others
    }
    
    enum TableViewCellType {
        case eventTypeCell , spaceCell , queryCell
    }
    
    var creationDate: String = ""
    var currentEvent: EventType = .flight
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
                APIKeys.currentEvent.rawValue: self.currentEvent]
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
//            self.currentEvent = "\(obj)".removeNull == "flight"
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
}
