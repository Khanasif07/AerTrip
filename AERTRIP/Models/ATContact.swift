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
    private var _fullName: String
    
    //            paramsContacts.put(String.format(Locale.getDefault(), "data[%d][last_name]", i), mLname);
    //            paramsContacts.put(String.format(Locale.getDefault(), "data[%d][first_name]", i), mFName);
    //            if (!mSelectedContacts.get(i).getEmail().equalsIgnoreCase("")) {
    //                paramsContacts.put(String.format(Locale.getDefault(), "data[%d][email][0][contact_label]", i), "internet");
    //                paramsContacts.put(String.format(Locale.getDefault(), "data[%d][email][0][contact_type]", i), "email");
    //                paramsContacts.put(String.format(Locale.getDefault(), "data[%d][email][0][contact_value]", i), mSelectedContacts.get(i).getEmail());
    //            }
    //            paramsContacts.put(String.format(Locale.getDefault(), "data[%d][mobile][0][contact_label]", i), "cell");
    //            paramsContacts.put(String.format(Locale.getDefault(), "data[%d][mobile][0][contact_type]", i), "mobile");
    //            paramsContacts.put(String.format(Locale.getDefault(), "data[%d][mobile][0][contact_value]", i), mSelectedContacts.get(i).getPhoneNumber());
 
    var label: Label {
        return Label(rawValue: self.internalLabel) ?? .phone
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
        self.internalLabel = ""
        self.firstName = ""
        self.lastName = ""
        self.image = ""
        self.contact = ""
        self.email = ""
        self.emailLabel = ""
        self.isd = ""
        self._fullName = ""
    }
    
    static func fetchModels(phoneContactsArr: [CNContact]) -> [ATContact] {
        var temp = [ATContact]()
        for obj in phoneContactsArr {
            var contact = ATContact()
            contact.internalLabel = Label.phone.rawValue
            contact.firstName = obj.givenName
            contact.lastName = obj.familyName
            if let email = obj.emailAddresses.first {
                contact.email = email.value as String
                contact.emailLabel = "internet"
            }
            temp.append(contact)
        }
        return temp
    }
    
    static func fetchModels(facebookContactsArr: [JSONDictionary]) -> [ATContact] {
        var temp = [ATContact]()
        for dict in facebookContactsArr {
            var contact = ATContact()
            contact.internalLabel = Label.facebook.rawValue
            
            if let picture = dict["picture"] as? JSONDictionary, let data = picture["data"] as? JSONDictionary, let url = data["url"] {
                contact.image = "\(url)"
            }
            
            if let obj = dict["name"] {
                contact._fullName = "\(obj)"
            }
            
            if let obj = dict["first_name"] {
                contact.firstName = "\(obj)"
            }
            
            if let obj = dict["last_name"] {
                contact.lastName = "\(obj)"
            }
            
            if let obj = dict["id"] {
                contact.socialId = "\(obj)"
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
                contact.internalLabel = Label.facebook.rawValue
                
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
