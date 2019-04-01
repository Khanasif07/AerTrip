//
//  ATContact.swift
//  AERTRIP
//
//  Created by Admin on 10/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit
import Contacts
import PhoneNumberKit

struct ATContact {
    
    enum Label: String {
        case phone = "mobile"
        case facebook = "contact"
        case google = "google"
        case traveller = "traveller"
    }
    
    var id: String
    var socialId: String
    private var _label: String
    var firstName: String
    var lastName: String
    var image: String
    var imageData: Data?
    var contact: String
    var email: String
    var emailLabel: String
    var isd: String
    private var _fullName: String
    
    var dob: String
    var salutation: String
    private var _passengerType: String
    var profilePicture: String
    var numberInRoom: Int
    var age: Int
    
    var flImage: UIImage? {
        return AppGlobals.shared.getImageFor(firstName: firstName, lastName: lastName)
    }
    
    var passengerType: PassengersType {
        set {
            _passengerType = newValue.rawValue
        }
        
        get {
            return PassengersType(rawValue: _passengerType) ?? .Adult
        }
    }
 
    var label: Label {
        set {
            _label = newValue.rawValue
        }
        
        get {
            return Label(rawValue: self._label) ?? .phone
        }
    }
    
    var fullName: String {
        if self._fullName.isEmpty {
            let final = "\(self.firstName) \(self.lastName)"
            if final.removeAllWhiteSpacesAndNewLines.isEmpty {
                return self.email
            }
            else {
                return final
            }
        }
        else {
            return self._fullName
        }
    }

    init() {
        let json = JSON()
        self.init(json: json)
    }
    
    init(json: JSON) {
        self.id = UIApplication.shared.uniqueID
        self.socialId = ""
        self._label = ""
        self.firstName = ""
        self.lastName = ""
        self.image = ""
        self.contact = ""
        self.email = ""
        self.emailLabel = ""
        self.isd = ""
        self._fullName = ""
        
        self.dob = ""
        self.salutation = ""
        self.profilePicture = ""
        self._passengerType = ""
        self.numberInRoom = -1
        self.age = 0
    }
    
    static func fetchModels(phoneContactsArr: [CNContact]) -> [ATContact] {
        var temp = [ATContact]()
        for obj in phoneContactsArr {
            var contact = ATContact()
            contact._label = Label.phone.rawValue
            if obj.givenName.contains(" ") {
                let arr = obj.givenName.components(separatedBy: " ")
                if arr.count > 1 {
                    contact.firstName = arr[0]
                    contact.lastName = arr[1]
                }
                else if arr.count == 1{
                    contact.firstName = arr[0]
                }
            }
            else {
                contact.firstName = obj.givenName
                contact.lastName = obj.familyName
            }

            if let email = obj.emailAddresses.first {
                contact.email = email.value as String
                contact.emailLabel = "internet"
            }
            
            if let phone = obj.phoneNumbers.first {
                let tempNumber = phone.value.stringValue
                contact.contact = phone.value.stringValue
                do {
                    let temp = try PhoneNumberKit().parse(tempNumber)
                    contact.contact = "\(temp.nationalNumber)"
                    contact.isd = "+\(temp.countryCode)"
                }
                catch {
                    printDebug("not able to parse the number")
                    contact.contact = ""
                }
            }
            
            contact.imageData = obj.imageData
            
            temp.append(contact)
        }
        return temp
    }
    
    static func fetchModels(facebookContactsArr: [JSONDictionary]) -> [ATContact] {
        var temp = [ATContact]()
        for dict in facebookContactsArr {
            var contact = ATContact()
            contact._label = Label.facebook.rawValue
            
            if let picture = dict["picture"] as? JSONDictionary, let data = picture["data"] as? JSONDictionary, let url = data["url"] {
                contact.image = "\(url)".removeNull
            }
            
            if let obj = dict["name"] {
                contact._fullName = "\(obj)".removeNull
            }
            
            if let obj = dict["first_name"] {
                contact.firstName = "\(obj)".removeNull
            }
            
            if let obj = dict["last_name"] {
                contact.lastName = "\(obj)".removeNull
            }
            
            if let obj = dict["id"] {
                contact.socialId = "\(obj)".removeNull
            }
            
            temp.append(contact)
        }
        return temp
    }
    
    static func fetchModels(googleContactsDict: JSONDictionary) -> [ATContact] {
        var temp = [ATContact]()
        
        if let feed = googleContactsDict["feed"] as? JSONDictionary, let entries = feed["entry"] as? [JSONDictionary] {
            for dict in entries {
                var contact = ATContact()
                contact._label = Label.google.rawValue
                
                if let id = dict["id"] as? JSONDictionary, let path = id["$t"] as? String, let obj = path.toUrl?.lastPathComponent {
                    contact.socialId = "\(obj)"
                }
                
                if let title = dict["title"] as? JSONDictionary, let obj = title["$t"] as? String {
                    contact._fullName = obj
                    
                    let nameArr = obj.components(separatedBy: " ")
                    contact.firstName = nameArr.first ?? ""
                    contact.lastName = nameArr.last ?? ""
                }
                
                if let emailArr = dict["gd$email"] as? [JSONDictionary], let obj = emailArr.first?["address"] {
                    contact.email = "\(obj)"
                    contact.emailLabel = "internet"
                }
                
                if let links = dict["link"] as? [JSONDictionary] {
                    for link in links {
                        if let type = link["type"] as? String, type == "image/*", let path = link["href"] {
                            contact.image = "\(path)"
                            break
                        }
                    }
                }
                
                temp.append(contact)
            }
        }

        return temp
    }
}
