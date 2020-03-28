//
//  MessageModel.swift
//  AERTRIP
//
//  Created by Appinventiv on 19/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MessageModel {
    
    enum MessageSource{
        case me
        case other
        case typing
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
    
    init(msg : String, source : MessageSource) {
        self.msg = msg
        msgSource = source
        fullfilment = ""
        delta = ""
        sessionId = ""
        depart = ""
        origin = ""
        destination = ""
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
        
    }
    
}
