//
//  ATContact.swift
//  AERTRIP
//
//  Created by Admin on 10/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import Contacts

struct ATContact {
    
    enum Label: String {
        case phone = "mobile"
        case facebook = "contact"
        case google = "google"
    }
    
    var id: String
    var socialId: String
    private var internalLabel: String
    var firstName: String
    var lastName: String
    var image: String
    var contact: String
    var email: String
    var emailLabel: String
    var isd: String
    
    var label: Label {
        return Label(rawValue: self.internalLabel) ?? .phone
    }
    
    var fullName: String {
        return "\(self.firstName) \(self.lastName)"
    }
    
    init() {
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        self.id = UIApplication.shared.uniqueID
        self.socialId = ""
        self.internalLabel = ""
        self.firstName = ""
        self.lastName = ""
        self.image = ""
        self.contact = ""
        self.email = ""
        self.emailLabel = ""
        self.isd = ""
    }
    
    static func fetchModels(contactsArr: [CNContact]) -> [ATContact] {
        var temp = [ATContact]()
        for obj in contactsArr {
            var contact = ATContact()
            contact.internalLabel = Label.phone.rawValue
            contact.firstName = obj.givenName
            contact.lastName = obj.familyName
            if let email = obj.emailAddresses.first {
                contact.email = email.value as String
                contact.emailLabel = email.label ?? "internet"
            }
            temp.append(contact)
        }
        return temp
    }
}
