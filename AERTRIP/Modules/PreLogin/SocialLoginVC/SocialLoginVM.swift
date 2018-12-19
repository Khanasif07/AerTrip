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
    var userData = UserModel()
    var isFirstTime = true
    
    //MARK:- Actions
    //MARK:-
    func fbLogin(vc: UIViewController) {
        
        vc.view.endEditing(true)
        FacebookController.shared.getFacebookUserInfo(fromViewController: vc, success: { (result) in
            
            printDebug(result)
            
            self.userData.authKey = "\(result.authToken)"
            self.userData.picture   = "https://graph.facebook.com/\(result.id)/picture?width=200"
            self.userData.firstName  = result.first_name
            self.userData.lastName   = result.last_name
            self.userData.email     = result.email
            self.userData.service   = "facebook"
            self.userData.id        = result.id
            self.webserviceForSocialLogin()
            
        }, failure: { (error) in
            printDebug(error?.localizedDescription ?? "")
        })
    }
    
    func googleLogin() {
        
        GoogleLoginController.shared.login(success: { (model :  GoogleUser) in
            
            printDebug(model.name)
            
            self.userData.authKey        = model.accessToken
            self.userData.firstName       = model.name
            self.userData.email          = model.email
            self.userData.service         = "google"
            self.userData.id            = model.id
            
            if let imageURl = model.image {
                
                self.userData.picture = "\(imageURl)"
            }
            
            
            self.webserviceForSocialLogin()
            
        }){ (err : Error) in
            printDebug(err.localizedDescription)
        }
    }
    
    func linkedLogin() {
        
        let linkedinHelper = LinkedinSwiftHelper(
            configuration: LinkedinSwiftConfiguration(clientId: AppConstants.linkedIn_Client_Id, clientSecret: AppConstants.linkedIn_ClientSecret, state: AppConstants.linkedIn_States, permissions: AppConstants.linkedIn_Permissions, redirectUrl: AppConstants.linkedIn_redirectUri)
        )
        
        linkedinHelper.authorizeSuccess({ (lsToken) -> Void in
            //Login success lsToken
            
            
            linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
                
                guard let data = response.jsonObject else {return}
                
                self.userData.authKey = linkedinHelper.lsAccessToken?.accessToken ?? ""
                self.userData.firstName = data["firstName"] as? String ?? ""
                self.userData.lastName  = data["lastName"]  as? String ?? ""
                self.userData.id      = data["id"] as? String ?? ""
                self.userData.service   = "linkedin"
                
                printDebug(response)
                
                self.webserviceForSocialLogin()
                linkedinHelper.logout()
                
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
                
                self.delegate?.didLoginSuccess()
            }
            else {
                self.delegate?.didLoginFail(errors: errors)
            }
        })
        
    }
}
