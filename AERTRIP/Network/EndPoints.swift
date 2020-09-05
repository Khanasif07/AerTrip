//
//  EndPoints.swift
//
//
//  Created by Pramod Kumar on 17/07/17.
//  Copyright © 2017 Pramod Kumar. All rights reserved.
//

import Foundation

enum APIEndPoint: String {
    // MARK: - Base URLs
    
    //MARK: - Base URLs
    case apiKey       = "3a457a74be76d6c3603059b559f6addf"
    case baseUrlPath  = "https://beta.aertrip.com/api/v1/"

    //MARK: - Account URLs -

    case isActiveUser                  = "users/is-active-user"
    case login                         = "users/login"
    case logout                        = "users/logout"
    case socialLogin                   = "social/app-social-login"
    case socialLink                    = "social/app-social-link"
    case register                      = "users/register"
    case emailAvailability             = "users/email-availability"
    case forgotPassword                = "users/reset-password"
    case updateUserDetail              = "users/initial-details"
    case updateUserPassword            = "users/update-password"
    case verifyRegistration            = "users/verify-registration"
    case resetPassword                 = "users/validate-password-reset-token"
    case getTravellerDetail            = "users/traveller-detail"
    case validateFromToken            = "users/validate-from-token"

    
    case dropDownSalutation            = "default/dropdown-keys"
    case flightsPreferences            = "flights/preference-master"
    case flyerSearch                   = "airlines/search"
    case countryList                   = "country/list"
    case saveProfile                   = "user-passenger/save-new"
    case defaultAirlines               = "airlines/get-default-airlines"
    case hotelPreferenceList           = "users/hotel-pref-list-new"
    case searchHotels                  = "hotels/suggestions-new"
    case favourite                     = "hotels/favourite"
    case hotelStarPreference           = "users/hotel-star-preference"
    case travellerList                 = "users/traveller-list"
    case saveGeneralPreferences        = "users/save-general-preferences"
    case phoneContacts                 = "user-passenger/import-contacts"
    case socialContacts                = "social/import"
    case assignGroup                   = "users/apply-label"
    case deletePaxData                 = "user-passenger/delete-pax-data"
    case linkedAccounts                = "users/linked-accounts"
    case unlinkSocialAccount           = "users/unlink-social-account"
    case searchDestinationHotels       = "hotels/places"
    case hotelsNearByMe                = "hotels/get-nearby-hotels"
    case hotelsNearByMeLocations       = "hotels/location"
    case hotelListOnPreferenceL        = "hotels/search"
    case hotelListOnPreferenceResult   = "hotels/results"
    case hotelBulkBooking              = "enquiry/bulk-booking-enquiry"
    case hotelInfo                     = "hotels/details"
    case hotelDistanceAndTravelTime    = "https://maps.googleapis.com/maps/api/"
    case hotelRecentSearches           = "recent-search/get"
    case changePassword                = "users/change-password"
    case setPassword                   = "users/set-password"

    
    // Hotel Result Api
    case getPinnedTemplate = "hotels/get-pinned-template"
    case hotelReviews = "hotels/review"
    case sendPinnedMail = "hotels/send-pinned-mail"
    case confirmation = "hotels/confirmation"
    case recheckRates = "hotels/recheck-rates"
    case resutlFallBack = "hotels/result-fallback"
    case getShareLink = "hotels/get-share-link"



    // Email Itineraries
    case emailItineraries = ""
    //    case emailItineraries              = "dashboard/booking-action?booking_id=9035&type=email"
    case getCoponDetails = "itinerary/get-details?action=coupons"
    case applyCouponCode = "hotels/itinerary?action=coupons"
    case removeCouponCode = "itinerary/remove-coupon"
    // Trip
    case tripsList = "trips/list"
    case addTrip = "trips/add"
    case tripEventHotelsSave = "trips/event/hotels/save"
    case ownedTrips = "trips/owned"
    case tripsEventMove = "trips/event/move"
    case tripsUpdateBooking = "trips/update-booking"
    case addToTripFlight = "trips/event/flights/save"
    
    // payment
    case makePayment = "payment/make-payment"
    case paymentResponse = "payment/response"
    
    // booking
    case bookingReceipt = "booking/receipt"
    case setRecentSearch = "recent-search/set"
    case bookingList = "dashboard/list-booking"
    case preferenceMaster = "addon/preference-master"
    case cancellationRefundModeReasons = "cancellation/refund-mode-reasons"
    case cancellationRequest = "cancellation/request"
    case hotelSpecialRequestList = "default/special-request-dd"
    case makeHotelSpecialRequest = "dashboard/hotel-special-request"
    
    // booking Detail
    case getBookingDetails = "dashboard/get-booking-details"
    case getBookingFees = "dashboard/get-booking-fees"
    case getFareRules = "dashboard/get-fare-rules"
    case getCaseHistory = "dashboard/case-history"
    case abortRequest = "dashboard/abort-request"
    case requestConfirmation = "dashboard/request-confirmation"
    case getTravellerEmails = "dashboard/get-traveller-emails"
    case rescheduleRequest = "reschedule/request"
    case addOnRequest = "addon/request"
    case communicationDetail = "dashboard/communication-detail"
    case pass = "dashboard/pass"

    // Final Checkout
    
    // ACCOUNT
    case accountDetail = "user-accounts/detail"
    case accountReportAction = "user-accounts/report-action"
    case outstandingPayment = "user-accounts/outstanding-payment"
    case registerPayment = "payment/register-payment"
    case bookingOutstandingPayment = "user-accounts/booking-outstanding-payment"
    case updateConvenienceFee = "itinerary/get"
    case accountsummary = "user-accounts/get-summary"

    //my booking
    case addonPayment = "quotation/addon-payment"
    
    case hotelItinerary = "hotels/itinerary?action=traveller"
    case getPaymentMethod = "itinerary/get-payment-methods"
    case shareText = "su/create"
    
    case chatBotStart = "aerin/start"
    
//    case currencies = "default/supported-currencies"
    case currencies = "default/currencies"

    
    case privacy = "https://beta.aertrip.com/privacy"
    case about = "https://beta.aertrip.com/about"
    case legal = "https://beta.aertrip.com/legal"
    
    case whyAertrip = "https://beta.aertrip.com/why"
    case smartSort = "https://beta.aertrip.com/smart-sort"
    case offers = "https://beta.aertrip.com/offers"
    case contact = "https://beta.aertrip.com/contact"

    //Flights
    case fareConfirmation = "flights/confirmation"
    case addonsMaster = "flights/addons-master"
    case gstValidation = "flights/validate-gst-number"
    case applyFlightCouponCode = "flights/itinerary?action=coupons"
    case flightReconfirmationApi = "flights/re-confirmation"
    case flightItinerary = "flights/itinerary"
    case refundCase = "/itinerary/refund-case"
    case otherFare = "flights/otherfares"
    
    //FlightAddOns
    case seatMap = "flights/seat-map-list"
    case postBookingAddOn = "addon/get-addon-availability"
    case addOnConfirmation = "addon/addon-confirmation"
    case getAddonsQuatation = "itinerary/get-quotation"
    case getAddonsReceipt = "receipt/get"
}

// MARK: - endpoint extension for url -

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
