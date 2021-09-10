//
//  MessageModel.swift
//  AERTRIP
//
//  Created by Appinventiv on 19/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
//import SwiftyJSON

struct MessageModel {
    
    enum MessageSource{
        case me
        case other
        case typing
        case seeResultsAgain
    }
    
    var msg : String
    var msgSource : MessageSource
    var isHidden : Bool = true
    let sessionId : String
    let fullfilment : String
    let delta : String
    let depart : String
    let origin : String
    let destination : String
    let cabinclass : String
    let adult : Int
    let child : Int
    let infant : Int
    var tripType: String
    let returnDate: String
    
    var shouldShowTypingContent = false
    
    /// To be enabled on tap to show extra details
    var showDetails = false
    
    // Mark: Hotel Exclusive keys
    var destType: String
    var destName: String
    var checkin: String
    var checkout: String
    var destId: String
    var guests: String
    var roomDetailsDict: [String:Int]
            
    init(msg : String, source : MessageSource) {
        self.msg = msg
        msgSource = source
        fullfilment = ""
        delta = ""
        sessionId = ""
        depart = ""
        origin = ""
        destination = ""
        cabinclass = ""
        adult = 0
        child = 0
        infant = 0
        tripType = ""
        returnDate = ""
        
        // hotels
        destType = ""
        destName = ""
        checkin = ""
        checkout = ""
        destId = ""
        guests = ""
        roomDetailsDict = [:]
        
    }
    
    init(json : JSON){
        msgSource = .other
        isHidden = false
        msg = json[APIKeys.fullfilment.rawValue].stringValue
        fullfilment = json[APIKeys.fullfilment.rawValue].stringValue
        sessionId = json[APIKeys.session_id.rawValue].stringValue
        delta = json[APIKeys.delta.rawValue].stringValue
        depart = json[APIKeys.depart.rawValue].stringValue
        origin = json[APIKeys.origin.rawValue].stringValue
        destination = json[APIKeys.destination.rawValue].stringValue
        cabinclass = json[APIKeys.cabinclass.rawValue].stringValue
        adult = json[APIKeys.adult.rawValue].intValue
        child = json[APIKeys.child.rawValue].intValue
        infant = json[APIKeys.infant.rawValue].intValue
        tripType = json[APIKeys.tripType.rawValue].stringValue
        returnDate = json[APIKeys.returnDate.rawValue].stringValue
        
        // hotels
        destType = json[APIKeys.dest_type.rawValue].stringValue
        destName = json[APIKeys.dest_name.rawValue].stringValue
        checkin = json[APIKeys.checkin.rawValue].stringValue
        checkout = json[APIKeys.checkout.rawValue].stringValue
        destId = json[APIKeys.dest_id.rawValue].stringValue
        guests = json[APIKeys.guests.rawValue].stringValue
        var roomDetails = [String:Int]()
        json.forEach { (key, subJson) in
            if key.contains("r0") || key.contains("r1") || key.contains("r2") || key.contains("r3") {
                roomDetails[key] = subJson.intValue
            }
        }
        roomDetailsDict = roomDetails
    }
    
}
