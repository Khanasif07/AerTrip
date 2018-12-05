//
//  SocialLoginVM.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 04/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
import LinkedinSwift

class SocialLoginVM {
    
    //MARK:- Properties
    //MARK:-
    
    //MARK:- Actions
    //MARK:-
    func fbLogin(vc: UIViewController) {
        
        vc.view.endEditing(true)
        FacebookController.shared.getFacebookUserInfo(fromViewController: vc, success: { (result) in
            
            printDebug(result)
            
            //            self.socialData[.image]        = "https://graph.facebook.com/\(result.id)/picture?width=200"
            //            self.socialData[.name]         = result.name
            //            self.socialData[.email]        = result.email
            //            self.socialData[.socialType]   = "1"
            //            self.socialData[.id]           = result.id
            //            self.socialData[.manual_email] = "2"
            //            self.webserviceForSocialLogin(data: self.socialData)
            
        }, failure: { (error) in
            printDebug(error?.localizedDescription ?? "")
        })
    }
    
    func googleLogin(vc: UIViewController) {
        
        vc.view.endEditing(true)
        GoogleLoginController.shared.login(success: { (model :  GoogleUser) in
            
            printDebug(model.name)
            
//            self.socialData[.name]         = model.name
//            self.socialData[.email]        = model.email
//            self.socialData[.socialType]   = "2"
//            self.socialData[.id]           = model.id
//            self.socialData[.manual_email] = "2"
//
//            if let imageURl = model.image {
//
//                self.socialData[.image] = "\(imageURl)"
//            }
//            self.webserviceForSocialLogin(data: self.socialData)
            
        }){ (err : Error) in
            printDebug(err.localizedDescription)
        }
    }
    
    func linkedLogin(vc: UIViewController) {
     
        let linkedinHelper = LinkedinSwiftHelper(
            configuration: LinkedinSwiftConfiguration(clientId: AppConstants.linkedIn_Client_Id, clientSecret: AppConstants.linkedIn_ClientSecret, state: AppConstants.linkedIn_States, permissions: AppConstants.linkedIn_Permissions, redirectUrl: AppConstants.linkedIn_redirectUri)
        )
        
        linkedinHelper.authorizeSuccess({ (lsToken) -> Void in
            //Login success lsToken
            
            linkedinHelper.requestURL("https://api.linkedin.com/v1/people/~?format=json", requestType: LinkedinSwiftRequestGet, success: { (response) -> Void in
              
                printDebug(response)
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
