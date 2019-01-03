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
    
    // MARK:- TextField validation
    //MARK:-
    case Enter_email_address       = "Enter_email_address"
    case Enter_valid_email_address = "Enter_valid_email_address"
    case Enter_password            = "Enter_password"
    case Enter_valid_Password      = "Enter_valid_Password"
   
    
    // MARK:- SocialLoginVC
    //MARK:-
    case I_am_new_register  = "I_am_new_register"
    case Existing_User_Sign = "Existing_User_Sign"
    case Continue_with_Facebook  = "Continue_with_Facebook"
    case Continue_with_Google    = "Continue_with_Google"
    case Continue_with_Linkedin  = "Continue_with_Linkedin"
    
    // MARK:- LoginVC
    //MARK:-
    case Forgot_Password  = "Forgot_Password"
    case Welcome_Back     = "Welcome_Back"
    case Email_ID         = "Email_ID"
    case Password         = "Password"
    case Not_ye_registered_Register_here  = "Not_ye_registered_Register_here"
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
    case Cancel = "Cancel"
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

    //MARK:- ViewProfileVC
    //MARK:-
    case ALERT  = "ALERT"
    case DoYouWantToLogout = "DoYouWantToLogout"
    case Logout = "Logout"
    
    //MARK: - View Profile
    
    case Edit = "Edit"
    case TravellerList = "Travellers List"
    case HotelPreferences = "Hotel Preferences"
    case QuickPay = "QuickPay"
    case LinkedAccounts = "Linked Accounts"
    case NewsLetters = "Newsletters"
    case Notifications  = "Notifications"
    case LogOut = "Log Out"
    
    // MARK: - ViewProfileDetailVC
    
    case EmailAddress = "Email address"
    case ContactNumber = "Contact Number"
    case SocialAccounts = "Social Accounts"
    case Address = "Address"
    case MoreInformation = "More Information"
    case PassportDetails = "Passport Details"
    case FlightPreferences = "Flight Preferences"
    case Birthday = "Birthday"
    case Anniversary = "Anniversary"
    case Notes = "Notes"
    case Mobile = "Mobile"
    case passportNo = "Passport No."
    case issueCountry = "Issue Country"
    case issueDate = "Issue Date"
    case expiryDate = "Expiry Date"
    case seatPreference = "Seat Preference"
    case mealPreference = "Meal Preference"
    
    // MARK: - Edit Profile VC
    
    case Save = "Save"
    case FirstName = "First name"
    case LastName = "Last name"
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
    case FrequentFlyer = "Frequent Flyer"
    case AddFrequentFlyer = "Add Frequent Flyer"
    
    // Mark: - Salutation
    case Mrs = "Mrs"
    case Ms = "Ms"
    case Miss = "Miss"
    case Mast = "Mast"
    
    //MARK:- Hotel Search
    //MARK:-
    case PreferredStarCategory = "PreferredStarCategory"
    case FavouriteHotels = "FavouriteHotels"
    case stars = "stars"
    case star = "star"
    case searchForHotelsToAdd = "searchForHotelsToAdd"
    case searchHotelName = "searchHotelName"
}

