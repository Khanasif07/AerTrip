//
//  SocialLoginVM.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 04/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
//import LinkedinSwift


protocol SocialLoginVMDelegate: class {
    
    func willLogin()
    func didLoginSuccess()
    func didLoginFail(errors: ErrorCodes)
}

class SocialLoginVM {
    
    //MARK:- Properties
    //MARK:-
    weak var delegate: SocialLoginVMDelegate?
    var userData = SocialUserModel()
    var currentlyUsingFrom = LoginFlowUsingFor.loginProcess
    var isFirstTime = true
    
    //MARK:- Actions
    //MARK:-
    func fbLogin(vc: UIViewController, completionBlock: ((_ success: Bool)->())? ) {
        
        vc.view.endEditing(true)
        FacebookController.shared.getFacebookUserInfo(fromViewController: vc, success: { (result) in
            
            printDebug(result)
            
            if result.email.isEmpty {
                //show toast
                AppToast.default.showToastMessage(message: LocalizedString.PleaseLoginByEmailId.localized, title: "", onViewController: vc)
                completionBlock?(false)
            }
            else {
                self.userData.authKey = "\(result.authToken)"
                self.userData.picture   = "https://graph.facebook.com/\(result.id)/picture?width=200"
                self.userData.firstName  = result.first_name
                self.userData.lastName   = result.last_name
                self.userData.email     = result.email
                self.userData.service   = APIKeys.facebook.rawValue
                self.userData.id        = result.id
                if vc is EditProfileVC {
                    // do nothing
                } else {
                    self.webserviceForSocialLogin()
                }
                completionBlock?(true)
            }
            
        }, failure: { (error) in
            printDebug(error?.localizedDescription ?? "")
            completionBlock?(false)
        })
    }
    
    func googleLogin(vc: UIViewController, completionBlock: ((_ success: Bool)->())? )  {
        
        GoogleLoginController.shared.login(success: { (model :  GoogleUser) in
            
            printDebug(model.name)
            let fullNameArr = model.name.components(separatedBy: " ")
            self.userData.authKey        = model.accessToken
            self.userData.firstName       = fullNameArr[0]
            self.userData.lastName        = fullNameArr[1]
            self.userData.email          = model.email
            self.userData.service         = APIKeys.google.rawValue
            self.userData.id            = model.id
            
            if let imageURl = model.image {
                
                self.userData.picture = "\(imageURl)"
            }
            completionBlock?(true)
            if vc is EditProfileVC {
                // do nothing
            } else {
                self.webserviceForSocialLogin()
            }
            
        }){ (err : Error) in
            completionBlock?(false)
            printDebug(err.localizedDescription)
        }
    }
    
    func linkedLogin(vc: UIViewController) {
        /*
         let linkedinHelper = LinkedinSwiftHelper(
         configuration: LinkedinSwiftConfiguration(clientId: AppConstants.linkedIn_Client_Id, clientSecret: AppConstants.linkedIn_ClientSecret, state: AppConstants.linkedIn_States, permissions: AppConstants.linkedIn_Permissions, redirectUrl: AppConstants.linkedIn_redirectUri)
         )
         
         linkedinHelper.authorizeSuccess({ (lsToken) -> Void in
         //Login success lsToken
         
         
         linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,headline,picture-url,public-profile-url)?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
         
         guard let data = response.jsonObject else {return}
         
         if let email = data["emailAddress"] as? String, email.isEmpty {
         //show toast
         AppToast.default.showToastMessage(message: LocalizedString.AllowEmailInLinkedIn.localized)
         linkedinHelper.logout()
         }
         else {
         self.userData.authKey     = linkedinHelper.lsAccessToken?.accessToken ?? ""
         self.userData.firstName  = data["firstName"] as? String ?? ""
         self.userData.lastName  = data["lastName"]  as? String ?? ""
         self.userData.id            = data["id"] as? String ?? ""
         self.userData.service   = "linkedin_oauth2"
         self.userData.email      =  data["emailAddress"] as? String ?? ""
         self.userData.picture   = data["pictureUrl"] as? String ?? ""
         
         printDebug(response)
         //                    completionBlock?(true)
         self.webserviceForSocialLogin()
         linkedinHelper.logout()
         }
         }) { (error) -> Void in
         //                completionBlock?(false)
         //Encounter error
         printDebug(error.localizedDescription)
         }
         
         }, error: { (error) -> Void in
         //Encounter error: error.localizedDescription
         //            completionBlock?(false)
         printDebug(error.localizedDescription)
         }, cancel: { () -> Void in
         //User Cancelled!
         //            completionBlock?(false)
         })
         */
    }
    func appleLogin(vc: UIViewController, completionBlock: ((_ success: Bool)->())? )  {
        AppleLoginController.shared.login(success: { (model :  AppleUser) in
            //            let message = "Apple Login Succes.\nUser Name: \(model.fullName)\nEmail: \(model.email)\nUser id: \(model.id)"
            //            AppToast.default.showToastMessage(message: message)
            //
            
            self.userData.authKey        = ""//model.accessToken
            self.userData.firstName       = model.firstName
            self.userData.lastName        = model.lastName
            self.userData.email          = model.email
            self.userData.service         = "apple_oauth2"
            self.userData.id            = model.id
            completionBlock?(true)
            
            self.webserviceForSocialLogin(isAppleLogin: true)
        }) { (error) in
            completionBlock?(false)
        }
    }
}



//MARK:- Extension Webservices
//MARK:-
extension SocialLoginVM {
    
    func webserviceForSocialLogin(isAppleLogin: Bool = false) {
        
        var params = JSONDictionary()
        if isAppleLogin {
            params[APIKeys.id.rawValue]        = self.userData.id
            params[APIKeys.userName.rawValue]    = (self.userData.firstName + " " + self.userData.lastName).removeAllWhiteSpacesAndNewLines//self.userData.firstName
            params[APIKeys.firstName.rawValue]   = self.userData.firstName
            params[APIKeys.lastName.rawValue]    = self.userData.lastName
            params[APIKeys.authKey.rawValue]     = self.userData.id
            params[APIKeys.email.rawValue]     = self.userData.email
            params[APIKeys.picture.rawValue]   = ""
            params[APIKeys.gender.rawValue]   = ""
            params[APIKeys.service.rawValue]   = self.userData.service
            
            //            [
            //            'id' => 'apple-@appleID,
            //            'username' => @FirstName . ' ' . @Lastname,
            //            'profile' => [
            //                'name' => @FirstName . ' ' . @Lastname,
            //                'id' => @appleID,
            //                'emailAddress' => @email,
            //                'birthday' => '',
            //                'firstName' => @FirstName,
            //                'lastName' => @Lastname,
            //                'picture' => [
            //                    'data' => '',
            //                ],
            //                'gender' => '',
            //                'service' => 'apple_oauth2'
            //            ]
            //            ]
            // new params
            //            [
            //                  'id' => @appleID,
            //                  'username' => @first_name . ' ' . @last_name,
            //                  'first_name' => @first_name,
            //                  'last_name' => @last_name,
            //                  'authKey' => @appleID,
            //                  'email' => @email,
            //                  'picture' => '',
            //                  'gender' => '',
            //                  'service' => 'apple_oauth2',
            //            ]
        } else {
            params[APIKeys.id.rawValue]        = self.userData.id
            params[APIKeys.userName.rawValue]    = (self.userData.firstName + " " + self.userData.lastName).removeAllWhiteSpacesAndNewLines//self.userData.firstName
            params[APIKeys.firstName.rawValue]   = self.userData.firstName
            params[APIKeys.lastName.rawValue]    = self.userData.lastName
            params[APIKeys.authKey.rawValue]     = self.userData.authKey
            params[APIKeys.email.rawValue]     = self.userData.email
            params[APIKeys.picture.rawValue]   = self.userData.picture
            params[APIKeys.service.rawValue]   = self.userData.service
            params[APIKeys.dob.rawValue]       = self.userData.dob
            
            let permission = ["user_birthday" : 1, "user_friends" : 1, "email" : 1, "publish_actions" : 1 , "public_profile" : 1]
            params[APIKeys.permissions.rawValue] = AppGlobals.shared.json(from: [permission])
        }
        self.delegate?.willLogin()
        APICaller.shared.callSocialLoginAPI(params: params, loader: true, completionBlock: {(success, errors) in
            
            if success {
                
                switch self.userData.service.lowercased() {
                    //                case "linkedin".lowercased():
                    //                    UserInfo.loggedInUser?.socialLoginType = LinkedAccount.SocialType.linkedin
                    
                case "google".lowercased():
                    self.firebaseLogEvent(with: .connectWithGoogle)
                    UserInfo.loggedInUser?.socialLoginType = LinkedAccount.SocialType.google
                    
                case "facebook".lowercased():
                    self.firebaseLogEvent(with: .connectWithFacebook)
                    UserInfo.loggedInUser?.socialLoginType = LinkedAccount.SocialType.facebook
                    
                case "apple_oauth2".lowercased():
                    self.firebaseLogEvent(with: .connectWithApple)
                    UserInfo.loggedInUser?.socialLoginType = LinkedAccount.SocialType.apple
                default:
                    UserInfo.loggedInUser?.socialLoginType = nil
                }
                
                self.delegate?.didLoginSuccess()
                APICaller.shared.saveLocallyFavToServer()
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .login)
                self.delegate?.didLoginFail(errors: errors)
            }
        })
        
    }
}

///Logs events for hotels checkouts
extension SocialLoginVM{
    
    func firebaseLogEvent(with event:FirebaseEventLogs.EventsTypeName){
        switch self.currentlyUsingFrom {
        case .loginProcess:break
        case .loginVerificationForCheckout:
            FirebaseEventLogs.shared.logHotelsGuestUserCheckoutEvents(with: event)
        case .loginVerificationForBulkbooking:break;
        case .loginFromEmailShare:break
        }
        
        
    }
    
}
