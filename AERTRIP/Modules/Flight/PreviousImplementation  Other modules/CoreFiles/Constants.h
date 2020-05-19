//
//  Constants.h
//  Mazkara
//
//  Created by Kakshil Shah on 17/01/17.
//  Copyright © 2017 BazingaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Headers = @["Content-type application":"json"]

//#define ApiURL @"https://aertrip.com/api/v1/"
#define ApiURL @"https://beta.aertrip.com/api/v1/"
#define iTUNE_LINK @"https://itunes.apple.com/app/id1086643190"
#define ApiURL_KEY @"apiURLKey"

// define macro
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)






#define DEEPLINK_SCHEEM_CONSTANT @"com.aertrip.Aertrip"
#define CONTROLLER @"Controller"
#define ImageURL "Media URL here"



//MARK:- MISC
#define USER_NAME  @"UserName"
#define USER_EMAIL  @"UserEmail"
#define USER_MOBILE  @"UserMobile"
#define AUTH_CODE @"AuthCode"
#define SHOULD_OPEN_PASSWORD_SCREEN @"OpenPassword"
#define SHOULD_OPEN_REGISTER_COMPLETE_SCREEN @"OpenRegisterComplete"

#define IS_REGISTER_COMPLETE_SCREEN_OPEN @"IsRegisterCompleteScreenOpen"


//MARK:- CONTROLLER KEYS
#define TESTING_CONTROLLER @"Testing"
#define SIDE_MENU @"SideMenu"
#define PROFILE @"Profile"
#define HOME_MODULE @"Home"
#define QUICK_PAY_MODULE @"QuickPay"
#define LOGIN_OR_REGISTER_CONTROLLER @"LoginOrRegister"
#define REGISTER_EMAIL_CONTROLLER @"LoginEmailRegister"
#define SECURE_PASSWORD_CONTROLLER @"LoginSecurePassword"
#define SIGN_IN_CONTROLLER @"LoginSignIn"
#define REGISTER_COMPLETE_CONTROLLER @"LoginRegisterComplete"
#define TRAVELLER_LIST_CONTROLLER @"TravellerList"
#define TRAVELLER_PROFILE_CONTROLLER @"TravellerProfile"
#define LOGIN_CREATE_PROFILE_CONTROLLER @"LoginCreateProfile"
#define ADD_TRAVELLER_CONTROLLER @"AddTraveller"
#define LOGIN_SUCCESSFUL_SCREEN_CONTROLLER @"LoginSuccessfulScreen"
#define TRAVELLER_LIST_SELECT_CONTROLLER @"TravellerListSelect"
#define ASSIGN_GROUP_CONTROLLER @"AssignGroup"
#define SEARCH_HOTEL_TO_ADD_CONTROLLER @"SearchHotelsToAdd"
#define FAVOURITE_HOTELS_CONTROLLER @"FavouriteHotels"
#define HOTEL_PREFERENCES_CONTROLLER @"HotelPreferences"
#define FREQUENT_FLYER_CONTROLLER @"FrequentFlyer"
#define TRAVELLER_LIST_PREFERENCES_CONTROLLER @"TravellerListPreferences"
#define LINKED_ACCOUNTS_CONTROLLER @"LinkedAccounts"
#define TRAVELLER_LIST_IMPORT_CONTROLLER @"TravellerListImport"
#define HOME_ADD_ROOM_CONTROLLER @"HomeAddRoom"
#define HOME_HOTEL_SEARCH_RESULT_CONTROLLER @"HomeHotelSearchResult"
#define HOME_SEARCH_LOCATION_CONTROLLER @"HomeSearchLocation"
#define HOME_BULK_HOTEL_BOOKING_CONTROLLER @"HomeBulkHotelBooking"
#define HOME_ADD_BULK_HOTEL_ROOM_CONTROLLER @"HomeAddBulkHotelRoom"
#define HOME_BULK_HOTEL_SUBMIT_CONTROLLER @"HomeBulkHotelSubmit"
#define CUSTOM_CALENDAR_CONTROLLER @"CustomCalendar"
#define FLIGHT_ADD_PASSENGER_CONTROLLER @"FlightAddPassenger"
#define HOME_FLIGHT_ADD_CLASS_CONTROLLER @"HomeFlightAddClass"
#define AIRPORT_SELECTION_CONTROLLER @"AirportSelectionView"
#define HOME_HOTEL_DETAILS_CONTROLLER @"HomeHotelDetails"
#define GUESTS_CONTROLLER @"Guests"
#define GUESTS_DETAILS_CONTROLLER @"GuestDetails"
#define CHECKOUT_CONTROLLER @"Checkout"
#define HOME_FLIGHT_SEARCH_RESULTS_CONTROLLER @"HomeFlightSearchResult"
#define GUEST_SPECIAL_REQUEST_CONTROLLER @"GuestSpecialRequest"
#define APPLY_COUPON_CODE_CONTROLLER @"ApplyCouponCode"
#define BOOKING_CONFIRMED_CONTROLLER @"BookingConfirmed"
#define HOTEL_ROOM_TYPES_CONTROLLER @"HotelRoomTypes"
#define FLIGHT_AMINITIES_POPUP_CONTROLLER @"HomeFlightAminitiesPopup"
#define HOME_FLIGHT_DETAIL_CONTROLLER @"HomeFlightDetail"
#define HOME_FLIGHT_ARRIVAL_PERFORMANCE_POPUP_CONTROLLER @"HomeFlightArrivalPerformancePopup"
#define PASSENGERS_CONTROLLER @"Passengers"
#define PASSENGERS_DETAIL_CONTROLLER  @"PassengerDetail"
#define HOTEL_FILTER_CONTROLLER @"HotelFilter"
#define HOTEL_REVIEWS_CONTROLLER @"HotelReviews"
#define SELECT_TRIP_CONTROLLER @"SelectTrip"
#define CREATE_NEW_TRIP_CONTROLLER @"CreateNewTrip"
#define HOTEL_OVERVIEW_CONTROLLER @"HotelOverview"
#define HOTEL_AMENITIES_CONTROLLER @"HotelAmenities"
#define FLIGHT_BULK_BOOKING_CONTROLLER @"FlightBulkBooking"
#define FLIGHT_FILTER_CONTROLLER @"FlightFilter"
#define CHECKOUT_FLIGHT_SKIP_CONTROLLER @"CheckoutFlightSkip"
#define ASSIGN_TO_PASSENGER_CONTROLLER @"AssignToPassenger"
#define FLIGHT_SELECT_SKIPABLE_OFFER_CONTROLLER @"FlightSelectSkipableOffer"
#define AGREE_DECLINE_CONTROLLER @"AgreeDecline"
#define BOOKING_INCOMPLETE_CONTROLLER @"BookingIncomplete"
#define REFUND_POPUP_CONTROLLER @"RefundPopup"
#define REQUEST_COMPLETED_CONTROLLER @"RequestCompleted"
//MARK:- Keys


#define PAYMENT_ID @"PAYMENT_ID"
#define ITENARY_ID @"ITENARY_ID"

#define CACHE_KEY @"CACHE_KEY"
#define CACHE_LIST_KEY @"CACHE_LIST_KEY"
#define LOCATION_ACCESS_PROVIDED @"locationAccessProvided"
#define REACHABLE_KEY @"isReachable"
#define NOTIFICATION_BADGE @"notificaitonBadge"
#define OPEN_PUSH @"openPush"
#define DEVICE_TOKEN @"deviceToken"
#define NO_INTERNET_KEY @"NoInternet"
#define MANUAL_ZONE_SELECTED @"manualZoneSelected"
#define USERID_KEY @"userIDAertrip"
#define USER_OBJECT @"userObject"
#define LAT_KEY @"latitude"
#define LONG_KEY @"longitude"
#define CUSTOM_LAT_KEY @"customLatitude"
#define CUSTOM_LONG_KEY @"customLongitude"
#define SUCCESS_KEY @"success"
#define SUCCESS @"true"
#define FAILURE @"0"
#define URL_KEY @"url"
#define DROP_DOWN_DATA_KEY @"DropDownData"
#define FLIGHT_PREFERENCES_DROP_DOWN_DATA_KEY @"FlightPreferencesDropDownData"

#define IS_DROP_DOWN_DATA_PRESENT_KEY @"IsDropDownDataPresent"
#define IS_FLIGHT_DROP_DOWN_DATA_PRESENT_KEY @"IsFlightDropDownDataPresent"
#define IS_CATEGORISED_GROUP_SET_KEY @"IsCatrgorizedGroupSet"
#define IS_CATEGORISED_GROUP_KEY @"IsCatrgorizedGroup"
#define IS_GET_DATA_FROM_SERVER @"isGetDataFromServer"


#define FACEBOOK_CONNECTED @"IS_FACEBOOK_CONNECTED"
#define FACEBOOK_CONNECTED_EMAIL_ID @"FACEBOOK_CONNECTED_EMAIL_ID"

#define LINKEDIN_CONNECTED @"IS_LINKEDIN_CONNECTED"
#define LINKEDIN_CONNECTED_EMAIL_ID @"LINKEDIN_CONNECTED_EMAIL_ID"

#define GOOGLE_CONNECTED @"IS_GOOGLE_CONNECTED"
#define GOOGLE_CONNECTED_EMAIL_ID @"GOOGLE_CONNECTED_EMAIL_ID"

#define GOOGLE_ACCESS_TOKEN @"GOOGLE_ACCESS_TOKEN"
#define PUSH_BACK_VIEW_PROFILE @"pushBackProfile"



#define HOTEL_CHECKOUT_HOTEL_SEARCH_ID @"HOTEL_CHECKOUT_HOTEL_SEARCH_ID"
#define HOTEL_CHECKOUT_HOTEL_SEARCH_RESULT_DETAIL @"HOTEL_CHECKOUT_HOTEL_SEARCH_RESULT_DETAIL"
#define HOTEL_CHECKOUT_HOTEL_SELECTED_ROOM @"HOTEL_CHECKOUT_HOTEL_SELECTED_ROOM"
#define HOTEL_CHECKOUT_HOTEL_SELECTED_RATE_DETAILS @"HOTEL_CHECKOUT_HOTEL_SELECTED_RATE_DETAILS"
#define HOTEL_CHECKOUT_MOVE_TO_GUESTS @"HOTEL_CHECKOUT_MOVE_TO_GUESTS"



#define FLIGHT_CHECKOUT_MOVE_TO_PASSENGERS @"FLIGHT_CHECKOUT_MOVE_TO_PASSENGERS"

#define ADULT_TYPE @"ADT"
#define CHILD_TYPE @"CHD"
#define INFANT_TYPE @"INF"

#define ECONOMY_FLIGHT_TYPE @"ECONOMY"
#define BUSINESS_FLIGHT_TYPE @"BUSINESS"
#define PREMIUM_FLIGHT_TYPE @"PREMIUM"
#define FIRST_FLIGHT_TYPE @"FIRST"

#define RECENT_HOTEL_LOCATIONS @"RECENT_HOTEL_LOCATIONS"



//MARK:- Notification
#define LOCATION_NOTIFICATION @"locationNotification"
#define LOCATION_DENIED @"locationDenied"
#define ZONE_ACCESSED @"zoneAccessed"
#define ZONE_ACCESS_ERROR @"zoneAccessError"




//MARK:- Texts
#define DISMISS_TEXT @"Ok"
#define NO_INTERNET_ERROR @"No internet Connection found, try again"
#define OOPS_ERROR_TITLE @"Oops!"
#define OOPS_ERROR_MESSAGE @"Oops, something went wrong, please try again!"

#define ERROR @"Error!"
#define NOT_KNOWN @"not known"
#define DOT_UNICODE @"\u25CF"
#define COUNTRY_DIALER_CODE @"+91"
#define EMPTY_STRING @"";
#define SORT_ORDER_FL_STRING @"FL"
#define SORT_ORDER_LF_STRING @"LF"
#define DISPLAY_ORDER_LF_STRING @"LF"
#define DISPLAY_ORDER_FL_STRING @"FL"
#define PREFERENCE_SEAT_STRING @"seat"
#define PREFERENCE_MEAL_STRING @"meal"
#define HOTEL_STRING @"HOTEL"
#define FLIGHT_STRING @"FLIGHT"



//MARK:- CONSTANTS
#define SPECIAL_KEY_CITY @"SPECIAL_KEY_CITY"

#define SPECIAL_KEY_AIRLINE @"SPECIAL_KEY_AIRLINE"
#define REGISTER_EMAIL_ID @"RegisterEmailID"
#define OPEN_DEEPLINK @"openDeepLink"
//#define API_KEY @"7472e9071e9cf87bf2c12876a1fe2006"
#define API_KEY @"3a457a74be76d6c3603059b559f6addf"
#define DEEP_LINK_KEY @"deepLinkKey"
#define DEEP_LINK_TOKEN @"deepLinkToken"
#define IS_RESET_DEEP_LINK @"isResetDeepLink"
#define BUTTON_PRESSED_SHADOW_OPACITY 0.23
#define BUTTON_RELEASED_SHADOW_OPACITY 0.74

#define FLIGHT_FILTER_DEFAULT_SORT @"Nonstop only"
#define FLIGHT_FILTER_DEFAULT_IS_REFUNDABLEFARE @YES
#define FLIGHT_FILTER_DEFAULT_PRICE_RANGE_LOW @"5000"
#define FLIGHT_FILTER_DEFAULT_PRICE_RANGE_HIGH @"10000"
#define FLIGHT_FILTER_DEFAULT_LAYOVER_RANGE_LOW @"1"
#define FLIGHT_FILTER_DEFAULT_LAYOVER_RANGE_HIGH @"23"
#define FLIGHT_FILTER_DEFAULT_TRIP_RANGE_LOW @"1"
#define FLIGHT_FILTER_DEFAULT_TRIP_RANGE_HIGH @"23"
#define FLIGHT_FILTER_DEFAULT_DEPARTURE_TIME_RANGE_LOW @"0"
#define FLIGHT_FILTER_DEFAULT_DEPARTURE_TIME_RANGE_HIGH @"24"
#define FLIGHT_FILTER_DEFAULT_ARRIVAL_TIME_RANGE_LOW @"1"
#define FLIGHT_FILTER_DEFAULT_ARRIVAL_TIME_RANGE_HIGH @"23"

//MARK:- AERTRIP API

#define LOGIN_AERTRIP_API @"users/login/"
#define REGISTER_AERTRIP_API @"users/register/"
#define FACEBOOK_LOGIN_API @"social/app-social-login/"
#define CREATE_PROFILE_API @"users/initial-details/"
#define RESET_PASSWORD_API @"users/reset-password/"
#define UPDATE_PASSWORD_API @"users/update-password/"
#define USERS_META_API @"users/meta/"
#define SAVE_TRAVELLER @"user-passenger/save"
#define USERS_ACTIVATE_API @"users/activate"
#define USERS_VERIFY_REGISTRATION_API @"users/verify-registration"
#define USERS_VERIFY_PASSWORD_RESET_TOCKEN_API @"users/validate-password-reset-token"
#define EMAIL_AVAILABILITY_API @"users/email-availability"
#define USERS_LOGOUT_API @"users/logout/"
#define DEFAULT_PROFILE_DD_KEYS_API @"default/dropdown-keys"
#define FLIGHTS_PREFERENCE_MASTER_API @"flights/preference-master"
#define AIRLINE_SEARCH_API @"airlines/search"
#define SAVE_GENERAL_PREFERENCES_API @"users/save-general-preferences"
#define DELETE_TRAVELLER @"user-passenger/delete-pax-data"
#define ASSIGN_GROUP_TO_TRAVELLER @"users/apply-label"
#define HOTEL_SUGGESTIONS_API @"hotels/suggestions"
#define HOTEL_FAVOURITE_API @"hotels/favourite"
#define HOTEL_MIN_MAX_API @"users/hsps"
#define USER_UPLOAD_IMAGE_API @"users/upload-user-image"
#define HOTEL_PLACES_API @"hotels/places"
#define IMPORT_TRAVELLER_API @"user-passenger/import-contacts"
#define HOTEL_SEARCH_API @"hotels/search"
#define RECENT_SEARCH_SET_API @"recent-search/set"
#define RECENT_SEARCH_GET_API @"recent-search/get"

#define HOTEL_RESULTS_API @"hotels/results"
#define HOTEL_DETAILS_API @"hotels/details"
#define BULK_BOOKING_INQUIRY_API @"enquiry/bulk-booking-enquiry"
#define HOTEL_CONFIRMATION_API @"hotels/confirmation"
#define HOTEL_ITENARY_API @"hotels/itinerary"
#define RECEIPT_API @"booking/receipt"
#define MAKE_PAYMENT_API @"booking/make-payment"
#define FLIGHT_ITENARY_API @"flights/itinerary"


#define AIRPORT_SEARCH_API @"airports/search"
#define NEARBY_AIRPORT_SEARCH_API @"airports/nearby"
#define FLIGHT_SEARCH_API @"flights/search"
#define FLIGHT_RESULTS_API @"flights/results"
#define FLIGHT_CONFIRMATION_API @"flights/confirmation"
#define FLIGHT_BULK_BOOKING_API @"flights/confirmation"

//Nib names

#define SIMPLE_LABEL_IMAGE_COLLECTION_VIEW_NIB_IDENTIFIER @"SimpleLabelCollectionCell"


#define AMENITIES_ARRAY @[@{@"iconName":@"WifiIcon", @"name": @"Wifi"}, @{@"iconName":@"RoomServiceIcon", @"name": @"Room Service"}, @{@"iconName":@"Interneticon", @"name": @"Internet"}, @{@"iconName":@"ACIcon", @"name": @"Air Conditioner"}, @{@"iconName":@"RestaurantBarIcon", @"name": @"Restaurant Bar"}, @{@"iconName":@"FitnessIcon", @"name": @"Gym"}, @{@"iconName":@"BusinessCenterIcon", @"name": @"Business Center"}, @{@"iconName":@"PoolIcon", @"name": @"Pool"}, @{@"iconName":@"SpaIcon", @"name": @"Spa"}, @{@"iconName":@"CoffeeShopIcon", @"name": @"Coffee Shop"}]

#define ALL_ROOM_TYPE_ARRAY @[@"Taj Club - Tranquility", @"Taj Club", @"Twin Room", @"Double Room", @"Club King Room Queen Bed With City View", @"Club King Room Queen Bed", @"Club Room Single Beds With City View"]

//MARK:-SOCIAL SIGN IN
#define GOOGLE_CLIENT_ID @"175392921069-agcdbrcffqcbhl1cbeatvjafd35335gm.apps.googleusercontent.com"


#define ERROR_CODES @{@"-1":@"Oops Something went wrong",@"1":@"Kindly provide a valid email ID",@"2":@"Kindly provide a valid email ID",@"3":@"Please provide a valid password",@"4":@"Multiple user accounts with this email id",@"5":@"No user account with this email id",@"6":@"The email ID and / or password you have entered is incorrect.",@"7":@"The email ID and / or password you have entered is incorrect.",@"8":@"The email ID and / or password you have entered is incorrect.",@"9":@"Link has been expired",@"10":@"Link already used to create a user",@"11":@"User not found",@"12":@"Invalid user data",@"13":@"Invalid user data",@"14":@"Invalid user data",@"15":@"Invalid user data",@"16":@"Invalid user data",@"17":@"Invalid user data",@"18":@"Please provide valid hash key",@"19":@"Invalid user data",@"20":@"Invalid user data",@"21":@"Invalid user data",@"22":@"Invalid user data",@"23":@"Invalid user data",@"24":@"Invalid user data",@"25":@"Invalid user data",@"26":@"Invalid user data",@"27":@"User already registerd with this email id",@"28":@"User already registerd with this email id",@"29":@"User already registerd with this email id",@"30":@"User already logged in",@"31":@"Capcha atempts limit over",@"32":@"guest login is not permitted for this user",@"33":@"something went wrong. please try again",@"34":@"For Mobile App only",@"35":@"Failed to register Email Change Request",@"9":@"Link has been expired",@"36":@"Token has been expired",@"37":@"User already created using this link",@"38":@"Failed to create user",@"39":@"Failed to create user",@"40":@"Password is weak. Please set a stronger password.",@"41":@"Please provide a valid new password",@"42":@"Unable to set new password",@"6":@"The email ID and / or password you have entered is incorrect.",@"8":@"The email ID and / or password you have entered is incorrect.",@"106":@"You have exceeded maximum attempts to Reset Password for the day. Please try again tomorrow.",@"18":@"Please provide valid hash key",@"43":@"Please provide valid token",@"3":@"Please provide a valid password",@"40":@"Password is weak. Please set a stronger password.",@"44":@"Please provide valid token",@"8":@"The email ID and / or password you have entered is incorrect.",@"45":@"Password has already been reset using this link",@"9":@"Link has been expired",@"46":@"Failed to reset password",@"27":@"User already registerd with this email id",@"88":@"The previous enquiry for this email id was REJECTED BY CSR",@"89":@"Failed to update status of Corp Enquiry",@"90":@"Something went wrong. Please try again after some time",@"91":@"Failed to send registration email",@"58":@"Refund mode is required",@"59":@"Failed to update refund mode"}

@interface Constants : NSObject

@end
