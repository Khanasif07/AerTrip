//
//  MessageModel.swift
//  AERTRIP
//
//  Created by Appinventiv on 19/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation


struct MessageModel {
    
    enum MessageSource{
        case me
        case other
        case typing
    }
    
    var msg : String
    var msgSource : MessageSource
    var isHidden : Bool = true
    
    init(msg : String, source : MessageSource) {
        self.msg = msg
        msgSource = source
    }
    
}
