//
//  HCEmailItinerariesModel.swift
//  AERTRIP
//
//  Created by Admin on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct HCEmailItinerariesModel {
    
    //Mark:- Enum
    //===========
    enum EmailStatus {
        case toBeSend, sending, sent
    }
    
    //Mark:- Variables
    //================
    var emailId: String = ""
    var emailStatus: EmailStatus = .toBeSend
    
    init() {
        self.emailId = ""
        self.emailStatus = .toBeSend
    }
}
