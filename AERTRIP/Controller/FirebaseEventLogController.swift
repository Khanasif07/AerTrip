//
//  FirebaseEventLogController.swift
//  AERTRIP
//
//  CreatedBy Admin on 12/03/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import Foundation


class FirebaseEventLogs: NSObject{
    
    @objc static let shared = FirebaseEventLogs()
    override init(){}
    
    enum EventsTypeName:String {
        
        //MARK:- Settings Events TypeNames
        case changeCountry = "TryToChangeCountry"
        case changeCurrency = "TryToChangeCurrency"
        case changeNotification = "TryToChangeNotification"
        case toggleCalendar = "TryToToggleOnCalendarSync"
        case openChangeId = "OpenChangeAertripID"
        case openSetMobile = "OpenChangeMobileNumber"
        case openChangeMobile = "OpenSetMobileNumber"
        case openSetPassword = "OpenSetPassword"
        case openChangePassword = "OpenChangePassword"
        case openEnableWallet = "OpenEnableOTPForWalletPayments"
        case openDisableWallet = "OpenDisableOTPForWalletPayments"
        case OpenAboutUs
        case OpenLegal = "OpenLegal"
        case openPrivacy = "OpenPrivacyPolicy"
        
        //MARK:- Account update Events TypeNames
        case aadhar = "Aadhar"
        case pan = "PAN"
        case defaultRefundMode = "ChangeDefaultRefundMode"
        case billingAddress = "BillingAddress"
        case gstIn = "GSTIN"
        case billingName = "BillingName"
        
        //MARK:- Set and Change Mobile Events TypeNames
        case emptyMobile = "PressCTAWithoutEnteringMobileNumber"
        case incorrectMobile = "PressCTAEnteringWrongMobileNumber"
        case invlidCurrentPassword = "EnterIncorrectCurrentPassword"
        case openCC = "OpenCountryDD"
        case incorrectOtp = "EnterIncorrectOTP"
        case generatedOtp = "GenerateNewOTP"
        case success
        
         //MARK:- Set And Change Password Events TypeNames
        case invalidPasswordFormat = "EnterIncorrectFormatAndContinue"
        case hidePassword = "HidePassword"
        case showPassword = "ShowPassword"
        
        //MARK:- Enable And Disable OTP Events TypeNames
        case generateOtpForMob = "GenerateNewMobileOTP"
        case incorrectMobOtp = "EnterIncorrectMobileOTP"
        case generateOtpForEmail = "GenerateNewEmailOTP"
        case incorrectEmailOtp = "EnterIncorrectEmailOTP"
        case enterPasswordAndContinue = "EnterPasswordAndProceed"
        case enableDisableOtp
        
        //MARK:- Individual Hotel Detials Events TypeNames
        case FoundNoHotelsInfo
        case CaptureHotelStarRating
        case CaptureHotelTARating
        case CaptureHotelDistanceFromCentre
        case FoundNoHotelPhoto
        case OpenPhotos
        case PinchPhotos
        case ViewPhotosOpening
        case OpenShare
        case OpenAddressOnMap
        case CancelAddressOnMap
        case OpenAddressOnAppleMap
        case OpenAddressOnGoogleMap
        case OpenOverview
        case OpenAmenities
        case OpenTripAdvisor
        case OpenViewReviews
        case OpenTAPhotos
        case OpenWriteAReview
        case OpenRoomSearch
        case OpenRoomSearchViaMic
        case BreakfastFilterPresetsOn
        case BreakfastFilterPresetsOff
        case FreeCancellationFilterPresetOn
        case FreeCancellationFilterPresetOff
        case FindNoResultsAfterAapplyingRoomfilters
        case ResetRoomFilters
        case OpenAddToTrips
        case CancelAddToTrips
        case OpenCreateNewTrip
        case SetATripPhoto
        case CancelCreateNewTrip
        case CreateNewTrip
        case SelectTripAndSave
        case TryAddingToTripAlreadyExists
        case ClearFilterTerm
        case ClickOnSelectRoom
        case CountTotalRoomsAvailable
        case ExpandCancellationPolicy
        case BookRoomWithNoMeals
        case BookRoomWithBreakfast
        case BookRoomWithHalfBoard
        case BookRoomWithFullBoard
        case BookRoomWithOtherBoardTypes
        case BookRoomWithFreeCancellation
        case BookRoomWithPartialCancellation
        case BookRoomWithNoRefunds
        case BookRoomWithTransfers
        case CountTotalOpenedHotels
        
        //MARK:- Hotels Checkout as Guest Events TypeNames
        case continueAsGuest = "ContinueAsGuest"
        case connectWithFacebook = "ConnectWithFacebook"
        case connectWithGoogle = "ConnectWithGoogle"
        case connectWithApple = "ConnectWithApple"
        case login = "Login"
        case navigateBack = "NavigateBack"
        
        //MARK:- Hotels Checkout Events TypeName
        case fareDipped = "FareDipped"
        case fareIncrease = "FareIncrease"
        case continueWithFareIncrease = "ContinueWithFareIncrease"
        case backWithFareIncrease = "BackWithFareIncrease"
        case openPassengerDetails = "OpenPassengerDetails"
        case openSelectGuest = "OpenSelectGuest"
        
        //MARK:- Flight Filters
        case FlightSortFilterByTapOnFilterIcon = "FlightSortFilterByTapOnFilterIcon"
        case FlightSortFilterTapped = "FlightSortFilterTapped"
        case FlightStopsFilterTapped = "FlightStopsFilterTapped"
        case FlightTimesFilterTapped = "FlightTimesFilterTapped"
        case FlightDurationFilterTapped = "FlightDurationFilterTapped"
        case FlightAirlinesFilterTapped = "FlightAirlinesFilterTapped"
        case FlightAirportFilterTapped = "FlightAirportFilterTapped"
        case FlightPriceFilterTapped = "FlightPriceFilterTapped"
        case FlightAircraftFilterTapped = "FlightAircraftFilterTapped"
        
        case FlightSortFilterSwiped = "FlightSortFilterSwiped"
        case FlightStopsFilterSwiped = "FlightStopsFilterSwiped"
        case FlightTimesFilterSwiped = "FlightTimesFilterSwiped"
        case FlightDurationFilterSwiped = "FlightDurationFilterSwiped"
        case FlightAirlinesFilterSwiped = "FlightAirlinesFilterSwiped"
        case FlightAirportFilterSwiped = "FlightAirportFilterSwiped"
        case FlightPriceFilterSwiped = "FlightPriceFilterSwiped"
        case FlightAircraftFilterSwiped = "FlightAircraftFilterSwiped"
        
        case ClearAllFlightFilters = "ClearAllFlightFilters"
        case CloseFlightFilterUsingDone = "CloseFlightFilterUsingDone"
        case CloseFlightFiltersByOutsideClick = "CloseFlightFiltersByOutsideClick"
        case CloseFlightFilterByTappingFilter = "CloseFlightFilterByTappingFilter"
        case NoResultsApplyingFlightFilters = "NoResultsApplyingFlightFilters"
        
        // Hotel Filters
        case HotelSortFilterByTapOnFilterIcon = "HotelSortFilterByTapOnFilterIcon"
        case HotelSortFilterTapped = "HotelSortFilterTapped"
        case HotelDistanceFilterTapped = "HotelDistanceFilterTapped"
        case HotelPriceFilterTapped = "HotelPriceFilterTapped"
        case HotelRatingsFilterTapped = "HotelRatingsFilterTapped"
        case HotelAmenitiesFilterTapped = "HotelAmenitiesFilterTapped"
        case HotelRoomFilterTapped = "HotelRoomFilterTapped"
        
        case HotelSortFilterSwiped = "HotelSortFilterSwiped"
        case HotelDistanceFilterSwiped = "HotelDistanceFilterSwiped"
        case HotelPriceFilterSwiped = "HotelPriceFilterSwiped"
        case HotelRatingsFilterSwiped = "HotelRatingsFilterSwiped"
        case HotelAmenitiesFilterSwiped = "HotelAmenitiesFilterSwiped"
        case HotelRoomFilterSwiped = "HotelRoomFilterSwiped"
        
        case ClearAllHotelFilters = "ClearAllHotelFilters"
        case CloseHotelFilterUsingDone = "CloseHotelFilterUsingDone"
        case CloseHotelFiltersByOutsideClick = "CloseHotelFiltersByOutsideClick"
        case CloseHotelFilterByTappingFilter = "CloseHotelFilterByTappingFilter"
        case NoResultsApplyingHotelFilters = "NoResultsApplyingHotelFilters"

        //MARK:- Favourite Hotels Events TypeNames
        case AddHotel
        case SwipeHorizontallyToNavigate
        case TapToNavigate
        case RemoveAllHotels
        case FindNoResults
        
        //MARK:- Travellers List Events TypeNames
        case OpenMainUser
        case OpenTraveller
        case SearchTraveller
        case SearchTravellerFindNoResults
        case SwipeToDelete
        case AddNewTraveller
        case EnterSelectModeByLongPressing
        case EnterSelectModeFromMenu
        case EnterPreferencesFromMenu
        case EnterImportFromMenu
        case SelectTravellersAndDelete
        case SelectTravellersAndAssignGroup
        
        //MARK:- View Traveller Events TypeNames
        case OpenEditTraveller
        case CopyDetails
        
        //MARK:- Edit Main Traveller Events TypeNames
        case Cancel
        case Save
        case PressCTAwithoutSelectingGender
        case PressCTAWithoutEnteringFirstName
        case PressCTAWithoutEnteringLastName
        case EditPhoto
        case TakePhoto
        case ChoosePhoto
        case ImportPhotoFromFacebook
        case ImportPhotoFromGoogle
        case RemovePhoto
        case ChangeAertripID
        case AddMoreEmails
        case EnterIncorrectEmail
        case DeleteEmailID
        case SetDefaultMobileNumber
        case AddMoreNumbers
        case DeleteNumbers
        case EnterSocialAccount
        case AddMoreSocialAccounts
        case DeleteSocialAccounts
        case AddMoreAddresses
        case DeleteAddress
        case EnterDOB
        case EditDOB
        case EnterAnniversary
        case EditAnniversary
        case EnterNotes
        case EditNotes
        case EnterPassportNumber
        case EditPassportNumber
        case EnterIssueCountry
        case EditIssueCountry
        case EnterIssueDate
        case EditIssueDate
        case EnterExpiryDate
        case EditExpiryDate
        case SetSeatPreference
        case EditSeatPreference
        case SetMealPreference
        case EditMealPreference
        case AddFF
        case EditFF
        case DeleteFromTravellersList
        
        //MARK:- Traveller Preferences Events TypeNames
        case ChangeSortOrder
        case ChangeDisplayOrder
        case SwitchCategoriseByGroupOff
        case SwitchCategoriseByGroupOn
        case DeleteGroup
        case SortGroup
        case AddNewGroup
        
        //MARK:- Import Traveller Events TypeNames
        case AccessContacts
        case AccessGoogle
        case ImportFromContacts
        case ImportFromGoogle
        
        //MARK:- Linked Account Events TypeNames
        case DisconnectFromFacebook
        case DisconnectFromGoogle
        case DisconnectFromApple
        
        //MARK:- Change Aertrip ID Events TypeNames
        case PressCTAWithoutValidNewEmailID
        case PressCTAWithoutExistingPassword
        case EnterIncorrectPassword
        case InitiateChangeAertripID
        
        //MARK:- Login Or Register Events TypeNames
        case LoginWithFacebook
        case LoginWithGoogle
        case LoginWithApple
        case Register
        case SignIn
        
        //MARK:- Login Events TypeNames
        case ForgotPassword
        case ViewPassword
        case EmailDidntExist
        case PasswordIncorrect
        case ClickOnRegister
        case LoginSuccessfully
        
        //MARK:- Register Events TypeNames
        case OpenTermsOfUse
        case ProceedToThankYouForRegistering
        
        //MARK:- Thank you for Registering Events TypeNames
        case OpenEmailApp
        
        //MARK:- Secure Your Account Events TypeNames
        case EnterIncorrectFormateAndContinue
        
        //MARK:- Create Profile Events TypeNames
//        case PressCTAwithoutSelectingGender
//        case PressCTAWithoutEnteringFirstName
//        case PressCTAWithoutEnteringLastName
//        case PressCTAWithoutEnteringMobileNumber
//        case PressCTAEnteringWrongMobileNumber
//        case OpenCountryDD
        
        //MARK:- Forgot Password Events TypeNames
        case Continued
        
        //MARK:- Check Forgot Password Email Events TypeNames
//        case OpenEmailApp
        
        //MARK:- Reset Password Events TypeNames
        case UsedAPreviouslyUsedPassword
        
        //MARK:- Try verifying your email again Events TypeNames
        case UsedExpiredRegistrationLink
        case UsedExpiredResetPasswordPink
        
        //MARK:- Profile Events TypeNames
        case ClickOnEditMainUserProfile
        case ClickOnMainUserProfile
        
        //OneWay Results
        case OpenFlightDetails
        case SwipeClubbedJourneys
        case ExpandClubbedJourneys
        case CollapseclubbedJourneys
        case ShowLongerOrExpensiveFlights
        case HideLongerOrExpensiveFlights
        case PinFlight
        case UnPinFlight
        case ShareFlight
        case UnPinAll
        case EmailPinnedFlights
        case AddToTrip
        
        case LoggedInUserType
        case JourneyTitle
        
        
        //MARK:- Accounts
        case Accounts
        case AccountsLedger
        case AccountsOutstandingLedger
        case AccountsPeriodicStatement
        case AccountsFilterOptionSelected
        case AccountsApplyFilterOptionSelected
        case AccountsClearAllFilterOptionSelected
        case AccountsSpeechToTextOptionSelected
        case AccountsConvertedSpeechToText
        case AccountsOutstandingLedgerPayOnlineOptionSelected
        case AccountsOutstandingLedgerPayOfflineOptionSelected

        case AccountsPayOnlineOptionSelected
        case AccountsPayOfflineOptionSelected
        case AccountsDepositeOptionSelected
        case AccountsInfoOptionSelected
        case StatementUserAccountsLedgerOptionSelected
        case StatementUserAccountsOutstandingLedgerOptionSelected
        case StatementUserAccountsPeriodicStatementOptionSelected
        case TopupUserAccountsLedgerOptionSelected
        case TopupUserAccountsOutstandingLedgerOptionSelected
        case BillwiseUserAccountsLedgerOptionSelected
        case BillwiseUserAccountsOutstandingLedgerOptionSelected
        case AccountsSendEmailOptionSelected
        case AccountsDownloadPDFOptionSelected
        case AccountsClearSearchBarOptionSelected
        case AccountsCancelSearchBarOptionSelected
        case AccountSearchOptionSelected
        case OutstandingAccountSearchOptionSelected
        case AccountDetailsSearchOptionSelected
        case AccountsLedgerSpeechToTextSelected
        case AccountsMenuOptionSelected
        case AccountsLedgerFilterOptionSelected
        case AccountsLedgerClearFilterOptionSelected
        case AccountsLedgerConvertedSpeechToText
        case AccountsLedgerViewLedgerDetailsSelectedFromList
        case AccountsLedgerDetails
        case AccountsLedgerHotelDetails
        case AccountsLedgerFlightDetails
        case AccountsLedgerDetailsFlightsOptionSelected
        case AccountsLedgerDetailsHotelsOptionSelected
        case AccountsLedgerDetailsDownloadReciptSelected
        case AccountsOutstandingLedgerSelectBookingsOptionSelected
        case AccountsOutstandingLedgerOnAccountOptionSelected
        case AccountsMakePaymenrOptionSelected
        case AccountsOutstandingLedgerViewLedgerDetailsSelectedFromList
        case AccountsPeriodicStatementViewStatementDetailsSelectedFromList

        
    //        MARK:- FlightDetails
        case FlightDetailsIntFlightInfo
        case FlightDetailsIntBaggageInfo
        case FlightDetailsIntFareInfo
        case FlightDetailsFlightInfo
        case FlightDetailsBaggageInfo
        case FlightDetailsFareInfo
        case CloseButtonClicked
        case FlightDetailsPinOptionSelected
        case FlightDetailsShareOptionSelected
        case FlightDetailsAddToTripOptionSelected
        case FlightBookFlightOptionSelected
        case FlightDetailsOpenPassengerSelectionScreen
        case FlightDetailsInfoOptionSelected
        case FlightDetailsUpgradeOptionSelected
        case FlightDetailsBaggageDimentionsOptionSelected
        case FlightDetailsFareRulesOptionSelected
        case FlightDetailsOnTimePerformanceOptionSelected
        
    //        MARK:- Upgrade Flight
        case UpgradePlanInfoOptionSelected
        case UpgradePlanPresentPessangerSelectionScreen
        case UpgradePlanBookOptionSelected
        
    //        MARK:- Bookings
        case MyBookings
        case MyBookingsFilterApplied
        case MyBookingsFilterCleared
        case MyBookingsFilterClearedFromFilterScreen
        case MyBookingsList
        case MyBookingsSearchOptionSelected
        case MyBookingsSpeechToTextOptionSelected
        case MyBookingsConvertedSpeechToText
        case MyBookingsFilter
        case BookingsReviewCancellationRequest
        case BookingsReviewReschedulingRequest
        case BookingsReviewSpecialRequest
        case BookingsCancellation
        case BookingsRescheduling
        case BookingsRequestAddOns
        case BookingsDirections
        case BookingsContactNumberList
        case BookingsVoucherDepositPayOnlineOptionSelected
        case BookingsVoucherDepositPayOfflineOptionSelected
        case BookingsFlightDetails
        case BookingsFlightDetailsBaggageDimensionOptionsSelected
        case BookingsFlightDetailsFlightInfo
        case BookingsFlightDetailsBaggageInfo
        case BookingsFlightDetailsFareInfo
        case BookingsFlightDetailsFareInfoFareRulesOptionSelected
        case BookingsAddonsRequest
        case BookingsDetailsMakePaymentOptionSelected
        case BookingsAddonRequestPayOnlineOptionSelected
        case BookingsAddonRequestPayOfflineOptionSelected

        case OtherBookingsDetails
        case OtherBookingsDetailsDepositPayOnlineOptionSelected
        case OtherBookingsDetailsDepositPayOfflineOptionSelected
        case OtherBookingsDetailsPaymentInfoOptionSelected
        case MyBookingsFlightBookingsDetails
        case MyBookingsFlightBookingsDetailsPayOnlineOptionSelected
        case MyBookingsFlightBookingsDetailsPayOfflineOptionSelected
        case MyBookingsRequestAddOnFrequentFlyerOptionSelected
        case MyBookingsReschedulingOptionSelected
        case MyBookingsFlightDetailsShareOptionSelected
        case MyBookingsFlightDetailsBookSameFlightOptionSelected
        case MyBookingsFlightDetailsAddToCalenderOptionSelected
        case MyBookingsFlightDetailsAddToAppleWalletOptionSelected

        case MyBookingsWebCheckinOptionSelected
        case MyBookingsHotelDetails
        case MyBookingsHotelDetailsPayOnlineOptionSelected
        case MyBookingsHotelDetailsPayOfflineOptionSelected
        case MyBookingsHotelDetailsProcessCancellationOptionSelected
        case MyBookingsHotelDetailsProcessSpecialRequestOptionSelected
        case MyBookingsHotelDetailsDownloadDetailsOptionSelected
        case MyBookingsHotelDetailsResendConfirmationMailOptionSelected
        case MyBookingsHotelDetailsReloadDetailsOptionSelected
        case MyBookingsHotelDetailsShareOptionSelected
        case MyBookingsHotelDetailsOpenDirectionsOptionSelected
        case MyBookingsHotelDetailsAddToCalenderOptionSelected
        case MyBookingsHotelDetailsBookAnotherRoomOptionSelected
        case BookingConfirmationMail

        //Addons
        case OpenMeals
        case OpenBaggage
        case OpenSeat
        case OpenOthers
        case addMealsAddon
        case addBaggageAddons
        case addOtherAddons
        case addSeatAddons
        

//        Home
        case NavigatetoAerinbyTapping
        case NavigatetoAerinbySwiping
        case NavigatetoFlightsbySwiping
        case NavigatetoFlightsbyTapping
        case NavigatetoHotelsbySwiping
        case NavigatetoHotelsbyTapping
        case NavigatetoTripsbySwiping
        case NavigatetoTripsbyTapping
        case ProfileOptionSelected
        case TravelSafetyGuidelinesOptionSelected
        case NavigateToTripsFromHome

//        case OpenDoorbySwipeonRightEdge

        
//        SideMenu
        case OpenFacebook
        case OpenTwitter
        case OpenInstagram
        case CloseDoorbySwipingTheDoor
        case CloseDoorbyClickingonTheDoor
        case ClickedonLoginRegister
        case GuestUserOpenWhyAertrip
        case GuestUserOpenSmartSort
        case GuestUserOpenOffers
        case GuestUserOpenContactUs
        case GuestUserOpenSettings
        case OpenWhyAertrip
        case OpenSmartSort
        case OpenOffers
        case OpenContactUs
        case OpenSettings
        case OpenProfile
        case ViewAccounts
        case OpenBookings
        case OpenNotifications
        case OpenSupport
        case OpenRateUs
        
        //MARK:- Hotels Form Events TypeNames
        case ClickWhere
        case CaptureWhere
        case OpenCheckIn
        case OpenCheckOut
        case CalculateCheckInDateFromCurrentDate
        case CalculateTotalNights
        case CountTotalRooms
        case CountTotalAdults
        case CountTotalChildren
        case TryForMoreThan30Nights
        case SearchNearby
        case SearchByCity
        case SearchByHotel
        case SearchByArea
        case SearchPOI
        case OpenBulkBooking
        case Search
    
        // Hotel List
        case NavigateBackFromHotelList
        case NavigateBackBeforeHotelListAppears
        case NoHotelsFound
        case HotelsMapViewOpened
        case HotelSearchTapped
        case HotelMicSearchTapped
        case HotelBookmarked
        case HotelUnbookmarked
        case ClearHotelSearch
        case OpenHotelDetails
        
        // Hotel Bulk Booking
//        case ClickWhere
//        case OpenCheckIn
//        case OpenCheckOut
//        case CountTotalRooms
//        case CountTotalAdults
//        case CountTotalChildren
//        case TryForMoreThan30Nights
//        case SearchNearby
//        case SearchByCity
//        case SearchByHotel
//        case SearchByArea
//        case SearchPOI
        case CloseBulkBooking
        case SendBulkBookingQuery
        
        //Aerin
        case openAerin
        case talkToAerinByMessage
        case talkToAerinBySpeach
        case startListening
        case dismisAerin
        case ShowDetails
        case HideDetails
        
        // Hotel Map View
        case SwitchToHotelList
        case OpenHotelFilters
//        case HotelSearchTapped    repeat for reference, do not remove
//        case HotelMicSearchTapped
//        case HotelBookmarked
//        case HotelUnbookmarked
        case HideElementsOnMapClick
        case ShowElementsOnMapClick
//        case ClearHotelSearch
        case NavigateToMapCenter
        case OpenGroupedHotels
        case openGroupedHotelsByClusterTap
        case OpenHotelByCardTap
        case OpenHotelByDotTap
        
        
        //MARK:- Hotels Payment Events TypeNames
        case EnableWalletAmount
        case DisableWalletAmount
//        case TapOnPrivacyPolicy
//        case TapOnTermsOfUse
        case PaidTotalAmountViaWallet
        case PaymentFail
        case TapOnPayButton
        
        //MARK:- Hotels Receipt Events TypeNames
        case TapOnChangeTrip
        case OpenBookedHotelDetails
        case TapOnFacebookShareButton
        case TapOnTwitterShareButton
        case TapOnShareButton
        case TapOnWhatsNextFlightCard
        case TapOnWhatsNextHotelsCard
        case TapOnWhatsNextModifyBookingCard
        case TapOnReturnToHomeButton
        
        //MARK:- Flight Guest Checkout  Events TypeNames
//        case continueAsGuest = "ContinueAsGuest"
//        case connectWithFacebook = "ConnectWithFacebook"
//        case connectWithGoogle = "ConnectWithGoogle"
//        case connectWithApple = "ConnectWithApple"
//        case login = "Login"
//        case navigateBack = "NavigateBack"
        
        //MARK:- Flight Checkout  Events TypeNames
//        case fareDipped = "FareDipped"
//        case fareIncrease = "FareIncrease"
//        case continueWithFareIncrease = "ContinueWithFareIncrease"
//        case backWithFareIncrease = "BackWithFareIncrease"
//        case openPassengerDetails = "OpenPassengerDetails"
//        case openSelectGuest = "OpenSelectGuest"
        //FlightCheckout
        case openFlightCheckout
        case OpenApplyCoupon
        
        
        //MARK:- Flight Receipt Events TypeNames
//        case TapOnChangeTrip
        case OpenBookedFlightDetailsDetails
//        case TapOnFacebookShareButton
//        case TapOnTwitterShareButton
//        case TapOnShareButton
//        case TapOnWhatsNextFlightCard
//        case TapOnWhatsNextHotelsCard
//        case TapOnWhatsNextModifyBookingCard
//        case TapOnReturnToHomeButton
        case TicketsAddedToAppleWallet
        case EventAddedToCalendar
        case TapOnSelectSeat
        case PostBookingSeatSelectionAvailable
        case TapOnViewTickets
        case BookingIsConfirmed
        case BookingConfirmationIsPending
        
        //MARK:- Flight Post Bookings Seat Payment Events TypeNames
//        case PaidTotalAmountViaWallet
        case PaidTotalAmountViaOnlinePayment
        case UsedBothWalletAndOnlinePayment
        case FlightPostBookingsSeatPaymentFail
//        case TapOnPayButton
        
        
        //MARK:- Flight Post Bookings Seat Payment Status Events TypeNames
        case TapOnAccessThisBooking
        case SeatBookingIsConfirmed
        case SeatBookingIsPending
        
        case TripType
        case CheckInCheckOutDates
        case BulkBookingCheckInCheckOutDates
        
        case CitySelectedForBulkBooking
        case SelectedCity
    }
    
    // MARK: App Open Event
    func logAppOpenEvent() {
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.OpenApp.rawValue)
    }
    
    func logHotelBulkBookingEvent(name: EventsTypeName, value: String = "n/a") {
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.HotelBulkBooking.rawValue, params: [AnalyticsKeys.name.rawValue: name.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: value])
    }
    
    //MARK:- Settings Events Log Function
    func logSettingEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Settings.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }

    //MARK:- Update Account Details Events Log Function
    func logUpdateAccountEvents(with type: EventsTypeName, isUpdating:Bool = false, value:String = ""){
        var eventDetails = "n/a"
        var value = "n/a"
        switch type{
        case .aadhar : eventDetails = isUpdating ? "UpdateAadhar" : "InsertAadhar"
        case .pan:
            eventDetails = isUpdating ? "UpdatePAN" : "InsertPAN"
        case .gstIn:
            eventDetails = isUpdating ? "UpdateGSTIN" : "InsertGSTIN"
        case .defaultRefundMode:
            value = (value == "1") ? "Change default refund to Wallet" : "Change default refund to Online"
        case .billingName:
            eventDetails = "UpdateBillingName"
        case .billingAddress:
            eventDetails = "UpdateBillingAddress"
        default: break;
        }
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.AccountDetails.rawValue, params: [AnalyticsKeys.name.rawValue:type.rawValue, AnalyticsKeys.type.rawValue:eventDetails, AnalyticsKeys.values.rawValue:value])
    }
    
    //MARK:- Set and Change Mobile Log Function
    func logSetUpdateMobileEvents(with type: EventsTypeName, isUpdated:Bool = false){
        let eventName = isUpdated ? AnalyticsEvents.ChangeMobile.rawValue : AnalyticsEvents.SetMobile.rawValue
        var value = type.rawValue
        if type == .success{
            if isUpdated{
                value = "ChangeMobileNumberSuccessfully"
            }else{
                value = "SetMobileNumberSuccessfully"
            }
        }
        FirebaseAnalyticsController.shared.logEvent(name: eventName, params: [AnalyticsKeys.name.rawValue: value, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    //MARK:- Set and Change Password Log Function
    func logSetUpdatePasswordEvents(with type: EventsTypeName, isUpdated:Bool = false){
        let eventName = isUpdated ? AnalyticsEvents.ChangePassword.rawValue : AnalyticsEvents.SetPassword.rawValue
        var value = type.rawValue
        if type == .success{
            if isUpdated{
                value = "ChangePasswordSuccessfully"
            }else{
                value = "SetPasswordSuccessfully"
            }
        }
        FirebaseAnalyticsController.shared.logEvent(name: eventName, params: [AnalyticsKeys.name.rawValue: value, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    //MARK:- Enable and Disble wallet OTP Log Function
    func logEnableDisableWalletEvents(with type: EventsTypeName, isEnabled:Bool = false){
        let eventName = isEnabled ? AnalyticsEvents.EnableOTP.rawValue : AnalyticsEvents.DisableOTP.rawValue
        var value = type.rawValue
        if type == .enableDisableOtp{
            if isEnabled{
                value = "EnabledOTP"
            }else{
                value = "DisbaledOTP"
            }
        }
        FirebaseAnalyticsController.shared.logEvent(name: eventName, params: [AnalyticsKeys.name.rawValue: value, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    
    //MARK:- Individaul Hotel Detials Events Log Function
    func logIndividualHotelsDetalsEvents(with type: EventsTypeName, value:String?){
        var param:JSONDictionary = [AnalyticsKeys.name.rawValue: type.rawValue]
        if let value = value{
            param[AnalyticsKeys.values.rawValue] = value
        }else{
            param[AnalyticsKeys.values.rawValue] = "n/a"
        }
        param[AnalyticsKeys.type.rawValue] = "n/a"
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.IndividualHotelDetails.rawValue, params: param)
    }

    
    //MARK:- Hotels Guest User Checkout Events Log Function
    func logHotelsGuestUserCheckoutEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.HotelGuestCheckout.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    //MARK:- Hotels Checkout Events Log Function
    func logHotelsCheckoutEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.HotelCheckOut.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    // MARK: Flight and Hotel Filter Events
    func logFlightFiterEvents(params: JSONDictionary) {
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightFilters.rawValue, params: params)
    }
    
    func logHotelFilterEvents(params: JSONDictionary) {
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.HotelFilters.rawValue, params: params)
    }
    
    // MARK: Flight and Hotel Navigation Events
    func logFlightNavigationEvents(with type: EventsTypeName) {
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightFiltersNavigation.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    func logHotelNavigationEvents(with type: EventsTypeName) {
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.HotelFiltersNavigation.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    //MARK:- Favourite Hotels Events Log Function
    func logFavouriteHotelsEvents(with type: EventsTypeName, value:String?){
        var param:JSONDictionary = [AnalyticsKeys.name.rawValue: type.rawValue]
        if let value = value{
            param[AnalyticsKeys.values.rawValue] = value
        }else{
            param[AnalyticsKeys.values.rawValue] = "n/a"
        }
        param[AnalyticsKeys.type.rawValue] = "n/a"
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FavouriteHotels.rawValue, params: param)
    }
    
    //MARK:- Travellers List Events Log Function
    func logTravellersListEvents(with type: EventsTypeName, value:String?){
        var param:JSONDictionary = [AnalyticsKeys.name.rawValue: type.rawValue]
        if let value = value{
            param[AnalyticsKeys.values.rawValue] = value
        }else{
            param[AnalyticsKeys.values.rawValue] = "n/a"
        }
        param[AnalyticsKeys.type.rawValue] = "n/a"
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.TravellersList.rawValue, params: param)
    }
    
    //MARK:- View Traveller Events Log Function
    func logViewTravellerEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.ViewTraveller.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    //MARK:- Add/Edit Traveller Events Log Function
    func logEditMainTravellerEvents(with type: EventsTypeName, value:String?, key:String){
        var param:JSONDictionary = [AnalyticsKeys.name.rawValue: type.rawValue]
        var eventName = ""
        let typ = "n/a"
        var val = "n/a"
        if let value = value{
            val = value
        }
        param[AnalyticsKeys.type.rawValue] = typ
        param[AnalyticsKeys.values.rawValue] = val
        if key == "editMain"{
            eventName = AnalyticsEvents.EditMainTraveller.rawValue
        }else if key == "edit"{
            eventName = AnalyticsEvents.EditTraveller.rawValue
        }else  if key == "add"{
            eventName = AnalyticsEvents.AddTraveller.rawValue
        }
        FirebaseAnalyticsController.shared.logEvent(name: eventName, params: param)
    }
    
    
    //MARK:- Traveller Preferences Events Log Function
    func logTravellerPreferencesEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.TravellerPreferences.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    
    //MARK:- Import Traveller Events Log Function
    func logImportTravellerEvents(with type: EventsTypeName, value:String?){
        var val = "n/a"
        if let value = value{
            val = value
        }
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.ImportTraveller.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: val])
    }
    
    //MARK:- Linked Account Events Log Function
    func logLinkedAccountEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.LinkedAccount.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    //MARK:- Change Aertrip ID Events Log Function
    func logChangeAertripIDEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.ChangeAertripID.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    //MARK:- Login Or Register Events Log Function
    func logLoginOrRegisterEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.LoginOrRegister.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    //MARK:- Login Events Log Function
    func logLoginEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Login.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    //MARK:- Register Events Log Function
    func logRegisterEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Register.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    //MARK:- Thank you for Registering Events Log Function
    func logThankYouForRegisteringEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.ThankYouForRegistering.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    //MARK:- Secure Your Account Events Log Function
    func logSecureYourAccountEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.SecureYourAccount.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    //MARK:- Create Profile Events Log Function
    func logCreateProfileEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.CreateProfile.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    //MARK:- Forgot Password Events Log Function
    func logForgotPasswordEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.ForgotPassword.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    //MARK:- Check Forgot Password Email Events Log Function
    func logCheckForgotPasswordEmailEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.CheckForgotPasswordEmail.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    //MARK:- Reset Password Events Log Function
    func logResetPasswordEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.ResetPassword.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    //MARK:- Try Verifying Your Email Again Events Log Function
    func logTryVerifyingYourEmailAgainEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.TryVerifyingYourEmailAgain.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    

    //MARK:- Profile Events Log Function
    func logProfileEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Profile.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    
    //MARK:- Log Events Without Param Function
    func logEventsWithoutParam(with type: AnalyticsEvents){
        FirebaseAnalyticsController.shared.logEvent(name: type.rawValue) 
    }
    
    //MARK:- Flight Result Events
    func logOneWayResultEvents(with type : EventsTypeName, value : JSONDictionary = [:], groupId : String = "", fk : String = "", fkArray : [String] = []){
                
        switch type {
        case .PinFlight, .UnPinFlight, .OpenFlightDetails, .AddToTrip:
            
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightOneWayResults.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.values.rawValue : ["fk":fk].getString()])
            
        case .ShareFlight, .EmailPinnedFlights:
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightOneWayResults.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.values.rawValue : ["fk":fkArray].getString()
            ])

        default:
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightOneWayResults.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.values.rawValue : value.getString()])
            
        }
        
    }
    
    func logInternationalAndMulticityResults(with type : EventsTypeName, value : JSONDictionary = [:], groupId : String = "", fk : String = "", fkArray : [String] = []) {
        
        switch type {
        case .PinFlight, .UnPinFlight, .OpenFlightDetails, .AddToTrip:

            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightInternationalAndMulticityResults.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.values.rawValue : ["fk":fk].getString()])

        case .ShareFlight, .EmailPinnedFlights:
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightInternationalAndMulticityResults.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.values.rawValue : ["fk":fkArray].getString()])
            
        default:
            
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightInternationalAndMulticityResults.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.values.rawValue : value.getString()])

        }
        
    }
    
    func logDomesticAndMulticityResults(with type : EventsTypeName, value : JSONDictionary = [:], groupId : String = "", fk : String = "", fkArray : [String] = []) {
        
        switch type {
        case .PinFlight, .UnPinFlight, .AddToTrip:

            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightDomesticAndMulticityResults.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.values.rawValue : ["fk":fk].getString()])
     
        case .ShareFlight, .EmailPinnedFlights, .OpenFlightDetails:
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightDomesticAndMulticityResults.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.values.rawValue : ["fk":fkArray].getString()])
            
        default:
            
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightDomesticAndMulticityResults.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.values.rawValue : value.getString()])
            
        }
        
    }
    
    func logAddons(with type : EventsTypeName, addonName : String = "", flightTitle : String = "" ,fk : String = "", addonQty : Int = 0, value: String = ""){
        
        switch type {
     
        case .OpenMeals, .OpenBaggage, .OpenOthers, .OpenSeat:
            
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Addons.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue])

        case .addMealsAddon, .addOtherAddons, .addBaggageAddons:
            
            let valuesDict : JSONDictionary = ["addonName" : addonName, "addonQty" : addonQty, "fk" : fk, "flightTitle" : flightTitle]
            
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Addons.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.values.rawValue : valuesDict.getString()])
            
        case .addSeatAddons:
            
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Addons.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "Seat", AnalyticsKeys.values.rawValue: value])
            
        default:
        
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Addons.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue])

        }
        
    }
    
//    MARK:- Accounts
    func logAccountsOptionSelectionEvent(with type:EventsTypeName){
        let value : JSONDictionary = ["LoggedInUserType":UserInfo.loggedInUser?.userCreditType.rawValue ?? "n/a"]
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Accounts.rawValue, params: [AnalyticsKeys.name.rawValue: type, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: value.getString()])
    }
    
    func logAccountsEventsWithAccountType(with type:EventsTypeName, AccountType: String = "",isFrom : String = "")
    {
        let jsonDict : JSONDictionary = ["LoggedInUserType":AccountType]
        if isFrom == "Bookings"{
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.MyBookings.rawValue, params: [AnalyticsKeys.name.rawValue:type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: jsonDict.getString()])
        }else{
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Accounts.rawValue, params: [AnalyticsKeys.name.rawValue:type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: jsonDict.getString()])
        }
    }
    
    func logSearchBarEvents(with type:EventsTypeName,value:JSONDictionary = [:]){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Accounts.rawValue, params: [AnalyticsKeys.name.rawValue:type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: value.getString()])
    }

    func logAccountsDetailsEvents(with type:EventsTypeName,value:JSONDictionary = [:]){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Accounts.rawValue, params: [AnalyticsKeys.name.rawValue:type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: value.getString()])
    }

//    MARK:- FlightDetails
       
    func logFlightDetailsEventWithJourneyTitle(title: String = ""){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightDetails.rawValue, params: [AnalyticsKeys.name.rawValue:EventsTypeName.JourneyTitle.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: title])
    }
    
    
    func logFlightDetailsEvent(with type:EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightDetails.rawValue, params: [AnalyticsKeys.name.rawValue:type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])

    }

//    MARK:- Upgrade Plan
    func logUpgradePlanEvent(with type:EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.UpgradePlan.rawValue, params: [AnalyticsKeys.name.rawValue:type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])

    }

//    MARK:- My Bookings
    func logMyBookingsEvent(with type:EventsTypeName,value:JSONDictionary = [:]){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.MyBookings.rawValue, params: [AnalyticsKeys.name.rawValue:type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: value.getString()])

    }
    
//    MARK:- Home
    func logHomeEvents(with type:EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Home.rawValue, params: [AnalyticsKeys.name.rawValue:type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
//    MARK:- Side Menu
    
    func logSideMenuEvents(with type:EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.SideMenu.rawValue, params: [AnalyticsKeys.name.rawValue:type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }

    //MARK: Hotel List
    func logHotelListEvents(with type: EventsTypeName) {
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.HotelList.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    
    func logAerinEvents(with type: EventsTypeName, message : String = ""){
        
        switch type {
        case .talkToAerinBySpeach, .talkToAerinByMessage:
            
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Aerin.rawValue, params: [AnalyticsKeys.name.rawValue : type.rawValue, AnalyticsKeys.values.rawValue : message])
            
        default:
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Aerin.rawValue, params: [AnalyticsKeys.name.rawValue : type.rawValue])

        }
                
    }
    

//MARK: Hotel List
    func logHotelMapViewEvents(with type: EventsTypeName) {
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.HotelMapView.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    //MARK:- Hotels Form Events
    func LogHotelsFormEvents(with event: EventsTypeName, type:String?, strValue:String?){
        
        var param = JSONDictionary()
        param[AnalyticsKeys.name.rawValue] = event.rawValue
        if let type = type{
            param[AnalyticsKeys.type.rawValue] = type
        }else{
            param[AnalyticsKeys.type.rawValue] = "n/a"
        }
        if let valueStr = strValue{
            param[AnalyticsKeys.values.rawValue] = valueStr
        }else{
            param[AnalyticsKeys.values.rawValue] = "n/a"

        }
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.HotelForm.rawValue, params: param)
        
    }
    
    //MARK:- Hotels Final CheckOut Events Function
    func logHotelsFinalCheckOutEvent(with event: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.HotelsFinalCheckOut.rawValue, params: [AnalyticsKeys.name.rawValue: event.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue:"n/a"])
    }
    
    
    //MARK:- Hotel Receipt Events Function
    func logHotelReceiptEvent(with event: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.HotelReceipt.rawValue, params: [AnalyticsKeys.name.rawValue: event.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue:"n/a"])
    }
    
    
    //MARK:- Flight Guest User Checkout Events Log Function
    func logFlightGuestUserCheckoutEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightGuestCheckout.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    
    //MARK:- Flight  Checkout Events Log Function
    func logFlightCheckoutEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightCheckOut.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue: "n/a"])
    }
    
    func logFlightCheckoutEvent(with type: EventsTypeName){
        
        
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FinalFlightCheckout.rawValue, params: [AnalyticsKeys.name.rawValue : type.rawValue])
        
    }
    
    
    func logApplyCouponCodeForFlights(coupon : String){
        
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.ApplyCouponForFlights.rawValue, params: [AnalyticsKeys.name.rawValue : "n/a", AnalyticsKeys.values.rawValue : coupon])

    }
    
    
    //MARK:- Flight Receipt Events Function
    func logFlightsReceiptEvent(with event: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightReceipt.rawValue, params: [AnalyticsKeys.name.rawValue: event.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue:"n/a"])
    }
    
    
    //MARK:- Flight Post Bookings Seat Payment Events Function
    func logPostBookingSeatPaymentEvent(with event: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.PostBookingSeatPayment.rawValue, params: [AnalyticsKeys.name.rawValue: event.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue:"n/a"])
    }
    
    
    //MARK:- Flight Post Bookings Seat Payment status Events Function
    func logPostBookingSeatPaymentStatusEvent(with event: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.PostBookingSeatPaymentStatus.rawValue, params: [AnalyticsKeys.name.rawValue: event.rawValue, AnalyticsKeys.type.rawValue: "n/a", AnalyticsKeys.values.rawValue:"n/a"])
    }
    
}

///Objective c Event functions
 extension FirebaseEventLogs{
    
    ///Objective c Event type
    enum EventsTypeNameObjc:String {
        ///Maintain the order of case in same.
        //MARK:- FlighForm Events TypeNames
        case TapFrom
        case TapTo
        case TapOnwardDate
        case TapReturnDate
        case TapSelectPassenger
        case TapSelectClass
        case TapSearchButton
        case TapOneWay
        case TapReturn
        case TapMulticity
        case SearchFromRecentSearch
        case TapBulkBooking
        case TapSearchButtonWithoutSelectingDestinationCity
        case TapSearchButtonWithoutSelectingReturnDate
        case TapSearchButtonWithSameOriginAndDestination
        case TapSearchButtonWithoutSelectingDate
        case TapSearchButtonWithoutSelectingOriginCity
        case AddMoreSector
        case RemoveSector
        
        //MARK:- Airport Selection Events TypeNames
        case SelectFromRecentlySearch
        case SelectFromPopularAirport
        case SelectFromNearByAirport
        case TapOnNearMe
        case SearchAirport
        case TapDoneButton
        
        //MARK:- Passenger Selection Events TypeNames
        case SelectedMoreThanSixPassenger
        case TryToSelectMoreThanNinePassenger
        case TryToSelectInfantMoreThanAdult
        
        //MARK:- CabinClass Selection Events TypeNames
        case SelectEconomyClass
        case SelectPremiumEconomyClass
        case SelectBusinessClass
        case SelectFistClass
        case none
        
        init?(with value: String) {
            switch value {
            case "0":  self = .TapSearchButton
            case "1": self = .TapFrom
            case "2": self = .TapTo
            case "3": self = .TapOnwardDate
            case "4": self = .TapReturnDate
            case "5": self = .TapSelectPassenger
            case "6": self = .TapSelectClass
            case "7": self = .TapOneWay
            case "8": self = .TapReturn
            case "9": self = .TapMulticity
            case "10": self = .SearchFromRecentSearch
            case "11": self = .TapBulkBooking
            case "12": self = .TapSearchButtonWithoutSelectingDestinationCity
            case "13": self = .TapSearchButtonWithoutSelectingReturnDate
            case "14": self = .TapSearchButtonWithSameOriginAndDestination
            case "15": self = .TapSearchButtonWithoutSelectingDate
            case "16": self = .TapSearchButtonWithoutSelectingOriginCity
            case "17": self = .AddMoreSector
            case "18": self = .RemoveSector
            case "19":  self = .SelectFromRecentlySearch
            case "20": self = .SelectFromPopularAirport
            case "21": self = .SelectFromNearByAirport
            case "22": self = .TapOnNearMe
            case "23": self = .SearchAirport
            case "24": self = .TapDoneButton
            case "25": self = .SelectedMoreThanSixPassenger
            case "26": self = .TryToSelectMoreThanNinePassenger
            case "27": self = .TryToSelectInfantMoreThanAdult
            case "28": self = .SelectEconomyClass
            case "29": self = .SelectPremiumEconomyClass
            case "30": self = .SelectBusinessClass
            case "31": self = .SelectFistClass
            default: return nil
            }
        }
        
        
    }
    
//    MARK:- Hotel City Selection
    @objc func logSelectedCityForHotel(city:String, isFromHotelBulkBooking:Bool = false){
        var eventName = ""
        if isFromHotelBulkBooking{
            eventName = EventsTypeName.CitySelectedForBulkBooking.rawValue
        }else{
            eventName = EventsTypeName.SelectedCity.rawValue
        }

        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.HotelCitySelected.rawValue, params:[AnalyticsKeys.name.rawValue:eventName, AnalyticsKeys.type.rawValue:"n/a", AnalyticsKeys.values.rawValue:city])

    }
    
//    MARK:- Hotel Calender
    
    @objc func logHotelCalenderDateSelectionEvents(dictValue:JSONDictionary, isFromHotelBulkBooking:Bool = false){
        
        var eventName = ""
        if isFromHotelBulkBooking{
            eventName = EventsTypeName.BulkBookingCheckInCheckOutDates.rawValue
        }else{
            eventName = EventsTypeName.CheckInCheckOutDates.rawValue
        }
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.HotelsCalendar.rawValue, params:[AnalyticsKeys.name.rawValue:eventName, AnalyticsKeys.type.rawValue:"n/a", AnalyticsKeys.values.rawValue:dictValue])

    }
//    MARK:- Flight Calender
    
    @objc func logFlightCalenderDateSelectionEvents(_ tripType: String, dictValue:JSONDictionary){
        
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightsCalendar.rawValue, params:[AnalyticsKeys.name.rawValue:EventsTypeName.TripType.rawValue,AnalyticsKeys.type.rawValue:tripType, AnalyticsKeys.values.rawValue:dictValue])

    }
    //MARK:- Flight Form Events function
    @objc func logFlightFormEvents(_ nameInt: String, type: String, stringValue:String, dictValue:JSONDictionary){
        if let event = EventsTypeNameObjc(with: nameInt){
            var param :JSONDictionary = [:]
            param[AnalyticsKeys.name.rawValue] = event.rawValue
            if !type.isEmpty{
                param[AnalyticsKeys.type.rawValue] = type
            }else{
                param[AnalyticsKeys.type.rawValue] = "n/a"
            }
            
            if dictValue.count != 0{
                switch (dictValue["trip_type"] as? String ?? "").lowercased(){
                case "single", "return":
                    let origin = dictValue["origin"] as? String ?? ""
                    let destination = dictValue["destination"] as? String ?? ""
                    let cabinClasses = dictValue["cabinclass"] as? String ?? ""
                    let adt = dictValue["adult"] as? Int ?? 0
                    let chd = dictValue["child"] as? Int ?? 0
                    let inf = dictValue["infant"] as? Int ?? 0
                    
                    param[AnalyticsKeys.values.rawValue] = "Origin:\(origin),Dest:\(destination),CabinClass:\(cabinClasses),ADT:\(adt),CHD:\(chd),INF:\(inf)"
                    param[AnalyticsKeys.type.rawValue] = (dictValue["trip_type"] as? String ?? "").capitalized
                case "multi":
                    
                    var origin = ""
                    var destination = ""
                    var count = 0
                    while dictValue["origin[\(count)]"] != nil{
                        if let org = dictValue["origin[\(count)]"] as? String{
                            if origin.isEmpty{
                                origin += org
                            }else{
                                origin += ",\(org)"
                            }
                        }
                        if let dest = dictValue["destination[\(count)]"] as? String{
                            if dest.isEmpty{
                                destination += dest
                            }else{
                                destination += ",\(dest)"
                            }
                        }
                        count += 1
                    }
                    let cabinClasses = dictValue["cabinclass"] as? String ?? ""
                    let adt = dictValue["adult"] as? Int ?? 0
                    let chd = dictValue["child"] as? Int ?? 0
                    let inf = dictValue["infant"] as? Int ?? 0
                    
                    param[AnalyticsKeys.values.rawValue] = "Origin:\(origin),Dest:\(destination),CabinClass:\(cabinClasses),ADT:\(adt),CHD:\(chd),INF:\(inf)"
                    
                    param[AnalyticsKeys.type.rawValue] = "Multicity"
                default: break;
                }
               
            }else{
                if !stringValue.isEmpty{
                    param[AnalyticsKeys.values.rawValue] = stringValue
                }else{
                    param[AnalyticsKeys.values.rawValue] = "n/a"
                }
            }
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightForm.rawValue, params: param)
        }
        
        if nameInt == "0" || nameInt == "10"{
            self.logEventsWithoutParam(with: .FlightSearch)
        }
        
    }

    
    //MARK:- Airport Selection Events function
    @objc func logAirportSelectionEvents(_ nameInt: String, isForFrom:Bool, dictValue: String){
        if let event = EventsTypeNameObjc(with: nameInt){
            var param :JSONDictionary = [:]
            param[AnalyticsKeys.name.rawValue] = event.rawValue
            if isForFrom{
                param[AnalyticsKeys.type.rawValue] = "OriginAirport"
            }else{
                param[AnalyticsKeys.type.rawValue] = "DestinationAirport"
            }
            
            if dictValue.isEmpty{
                param[AnalyticsKeys.values.rawValue] = dictValue
            }else{
                param[AnalyticsKeys.values.rawValue] = "n/a"
            }
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.AirportSelection.rawValue, params: param)
        }
        
    }
    
    //MARK:- Airport Selection Events function
    @objc func logPassengersSelectionEvents(_ nameInt: String, dictValue:TravellerCount){
        if let event = EventsTypeNameObjc(with: nameInt){
            var param :JSONDictionary = [:]
            param[AnalyticsKeys.name.rawValue] = event.rawValue
            param[AnalyticsKeys.type.rawValue] = "n/a"
            if nameInt ==  "24"{
                var passengerDetails:String = ""
                passengerDetails += "adult:\(dictValue.flightAdultCount)"
                passengerDetails += ", child:\(dictValue.flightChildrenCount)"
                passengerDetails += ", infant\(dictValue.flightInfantCount)"
                param[AnalyticsKeys.values.rawValue] = passengerDetails
            }else{
                param[AnalyticsKeys.values.rawValue] = "n/a"
            }
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.AirportSelection.rawValue, params: param)
        }
        
    }
    
    //MARK:- Airport Selection Events function
    @objc func logCabinClassSelectionEvents(_ nameInt: String){
        if let event = EventsTypeNameObjc(with: nameInt){
            var param :JSONDictionary = [:]
            param[AnalyticsKeys.name.rawValue] = event.rawValue
            param[AnalyticsKeys.type.rawValue] = "n/a"
            param[AnalyticsKeys.values.rawValue] = "n/a"
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.AirportSelection.rawValue, params: param)
        }
        
    }
    
    //MARK: FlightBulkBooking
    @objc func logFlightBulkBookingEvents(_ nameInt: String, type: String, stringValue:String, dictValue:JSONDictionary) {
        if let event = EventsTypeNameObjc(with: nameInt){
            var param :JSONDictionary = [:]
            param[AnalyticsKeys.name.rawValue] = event.rawValue
            if !type.isEmpty{
                param[AnalyticsKeys.type.rawValue] = type
            }else{
                param[AnalyticsKeys.type.rawValue] = "n/a"
            }
            
            if dictValue.count != 0{
                switch (dictValue["trip_type"] as? String ?? "").lowercased(){
                case "single", "return":
                    let origin = dictValue["origin"] as? String ?? ""
                    let destination = dictValue["destination"] as? String ?? ""
                    let cabinClasses = dictValue["cabinclass"] as? String ?? ""
                    let adt = dictValue["adult"] as? Int ?? 0
                    let chd = dictValue["child"] as? Int ?? 0
                    let inf = dictValue["infant"] as? Int ?? 0
                    let specialReq = dictValue["special_request"] as? String ?? ""
                    let prefAirline = dictValue["preferred"] as? String ?? ""
                    var additionalStr = ""
                    if !specialReq.isEmpty {
                        additionalStr.append(",SpReq:\(specialReq)")
                    }
                    if !prefAirline.isEmpty {
                        additionalStr.append(",PrefAir:\(prefAirline)")
                    }
                    param[AnalyticsKeys.values.rawValue] = "Origin:\(origin),Dest:\(destination),CabinClass:\(cabinClasses),ADT:\(adt),CHD:\(chd),INF:\(inf)\(additionalStr)"
                    param[AnalyticsKeys.type.rawValue] = (dictValue["trip_type"] as? String ?? "").capitalized
                case "multi":
                    
                    var origin = ""
                    var destination = ""
                    var count = 0
                    while dictValue["origin[\(count)]"] != nil{
                        if let org = dictValue["origin[\(count)]"] as? String{
                            if origin.isEmpty{
                                origin += org
                            }else{
                                origin += ",\(org)"
                            }
                        }
                        if let dest = dictValue["destination[\(count)]"] as? String{
                            if dest.isEmpty{
                                destination += dest
                            }else{
                                destination += ",\(dest)"
                            }
                        }
                        count += 1
                    }
                    let cabinClasses = dictValue["cabinclass"] as? String ?? ""
                    let adt = dictValue["adult"] as? Int ?? 0
                    let chd = dictValue["child"] as? Int ?? 0
                    let inf = dictValue["infant"] as? Int ?? 0
                    let specialReq = dictValue["special_request"] as? String ?? ""
                    let prefAirline = dictValue["preferred"] as? String ?? ""
                    var additionalStr = ""
                    if !specialReq.isEmpty {
                        additionalStr.append(",SpReq:\(specialReq)")
                    }
                    if !prefAirline.isEmpty {
                        additionalStr.append(",PrefAir:\(prefAirline)")
                    }
                    param[AnalyticsKeys.values.rawValue] = "Origin:\(origin),Dest:\(destination),CabinClass:\(cabinClasses),ADT:\(adt),CHD:\(chd),INF:\(inf)\(additionalStr)"
                    
                    param[AnalyticsKeys.type.rawValue] = "Multicity"
                default: break;
                }
               
            }else{
                if !stringValue.isEmpty{
                    param[AnalyticsKeys.values.rawValue] = stringValue
                }else{
                    param[AnalyticsKeys.values.rawValue] = "n/a"
                }
            }
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightBulkBooking.rawValue, params: param)
        }
    }
}
