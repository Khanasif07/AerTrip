//
//  EndPoints.swift
//  
//
//  Created by Pramod Kumar on 17/07/17.
//  Copyright © 2017 Pramod Kumar. All rights reserved.
//

import Foundation

enum APIEndPoint : String {
    
    //MARK: - Base URLs
    case apiKey       = "3a457a74be76d6c3603059b559f6addf"
    case baseUrlPath  = "https://beta.aertrip.com/api/v1/"

    //MARK: - Account URLs -
    case isActiveUser       = "users/is-active-user"
    case login              = "users/login"
    case logout             = "users/logout"
    case socialLogin        = "social/app-social-login"
    case socialLink        = "social/app-social-link"
    case register           = "users/register"
    case emailAvailability  = "users/email-availability"
    case forgotPassword     = "users/reset-password"
    case updateUserDetail   = "users/initial-details"
    case updateUserPassword = "users/update-password"
    case verifyRegistration = "users/verify-registration"
    case resetPassword         = "users/validate-password-reset-token"
    case getTravellerDetail = "users/traveller-detail"
    case dropDownSalutation = "default/dropdown-keys"
    case flightsPreferences = "flights/preference-master"
    case flyerSearch = "airlines/search"
    case countryList = "country/list"
    case saveProfile =  "user-passenger/save-new"
    case defaultAirlines = "airlines/get-default-airlines"
    case hotelPreferenceList = "users/hotel-pref-list-new"
    case searchHotels = "hotels/suggestions-new"
    case favourite = "hotels/favourite"
    case hotelStarPreference = "users/hotel-star-preference"    
    case travellerList = "users/traveller-list"
    case saveGeneralPreferences = "users/save-general-preferences"
    case phoneContacts = "user-passenger/import-contacts"
    case socialContacts = "social/import"
    case assignGroup = "users/apply-label"
    case deletePaxData = "user-passenger/delete-pax-data"
    case linkedAccounts = "users/linked-accounts"
    case unlinkSocialAccount = "users/unlink-social-account"
    case searchDestinationHotels = "hotels/places"
    case hotelsNearByMe = "hotels/get-nearby-hotels"
    case hotelsNearByMeLocations = "hotels/location"
    case hotelListOnPreferenceL = "hotels/search"
    case hotelListOnPreferenceResult = "hotels/results"
    case hotelBulkBooking = "enquiry/bulk-booking-enquiry"
    case hotelInfo = "hotels/details"
    case hotelDistanceAndTravelTime = "https://maps.googleapis.com/maps/api/"
    case hotelRecentSearches = "recent-search/get"
    case getPinnedTemplate = "hotels/get-pinned-template"
    case sendPinnedMail = "hotels/send-pinned-mail"
}

//MARK: - endpoint extension for url -
extension APIEndPoint {
    
    var path: String {
        
        switch self {
        case .baseUrlPath:
            return self.rawValue
        default:
            let tmpString = "\(APIEndPoint.baseUrlPath.rawValue)\(self.rawValue)"
            return tmpString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        }
    }
}
