//
//  AppKeys.swift
//  
//
//  Created by Pramod Kumar on 15/05/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

typealias ErrorCodes = [Int]

enum APIKeys: String {
    
    //MARK:- Common Used
    case key
    case value
    case success
    case errors
    case status
    
    //MARK:- Login Module
    //MARK:-
    case isLoggedIn
    case data
    case msg
    case loginid     = "loginid"
    case password    = "password"
    case isGuestUser = "isGuestUser"
    case id          = "id"
    case userName    = "username"
    case firstName   = "first_name"
    case lastName    = "last_name"
    case authKey     = "authKey"
    case email       = "email"
    case picture     = "picture"
    case gender      = "gender"
    case service = "service"
    case dob     = "dob"
    case permissions    = "permissions"
    case login = "login"
    case ref   = "ref"
    case isd   = "isd"
    case country    = "country"
    case salutation = "salutation"
    case facebook   = "facebook"
    case google     = "google"
    case linkedin   = "linkedin"
    case token
    case paxId = "pax_id"
    case address = "address"
    case mobile = "mobile"
    case social = "social"
    case preferences = "preferences"
    case seat = "seat"
    case meal = "meal"
    case query = "q"
    case contact = "contact"
    case ff = "ff"
    case label = "label"
    case hash_key
    case hotel_min_star
    case hotel_max_star
    case hotels
    case hid
    case name
    case city_id
    case stars
    case rating
    case ta_rating
    case photo
    case city
    case preference_id
    case is_favourite
    
    case passportCountryName = "passport_country_name"
    case passportCountry = "passport_country"
    case passportIssueDate = "passport_issue_date"
    case passportExpiryDate = "passport_expiry_date"
    case passportNumber = "passport_number"
    case doa = "doa"
    case seatPreference = "seat_pref"
    case mealPreference = "meal_pref"
    case profileImage = "profile_image"
    case imageSource = "image_source"
    case generalPref = "general_pref"
}


