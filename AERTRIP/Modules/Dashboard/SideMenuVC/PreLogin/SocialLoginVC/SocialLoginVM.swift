//
//  SocialLoginVM.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 04/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
import LinkedinSwift

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
                self.userData.service   = "facebook"
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
            self.userData.service         = "google"
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
    }
}

//MARK:- Extension Webservices
//MARK:-
extension SocialLoginVM {
    
    func webserviceForSocialLogin() {
        
        var params = JSONDictionary()
        
        params[APIKeys.id.rawValue]        = self.userData.id
        params[APIKeys.userName.rawValue]    = self.userData.firstName
        params[APIKeys.firstName.rawValue]   = self.userData.firstName
        params[APIKeys.lastName.rawValue]    = self.userData.lastName
        params[APIKeys.authKey.rawValue]     = self.userData.authKey
        params[APIKeys.email.rawValue]     = self.userData.email
        params[APIKeys.picture.rawValue]   = self.userData.picture
        params[APIKeys.service.rawValue]   = self.userData.service
        params[APIKeys.dob.rawValue]       = self.userData.dob
        
        let permission = ["user_birthday" : 1, "user_friends" : 1, "email" : 1, "publish_actions" : 1 , "public_profile" : 1]
        params[APIKeys.permissions.rawValue] = AppGlobals.shared.json(from: [permission])
        
        self.delegate?.willLogin()
        APICaller.shared.callSocialLoginAPI(params: params, loader: true, completionBlock: {(success, errors) in
            
            if success {
                
                switch self.userData.service.lowercased() {
                case "linkedin".lowercased():
                    UserInfo.loggedInUser?.socialLoginType = LinkedAccount.SocialType.linkedin
                    
                case "google".lowercased():
                    UserInfo.loggedInUser?.socialLoginType = LinkedAccount.SocialType.google
                    
                case "facebook".lowercased():
                    UserInfo.loggedInUser?.socialLoginType = LinkedAccount.SocialType.facebook
                    
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
