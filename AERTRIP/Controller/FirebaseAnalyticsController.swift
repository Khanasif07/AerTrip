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
    case OpenApp
    case HotelBulkBooking
    case FlightBulkBooking
    case FlightFilters = "FlightFilters"
    case HotelFilters = "HotelFilters"
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
    case FlightDomesticReturnAndMulticity
    case FlightsInternationalReturnAndMulticity
    case EditTraveller
    case AddTraveller
    case TravellerPreferences
    case Accounts
//    case AccountsLedger
//    case AccountsOutstandingLedger
//    case AccountsPeriodicStatement
    case FlightDetails
    case UpgradePlan
    case Bookings
    case Webcheckin
    case ImportTraveller
    case LinkedAccount
    case ChangeAertripID
    case LoginOrRegister
    case Login
    case Register
    case ThankYouForRegistering
    case SecureYourAccount
    case CreateProfile
    case ForgotPassword
    case CheckForgotPasswordEmail
    case ResetPassword
    case TryVerifyingYourEmailAgain
    case Profile
    case OpenTravellersList
    case OpenFavouriteHotels
    case OpenQuickPay
    case OpenLinkedAccounts
    case OpenAccountDetails
    case LogOut
    case HotelList
    case HotelMapView
    
    // Filter
    case Sort
    case Distance
    case Price
    case PriceRange
    case PriceType
    case PerNight
    case Total
    case Ratings
    case StarRating
    case TARating
    case Amenities
    case Room
    
    case FlightOneWayResults
    case FlightInternationalAndMulticityResults
    case FlightDomesticAndMulticityResults
    
    case Addons
    
    
   
    case MyBookingsHotelCancellation
    case MyBookingsNotes
    case NavigateBack
    case MyBookings
    case CloseButtonClicked
    
//    Home
    case Home
    case FlightForm
    case AirportSelection
    case PassengerSelection
    case CabinClassSelection
    case HotelForm
    case HotelSearch
    case HotelsFinalCheckOut
    case OpenHotelSpecialRequest
    case HotelSpecialRequest
    case OpenHotelCheckOut
    case OpenHotelsDetails
    case OpenHotelsFinalCheckOut
    case OpenHotelsPayment
    case OpenHotelsReceipt
    case OpenCouponForHotels
    case HotelReceipt
    
    case FlightGuestCheckout
    case FlightCheckOut
    case FlightSearch
    case OpenFlightDetails
    case OpenPassengerDetails
    case OpenFlightCheckOut
    case OpenFightPayment
    case OpenFlightReceipt
    case FlightReceipt
    case PostBookingSeatPayment
    case PostBookingSeatPaymentStatus
    
//    SideMenu
    case SideMenu
    
    case Aerin
    
    //Flight Checkout
    case FinalFlightCheckout
    case ApplyCouponForFlights
    case FlightPayment
    
}

enum AnalyticsKeys: String {
    
    //MARK: Firebase Log Event Keys
    case name = "Name"
    case type = "Type"
    case values = "Values"
    
}
