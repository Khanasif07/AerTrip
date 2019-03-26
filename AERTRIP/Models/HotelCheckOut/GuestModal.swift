//
//  GuestModal.swift
//  AERTRIP
//
//  Created by apple on 14/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

struct GuestModal {
    var idInt: Int = 0
    var id: Int = 0
    var firstName: String = ""
    var lastName: String = ""
    var salutation: String = ""
    private var _passengerType: String = ""
    var profilePicture: String = ""
    var numberInRoom: Int = -1
    var age: Int = 0
    
    var passengerType: PassengersType {
        set {
            _passengerType = newValue.rawValue
        }
        
        get {
            return PassengersType(rawValue: _passengerType) ?? .Adult
        }
    }
    
    var fullName: String {
        if !firstName.isEmpty {
            let final = "\(firstName) \(lastName)"
            return final
        }
        else {
            return lastName
        }
    }
    
    var jsonDict: [String: Any] {
        return ["id": self.id,
                "firstName": self.firstName,
                "lastName": self.lastName,
                "salutation": self.salutation, "passengerType": self._passengerType, "profilePicture": self.profilePicture]
    }
    
    init() {
        id = 0
        firstName = ""
        lastName = ""
        salutation = ""
        _passengerType = ""
        profilePicture = ""
    }
}
