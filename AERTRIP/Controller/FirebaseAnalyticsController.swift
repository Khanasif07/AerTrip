//
//  FirebaseAnalyticsController.swift
//  AERTRIP
//
//  Created by Rishabh on 03/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
import FirebaseAnalytics

class FirebaseAnalyticsController {
    
    static let shared = FirebaseAnalyticsController()
    
    func logEvent(name: String, params: JSONDictionary? = nil) {
        if AppConstants.isReleasingForCustomers{
            Analytics.logEvent(name, parameters: params)
        }
    }
    
}

enum AnalyticsEvents: String {
    //MARK: Firebase event names
    case FlightFilters = "FlightFilters"
    case FlightFiltersNavigation = "FlightFiltersNavigation"
    case HotelFiltersNavigation = "HotelFiltersNavigation"
    case AccountDetails
    case SetPassword
    case ChangePassword
    case ChangeMobile
    case SetMobile
    case EnableOTP
    case DisableOTP
    case Settings
    case IndividualHotelDetails
    case HotelGuestCheckout
    case HotelCheckOut
    case FavouriteHotels
    case TravellersList
    case ViewTraveller
    case EditMainTraveller
    case FlightOneWayResults
    case FlightDomesticReturnAndMulticity
    case FlightsInternationalReturnAndMulticity
    case EditTraveller
    case AddTraveller
    case TravellerPreferences
    case Accounts
    case AccountsLedger
    case AccountsOutstandingLedger
    case AccountsPeriodicStatement
    case FlightDetails
    case UpgradePlan
    case Bookings
    case Webcheckin
    case BookingConfirmationMail

}

enum AnalyticsKeys: String {
    
    //MARK: Firebase Log Event Keys
    case FilterName = "FilterName"
    case FilterType = "FilterType"
    case Values = "Values"
    
}
