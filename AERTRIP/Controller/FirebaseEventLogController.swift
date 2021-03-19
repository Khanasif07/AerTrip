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
        //MARK: Settings Events TypeNames
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
        
        //MARK: Account update Events TypeNames
        case aadhar = "Aadhar"
        case pan = "PAN"
        case defaultRefundMode = "ChangeDefaultRefundMode"
        case billingAddress = "BillingAddress"
        case gstIn = "GSTIN"
        case billingName = "BillingName"
        
        //MARK: Set and Change Mobile Events TypeNames
        case emptyMobile = "PressCTAWithoutEnteringMobileNumber"
        case incorrectMobile = "PressCTAEnteringWrongMobileNumber"
        case invlidCurrentPassword = "EnterIncorrectCurrentPassword"
        case openCC = "OpenCountryDD"
        case incorrectOtp = "EnterIncorrectOTP"
        case generatedOtp = "GenerateNewOTP"
        case success
        
         //MARK: Set And Change Password Events TypeNames
        case invalidPasswordFormat = "EnterIncorrectFormatAndContinue"
        case hidePassword = "HidePassword"
        case showPassword = "ShowPassword"
        
        //MARK: Enable And Disable OTP Events TypeNames
        case generateOtpForMob = "GenerateNewMobileOTP"
        case incorrectMobOtp = "EnterIncorrectMobileOTP"
        case generateOtpForEmail = "GenerateNewEmailOTP"
        case incorrectEmailOtp = "EnterIncorrectEmailOTP"
        case enterPasswordAndContinue = "EnterPasswordAndProceed"
        case enableDisableOtp
        
        //MARK: Individual Hotel Detials Events TypeNames
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
        
        //MARK: Hotels Checkout as Guest Events TypeNames
        case continueAsGuest = "ContinueAsGuest"
        case connectWithFacebook = "ConnectWithFacebook"
        case connectWithGoogle = "ConnectWithGoogle"
        case connectWithApple = "ConnectWithApple"
        case login = "Login"
        case navigateBack = "NavigateBack"
        
        //MARK: Hotels Checkout Events TypeName
        case fareDipped = "FareDipped"
        case fareIncrease = "FareIncrease"
        case continueWithFareIncrease = "ContinueWithFareIncrease"
        case backWithFareIncrease = "BackWithFareIncrease"
        case openPassengerDetails = "OpenPassengerDetails"
        case openSelectGuest = "OpenSelectGuest"
        
        //MARK: Flight Filters
        case SortFilterByTapOnFilterIcon = "SortFilterByTapOnFilterIcon"
        case SortFilterTapped = "SortFilterTapped"
        case StopsFilterTapped = "StopsFilterTapped"
        case TimesFilterTapped = "TimesFilterTapped"
        case DurationFilterTapped = "DurationFilterTapped"
        case AirlinesFilterTapped = "AirlinesFilterTapped"
        case AirportFilterTapped = "AirportFilterTapped"
        case PriceFilterTapped = "PriceFilterTapped"
        case AircraftFilterTapped = "AircraftFilterTapped"
        
        case SortFilterSwiped = "SortFilterSwiped"
        case StopsFilterSwiped = "StopsFilterSwiped"
        case TimesFilterSwiped = "TimesFilterSwiped"
        case DurationFilterSwiped = "DurationFilterSwiped"
        case AirlinesFilterSwiped = "AirlinesFilterSwiped"
        case AirportFilterSwiped = "AirportFilterSwiped"
        case PriceFilterSwiped = "PriceFilterSwiped"
        case AircraftFilterSwiped = "AircraftFilterSwiped"
        
        //MARK: Favourite Hotels Events TypeNames
        case AddHotel
        case SwipeHorizontallyToNavigate
        case TapToNavigate
        case RemoveAllHotels
        case FindNoResults
        
        //MARK: Travellers List Events TypeNames
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
        
        //MARK: View Traveller Events TypeNames
        case EditTraveller
        case CopyDetails
        
        //MARK: Edit Main Traveller Events TypeNames
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
        
    }
    
    
    //MARK: Settings Events Log Function
    func logSettingEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.Settings.rawValue, params: [AnalyticsKeys.FilterName.rawValue: type.rawValue])
    }

    //MARK: Update Account Details Events Log Function
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
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.AccountDetails.rawValue, params: [AnalyticsKeys.FilterName.rawValue:type.rawValue, AnalyticsKeys.FilterType.rawValue:eventDetails, AnalyticsKeys.Values.rawValue:value])
    }
    
    //MARK: Set and Change Mobile Log Function
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
        FirebaseAnalyticsController.shared.logEvent(name: eventName, params: [AnalyticsKeys.FilterName.rawValue: value])
    }
    
    //MARK: Set and Change Password Log Function
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
        FirebaseAnalyticsController.shared.logEvent(name: eventName, params: [AnalyticsKeys.FilterName.rawValue: value])
    }
    
    //MARK: Enable and Disble wallet OTP Log Function
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
        FirebaseAnalyticsController.shared.logEvent(name: eventName, params: [AnalyticsKeys.FilterName.rawValue: value])
    }
    
    
    //MARK: Individaul Hotel Detials Events Log Function
    func logIndividualHotelsDetalsEvents(with type: EventsTypeName, value:String?){
        var param:JSONDictionary = [AnalyticsKeys.FilterName.rawValue: type.rawValue]
        if let value = value{
            param[AnalyticsKeys.Values.rawValue] = value
        }
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.IndividualHotelDetails.rawValue, params: param)
    }

    
    //MARK:Hotels Guest User Checkout Events Log Function
    func logHotelsGuestUserCheckoutEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.HotelGuestCheckout.rawValue, params: [AnalyticsKeys.FilterName.rawValue: type.rawValue])
    }
    
    //MARK:Hotels Checkout Events Log Function
    func logHotelsCheckoutEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.HotelCheckOut.rawValue, params: [AnalyticsKeys.FilterName.rawValue: type.rawValue])
    }
    
    func logFlightFilterEvents(with type: EventsTypeName) {
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FlightFiltersNavigation.rawValue, params: [AnalyticsKeys.FilterName.rawValue: type.rawValue])
    }
    
    //MARK:Favourite Hotels Events Log Function
    func logFavouriteHotelsEvents(with type: EventsTypeName, value:String?){
        var param:JSONDictionary = [AnalyticsKeys.FilterName.rawValue: type.rawValue]
        if let value = value{
            param[AnalyticsKeys.Values.rawValue] = value
        }
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.FavouriteHotels.rawValue, params: param)
    }
    
    //MARK:Travellers List Events Log Function
    func logTravellersListEvents(with type: EventsTypeName, value:String?){
        var param:JSONDictionary = [AnalyticsKeys.FilterName.rawValue: type.rawValue]
        if let value = value{
            param[AnalyticsKeys.Values.rawValue] = value
        }
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.TravellersList.rawValue, params: param)
    }
    
    //MARK:View Traveller Events Log Function
    func logViewTravellerEvents(with type: EventsTypeName){
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.ViewTraveller.rawValue, params: [AnalyticsKeys.FilterName.rawValue: type.rawValue])
    }
    
    //MARK:Edit Main Traveller Events Log Function
    func logEditMainTravellerEvents(with type: EventsTypeName, value:String?){
        var param:JSONDictionary = [AnalyticsKeys.FilterName.rawValue: type.rawValue]
        if let value = value{
            param[AnalyticsKeys.Values.rawValue] = value
        }
        FirebaseAnalyticsController.shared.logEvent(name: AnalyticsEvents.TravellersList.rawValue, params: param)
    }
    
}
