//
//  LinkedAccountsVM.swift
//  AERTRIP
//
//  Created by Admin on 15/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit
import LinkedinSwift

protocol LinkedAccountsVMDelegate: class {
    func willFetchLinkedAccount()
    func fetchLinkedAccountSuccess()
    func fetchLinkedAccountFail()
}

class LinkedAccountsVM {
    
    //MARK:- Properties
    //MARK:- Public
    weak var delegate: LinkedAccountsVMDelegate?
    var linkedAccounts: [LinkedAccount] = []
    
    //MARK:- Private
    private var userData = SocialUserModel()
    
    //MARK:- Methods
    //MARK:- Public
    func fetchLinkedAccounts() {
        self.delegate?.willFetchLinkedAccount()
        APICaller.shared.callFetchLinkedAccountsAPI { (success, accounts, error) in
            if success {
                self.linkedAccounts = accounts
                self.delegate?.fetchLinkedAccountSuccess()
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .login)
                self.delegate?.fetchLinkedAccountFail()
            }
        }
    }
    
    func disConnect(account: LinkedAccount) {
        var params = JSONDictionary()
        params[APIKeys.eid.rawValue] = account.eid
        params[APIKeys.service.rawValue] = account.socialType.rawValue
        params[APIKeys.email.rawValue] = account.email
        
        APICaller.shared.callDisconnectLinkedAccountsAPI(params: params) { (success, error) in
            if success {
                self.fetchLinkedAccounts()
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: error, fromModule: .login)
            }
        }
    }
    
    //MARK:- Private
}

extension LinkedAccountsVM {
    
    //MARK:- Actions
    //MARK:-
    func fbLogin(vc: UIViewController, completionBlock: ((_ success: Bool)->())? ) {
        
        vc.view.endEditing(true)
        FacebookController.shared.getFacebookUserInfo(fromViewController: vc, success: { (result) in
            
            printDebug(result)
            
            if result.email.isEmpty {
                //show toast
                AppToast.default.showToastMessage(message: LocalizedString.AllowEmailInFacebook.localized, vc: vc)
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
            
            self.userData.authKey        = model.accessToken
            self.userData.firstName       = model.name
            self.userData.email          = model.email
            self.userData.service         = "google_oauth"
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
                    AppToast.default.showToastMessage(message: LocalizedString.AllowEmailInLinkedIn.localized, vc: vc)
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
                    
                    self.webserviceForSocialLogin()
                    linkedinHelper.logout()
                }
            }) { [unowned self] (error) -> Void in
                
                //Encounter error
            }
            
        }, error: { (error) -> Void in
            //Encounter error: error.localizedDescription
        }, cancel: { () -> Void in
            //User Cancelled!
        })
    }
}

//MARK:- Extension Webservices
//MARK:-
extension LinkedAccountsVM {
    
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
        
        APICaller.shared.callSocialLoginAPI(params: params, loader: true, completionBlock: {(success, errors) in
            
            if success {
                self.fetchLinkedAccounts()
            }
            else {
                AppGlobals.shared.showErrorOnToastView(withErrors: errors, fromModule: .login)
            }
        })
    }
}

