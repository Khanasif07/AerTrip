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
    case hotelFilter = "hotelFilter"
    
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
    case international = "international"
    case requestParmaters = "request_parameters"
    case a = "a"
    case radius = "r"
    case underScore = "_"
   

    
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
    case amenities = "amenities"
    
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
    
    //HotelDetails
    case photos = "photos"
    case amenities_group = "amenities_group"
    case checkin_time = "checkin_time"
    case checkout_time = "checkout_time"
    case checkin = "checkin"
    case checkout = "checkout"
    case rates = "rates"
    case combine_rates = "combine_rates"
    case info = "info"
    case is_refetch_cp = "is_refetch_cp"
    case occupant = "occupant"
    case main = "main"
    case basic = "basic"
    case other = "other"
    case available = "available"
    case classType = "class"
    case qid = "qid"
    case can_combine = "can_combine"
    case hotel_code = "hotel_code"
    case rooms = "rooms"
    case terms = "terms"
    case cancellation_penalty = "cancellation_penalty"
    case penalty_array = "penalty_array"
    case group_rooms = "group_rooms"
    case inclusion_array = "inclusion_array"
    case payment_info = "payment_info"
    case part_payment_last_date = "part_payment_last_date"
    case rid = "rid"
    case type = "type"
    case bed_types = "bed_types"
    case desc = "desc"
    case max_adult = "max_adult"
    case max_child = "max_child"
    case room_reference = "room_reference"
    case meals = "meals"
    case cancellation = "cancellation"
    case is_refundable = "is_refundable"
    case to = "to"
    case penalty = "penalty"
    case tz = "tz"
    case from = "from"
    case boardType = "Board Type";
    case internet = "Internet";
    case other_inclusions = "Other Inclusions";
    case notes_inclusion = "Notes";
    case transfers = "Transfers";
    case about_Property = "About the Property";
    case internet_Business_Services = "Internet & Business Services";
    case food_Drinks = "Food and drinks";
    case things_To_Do = "Things to do";
    case Services = "Services";
    case text = "text"
    case duration = "duration"
    case routes = "routes"
    case product = "product"
    case startDate = "start_date"
    case error = "error"
    case errorMsg = "errorMsg"
    case added_on = "added_on"
    case time_ago = "time_ago"
    case place = "place"
    case checkInDate = "checkInDate"
    case checkOutDate = "checkOutDate"
    case nights = "nights"
    case guests = "guests"
    case room = "room"
    case adults = "adults"
    case child = "child"
    case show = "show"
    case age = "age"
    case boundaryMin = "boundaryMin"
    case boundaryMax = "boundaryMax"
    case minPrice = "min"
    case maxPrice = "max"
    case priceRange = "priceRange"
    case no_meals = "no_meals"
    case breakfast = "breakfast"
    case half_board = "half_board"
    case full_board = "full_board"
    case others = "others"
    case cancellation_policy = "cancellation_policy"
    case refundable = "rfdble"
    case partiallyRefundable = "part_refdble"
    case nonRefundable = "non_refundable"
    case tripAdvisorRatings = "tripAdvisorRatings"
    case isChecked = "isChecked"
    case recentSearchQuery = "query"
    case response = "response"
    case shortUrl = "short_url"
    case hotelFormPreviosSearchData = "hotelFormPreviosSearchData"
    case webUrl = "web_url"
    case ratingImgUrl = "rating_img_url"
    case numReviews = "num_reviews"
    case writeReview = "write_review"
    case photoCount = "photo_count"
    case awardsImage = "awards_image"
    case seeAllPhotos = "see_all_photos"
    case rankingData = "ranking_data"
    case reviewRatingCount = "review_rating_count"
    case subratings = "subratings"
    case tripTypes = "trip_types"
    case rankingString = "ranking_string"
    case rankingOutOf = "ranking_out_of"
    case geoLocationId = "geo_location_id"
    case ranking = "ranking"
    case geoLocationName = "geo_location_name"
    case rankingStringDetail = "ranking_string_detail"
    case ratingImageUrl = "rating_image_url"
    case localizedName = "localized_name"
    
    //itinerary data
    case payment_amount
    case pg_id
    case payment_method_id
    case payment_method_sub_type_id
    case display_currency
    case gateway_currency
    case booking_currency
    case display_currency_conversion
    case gateway_currency_conversion
    case booking_currency_conversion
    case booking_name
    case booking_description
    case user_billing_address
    case total_fare
    case convenience_fees
    case use_wallet
    case use_points
    case session_id
    case product_type_id
    case product_type
    case product_category
    case user_id
    case user_type
    case coupon_code
    case coupon_id
    case added_date
    case is_combo
    case vcode
    case it_id
    case traveller_master
    case special_requests
}


