//
//  UserInfo.swift
//
//  Created by Pramod Kumar on 04/02/16.
//  Copyright © 2016 Pramod Kumar. All rights reserved.
//

import UIKit

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

    struct Address {
        
        var isLoggedIn: Bool = false
        var profileName: String = ""
        var firstName: String = ""
        var lastName: String = ""
        var city: String = ""
        var state: String = ""
        var country: String = ""
        var countryCode: String = ""
        var postcode: String = ""
        var email: String = ""
        var mobile: String = ""
        var billingName: String = ""
        var creditType: String = ""
        var profileImage: String = ""
        var preferredCurrency: String = ""
        var isd: String = ""
        
        var jsonDict: JSONDictionary {
            
            return ["isLoggedIn": self.isLoggedIn,
                    "profile_name": self.profileName,
                    "first_name": self.firstName,
                    "last_name": self.lastName,
                    "city": self.city,
                    "state": self.state,
                    "postcode": self.postcode,
                    "country": self.country,
                    "countryCode": self.countryCode,
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
                self.profileName = "\(obj)".removeNull
            }
            
            if let obj = dict["profile_image"] {
                self.profileImage = "\(obj)".removeNull
            }
            
            if let obj = dict["first_name"] {
                self.firstName = "\(obj)".removeNull
            }
            
            if let obj = dict["last_name"] {
                self.lastName = "\(obj)".removeNull
            }
            
            
            if let obj = dict["city"] {
                self.city = "\(obj)".removeNull
            }
            
            if let obj = dict["state"] {
                self.state = "\(obj)".removeNull
            }
            
            if let obj = dict["postcode"] {
                self.country = "\(obj)".removeNull
            }
            
            if let obj = dict["country"] {
                self.postcode = "\(obj)".removeNull
            }
            
            if let obj = dict["email"] {
                self.email = "\(obj)".removeNull
            }
            
            if let obj = dict["mobile"] {
                self.mobile = "\(obj)".removeNull
            }
        }
    }
    
    struct GeneralPref {
        var sortOrder = ""
        var displayOrder = ""
        var categorizeByGroup : Bool = false
        var labels : [String] = []
       
        var jsonDict: [String:Any] {
            return ["sort_order": self.sortOrder,
                    "display_order": self.displayOrder,
                    "categorize_by_group": self.categorizeByGroup,
                    "labels": self.labels,
                   ]
        }
    
        init() {
            
            let json = JSON()
            self.init(json: json)
        }
        
        init(json: JSON) {
            
            self.sortOrder     = json["sort_order"].stringValue
            self.displayOrder   = json["display_order"].stringValue
            self.categorizeByGroup   = json["categorize_by_group"].boolValue
            self.labels = json["labels"].arrayObject as? [String] ?? []
        }
    }
    
    
    struct HotelFilter : Codable {
        var ratingCount: [Int] = []
        var tripAdvisorRatingCount: [Int] = []
        var isIncludeUnrated: Bool = false
        var distanceRange : Double = 0.0
        var minimumPrice : Double = 0.0
        var maximumPrice : Double = 0.0
        var leftRangePrice : Double = 0.0
        var rightRangePrice: Double = 0.0
        var amentities : [String] = []
        var roomMeal : [String] = []
        var roomCancelation : [String] = []
        var roomOther : [String] = []
        var sortUsing : SortUsing = .BestSellers
        
        
        init() {
            ratingCount =  []
            tripAdvisorRatingCount  = []
            isIncludeUnrated  = false
            distanceRange  = 0.0
            minimumPrice  = 0.0
            maximumPrice  = 0.0
            leftRangePrice = 0.0
            rightRangePrice = 0.0
            amentities  = []
            roomMeal  = []
            roomCancelation  = []
            roomOther  = []
            sortUsing = .BestSellers
           
        }
        
        
        private enum CodingKeys: String, CodingKey {
            case ratingCount
            case tripAdvisorRatingCount
            case isIncludeUnrated
            case distanceRange
            case minimumPrice
            case maximumPrice
            case leftRangePrice
            case rightRangePrice
            case amentities
            case roomMeal
            case roomCancelation
            case roomOther
            case sortUsing
        }

        
         init(from decoder:Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            ratingCount = try values.decode([Int].self, forKey: .ratingCount)
            tripAdvisorRatingCount = try values.decode([Int].self, forKey: .tripAdvisorRatingCount)
            isIncludeUnrated  = try values.decode(Bool.self, forKey: .isIncludeUnrated)
            distanceRange = try values.decode(Double.self, forKey: .distanceRange)
            minimumPrice = try values.decode(Double.self, forKey: .minimumPrice)
            maximumPrice = try values.decode(Double.self, forKey: .maximumPrice)
            leftRangePrice = try values.decode(Double.self, forKey: .leftRangePrice)
            rightRangePrice = try values.decode(Double.self, forKey: .rightRangePrice)
            amentities = try values.decode([String].self, forKey: .amentities)
            roomMeal = try values.decode([String].self, forKey: .roomMeal)
            roomCancelation = try values.decode([String].self, forKey: .roomCancelation)
            roomOther = try values.decode([String].self, forKey: .roomOther)
            sortUsing =  try values.decode(SortUsing.self, forKey: .sortUsing)
            
            
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

    
    static var loggedInUser:UserInfo? {
        
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
            return (userData?["email"] as? String ?? "").removeNull
        }
        set{
            updateInfo(withData: ["email":newValue])
        }
    }
    
    var password: String {
        get{
            return (userData?["password"] as? String ?? "").removeNull
        }
        set{
            updateInfo(withData: ["password":newValue])
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
    
    var salutation:String{
        get{
            return (userData?["salutation"] as? String ?? "").removeNull
        }
        set{
            updateInfo(withData: ["salutation":newValue])
        }
    }
    
    var billingName:String{
        get{
            return (userData?["billing_name"] as? String ?? "").removeNull
        }
        set{
            updateInfo(withData: ["billing_name":newValue])
        }
    }
    
    var profileName:String{
        get{
            return (userData?["profile_name"] as? String ?? "").removeNull
        }
        set{
            updateInfo(withData: ["profile_name":newValue])
            
        }
    }
    
    var firstName:String{
        get{
            return (userData?["first_name"] as? String ?? "").removeNull
        }
        set{
            updateInfo(withData: ["first_name":newValue])
        }
    }
    
    var lastName:String{
        get{
            return (userData?["last_name"] as? String ?? "").removeNull
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
    
    var gender: Gender? {
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
    
    var mobile:String{
        get{
            return (userData?["mobile"] as? String ?? "").removeNull
        }
        set{
            updateInfo(withData: ["mobile":newValue])
        }
    }
    
    var isd:String{
        get{
            let val = (userData?["isd"] as? String ?? "").removeNull
            return val.contains("+") ? val : "+\(val)"
        }
        set{
            let val = newValue.removeNull
            if !val.isEmpty {
                updateInfo(withData: ["isd": val.contains("+") ? val : "+\(val)"])
            }
        }
    }
    
    var mobileWithISD: String {
        if !self.mobile.isEmpty {
            return "\(self.isd) \(self.mobile)"
        }
        else {
            return ""
        }
    }
    
    var preferredCurrency:String{
        get{
            return (userData?["preferred_currency"] as? String ?? "").removeNull
        }
        set{
            updateInfo(withData: ["preferred_currency":newValue])
        }
    }
    
    var paxId:String{
        get{
            return (userData?["pax_id"] as? String ?? "").removeNull
        }
        set{
            updateInfo(withData: ["pax_id":newValue])
        }
    }
    
    var creditType:String{
        get{
            return (userData?["credit_type"] as? String ?? "").removeNull
        }
        set{
            updateInfo(withData: ["credit_type":newValue])
        }
    }
    
    var profileImage:String{
        get{
            return (userData?["profile_img"] as? String ?? "").removeNull
        }
        set{
            updateInfo(withData: ["profile_img":newValue])
        }
    }
    
    var accessToken:String{
        get{
            return (userData?["access_token"] as? String ?? "").removeNull
        }
        set{
            updateInfo(withData: ["access_token":newValue])
        }
    }
    
    var minContactLimit: Int{
        get{
            return ((userData?["minContactLimit"] as? String)?.toInt ?? 0)
        }
        set{
            updateInfo(withData: ["minContactLimit":newValue])
        }
    }
    
    var maxContactLimit: Int{
        get{
            return ((userData?["maxContactLimit"] as? String)?.toInt ?? 0)
        }
        set{
            updateInfo(withData: ["maxContactLimit":newValue])
        }
    }
    
    var generalPref: GeneralPref? {
        get {
            if let genPref = userData?[APIKeys.generalPref.rawValue] as? String {
                if let dict = AppGlobals.shared.onject(from: genPref) {
                    return GeneralPref(json: JSON(dict))
                }
            }
            return nil
        }
        set {
            if let vlaue = newValue?.jsonDict {
                updateInfo(withData: [APIKeys.generalPref.rawValue: AppGlobals.shared.json(from: vlaue) ?? ""])
            }
            else{
                UserDefaults.removeObject(forKey: APIKeys.generalPref.rawValue)
            }
        }
    }
    
    class var hotelFilter: HotelFilter? {
        get {
            if let obj = UserDefaults.standard.retrieve(object: UserInfo.HotelFilter.self , fromKey: APIKeys.hotelFilter.rawValue) {
                return obj
            }
            return nil
        }
        set {
            if let vlaue = newValue {
                UserDefaults.standard.save(customObject: vlaue, inKey: APIKeys.hotelFilter.rawValue)
            }
            else{
                UserDefaults.removeObject(forKey: APIKeys.hotelFilter.rawValue)
            }
        }
    }
    
    var address: Address? {
        get {
            
            if let dict = UserDefaults.getObject(forKey: "address") as? JSONDictionary {
                return Address(dict: dict)
            }
            return nil
        }
        set{
            if let vlaue = newValue?.jsonDict {
                UserDefaults.setObject(vlaue, forKey: "address")
            }
            else{
                UserDefaults.removeObject(forKey: "address")
            }
        }
    }
    
    var accountData: AccountModel? {
        get {
            
            if let dict = UserDefaults.getObject(forKey: "account_data") {
                return AccountModel(json: JSON(dict))
            }
            return nil
        }
        set{
            if let vlaue = newValue?.jsonDict {
                UserDefaults.setObject(vlaue, forKey: "account_data")
            }
            else{
                UserDefaults.removeObject(forKey: "account_data")
            }
        }
    }

    var socialLoginType: LinkedAccount.SocialType? {
        get {
            
            if let dict = UserDefaults.getObject(forKey: "socialLoginType") as? String {
                return LinkedAccount.SocialType(rawValue: dict)
            }
            return nil
        }
        set{
            if let vlaue = newValue?.rawValue {
                UserDefaults.setObject(vlaue, forKey: "socialLoginType")
            }
            else{
                UserDefaults.removeObject(forKey: "socialLoginType")
            }
        }
    }
    
    var profilePlaceholder: UIImage? {
        get {

            if let data = UserDefaults.getObject(forKey: "profilePlaceholder") as? Data {
                return UIImage(data: data)
            }
            return nil
        }
        set{
            if let vlaue = newValue, let data = vlaue.jpegData(compressionQuality: 1.0) {
                UserDefaults.setObject(data, forKey: "profilePlaceholder")
            }
            else{
                UserDefaults.removeObject(forKey: "profilePlaceholder")
            }
        }
    }
    
    var travellerDetailModel: TravelDetailModel {
        var temp = TravelDetailModel(json: JSON([:]))
        temp.id = self.paxId
        temp.firstName = self.firstName
        temp.dob = self.birthDate
        temp.lastName = self.lastName
        temp.salutation = self.salutation
        temp.profileImage = self.profileImage
        
        var cont = Contact(json: [:])
        
//        if !self.mobile.isEmpty {
            var mobile = Mobile(json: [:])
            mobile.isd = self.isd
            mobile.value = self.mobile
            mobile.label = LocalizedString.Default.localized
            cont.add(mobile: mobile)
//        }
        
//        if !self.email.isEmpty {
            var email = Email(json: [:])
            email.label = LocalizedString.Default.localized
            email.value = self.email
            cont.add(email: email)
//        }
        
        temp.contact = cont
        return temp
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
    
    func profileImagePlaceholder(font: UIFont = AppFonts.Regular.withSize(35.0), textColor: UIColor = AppColors.themeGray40) -> UIImage {
        return AppGlobals.shared.getImageFor(firstName: UserInfo.loggedInUser?.firstName, lastName: UserInfo.loggedInUser?.lastName, font: font, textColor: textColor)
    }
}

