//
//  Strings.swift
//  
//
//  Created by Pramod Kumar on 04/08/17.
//  Copyright © 2017 Pramod Kumar. All rights reserved.
//

import Foundation

extension LocalizedString {
    var localized: String {
        return self.rawValue.localized
    }
}

enum LocalizedString: String {
    
    //MARK:- Strings For Profile Screen
    case NoInternet = "NoInternet"
    case ParsingError = "ParsingError"
    case error = "error"
    case na = "na"
    case noData = "noData"
    case search = "search"
    case noResults = "No Results"
    case Undo = "Undo"
    case apply = "Apply"
    case For = "For"
    case Already = "Already"
    
    // MARK:- TextField validation
    //MARK:-
    case Enter_email_address       = "Enter_email_address"
    case Enter_valid_email_address = "Enter_valid_email_address"
    case Enter_password            = "Enter_password"
    case Enter_valid_Password      = "Enter_valid_Password"
   
    
    // MARK:- SocialLoginVC
    //MARK:-
    case I_am_new_register  = "I_am_new_register"
    case SkipSignIn = "SkipSignIn"
    case ContinueAsGuest = "ContinueAsGuest"
    case Existing_User_Sign = "Existing_User_Sign"
    case Continue_with_Facebook  = "Continue_with_Facebook"
    case Continue_with_Google    = "Continue_with_Google"
    case Continue_with_Linkedin  = "Continue_with_Linkedin"
    case AllowEmailInFacebook = "AllowEmailInFacebook"
    case AllowEmailInLinkedIn = "AllowEmailInLinkedIn"
    case PleaseLoginByEmailId = "PleaseLoginByEmailId"
    
    
    // MARK:- LoginVC
    //MARK:-
    case Forgot_Password  = "Forgot_Password"
    case Welcome_Back     = "Welcome_Back"
    case Email_ID         = "Email_ID"
    case Password         = "Password"
    case Not_ye_registered  = "Not_ye_registered"
    case Login = "Login"
    case Register_here = "Register_here"
    
    // MARK:- CreateYourAccountVC
    //MARK:-
    case Create_your_account  = "Create_your_account"
    case Register             = "Register"
    case By_registering_you_agree_to_Aertrip_privacy_policy_terms_of_use = "By_registering_you_agree_to_Aertrip_privacy_policy_terms_of_use"
    case Already_Registered = "Already_Registered"
    case  Login_here    = "Login_here"
    case privacy_policy = "privacy_policy"
    case terms_of_use   = "terms_of_use"
    
    // MARK:- ThankYouRegistrationVC
    //MARK:-
    case Thank_you_for_registering  = "Thank_you_for_registering"
    case We_have_sent_you_an_account_activation_link_on = "We_have_sent_you_an_account_activation_link_on"
    case Check_your_email_to_activate_your_account = "Check_your_email_to_activate_your_account"
    case Open_Email_App = "Open_Email_App"
    case No_Reply_Email_Text = "No_Reply_Email_Text"
    case noreply_aertrip_com = "noreply_aertrip_com"
    case password_redset_link_message = "password_redset_link_message"
    case Cancel = "Cancel"
    case Add = "Add"
    case CancelWithSpace = "CancelWithSpace"
    case CancelWithRightSpace = "CancelWithRightSpace"
    case Mail_Default = "Mail_Default"
    case Gmail = "Gmail"

    // MARK:- ResetPasswordVC
    //MARK:-
    case CheckYourEmail  = "CheckYourEmail"
    case PasswordResetInstruction = "PasswordResetInstruction"
    case CheckEmailToResetPassword = "CheckEmailToResetPassword"
 
    // MARK:- SecureYourAccountVC
    //MARK:-
    case Secure_your_account  = "Secure_your_account"
    case Set_password = "Set_password"
    case Password_Conditions = "Password_Conditions"
    case one = "one"
    case a   = "a"
    case A   = "A"
    case at  = "at"
    case eight_Plus = "eight_Plus"
    case Number     = "Number"
    case Lowercase  = "Lowercase"
    case Uppercase  = "Uppercase"
    case Special    = "Special"
    case Characters = "Characters"
    case Next       = "Next"
    case Reset_Password  = "Reset_Password"
    case Please_enter_new_Password = "Please_enter_new_Password"
    case New_Password = "New_Password"

    // MARK:- CreateProfileVC
    //MARK:-
    case Create_Your_Profile  = "Create_Your_Profile"
    case and_you_are_done = "and_you_are_done"
    case Title = "Title"
    case First_Name = "First_Name"
    case Last_Name   = "Last_Name"
    case Country   = "Country"
    case Mobile_Number  = "Mobile_Number"
    case Lets_Get_Started = "Lets_Get_Started"
    case Done    = "Done"
    case DoneWithSpace = "DoneWithSpace"
    
    // MARK:- ForgotPasswordVC
    //MARK:-
    case ForgotYourPassword  = "ForgotYourPassword"
    case EmailIntruction = "EmailIntruction"
    case Continue = "Continue"
    
    // MARK:- SuccessPopupVC
    //MARK:-
    case Successful  = "Successful"
    case Your_password_has_been_reset_successfully = "Your_password_has_been_reset_successfully"
    
    //MARK:- DashboardVC
    //MARK:-
    case aerin = "aerin"
    case flights = "flights"
    case hotels = "hotels"
    case trips = "trips"
    case hiImAerin = "hiImAerin"
    case yourPersonalTravelAssistant = "yourPersonalTravelAssistant"
    case tryAskingForFlightsFromMumbai = "tryAskingForFlightsFromMumbai"
    case EnjoyAMorePersonalisedTravelExperience = "EnjoyAMorePersonalisedTravelExperience"
    case LoginOrRegister = "LoginOrRegister"
    case WhyAertrip      = "WhyAertrip"
    case SmartSort       = "SmartSort"
    case Offers          = "Offers"
    case ContactUs       = "ContactUs"
    case Settings        = "Settings"
    case weekendGetaway  = "weekendGetaway"
    case ViewProfile     = "ViewProfile"
    case Bookings        = "Bookings"
    case Notification    = "Notification"
    case ReferAndEarn    = "ReferAndEarn"
    case ViewAccounts    = "ViewAccounts"
    
    
    
    //MARK:- CreateProfileVCDelegate
    //MARK:-
    case Mr  = "Mr"
    case Mis = "Mis"
    case PleaseSelectSalutation = "PleaseSelectSalutation"
    case PleaseEnterFirstName   = "PleaseEnterFirstName"
    case PleaseEnterLastName    = "PleaseEnterLastName"
    case PleaseSelectCountry    = "PleaseSelectCountry"
    case PleaseEnterMobileNumber = "PleaseEnterMobileNumber"
    case selectedCountryCode    = "selectedCountryCode"
    case selectedCountry        = "selectedCountry"
    case SelectedCountrySymbol = "SelectedCountySymbol"

    //MARK:- ViewProfileVC
    //MARK:-
    case ALERT  = "ALERT"
    case DoYouWantToLogout = "DoYouWantToLogout"
    case Logout = "Logout"
    
    //MARK: - View Profile
    case Edit = "Edit"
    case Create = "Create"
    case Travellers = "Travellers"
    case TravellerList = "TravellerList"
    case HotelPreferences = "HotelPreferences"
    case QuickPay = "QuickPay"
    case LinkedAccounts = "LinkedAccounts"
    case NewsLetters = "Newsletters"
    case Notifications  = "Notifications"
    case LogOut = "Log Out"
    
    // MARK: - ViewProfileDetailVC
    
    case EmailAddress = "EmailAddress"
    case ContactNumber = "ContactNumber"
    case SocialAccounts = "SocialAccounts"
    case Address = "Address"
    case MoreInformation = "MoreInformation"
    case PassportDetails = "PassportDetails"
    case FlightPreferences = "FlightPreferences"
    case Birthday = "Birthday"
    case Anniversary = "Anniversary"
    case Notes = "Notes"
    case Mobile = "Mobile"
    case passportNo = "Passport No."
    case issueCountry = "Issue Country"
    case IssueDate = "IssueDate"
    case ExpiryDate = "ExpiryDate"
    case seatPreference = "Seat Preference"
    case mealPreference = "Meal Preference"
    
    // MARK: - Edit Profile VC
    
    case Save = "Save"
    case SaveWithSpace = "SaveWithSpace"
    case Move = "Move"
    case FirstName = "FirstName"
    case LastName = "LastName"
    case TakePhoto = "Take Photo"
    case ChoosePhoto = "Choose Photo"
    case ImportFromFacebook = "Import from Facebook"
    case ImportFromGoogle  = "Import from Google"
    case RemovePhoto = "Remove Photo"
    case AddEmail = "Add Email"
    case AddSocialAccountId = "Add Social Account ID"
    case AddContactNumber = "Add Contact Number"
    case WouldYouLikeToDelete = "Would you like to delete this?"
    case Delete = "Delete"
    case Deleted = "Deleted"
    case FrequentFlyer = "Frequent Flyer"
    case AddFrequentFlyer = "Add Frequent Flyer"
    case AddAddress = "Add Address"
    case PassportIssueDateIsIncorrect = "Passport issue date is incorrect"
    case PassportExpiryDateIsIncorrect = "Passport expiry date is incorrect"
    case DateOfBirthIsIncorrect = "Date of birth is incorrect"
    case DateOfAnniversaryIsIncorrect = "Date of Anniversary is incorrect"
    case Group = "Group"
    case SelectMealPreference = "SelectMealPreference"
    case SelectSeatPreference = "SelectSeatPreference"
    case Email = "Email"
    case SocialProfile = "SocialProfile"
    case Home = "Home"
    case IndiaIsdCode = "IndianIsdCode"
    case Facebook = "Facebook"
    case Phone = "Phone"
    case SelectAirline = "SelectAirline"
    case SelectDate = "SelectDate"
    case AddNotes = "AddNotes"
    case DeleteFromTraveller = "DeleteFromTraveller"
    case Default = "Default"
    case Share = "Share"
    case FloatingButtonsTitle = "FloatingButtonsTitle"
    // Mark: - Salutation
    case Mrs = "Mrs"
    case Ms = "Ms"
    case Miss = "Miss"
    case Mast = "Mast"
    case EnterValidMobileNumber = "EnterValidMobileNumber"
    case AllMobileNumberShouldUnique = "AllMobileNumberShouldUnique"
    case EnterAllValidMobileNumber = "EnterAllValidMobileNumber"
    case EnterAirlineNumberForAllFrequentFlyer = "EnterAirlineNumberForAllFrequentFlyer"
    case SelectAirlineForAllFrequentFlyer = "SelectAirlineForAllFrequentFlyer"
    
    
    //MARK:- Hotel Search
    //MARK:-
    case PreferredStarCategory = "PreferredStarCategory"
    case FavouriteHotels = "FavouriteHotels"
    case stars = "stars"
    case star = "star"
    case searchForHotelsToAdd = "searchForHotelsToAdd"
    case searchHotelName = "searchHotelName"
    
    // MARK: - Traveller List VC
   case Select = "Select"
   case Preferences = "Preferences"
   case Import = "Import"
   case AssignGroup = "AssignGroup"
   case TheseContactsWillBeDeletedFromTravellersList = "TheseContactsWillBeDeletedFromTravellersList"
    
    // MARK: - PreferencesVC
    case SortOrder = "SORT ORDER"
    case DisplayOrder = "DISPLAY ORDER"
    case Groups = "GROUPS"
    case FirstLast = "First, Last"
    case LastFirst = "Last, First"
    case AddNewGroup = "Add New Group"
    case EnterAGroupName = "Enter a Group Name"
    case EnterGroupName = "Enter Group Name"
    case PreferencesSavedSuccessfully
    case GroupAlreadyExist = "GroupAlreadyExist"
    case GroupNameCanNotEmpty = "GroupNameCanNotEmpty"
    
    
    
    //MARK:- Import Contacts
    //MARK:-
    case Contacts = "Contacts"
    case Google = "Google"
    case LinkedIn = "LinkedIn"
    case ImportContactMessage = "ImportContactMessage"
    case ImportFacebookMessage = "ImportFacebookMessage"
    case ImportGoogleMessage = "ImportGoogleMessage"
    case SelectAll = "SelectAll"
    case DeselectAll = "DeselectAll"
    case AllowContacts = "AllowContacts"
    case ConnectWithGoogle = "ConnectWithGoogle"
    case ConnectWithFB = "ConnectWithFB"
    case ConnectWithLinkedIn = "ConnectWithLinkedIn"
    case ContactsSelected = "ContactsSelected"
    case NoContactsFetched = "NoContactsFetched"
    case SelectContactsToImport = "SelectContactsToImport"
    
    //MARK:- Linked Accounts
    //MARK:-
    case Disconnect = "Disconnect"
    case LinkedAccountsMessage = "LinkedAccountsMessage"
    
    //MARK:- Favourite Hotels
    //MARK:-
    case Remove = "Remove"
    case DoYouWishToRemoveAllHotelsFrom  = "DoYouWishToRemoveAllHotelsFrom"
    
    //Mark:- Hotels Search
    //Mark:-
    case WhereButton = "WhereButton"
    case CheckIn = "CheckIn"
    case CheckOut = "CheckOut"
    case Nights = "Nights"
    case Night = "Night"
    case AddRoom = "AddRoom"
    case StarRating = "StarRating"
    case AllStars = "AllStars"
    case WantMoreRooms = "WantMoreRooms"
    case RequestBulkBooking = "RequestBulkBooking"
    case LoginAndSubmit = "Login & Submit"
    
    //MARK:- Room Guest Selection
    case Room = "Room"
    case Adults = "Adults"
    case Children = "Children"
    case Adult = "Adult"
    case Child = "Child"
    case and = "and"
    case Age = "Age"
    case Ages = "Ages"
    case AdultsAges = "AdultsAges"
    case ChildAges = "ChildAges"
    case MostHotelsTypicallyAllow = "MostHotelsTypicallyAllow"
    case ageInYrs = "ageInYrs"
    
    //MARK:- Destination Selection
    case CityAreaOrHotels = "CityAreaOrHotels"
    case HotelsNearMe = "HotelsNearMe"
    case RecentlySearchedDestinations = "RecentlySearchedDestinations"
    case PopularDestinations = "PopularDestinations"
    
    //MARK:- Bulk Booking
    case BulkBooking = "BulkBooking"
    case PreferredHotels = "PreferredHotels"
    case SpecialRequest = "SpecialRequest"
    case IfAny = "IfAny"
    case Rooms = "Rooms"
    case BulkEnquirySent = "BulkEnquirySent"
    case CustomerServicesShallConnect = "CustomerServicesShallConnect"
    case Submit = "Submit"
    
    //MARK:- FF Search
    case SearchAirlines = "SearchAirlines"
    
    //MARK:- Search Result
    case SearchHotelsOrLandmark = "SearchHotelsOrLandmark"
    //MARK: - Hotel Filters
    case ClearAll = "ClearAll"
    case Sort = "Sort"
    case Range = "Range"
    case Price = "Price"
    case Ratings = "Ratings"
    case Amenities = "Amenities"
    case Reviews = "Reviews"
    
    case Excellent  =  "Excellent"
    case VeryGood =   "VeryGood"
    case Average =  "Average"
    case Poor =  "Poor"
    case Terrible =   "Terrible"
    case TravellerRating = "TravellerRating"
    case RatingSummary = "RatingSummary"
    
    case BestSellers = "BestSellers"
    case TripAdvisor = "TripAdvisorRating"
    case Distance = "Distance"
    case Recommended = "Recommended"
    case LowToHigh = "LowToHigh"
    case FiveToOne = "FiveToOne"
    case NearestFirst = "NearestFirst"
    
    case WriteYourOwnReview = "WriteYourOwnReview"
    case ViewAll = "ViewAll"
    case ReadAll = "ReadAll"
    case Within = "Within"
    case Kms = "Kms"
    
    
    //MARK: - RangeVC
    case SearchResultsRange = "SearchResultsRange"
    
    
    //MARK: - PriceVC
    case PricePerNight = "PricePerNight"
    case Total = "Total"
    case PerNight = "PerNight"
    
    // MARK: - RatingVC
    
    
    // MARK: - AmentitiesVC
    case Wifi = "Wifi"
    case RoomService = "RoomService"
    case Internet = "Internet"
    case AirConditioner = "AirConditioner"
    case RestaurantBar = "RestaurantBar"
    case Gym = "Gym";
    case BusinessCenter = "Business Center"
    case Pool = "Pool"
    case Spa = "Spa"
    case Wi_Fi = "Wi-Fi"
    case Coffee_Shop = "Coffee Shop"
    
    // MARK: - RoomVC
    
    // Meal
    case NoMeal = "NoMeal"
    case Breakfast = "Breakfast"
    case HalfBoard = "HalfBoard"
    case FullBoard = "FullBoard"
    case Others = "Others"
    
    // Cancellation policy
    case Refundable = "Refundable"
    case PartRefundable = "PartRefundable"
    case NonRefundable = "NonRefundable"
    case NonRefundableExplanation = "NonRefundableExplanation"
    case FullPaymentExplanation = "FullPaymentExplanation"
    case FreeCancellation = "FreeCancellation"
    case FullPaymentNow = "FullPaymentNow"
    case NoRoomsAvailable = "NoRoomsAvailable"
    
    // Others
    case FreeWifi = "FreeWifi"
    case TransferInclusive = "TransferInclusive"
    
    //MARK:- HotelFilterResultsVC
    case From = "From"
    case SelectRoom = "SelectRoom"
    case Maps = "Maps"
    case AddressSmallLaters = "AddressSmallLaters"
    case Overview = "Overview"
    case More = "More"
    case CheckTripAdvisor = "CheckTripAdvisor"
    case hotelFilterSearchBar = "hotelFilterSearchBar"
    case InformationUnavailable = "Information unavailable"
    case ApplyPreviousFilter = "ApplyPreviousFilter"
    case ReloadResults = "Reload results"
    case ShowHotelsBeyond = "ShowHotelsBeyond"
    case HideHotelBeyond = "HideHotelsBeyond"
    case Choose_App = "Choose_App"
    case GMap = "GMap"

    //MARK: - Hotel Result VC
    case RemoveFromFavourites = "RemoveFromFavourites"
    case EmailFavouriteHotelInfo = "EmailFavoriteHotelsInfo"
    case Send = "Send"
    case To = "To"
    case Message = "Message"
    case SeeRates = "SeeRates"
    case SharedMessage = "SharedMessage"
    case CheckOutMessage = "CheckOutMessage"
    case HotelResultFor = "HotelResultFor"
    case NoHotelFound = "NoHotelFound"
    case NoHotelFoundMessage = "NoHotelFoundMessage"
    case NoHotelFoundMessageOnFilter = "NoHotelFoundMessageOnFilter"
    case NoHotelFoundFilter = "NoHotelFoundFilter"
    case Inclusion = "Inclusion"
    case OtherInclusions = "OtherInclusions"
    case CancellationPolicy = "CancellationPolicy"
    case PaymentPolicy = "PaymentPolicy"
    case Info = "Info"
    case Book = "Book"
    case rupeesText = "rupeesText"
    case Whoops = "Whoops"
    case HotelDetailsEmptyState = "HotelDetailsEmptyState"
    case ResetFilter = "ResetFilter"
    
    // Mail Composer View
    case ContactUsAertrip = "ContactUsAertrip"
    case CopyrightAertrip = "CopyrightAertrip"
    case CheckoutMyFavouriteHotels = "CheckoutMyFavouriteHotels"
    case SendWithSpace = "SendWithSpace"
    case PleaseEnterEmail = "PleaseEnterEmail"
    
    
    //Select Trip Screen
    case SelectTrip = "SelectTrip"
    case CreateNewTrip = "CreateNewTrip"
    case NameYourTrip = "NameYourTrip"
    
    //Hotel Checkout Deatail Selection screen
    case Guests = "Guests"
    
    //Hotel Checkout Guest Details screen
    case GuestDetails = "GuestDetails"
   
    case Details = "Details"
    case PreferencesSpecialRequests = "Preferences, Special Requests"
    case Optional = "Optional"
    case EmailMobileCommunicationMessageForBooking = "EmailMobileCommunicationMessageForBooking"
    case FareIncreasedBy = "FareIncreasedBy"
    case TotalUpdatedPrice = "TotalUpdatedPrice"
    case ContinueBooking = "ContinueBooking"
    case GoBackToResults = "GoBackToResults"
    case FareDippedBy = "FareDippedBy"
    case FareBreakup = "FareBreakup"
    case TotalPayableNow = "TotalPayableNow"
    case Confirm = "Confirm"

    //Hotel Checkout Coupons VC
    case Coupons = "Coupons"
    case EnterCouponCode = "EnterCouponCode"
    case OfferTerms = "OfferTerms"
    case Code = "Code"
    case NoCouponRequired = "NoCouponRequired"
    case YouAlreadyHaveBestPrice = "YouAlreadyHaveBestPrice"
    
    //Hotel Checkout Special Request VC
    case AirlineNameFlightNumberArrivalTime = "AirlineNameFlightNumberArrivalTime"
    case SpecialRequestIfAny = "SpecialRequestIfAny"
    
    //Final Checkout Screen
    case CheckoutTitle = "CheckoutTitle"
    case ApplyCoupon = "ApplyCoupon"
    case PayByAertripWallet = "PayByAertripWallet"
    case Balance = "Balance"
    case FareDetails = "FareDetails"
    case Pay = "Pay"
    case FareRules = "FareRules"
    case CheckOutPrivacyAndPolicyTerms = "CheckOutPrivacyAndPolicyTerms"
    case CheckOutFareRulesPrivacyAndPolicyTerms
    case PayableWalletMessage = "PayableWalletMessage"
    case NetEffectiveFare = "NetEffectiveFare"
    case GrossFare = "GrossFare"
    case Discounts  = "Discounts"
    case CouponDiscount = "CouponDiscount"
    case AertripWallet = "AertripWallet"
    case CurrencyOptions = "CurrencyOptions"
    case CheckOutCurrencyOptionInfoMessage = "CheckOutCurrencyOptionInfoMessage"
    case Rating = "Rating"
   
    
    //Select Guests
    case SelectGuests = "SelectGuests"
    
    case EmailItineraries = "EmailItineraries"
    case SendToAll = "SendToAll"
    
    //Booking Incomplete Screen
    case BookingIncomplete = "BookingIncomplete"
    case YourWalletMoneyOf = "YourWalletMoneyOf"
    case WasUsedForAnotherTransaction = "WasUsedForAnotherTransaction"
    case BookingAmount = "BookingAmount"
    case PaidAmount = "PaidAmount"
    case BalanceAmount = "BalanceAmount"
    case RequestRefund = "RequestRefund"
    case BookingIncompleteBottomMessage = "BookingIncompleteBottomMessage"
    
    //Refund Requested
    case Requested = "Requested"
    case WeNotedYourRequestToRefund = "WeNotedYourRequestToRefund"
    case ToYour = "ToYour"
    case ReturnHome = "ReturnHome"
    case ThisWillCancelThisBookingAndAmountRefundToPayment = "ThisWillCancelThisBookingAndAmountRefundToPayment"

    case Change = "Change"
    case YourBookingIDIs = "YourBookingIDIs"
    case YourCaseIDIs = "YourCaseIDIs"
    case AndAllDetailsWillBeSentToYourEmail = "AndAllDetailsWillBeSentToYourEmail"
    case YouAreAllDoneLabel = "YouAreAllDoneLabel"
    case AddToAppleWallet = "AddToAppleWallet"
    case BookingDetails = "BookingDetails"
    case Website = "Website"
    case Beds = "Beds"
    case EmailItinerary = "EmailItinerary"
    case TotalCharge = "TotalCharge"
    case ConfirmationVoucher = "ConfirmationVoucher"
    case View = "View"
    case TellYourFriendsAboutYourPlan = "TellYourFriendsAboutYourPlan"
    case WhatNext = "WhatNext"
    case InstantCashBackAppliedText = "InstantCashBackAppliedText"
    case WalletCashBackAppliedText = "WalletCashBackAppliedText"
    case CouponApplied = "Coupon Applied:"
    case convenienceFee1 = "convenienceFee1"
    case convenienceFee2 = "convenienceFee2"
    case ConfirmBooking = "ConfirmBooking"
    case ConvenienceFee = "ConvenienceFee"
    case InvalidCouponCodeText = "InvalidCouponCodeText"
    case PleaseEnterCouponCode = "PleaseEnterCouponCode"
    
    case EnterIsdMessage = "EnterIsdMessage"
    case GuestDetailsMessage = "GuestDetailsMessage"
    case EnterMobileNumberMessage = "EnterMobileNumberMessage"
    case EnterEmailAddressMessage = "EnterEmailAddressMessage"
    case UnableToGetMail = "UnableToGetMail"
    case ImportantNote = "ImportantNote"
    case YourBookingIdStmt = "YourBookingIdStmt"
    case AertripEmailId = "AertripEmailId"
    case ThankYouStmtForBookingId = "ThankYouStmtForBookingId"
    case ThankYouStmtForCId = "ThankYouStmtForCId"
    case WriteReviews = "WriteReviews"
    case Photos = "Photos"
    case ReadReviews = "ReadReviews"
    
    //AccountDetails Screen
    case Accounts = "Accounts"
    case AccountsLegder = "AccountsLegder"
    case AccountLegder
    case Amount = "Amount"
    case Pending
    case Voucher = "Voucher"
    
    //MARK:- BookingVC
    case MyBookings = "MyBookings"
    case NoBookingsYet = "NoBookingsYet"
    case StartYourWanderlustJourneyWithUs = "StartYourWanderlustJourneyWithUs"
    case TravelDate = "TravelDate"
    case EventType  = "Event Type"
    case BookingDate = "BookingDate"
    case FromDate = "FromDate"
    case ToDate = "ToDate"
    case Upcoming = "Upcoming"
    case Completed = "Completed"
    case Cancelled = "Cancelled"
    case YouHaveNoUpcomingBookings = "YouHaveNoUpcomingBookings"
    case NewDestinationsAreAwaiting = "NewDestinationsAreAwaiting"
    case BookingIDAndDate = "BookingIDAndDate"
    case Documents = "Documents"
    case PaymentInfo = "PaymentInfo"
    case Booking = "Booking"
    case Paid = "Paid"
    case FareInfo = "FareInfo"
    case ViewDetails
    case TravellersAddOns
    case BookingPolicy
    case cancellationPolicy
    case OpenInMaps
    case OpenInGoogleMaps
    case CancellationFee
    case SpecialCheckInInstructions
    case CheckInInstructions
    case BookingNote
    case AddOnRequest
    case InProcess
    case ActionRequired
    case AbortThisRequest
    case ConfirmAbort
    case NotesCapitalised
    case Vouchers
    case PayNow
    case EnterComments
    case AbortTitle
    case Call
    case Date
    case VoucherNo
    case DownloadInvoice
    case Directions
    case RequestAddOnsAndFF
    case AddOns
    case Request
    case SelectPassengerFlightRescheduled
    case Rescheduling
    case AddOnRequestSent
    case AddOnRequestMesage
    case PNRNo
    case SaleAmount
    case CancellationCharges
    case NetRefund
    
    // Booking Action sheet text
    case RequestAddOnAndFrequentFlyer
    case RequestRescheduling
    case RequestCancellation
    case Download
    case ResendConfirmationMail
    
    // Booking Review Cancellation VC
    
    case ReviewCancellation
    case RefundMode
    case ReasonForCancellation
    case TotalNetRefund
    case ReviewCancellationInfoLabel
    case EnterYourCommentOptional
    case Passengers
    case Passenger
    case Selected
    
    // Booking Cancellation VC
    case Cancellation
    
    
    //MARK: - AerinVC
    case Hi = "Hi"
    case HelpMessage = "HelpMessage"
    case ShowPendingActionsOnly = "ShowPendingActionsOnly"
    case DateSpan = "DateSpan"
    case VoucherType = "VoucherType"
    
    //MARK: - Import Contact Screen
    case NoContactFoundInDevice
    case NoContactFoundInFB
    case NoContactFoundInGoogle
    case NotAbleToSaveContactTryAgain
    case SelectMaxNContacts
    
    
    //MARK: - Aerin Text Speech VC
    case TryAskingFor
    case FilterText
    case Listening
    
    //MARK: - Aerin Text Speech Detail VC
    
    case Departure = "Departure"
    case Return = "Return"
    case Class = "Class"
    case TapToEdit = "TapToEdit"
    case ThingsYouCanAskMe
    case FilterApplied
    
    
    // Booking Details VC
    case ForwardArrow 
    case Dimensions
    case HandBaggageDimensions
    
    
   
    
    //MARK:- Account Ladger
    case DownloadAsPdf
    case NoTransactions
    case NoResultsFound
    case Oops
    case ClearFilters
    case BookingID
    case OpeningBalance
    
    //MARK:- OutStanding Ladger
    case Summary
    case OutstandingLedger
    case GrossOutstanding
    case OnAccount
    case NetOutstanding
    case DebitShort
    case CreditShort
    case SelectBookingsPay
    case MakePayment
    
    //MARK:- On Account Screen
    case ason
    case PeriodicStatement
    case NoStatementGenerated
    case PayOnline
    case PayOfflineNRegister
    case ChequeDemandDraft
    case FundTransfer
    case Breakup
    case DepositAmount
    case ConvenienceFeeNonRefundable
    case PaymentRegisteredSuccesfully
    case WeShallCreditYourAccount
    case Payment
    case DraftOrChequeDepositDate
    case EnterDraftOrChequeNumber
    case DepositBranchDetails
    case YourBank
    case SelectBank
    case EnterAccountName
    case EnterAccountNumber
    case AdditionalNote
    case AertripBankName
    case SeeBankDetails
    case UploadDepositConfirmationSlip
    case OffileDepositTerms
    case StepsForOfflinePayment
    case DepositDate
    case TransferType
    case EnterUTRSwiftCode
    
    case Camera
    case PhotoLibrary
    case Document
    case ChooseOptionToSelect
 }
