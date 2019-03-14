//
//  GuestModal.swift
//  AERTRIP
//
//  Created by apple on 14/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation


struct GuestModal {
    var id : Int = 0
    var firstName : String = ""
    var lastName : String = ""
    var salutation : String = ""
    var passengerType:String = ""
    var profilePicture:String = ""
    
    var jsonDict: [String:Any] {
        return ["id":self.id,
                "firstName":self.firstName,
                "lastName":self.lastName,
                "salutation":self.salutation,"passengerType":self.passengerType,"profilePicture":self.profilePicture]
    }
    
    init () {
       id = 0
       firstName = ""
       lastName = ""
       salutation = ""
       passengerType = ""
       profilePicture = ""
    }
  
}
