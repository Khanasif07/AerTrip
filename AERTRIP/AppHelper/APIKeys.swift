//
//  AppKeys.swift
//  
//
//  Created by Pramod Kumar on 15/05/18.
//  Copyright © 2108 Pramod Kumar. All rights reserved.
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
    case auto_share = "auto_share"
    case notes = "notes"
    case eid = "eid"
    
    case dest_id = "dest_id"
    case dest_type = "dest_type"
    case category = "category"
    case dest_name = "dest_name"
    case latitude = "latitude"
    case longitude = "longitude"
    case check_in = "check_in"
    case check_out = "check_out"
    case isPageRefereshed = "isPageRefereshed"
    case filter = "filter"
    case star = "star"
    case vcodes = "vcodes"
    case sid = "sid"
    
    case facilities = "facilities"
    case city_code = "city_code"
    case acc_type = "acc_type"
    case temp_price = "temp_price"
    case price = "price"
    case at_hotel_fares = "at_hotel_fares"
    case no_of_nights = "no_of_nights"
    case num_rooms = "num_rooms"
    case list_price = "list_price"
    case tax = "tax"
    case discount = "discount"
    case vid = "vid"
    case hname = "hname"
    case locid = "locid"
    case bc = "bc"
    case fav = "fav"
    case distance = "distance"
    case thumbnail = "thumbnail"
    case ta_reviews  = "ta_reviews"
    case ta_web_url = "ta_web_url"
    case per_night_price = "per_night_price"
    case per_night_list_price = "per_night_list_price"
    case lat = "lat"
    case long = "long"
    
    //BulkBookings
    case source = "source"
    case from_date = "from_date"
    case to_date = "to_date"
    case destination = "destination"
    case room_count = "room_count"
    case adt = "adt"
    case chd = "chd"
    case preferred = "preferred"
    case special_request = "special_request"
    case pType = "pType"
}


