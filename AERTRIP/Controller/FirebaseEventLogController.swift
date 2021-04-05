//
//  FirebaseEventLogController.swift
//  AERTRIP
//
//  Created by Admin on 12/03/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import Foundation


class FirebaseEventLogs{
    
    static let shared = FirebaseEventLogs()
    private init(){}
    
    enum EventsTypeName:String {
        //MARK:- Settings Events TypeNames
        case changeCountry = "TryToChangeConuntry"
        case changeCurrency = "TryToChangeCurrency"
        case changeNotification = "TryToChangeNotification"
        case toggleCalender = "TryToToggleOnCalenderSync"
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
        
        
        //MARK:- Accounts
        case AccountsFilterOptionSelected
        case AccountsApplyFilterOptionSelected
        case AccountsClearAllFilterOptionSelected
        case AccountsSpeechToTextOptionSelected
        case AccountsConvertedSpeechToText
        case AccountsPayOnlineOptionSelected
        case AccountsPayOfflineOptionSelected
        case AccountsDepositeOptionSelected
        case AccountsInfoOptionSelected
        case AccountsLedgerOptionSelected
        case AccountsOutstandingLedgerOptionSelected
        case AccountsPeriodicStatementOptionSelected
        case AccountsSendEmailOptionSelected
        case AccountsDownloadPDFOptionSelected
        case AccountsClearSearchBarOptionSelected
        case AccountsCancelSearchBarOptionSelected
        case AccountSearchOptionSelected
        case AccountsLedgerSpeechToTextSelected
        case AccountsMenuOptionSelected
        case AccountsLedgerFilterOptionSelected
        case AccountsLedgerClearFilterOptionSelected
        case AccountsLedgerConvertedSpeechToText
        case AccountsLedgerViewLedgerDetailsSelectedFromList
        case AccountsLedgerDetails
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
        
        case MyBookingsHotelCancellation
        case MyBookingsNotes
        
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
        case ExpandClubbedJourneys
        case CollapseclubbedJourneys
        case SwipeClubbedJourneys
        case ShowLongerOrExpensiveFlights
        case HideLongerOrExpensiveFlights
        case PinFlight
        case UnPinFlight
        case ShareFlight
        case UnPinAll
        case EmailPinnedFlights
        case AddToTrip
        
        //Addons
        case OpenMeals
        case OpenBaggage
        case OpenSeat
        case OpenOthers
        case addPassengerToMeal
        case addPassengerToBaggage
        case addPassengerToOtherAddons
        
        
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
    func logEventsWithOutParam(with type: AnalyticsEvents){
        FirebaseAnalyticsController.shared.logEvent(name: type.rawValue)
    }
    
    //MARK:- Flight Result Events
    func logOneWayResultEvents(with type : EventsTypeName, value : JSONDictionary = [:], groupId : String = "", fk : String = "", fkArray : [String] = []){
                
        switch type {
        case .PinFlight, .UnPinFlight, .OpenFlightDetails, .AddToTrip:
            
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightOneWayResults.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.values.rawValue : ["fk":fk]])
            
        case .ShareFlight, .EmailPinnedFlights:
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightOneWayResults.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.values.rawValue : ["fk":fkArray]])

        default:
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightOneWayResults.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.values.rawValue : value])
        }
        

    }
    
    func logInternationalAndMulticityResults(with type : EventsTypeName, value : JSONDictionary = [:], groupId : String = "", fk : String = "", fkArray : [String] = []) {
        
        switch type {
        case .PinFlight, .UnPinFlight, .OpenFlightDetails, .AddToTrip:

            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightInternationalAndMulticityResults.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.values.rawValue : ["fk":fk]])

        case .ShareFlight, .EmailPinnedFlights:
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightInternationalAndMulticityResults.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.values.rawValue : ["fk":fkArray]])
            
        default:
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightInternationalAndMulticityResults.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.values.rawValue : value])

        }
        
    }
    
    func logDomesticAndMulticityResults(with type : EventsTypeName, value : JSONDictionary = [:], groupId : String = "", fk : String = "", fkArray : [String] = []) {
        
        switch type {
        case .PinFlight, .UnPinFlight, .AddToTrip:

            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightDomesticAndMulticityResults.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.values.rawValue : ["fk":fk]])
     
        case .ShareFlight, .EmailPinnedFlights, .OpenFlightDetails:
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightDomesticAndMulticityResults.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.values.rawValue : ["fk":fkArray]])
            
        default:
            FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightDomesticAndMulticityResults.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue, AnalyticsKeys.values.rawValue : value])

        }
        
    }
    
//    MARK:- Accounts
    func logAccountsOptionSelectionEvent(with type:EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Accounts.rawValue, params: [AnalyticsKeys.name.rawValue: type, AnalyticsKeys.type.rawValue: "LoggedInUserType", AnalyticsKeys.values.rawValue: UserInfo.loggedInUser?.userCreditType ?? "n/a"])

    }
    
    func logAddons(with type : EventsTypeName){
        
        FirebaseAnalyticsController.shared.logEvent(name: type.rawValue, params: [AnalyticsKeys.name.rawValue: type.rawValue])
        
    }
    
    
}
