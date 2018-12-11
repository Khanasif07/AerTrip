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
}

