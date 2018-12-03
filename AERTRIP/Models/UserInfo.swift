//
//  UserInfo.swift
//
//  Created by Pramod Kumar on 04/02/16.
//  Copyright © 2016 Pramod Kumar. All rights reserved.
//

import Foundation

//MARK:- Custom Notification for Notification Center
//MARK:-
extension Notification {
    static let notificationCountDidChanged = Notification.Name("notificationCountDidChanged_")
}

class UserInfo {
    
    enum Gender: Int {
        case male = 0
        case female = 1
    }

    struct address {
        var firstName: String = ""
        var lastName: String = ""
        var company: String = ""
        var address1: String = ""
        var address2: String = ""
        var city: String = ""
        var state: String = ""
        var country: String = ""
        var postcode: String = ""
        var email: String = ""
        var phone: String = ""
        var dict: JSONDictionary {
            return ["first_name": self.firstName,
                    "last_name": self.lastName,
                    "company": self.company,
                    "address_1": self.address1,
                    "address_2": self.address2,
                    "city": self.city,
                    "state": self.state,
                    "postcode": self.postcode,
                    "country": self.country,
                    "email": self.email,
                    "phone": self.phone]
        }
        var full: String {
            var fullAdd = ""
            
            if !address1.isEmpty {
               fullAdd = address1
            }
            if !address2.isEmpty {
                fullAdd = fullAdd + " " + address2
            }
            if !city.isEmpty {
                fullAdd = fullAdd + " " + city
            }
            if !state.isEmpty {
                fullAdd = fullAdd + " " + state
            }
            if !country.isEmpty {
                fullAdd = fullAdd + " " + country
            }
            if !postcode.isEmpty {
                fullAdd = fullAdd + " " + postcode
            }
            if !phone.isEmpty {
                fullAdd = fullAdd + " " + phone
            }
            
            return fullAdd
        }
        
        init(dict: JSONDictionary) {
            
            if let obj = dict["first_name"] {
                self.firstName = "\(obj)"
            }
            
            if let obj = dict["last_name"] {
                self.lastName = "\(obj)"
            }
            
            if let obj = dict["company"] {
                self.company = "\(obj)"
            }
            
            if let obj = dict["address_1"] {
                self.address1 = "\(obj)"
            }
            
            if let obj = dict["address_2"] {
                self.address2 = "\(obj)"
            }
            
            if let obj = dict["city"] {
                self.city = "\(obj)"
            }
            
            if let obj = dict["state"] {
                self.state = "\(obj)"
            }
            
            if let obj = dict["postcode"] {
                self.country = "\(obj)"
            }
            
            if let obj = dict["country"] {
                self.postcode = "\(obj)"
            }
            
            if let obj = dict["email"] {
                self.email = "\(obj)"
            }
            
            if let obj = dict["phone"] {
                self.phone = "\(obj)"
            }
        }
    }
    
    static var loggedInUserId:String?{
        get{
            return UserDefaults.getObject(forKey: UserDefaults.Key.loggedInUserId.rawValue) as? String
        }
        set{
            if let vlue = newValue{
                UserDefaults.setObject(vlue, forKey: UserDefaults.Key.loggedInUserId.rawValue)
            }
            else{
                if let oldV = self.loggedInUserId {
                    UserDefaults.removeObject(forKey: "userProfileData_\(oldV)")
                }
                UserDefaults.removeObject(forKey: UserDefaults.Key.loggedInUserId.rawValue)
            }
        }
    }
    
    static var loggedInUser:UserInfo?{
        
        if let id = UserInfo.loggedInUserId{
            return fetchUser(userId: id)
        }
        return nil
    }

    private var userData:JSONDictionary?{
        return UserDefaults.getObject(forKey: "userProfileData_\(userId)") as? JSONDictionary
    }
    
    var userId:String = ""
    
    var email: String {
        get{
            return (userData?["user_email"] as? String ?? "")
        }
        set{
            updateInfo(withData: ["user_email":newValue])
        }
    }
    
    var userNicename:String{
        get{
            return (userData?["user_nicename"] as? String ?? "")
        }
        set{
            updateInfo(withData: ["user_nicename":newValue])
        }
    }
    
    var userDisplayName:String{
        get{
            return (userData?["user_display_name"] as? String ?? "")
        }
        set{
            updateInfo(withData: ["user_display_name":newValue])
        }
    }
    
    var firstName:String{
        get{
            return (userData?["first_name"] as? String ?? "")
        }
        set{
            updateInfo(withData: ["first_name":newValue])
        }
    }
    
    var lastName:String{
        get{
            return (userData?["last_name"] as? String ?? "")
        }
        set{
            updateInfo(withData: ["last_name":newValue])
        }
    }

    var birthDate:String{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: (userData?["dob"] as? String ?? "")) {
                dateFormatter.dateFormat = "dd MMM yyyy"
                return dateFormatter.string(from: date)
            }
            return ""
        }
        set{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            if let date = dateFormatter.date(from: (userData?["dob"] as? String ?? "")) {
                dateFormatter.dateFormat = "yyyy-MM-dd"
                updateInfo(withData: ["dob":dateFormatter.string(from: date)])
            }
            updateInfo(withData: ["dob":""])
        }
    }
    var gender: Gender?{
        get{
            return Gender(rawValue: (userData?["gender"] as? Int ?? 0))
        }
        set{
            if let vlaue = newValue {
                updateInfo(withData: ["gender":vlaue.rawValue])
            }
            else{
                deleteValueFor(key: "gender")
            }
        }
    }
    var accessToken:String{
        get{
            return (userData?["token"] as? String ?? "")
        }
        set{
            updateInfo(withData: ["token":newValue])
        }
    }
    
    var device_id:String{
        get{
            return (userData?["device_id"] as? String ?? "")
        }
        set{
            updateInfo(withData: ["device_id":newValue])
        }
    }
    
    var notificationCount: Int {
        get{
            return UserDefaults.getObject(forKey: "\(UserInfo.loggedInUserId ?? "biker")_user_notificationCount") as? Int ?? 0
        }
        set{
            UserDefaults.setObject(newValue, forKey: "\(UserInfo.loggedInUserId ?? "biker")_user_notificationCount")
            NotificationCenter.default.post(name: Notification.notificationCountDidChanged, object: nil)
        }
    }

    init(withData data:JSONDictionary, userId:String) {
        self.userId = userId
        self.updateInfo(withData: data)
    }
    
    func updateInfo(withData data:JSONDictionary){
        
        var userInfo = userData ?? [:]
        for (key, value) in data {
            userInfo[key] = "\(value)"
        }

        UserDefaults.setObject(userInfo, forKey: "userProfileData_\(userId)")
    }
    private func deleteValueFor(key:String){
        
        var userInfo = userData ?? [:]
        userInfo[key] = nil
        UserDefaults.setObject(userInfo, forKey: "userProfileData_\(userId)")
    }
    
    class func fetchUser(userId:String)->UserInfo?{
        
        if let userInfo = UserDefaults.getObject(forKey: "userProfileData_\(userId)") as? JSONDictionary{
            
            return UserInfo(withData: userInfo, userId: userId)
        }
        return nil
    }
    class func deleteUser(userId:String){
        
        UserDefaults.removeObject(forKey: "userProfileData_\(userId)")
    }
   
}

