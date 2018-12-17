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
        
        var isLoggedIn: Bool = false
        var profileName: String = ""
        var firstName: String = ""
        var lastName: String = ""
        var city: String = ""
        var state: String = ""
        var country: String = ""
        var postcode: String = ""
        var email: String = ""
        var mobile: String = ""
        var billingName: String = ""
        var creditType: String = ""
        var profileImage: String = ""
        var preferredCurrency: String = ""
        var isd: String = ""
        
        var dict: JSONDictionary {
            
            return ["isLoggedIn": self.isLoggedIn,
                "profile_name": self.profileName,
                    "first_name": self.firstName,
                    "last_name": self.lastName,
                    "city": self.city,
                    "state": self.state,
                    "postcode": self.postcode,
                    "country": self.country,
                    "email": self.email,
                    "mobile": self.mobile,
                "billing_name": self.billingName,
                "credit_type": self.creditType,
                "profile_img": self.profileImage,
                "preferred_currency": self.preferredCurrency]
        }
        
        var full: String {
            var fullAdd = ""
            
            
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
            if !mobile.isEmpty {
                fullAdd = fullAdd + " " + mobile
            }
            
            return fullAdd
        }
        
        init(dict: JSONDictionary) {
            
            if let obj = dict["isLoggedIn"] {
                self.isLoggedIn = obj as? Bool ?? false
            }
            
            if let obj = dict["profile_name"] {
                self.profileName = "\(obj)"
            }
            
            if let obj = dict["profile_image"] {
                self.profileImage = "\(obj)"
            }
            
            if let obj = dict["first_name"] {
                self.firstName = "\(obj)"
            }
            
            if let obj = dict["last_name"] {
                self.lastName = "\(obj)"
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
            
            if let obj = dict["mobile"] {
                self.mobile = "\(obj)"
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
    
    var isLoggedIn: Bool {
        get{
            return (userData?["isLoggedIn"] as? Bool ?? false)
        }
        set{
            updateInfo(withData: ["isLoggedIn":newValue])
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

