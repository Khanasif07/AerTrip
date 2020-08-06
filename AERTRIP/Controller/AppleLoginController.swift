//
//  AppleLoginController.swift
//  AERTRIP
//
//  Created by Admin on 21/07/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit
import AuthenticationServices

class AppleLoginController : NSObject, ASAuthorizationControllerDelegate {
    
    // MARK: Variables and properties...
    static let shared = AppleLoginController()
    fileprivate var success : ((_ appleleUser : AppleUser) -> ())?
    fileprivate var failure : ((_ error : Error?) -> ())?
    
    private override init() {}
    
    func login(fromViewController viewController : UIViewController = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!,
               success : @escaping(_ appleleUser : AppleUser) -> (),
               failure : @escaping(_ error : Error?) -> ()) {
        self.success = success
        self.failure = failure
        
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        } else {
            failure(nil)
        }
    }
    
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let name = appleIDCredential.fullName
            let firstName = name?.givenName ?? ""
            let lastName = name?.familyName ?? ""
            let email = appleIDCredential.email ?? ""
            let fullName = "\(firstName) \(lastName)"
            printDebug(appleIDCredential.identityToken)
            printDebug("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")

           let user =  AppleUser(id: userIdentifier, fullName: fullName, firstName: firstName, lastName: lastName, email: email)
            success?(user)
            success = nil
            failure = nil
        }
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        failure?(error)
        success = nil
        failure = nil
    }
    
}

// MARK: - Model class to store the user information...
// MARK: ==============================================
struct AppleUser {
    
    let id   : String
    let fullName : String
    let firstName : String
    let lastName : String
    let email: String
    
}
