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
    // MARK: - Strings For Profile Screen
    
    case requestTimeOut
    case userNotLoggedIn
    case NoInternet
    case ParsingError
    case error
    case na
    case dash
    case noData
    case search
    case noResults = "No Results"
    case Undo
    case apply = "Apply"
    case For
    case Already
    case ALL

    // MARK: - TextField validation
    
    // MARK: -
    
    case Enter_email_address
    case Enter_valid_email_address
    case Enter_password
    case Enter_valid_Password
    
    // MARK: - SocialLoginVC
    
    // MARK: -
    
    case I_am_new_register
    case SkipSignIn
    case ContinueAsGuest
    case Existing_User_Sign
    case Continue_with_Facebook
    case Continue_with_Google
    case Continue_with_Linkedin
    case AllowEmailInFacebook
    case AllowEmailInLinkedIn
    case PleaseLoginByEmailId
    case Continue_with_Apple

    // MARK: - LoginVC
    
    // MARK: -
    
    case Forgot_Password
    case Welcome_Back
    case Email_ID
    case Password
    case Not_ye_registered
    case Login
    case Register_here
    
    // MARK: - CreateYourAccountVC
    
    // MARK: -
    
    case Create_your_account
    case Register
    case By_registering_you_agree_to_Aertrip_privacy_policy_terms_of_use
    case Already_Registered
    case Login_here
    case privacy_policy
    case terms_of_use
    
    // MARK: - ThankYouRegistrationVC
    
    // MARK: -
    
    case Thank_you_for_registering
    case We_have_sent_you_an_account_activation_link_on
    case Check_your_email_to_activate_your_account
    case Open_Email_App
    case No_Reply_Email_Text
    case noreply_aertrip_com
    case password_redset_link_message
    case Cancel
    case Add
    case CancelWithSpace
    case CancelWithRightSpace
    case Mail_Default
    case Gmail
    
    // MARK: - ResetPasswordVC
    
    // MARK: -
    
    case CheckYourEmail
    case PasswordResetInstruction
    case CheckEmailToResetPassword
    
    // MARK: - SecureYourAccountVC
    
    // MARK: -
    
    case Secure_your_account
    case Set_password
    case Password_Conditions
    case one
    case a
    case A
    case at
    case eight_Plus
    case Number
    case Lowercase
    case Uppercase
    case Special
    case Characters
    case Next
    case Reset_Password
    case Please_enter_new_Password
    case New_Password
    case Program
    case Current_Password
    case Please_enter_Current_Password
    case Please_enter_Valid_Password
    case Password_must_qualify_conditions
    
    // MARK: - CreateProfileVC
    
    // MARK: -
    
    case Create_Your_Profile
    case and_you_are_done
    case Title
    case First_Name
    case Last_Name
    case Country
    case Mobile_Number
    case Lets_Get_Started
    case Done
    case DoneWithSpace
    
    // MARK: - ForgotPasswordVC
    
    // MARK: -
    
    case ForgotYourPassword
    case EmailIntruction
    case Continue
    
    // MARK: - SuccessPopupVC
    
    // MARK: -
    
    case Successful
    case Your_password_has_been_reset_successfully
    
    // MARK: - DashboardVC
    
    // MARK: -
    
    case aerin
    case flights
    case hotels
    case trips
    case hiImAerin
    case yourPersonalTravelAssistant
    case tryAskingForFlightsFromMumbai
    case EnjoyAMorePersonalisedTravelExperience
    case LoginOrRegister
    case WhyAertrip
    case SmartSort
    case Offers
    case ContactUs
    case Settings
    case weekendGetaway
    case ViewProfile
    case Bookings
    case Notification
    case ReferAndEarn
    case ViewAccounts
    case Support
    case RateUs

    // MARK: - CreateProfileVCDelegate
    
    // MARK: -
    
    case Mr
    case Mis
    case PleaseSelectSalutation
    case PleaseEnterFirstName
    case PleaseEnterLastName
    case PleaseSelectCountry
    case PleaseEnterMobileNumber
    case selectedCountryCode
    case selectedCountry
    case SelectedCountrySymbol = "SelectedCountySymbol"
    case PleaseEnterValidMobileNumber

    // MARK: - ViewProfileVC
    
    // MARK: -
    
    case ALERT
    case DoYouWantToLogout
    case Logout
    
    // MARK: - View Profile
    
    case Edit
    case Create
    case Travellers
    case TravellerList
    case HotelPreferences
    case QuickPay
    case LinkedAccounts
    case NewsLetters = "Newsletters"
    case Notifications
    case LogOut = "Log Out"
    case Gender
    case Male
    case Female
    //case GSTIN
    case ChangePassword
    case changeMobileNumber
    case setMobileNumner
    case disableWalletOtp

    
    
    // MARK: - ViewProfileDetailVC
    
    case EmailAddress
    case ContactNumber
    case SocialAccounts
    case Address
    case MoreInformation
    case PassportDetails
    case FlightPreferences
    case Birthday
    case Anniversary
    case Notes
    case Disclaimer
    case Mobile
    case passportNo = "Passport No."
    case issueCountry = "Issue Country"
    case IssueDate
    case ExpiryDate
    case seatPreference = "Seat Preference"
    case mealPreference = "Meal Preference"
    
    // MARK: - Edit Profile VC
    
    case Save
    case SaveWithSpace
    case Move
    case FirstName
    case LastName
    case TakePhoto = "Take Photo"
    case ChoosePhoto = "Choose Photo"
    case ImportFromFacebook = "Import from Facebook"
    case ImportFromGoogle = "Import from Google"
    case RemovePhoto = "Remove Photo"
    case AddEmail = "Add Email"
    case AddSocialAccountId = "Add Social Account ID"
    case AddContactNumber = "Add Contact Number"
    case WouldYouLikeToDelete = "Would you like to delete this?"
    case Delete
    case Deleted
    case FrequentFlyer = "Frequent Flyer"
    case AddFrequentFlyer = "Add Frequent Flyer"
    case AddAddress = "Add Address"
    case PassportIssueDateIsIncorrect = "Passport issue date is incorrect"
    case PassportExpiryDateIsIncorrect = "Passport expiry date is incorrect"
    case DateOfBirthIsIncorrect = "Date of birth is incorrect"
    case DateOfAnniversaryIsIncorrect = "Date of Anniversary is incorrect"
    case Group
    case SelectMealPreference
    case SelectSeatPreference
    case Email
    case SocialProfile
    case Home
    case IndiaIsdCode = "IndianIsdCode"
    case Facebook
    case Phone
    case SelectAirline
    case SelectDate
    case AddNotes
    case DeleteFromTraveller
    case Default
    case Share
    case FloatingButtonsTitle
    case UnfavouritesAllTitle
    // Mark: - Salutation
    case Mrs
    case Ms
    case Miss
    case Mast
    case EnterValidMobileNumber
    case AllMobileNumberShouldUnique
    case EnterAllValidMobileNumber
    case EnterAirlineNumberForAllFrequentFlyer
    case SelectAirlineForAllFrequentFlyer
    
    // MARK: - Hotel Search
    // MARK: -
    
    case PreferredStarCategory
    case FavouriteHotels
    case stars
    case star
    case searchForHotelsToAdd
    case searchHotelName
    case NearMe

    
    // MARK: - Traveller List VC
    
    case Select
    case Preferences
    case Import
    case AssignGroup
    case TheseContactsWillBeDeletedFromTravellersList
    
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
    case GroupAlreadyExist
    case GroupNameCanNotEmpty
    case CantCreateGroupWithThisName
    case Me = "Me"

    // MARK: - Import Contacts
    case ImportingContacts
    case ThisMightTakeSomeTime

    // MARK: -
    
    case Contacts
    case Google
    case LinkedIn
    case Apple
    case ImportContactMessage
    case ImportFacebookMessage
    case ImportGoogleMessage
    case SelectAll
    case DeselectAll
    case AllowContacts
    case ConnectWithGoogle
    case ConnectWithFB
    case ConnectWithLinkedIn
    case ContactsSelected
    case ContactSelected
    case NoContactsFetched
    case SelectContactsToImport
    
    // MARK: - Linked Accounts
    
    // MARK: -
    
    case Disconnect
    case LinkedAccountsMessage
    case DoYouWantToDisconnect
    
    // MARK: - Favourite Hotels
    
    // MARK: -
    
    case Remove
    case DoYouWishToRemoveAllHotelsFrom
    
    // Mark:- Hotels Search
    // Mark:-
    case WhereButton
    case CheckIn
    case CheckOut
    case Nights
    case Night
    case AddRoom
    case StarRating
    case AllStars
    case WantMoreRooms
    case RequestBulkBooking
    case LoginAndSubmit = "Login & Submit"
    
    // MARK: - Room Guest Selection
    
    case Room
    case Adults
    case Children
    case Adult
    case Child
    case and
    case Age
    case Ages
    case AdultsAges
    case ChildAges
    case MostHotelsTypicallyAllow
    case ageInYrs
    case MaxGuestSelectionMessage

    // MARK: - Destination Selection
    
    case CityAreaOrHotels
    case HotelsNearMe
    case RecentlySearchedDestinations
    case PopularDestinations
    
    // MARK: - Bulk Booking
    
    case BulkBooking
    case PreferredHotels
    case MyDatesAre
    case SpecialRequest
    case IfAny
    case Rooms
    case BulkEnquirySent
    case CustomerServicesShallConnect
    case Submit
    
    // MARK: - FF Search
    
    case SearchAirlines
    
    // MARK: - Search Result
    
    case SearchHotelsOrLandmark
    
    // MARK: - Hotel Filters
    
    case ClearAll
    case Sort
    case Range
    case Price
    case Ratings
    case Amenities
    case Reviews
    
    case Excellent
    case VeryGood
    case Average
    case Poor
    case Terrible
    case TravellerRating
    case RatingSummary
    
    case BestSellers
    case TripAdvisor = "TripAdvisorRating"
    case Distance
    case Recommended
    case LowToHigh
    case FiveToOne
    case NearestFirst
    case HighToLow
    case OneToFive
    case FurthestFirst
    case Meal

    case WriteYourOwnReview
    case ViewAll
    case ReadAll
    case Within
    case Kms
    
    // MARK: - RangeVC
    
    case SearchResultsRange
    
    // MARK: - PriceVC
    
    case PricePerNight
    case Total
    case PerNight
    
    // MARK: - RatingVC
    
    // MARK: - AmentitiesVC
    
    case Wifi
    case RoomService
    case Internet
    case AirConditioner
    case RestaurantBar
    case Gym
    case BusinessCenter = "Business Center"
    case Pool
    case Spa
    case Wi_Fi = "Wi-Fi"
    case Coffee_Shop = "Coffee Shop"
    
    // MARK: - RoomVC
    
    // Meal
    case RoomOnly
    case NoMeal
    case Breakfast
    case HalfBoard
    case FullBoard
    case Others
    
    // Cancellation policy
    case Refundable
    case Reschedulable
    case NonReschedulable
    case PartRefundable
    case NonRefundable
    case NonRefundableExplanation
    case FullPaymentExplanation
    case FreeCancellation
    case FullPaymentNow
    case NoRoomsAvailable
    // Others
    case FreeWifi
    case TransferInclusive
    
    // MARK: - HotelFilterResultsVC
    
    case From
    case SelectRoom
    case Maps
    case AddressSmallLaters
    case Overview
    case More
    case CheckTripAdvisor
    case hotelFilterSearchBar
    case InformationUnavailable = "Information unavailable"
    case ApplyPreviousFilter
    case ReloadResults = "Reload results"
    case ShowHotelsBeyond
    case HideHotelBeyond = "HideHotelsBeyond"
    case Choose_App
    case GMap
    case TripRating
    case ResultUnavailable = "Result unavailable"

    // MARK: - Hotel Result VC
    
    case RemoveFromFavourites
    case EmailFavouriteHotelInfo = "EmailFavoriteHotelsInfo"
    case Send
    case To
    case Message
    case SeeRates
    case SharedMessage
    case CheckOutMessage
    case HotelResultFor
    case NoHotelFound
    case NoHotelFoundMessage
    case NoHotelFoundMessageOnFilter
    case NoHotelFoundFilter
    case NoHotelMatchedYourFilters
    case Inclusion
    case OtherInclusions
    case CancellationPolicy
    case PaymentPolicy
    case Info
    case Book
    case rupeesText
    case Whoops
    case HotelDetailsEmptyState
    case ResetFilter
    case ConfirmationEmail
    case UnfavouriteAll
    case UnfavouriteAllMessage
    case Unfavourite
    case ShowingResultsFor
    case Clear
    case viewMorePhoto

    // Mail Composer View
    case ContactUsAertrip
    case CopyrightAertrip
    case CheckoutMyFavouriteHotels
    case SendWithSpace
    case PleaseEnterEmail
    case EnterEmail
    case FavoriteHotelsInfoSentMessage

    
    // Select Trip Screen
    case SelectTrip
    case CreateNewTrip
    case NameYourTrip
    case PleaseSelectTrip
    
    // Hotel Detail screen
    case HotelHasAlreadyBeenSavedToTrip
    case flightHasAlreadyBeenSavedToTrip
    
    // Hotel Checkout Deatail Selection screen
    case Guests
    
    // Hotel Checkout Guest Details screen
    case GuestDetails
    
    case Details
    case PreferencesSpecialRequests = "Preferences, Special Requests"
    case Optional
    case EmailMobileCommunicationMessageForBooking
    case FareIncreasedBy
    case TotalUpdatedPrice
    case ContinueBooking
    case GoBackToResults
    case FareDippedBy
    case FareBreakup
    case TotalPayableNow
    case Confirm
    case PanCard
    case EnterPanCardMessage
    case FirstLastNameCharacterLimitMessage
    case TravelSafetyGuidelines

    
    // Hotel Checkout Coupons VC
    case Coupons
    case EnterCouponCode
    case OfferTerms
    case Code
    case NoCouponRequired
    case YouAlreadyHaveBestPrice
    
    // Hotel Checkout Special Request VC
    case AirlineNameFlightNumberArrivalTime
    case SpecialRequestIfAny
    
    // Final Checkout Screen
    case CheckoutTitle
    case ApplyCoupon
    case PayByAertripWallet
    case Balance
    case FareDetails
    case Pay
    case FareRules
    case CheckOutPrivacyAndPolicyTerms
    case CheckOutFareRulesPrivacyAndPolicyTerms
    case CheckOutPrivacyAndPolicyTermsFlight
    case PayableWalletMessage
    case NetEffectiveFare
    case GrossFare
    case Discounts
    case CouponDiscount
    case AertripWallet
    case CurrencyOptions
    case CheckOutCurrencyOptionInfoMessage
    case Rating
    case PerAdult
    case PerChild
    case PerInfant
    case WeHaveNotedYourBookingRequirement
    case WeHaveNotedYourBookingRequirementMessage
    case paymentFails
    
    // Select Guests
    case SelectGuests
    
    case EmailItineraries
    case SendToAll
    
    // Booking Incomplete Screen
    case BookingIncomplete
    case YourWalletMoneyOf
    case WasUsedForAnotherTransaction
    case BookingAmount
    case PaidAmount
    case BalanceAmount
    case RequestRefund
    case BookingIncompleteBottomMessage
    
    // Refund Requested
    case Requested
    case WeNotedYourRequestToRefund
    case ToYour
    case ReturnHome
    case ThisWillCancelThisBookingAndAmountRefundToPayment
    
    case Change
    case YourBookingIDIs
    case YourCaseIDIs
    case YourBookingID 
    case AndAllDetailsWillBeSentToYourEmail
    case YouAreAllDoneLabel
    case AddToAppleWallet
    case BookingDetails
    case Website
    case Beds
    case EmailItinerary
    case TotalCharge
    case ConfirmationVoucher
    case View
    case TellYourFriendsAboutYourPlan
    case WhatNext
    case InstantCashBackAppliedText
    case WalletCashBackAppliedText
    case CouponApplied = "Coupon Applied: "
    case convenienceFee1
    case convenienceFee2
    case ConfirmBooking
    case ConvenienceFee
    case InvalidCouponCodeText
    case PleaseEnterCouponCode
    case BookingConfirmed
    case BookingIsInProcess
    case ConvenienceFeeNonRefundables
    case non_Refundable
    
    case EnterIsdMessage
    case GuestDetailsMessage
    case EnterMobileNumberMessage
    case EnterEmailAddressMessage
    case UnableToGetMail
    case ImportantNote
    case YourBookingIdStmt
    case AertripEmailId
    case ThankYouStmtForBookingId
    case ThankYouStmtForCId
    case WriteReviews
    case Photos
    case ReadReviews
    
    // AccountDetails Screen
    case Accounts
    case AccountsLegder
    case AccountLegder
    case Amount
    case Pending
    case Voucher
    case CancellationFor
    case ReschedulingFor

    
    // MARK: - BookingVC
    
    case MyBookings
    case NoBookingsYet
    case StartYourWanderlustJourneyWithUs
    case TravelDate
    case EventType = "Event Type"
    case BookingDate
    case FromDate
    case ToDate
    case Upcoming
    case Completed
    case Cancelled
    case YouHaveNoUpcomingBookings
    case YouHaveNoCompletedBookings
    case YouHaveNoCancelledBookings
    case YouHaveNoPendingAction
    case NewDestinationsAreAwaiting
    case BookingIDAndDate
    case Documents
    case PaymentInfo
    case Booking
    case Receipt
    case Paid
    case FareInfo
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
    case DownloadReceipt
    case DownloadVoucher
    case Directions
    case RequestAddOnsAndFF
    case AddOns
    case Request
    case SelectPassengerFlightRescheduled
    case SelectPassengerFlightCancellation
    case PassengersSelected
    case Rescheduling
    case AddOnRequestSent
    case AddOnRequestMesage
    case requestInProcess
    case PNRNo
    case SaleAmount
    case ConfirmationNo
    case CancellationCharges
    case ReschedulingCharges
    case NetRefund
    case CancellationRequestSent
    case CancellationRequestMessage
    case BookingConfirmationInfo
    case ETicket
    case TripName
    case AddToCalender
    case AddToTrips
    case BookSameFlight
    case Traveller
    case FlightInfo
    case Baggage
    case NoBaggage
    case NoInfo
    case BaggageDetailsMessage
    case CharactersRemaining
    case BookAnotherRoom
    case AddOnRequestPayment
    case AddOnRequestPaymentMessage
    case BookingPayment
    case BookingPaymentMessage
    
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
    
    // MARK: - AerinVC
    
    case Hi
    case HelpMessage
    case ShowPendingActionsOnly
    case DateSpan
    case VoucherType
    case hereAreYourResults = "hereAreYourResults"
    case seeResultsAgain = "seeResultsAgain"
    
    // MARK: - Import Contact Screen
    
    case NoContactFoundInDevice
    case NoContactFoundInFB
    case NoContactFoundInGoogle
    case NotAbleToSaveContactTryAgain
    case SelectMaxNContacts
    
    // MARK: - Aerin Text Speech VC
    
    case TryAskingFor
    case FilterText
    case Listening
    
    // MARK: - Aerin Text Speech Detail VC
    
    case Departure
    case Return
    case Class
    case TapToEdit
    case ThingsYouCanAskMe
    case FilterApplied
    
    // Booking Details VC
    case ForwardArrow
    case Dimensions
    case HandBaggageDimensions
    
    // MARK: - Account Ladger
    
    case DownloadAsPdf
    case NoTransactions
    case NoResultsFound
    case Oops
    case ClearFilters
    case BookingID
    case OpeningBalance
    case NoBookingsMatchYourFilters
    case NoBookingAvailableMessage
    case NoTransactionsMatchYourFilters
    case TryDifferentFiltersOrClearAll

    
    // MARK: - OutStanding Ladger
    
    case Summary
    case OutstandingLedger
    case SelectBooking
    case GrossOutstanding
    case OnAccount
    case NetOutstanding
    case DebitShort
    case CreditShort
    case SelectBookingsPay
    case MakePayment
    
    // MARK: - On Account Screen
    
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
    case DepositAmountErrorMessage
    case ModeOfPayment

    case Camera
    case PhotoLibrary
    case Document
    case ChooseOptionToSelect
    case requestNoted
    case maximumOnlineLimit
    
    // MARK: - OTHER BOOKING PRODUCT DETAIL
    
    case BillingName
    case GSTIN
    case BillingAddress
    
    case Economy
    case Carriers
    
    case Refund
    case PaymentPending
    case WebCheckin
    case Weather
    case SeeAll
    case Downloading
    case Requests
    case capNotes = "NOTES"
    case newDate
    case selectNewDepartingDate
    case newDepartingDate
    case customerExecutiveWillContact
    case preferredFlightNo
    case ReschedulingRequestHasBeenSent
    case OurCustomerServiceRepresenstativeWillContact
    case ProcessCancellation
    case CancellationHasBeenProcessed
    case ResendConfirmationEmail
    case SelectHotelOrRoomsForCancellation
    case SpecialRequestHasBeenSent
    case WriteAboutYourSpecialRequest
    case RequestType
    case WeatherFooterInfo
    
    case DownloadBlankDepositSlip
    case ChequeShouldDepositedInAccount
    case ACNumber
    case ACName
    case BankBranch
    case IFSCCode
    case AccountType
    
    // MARK: - Amount Double
    
    case AmountToBeRefunded
    
    // MARK: - Booking CallVC
    
    case Aertip
    case Airlines
    case Airports
    case Hotel
    
    // MARK: - Booking Add on Request
    
    case SeatBookingPlaceholder
    case ExtraBaggagePlacheholder
    case OtherBookingPlaceholder
    case MealBookingPlaceholder
    
    case SeatPreferenceTitle
    case MealPreferenceTitle
    case ExtraBaggageTitle
    case OtherBookingTitle
    case MealBookingTitle
    case SeatBookingTitle
    case SpaceWithHiphen
    case FlightTripChangeMessage
    case HotelTripChangeMessage
    case EventAddedToCalander
    case UnableToAddEventToCalander
    case EventAlreadyAddedInCalendar
    case SomethingWentWrong
    case Infant
    case FlightDomesticCancellationRequest
    case CancellationRequest
    case callingNotAvailable
    // MARK: -
    case UnderDevelopment
    case OperatedBy
    
    // MARK: - Static screen
    case ComingSoon
    case QuickPayInfo
    case NoNotificationYet
    case NotificationInfo
    
    //MARK: - Passengers Selections
    case firstName3Char
    case fistNameNumeric
    case lastName3Char
    case lastNameNumeric
    case fillContactDetails
    case adultAgeError
    case childAgeError
    case infantAgeError
    case fillAllPassengerDetails
    case enterISD
    case enterGSTName
    case enterGSTBillName
    case notValidGST
    
    
    // MARK: - Disconnect linkedin issue
    case DisconnectAccountMessage
    case DeleteTraveller
    case Yes
    case No
    case SendingEmail
    case LedgerSentToYourEmail
    case OutstandingSentToYourEmail
    
    // MARK: - Common
    case Other
    
    case PleaseSignInToContinue
    case Fixed
    case Flexible
    case ContactDetails
    case KindlyDisconnectMessage
    
    //MARK:- Settings
    case Currency
    case EnableDisableAllNotifications = "EnableDisableAllNotifications"
    case GetNotifiedAboutYourBookings = "GetNotifiedAboutYourBookings"
    case GetNotifiedAboutYourTripEvents = "GetNotifiedAboutYourTripEvents"
    case GetNotifiedAboutNewOffersAndDeals = "GetNotifiedAboutNewOffersAndDeals"
    case Ok = "Ok"
    case AllEventSyncedToCalendarApp = "AllEventSyncedToCalendarApp"
    case ThisFunctionalityWillBeAvailableSoon = "ThisFunctionalityWillBeAvailableSoon"
    case TryDelhiToGoaTomorrow = "TryDelhiToGoaTomorrow"
    case Copyright2018AllRightsReserved = "Copyright2018AllRightsReserved"
 
    case ThingsYouCanAsk = "ThingsYouCanAsk"
    
    case FlightFromMumbaiToDelhi = "FlightFromMumbaiToDelhi"
    case FindMeFlightFromBombayToKolkataTomorrowUnder = "FindMeFlightFromBombayToKolkataTomorrowUnder"
    case BangloreToGoaFlightOnTheWeekendAndReturnFollowingMonday = "BangloreToGoaFlightOnTheWeekendAndReturnFollowingMonday"
    case FlightOnDiwaliFromNewYorkToJaipur = "FlightOnDiwaliFromNewYorkToJaipur"
   case BOMDELOn26Feb = "BOMDELOn26Feb"
    case FlightToDubaiOn30thJun = "FlightToDubaiOn30thJun"
    case CommingSoon = "CommingSoon"
    case Flight = "Flight"
  
    
    //Payment and checkout
    
    case Meals = "Meals"
    case Seat = "Seat"
//    case Baggage = "Baggage"
//    case Others = "Others"
    case Skip = "Skip"
    
    // Seat Map
    case seatMap = "seatMap"
    case mainDeck = "mainDeck"
    case upperDeck = "upperDeck"
    case seatTotal = "seatTotal"
    case noSeatMapDataDesc = "noSeatMapDataDesc"
    case seatAvailablePostBooking = "seatAvailablePostBooking"
    
    case noMealsDataDesc = "noMealsDataDesc"
    
    case noBaggageDataDesc = "noBaggageDataDesc"
    
    case noOtherseDataDesc = "noOtherseDataDesc"
    
    case DomesticCheckIn = "DomesticCheckIn"
    case InternationalCheckIn = "InternationalCheckIn"
    
    case MealTotal = "MealTotal"

    case Select_Passengers_To_Assign_This_Meal = "Select_Passengers_To_Assign_This_Meal"
    
    case Select_Passengers_To_Assign_This_Baggage = "Select_Passengers_To_Assign_This_Baggage"

    case Select_Passengers = "Select_Passengers"
    
    case Choose_Meal = "Choose_Meal"
    
    case Choose_Baggage = "Choose_Baggage"
    
    case Reserve_Seat = "Reserve_Seat"

    case PreBook_Services = "PreBook_Services"
 
    case Complementary_Meal_Added = "Complementary_Meal_Added"
    
    case Complementary_Meal_Available = "Complementary_Meal_Available"
    
    case Free_Seats_Available = "Free_Seats_Available"

    case Passenger_Cannot_Be_Deselected_For_Meal = "Passenger_Cannot_Be_Deselected_For_Meal"
    
   case Will_Be_Available_Soon = "Will_Be_Available_Soon"
    
    case Important = "Important"
    
    case Baggage_Terms_Desc = "Baggage_Terms_Desc"
    
    case Baggage_Terms_Point1 = "Baggage_Terms_Point1"
    
    case Baggage_Terms_Point2 = "Baggage_Terms_Point2"
    
    case Baggage_Terms_Point3 = "Baggage_Terms_Point3"
    
    case Baggage_Terms_Point4 = "Baggage_Terms_Point4"

    case emergencySeatDesc = "emergencySeatDesc"
    
    case emergencySeatTerms1 = "emergencySeatTerms1"
    case emergencySeatTerms2 = "emergencySeatTerms2"
    case emergencySeatTerms3 = "emergencySeatTerms3"
    case emergencySeatTerms4 = "emergencySeatTerms4"
    case emergencySeatTerms5 = "emergencySeatTerms5"
    case emergencySeatTerms6 = "emergencySeatTerms6"
    case emergencySeatTerms7 = "emergencySeatTerms7"
    case emergencySeatTerms8 = "emergencySeatTerms8"
    case emergencySeatTerms9 = "emergencySeatTerms9"
    case Book_Now_And_Get_Off = "Book_Now_And_Get_Off"
    case Special_Request = "Special_Request"
    case Special_Request_If_Any = "Special_Request_If_Any"
    
    // FLight Filters
    case Stops = "Stops"
    case Times = "Times"
    case Duration = "Duration"
    case Quality = "Quality"
    
    // TripsVC
    case tripsComingSoon = "tripsComingSoon"
    case tripsNote = "tripsNote"
    case tripsLink = "tripsLink"

    case reloadDetail = "reloadDetail"
    
    //International return and multicity
    case selectedFlightsGap
    
    //Location Manager
    case placeNotFound

    
    //View Controller Extension
    case chooseFromOption
    case cameraNotAvailable
    case restrictedCameraUse
    case changeSettingForCameraUse
    case changeSettingForLibraryUse
    case restrictedLibraryUse
    case changeSettingForContactsUse
    case restrictedContactsUse
    case noDataFound
    
    //AppFlowManager
    case accessDenied
    case microphoneAccessRequired
    case allowMicAccess
    
    //AppEnum
    case notLoggedIn
    case emailRequired
    case invalidEmail
    case passwordRequired
    case multipleAccountWithEmail
    case incorrectEmailPassword
    case linkExpired
    case linkUsedToCreateUser
    case userNotFound
    case invalidUserData
    case provideValidHashKey
    case userAlreadyRegistered
    case userAlreadyLoggedIn
    case capchaLimitOver
    case guestLoginNotPermitted
    case somethingWentWrongTryAgain
    case mobileAppOnly
    case failedToRegisterEmailChangeRequest
    case tokenExpired
    case userAlreadyCreatedLink
    case failedToCreateUser
    case weakPassword
    case provideNewPassword
    case unableToSetNewPassword
    case provideValidToken
    case passwordAlreadyReset
    case failedToResetPassword
    case modeRequired
    case enquiryRejectedByCSR
    case failedtoUpdateStatusOfCorpEnquiry
    case somethingWentWrongTryAfterSomeTime
    case failedToSendEmail
    case exceededMaximumAttemptsToResetPassword
    case incorrectEmailId
    
    //App Globals
    case googleMapNotInstalled
    case restrictedCalendarUse
    
    //OTP varification
    case oneTimePassword
    case toProceedWalletBalance
    case waitAminToOtp
    case didntGetOtp
    case enterOtp
    case veryItsYou
    case tochangeMobileNumber
    case proceed
    case kindlyEnterOtp
    
    case Update_Aertrip = "Update_Aertrip"
    case Soft_Update_Msg = "Soft_Update_Msg"
    case Force_Update_Msg = "Force_Update_Msg"
    case Update_Now = "Update_Now"
    case Update_Later = "Update_Later"
    
    
    case toChangeMobileNumber
}
