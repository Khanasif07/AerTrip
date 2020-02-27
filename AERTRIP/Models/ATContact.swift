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
    var contact: String{
        didSet {
            if !contact.isEmpty, self.firstName.isEmpty {
                self.firstName = contact
            }
        }
    }
    var email: String {
        didSet {
            if !email.isEmpty, self.firstName.isEmpty {
                self.firstName = email.capitalizedFirst()
            }
        }
    }
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
        return AppGlobals.shared.getImageFor(firstName: firstName, lastName: lastName, font: AppFonts.Regular.withSize(38.0), offSet: CGPoint(x: 0, y: 9))
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
            // add Email when first aname and last name empty
            if final.removeAllWhiteSpacesAndNewLines.isEmpty {
                return self.email.removeAllWhiteSpacesAndNewLines
            }
            else {
                return final
            }
        }
        else {
            return self._fullName.removeAllWhiteSpacesAndNewLines
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
    
    init(contact: CNContact) {
        self.init()
        
        self.id = contact.identifier
        self._label = Label.phone.rawValue
        
        self.firstName = contact.firstName
        self.lastName = contact.lastName
        
        if let email = contact.emailAddresses.first {
            self.email = email.value as String
            self.emailLabel = "internet"
        }
        
        self.dob = contact.dob
        /*
        DispatchQueue.global(qos: .utility).async {
            if let phone = contact.phoneNumbers.first {
                self.contact = phone.value.stringValue
                do {
                    let temp = try PhoneNumberKit().parse(self.contact)
                    self.contact = "\(temp.nationalNumber)"
                    self.isd = "+\(temp.countryCode)"
                } catch {
                    printDebug("not able to parse the number")
                    self.contact = ""
                }
            }
        }*/
        self.imageData = contact.imageData
    }
    
    
    static func fetchModels(phoneContactsArr: [CNContact]) -> [ATContact] {
        var temp = [ATContact]()
        for obj in phoneContactsArr {
            let contact = ATContact(contact: obj)
            if !contact.firstName.isEmpty || !contact.lastName.isEmpty{
                temp.append(contact)
            }
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
            
            if !contact.firstName.isEmpty || !contact.lastName.isEmpty {
                temp.append(contact)
            }
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
                
                if let phoneArr = dict["gd$phoneNumber"] as? [JSONDictionary], let obj = phoneArr.first?["$t"] {
                    contact.contact = "\(obj)"
                }
                
                
                
                
                if let links = dict["link"] as? [JSONDictionary] {
                    for link in links {
                        if let type = link["type"] as? String, type == "image/*", let path = link["href"] {
                            contact.image = "\(path)"
                            break
                        }
                    }
                }
                
                if !contact.firstName.isEmpty || !contact.lastName.isEmpty {
                    temp.append(contact)
                }
                
            }
        }
        
        return temp
    }
}
extension ATContact: Equatable {
    static func == (lhs: ATContact, rhs: ATContact) -> Bool {
        return lhs.label == rhs.label &&
            lhs.id == rhs.id &&
            lhs.socialId == rhs.socialId
    }
}

extension CNContact {
    var firstName: String {
        var fName = ""
        // commenting because to match with contact appp we have to remove this logic
//        if self.givenName.contains(" ") {
//            let arr = self.givenName.components(separatedBy: " ")
//            if arr.count > 1 {
//                fName = arr[0]
//            }
//            else if arr.count == 1{
//                fName = arr[0]
//            }
//        }
        fName = self.givenName
        
        //if name is empty then set email's first char as name
        if fName.isEmpty {
            fName = self.email.capitalizedFirst()
        }
        
        //if name is empty then set email's first char as name
        if fName.isEmpty {
            fName = self.fullContact.contact
        }
        
        return fName
    }
    
    var lastName: String {
        // commenting because to match with contact appp we have to remove this logic
//        if self.givenName.contains(" ") {
//            let arr = self.givenName.components(separatedBy: " ")
//            if arr.count > 1 {
//                return arr[1]
//            }
//        }
        // sending space because backend is not accepting the
        if self.familyName.isEmpty {
            return " "
        }
        return self.familyName
    }
    
    var fullName: String {
        return "\(self.firstName) \(self.lastName)"
    }
    
    var id: String {
        return self.identifier
    }
    
    var email: String {
        if let email = self.emailAddresses.first {
            return (email.value as String)
        }
        return ""
    }
    
    var emailLabel: String {
        return "internet"
    }
    
    var dob: String {
        if let year = self.birthday?.year,let month = self.birthday?.month,let day = self.birthday?.day {
            let monthString = "\(month)"
            return "\(year)-\(monthString.count > 1 ? "": "0")\(month)-\(day)"
        } else {
            return ""
        }
        
    }
    
    
    var fullContact: (isd: String, contact: String) {
        if let phone = self.phoneNumbers.first {
            //            let tempNumber = phone.value.stringValue
            //            do {
            //                let temp = try PhoneNumberKit().parse(tempNumber)
            //                return ("+\(temp.countryCode)", "\(temp.nationalNumber)")
            //            }
            //            catch {
            //                printDebug("not able to parse the number")
            //            }
            return ("", phone.value.stringValue)
        }
        
        if let currentIsd = PKCountryPicker.default.getCurrentLocalCountryData()?.countryCode {
            return (currentIsd, "")
        }
        return ("", "")
    }
    
    var label: ATContact.Label {
        return ATContact.Label.phone
    }
}

protocol Test {
    func printName()
}

extension Test {
    
    func printName() {
        printDebug("hello world")
    }
}
