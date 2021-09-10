//
//  SignInWithApple.swift
//  SytUp
//
//  Created by Apple  on 30.01.20.
//  Copyright © 2020 Gurdeep Singh. All rights reserved.
//

import Foundation
import AuthenticationServices


protocol AppLoginWithApple: AppleSignInDelegate {
    var loginDelegate : SignInWithApple! {get set}

}

@available(iOS 13.0, *)
extension AppLoginWithApple {
    func openSinginOption() {
        if loginDelegate == nil {
            loginDelegate = SignInWithApple(self)
        }
        loginDelegate.actionHandleAppleSignin()
    }
}


protocol AppleSignInDelegate where Self: UIViewController {
    func didCompleteLogin(loginData : AplleLoginData?, status : Bool, message:String?)
}


class SignInWithApple: NSObject,ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    
    fileprivate var delegate: AppleSignInDelegate!
    
    init(_ delegate: AppleSignInDelegate) {
        self.delegate = delegate
    }
    
    
    @available(iOS 13.0, *)
    func actionHandleAppleSignin() {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
        
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.delegate.didCompleteLogin(loginData: nil, status: false, message: error.localizedDescription)
    }
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let id = appleIDCredential.user
            let firstName = appleIDCredential.fullName?.givenName ?? ""
            let lastName = appleIDCredential.fullName?.familyName ?? ""
            let email = appleIDCredential.email ?? ""
            let loginData = [AppleLoginKey.id: id, AppleLoginKey.fName: firstName, AppleLoginKey.lName: lastName, AppleLoginKey.email: email]
            self.delegate.didCompleteLogin(loginData: AplleLoginData(loginData), status: true, message: nil)
            
            
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            
            let username = passwordCredential.user
            let password = passwordCredential.password
            let loginData = [AppleLoginKey.userName: username, AppleLoginKey.password: password]
            self.delegate.didCompleteLogin(loginData: AplleLoginData(loginData), status: true, message: nil)
        }
    }
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.delegate.view.window!
    }
    
}

struct AppleLoginKey{
    
    static let id = "id"
    static let fName = "firstName"
    static let lName = "lastName"
    static let email = "email"
    static let userName = "userName"
    static let password = "password"
}


struct AplleLoginData{
    
    var id : String
    var fName : String
    var lName : String
    var email : String
    var userName : String
    var password : String
    
    init(_ data:[ String:String]){
        id = data[AppleLoginKey.id] ?? ""
        fName = data[AppleLoginKey.fName] ?? ""
        lName = data[AppleLoginKey.lName] ?? ""
        email = data[AppleLoginKey.email] ?? ""
        userName = data[AppleLoginKey.userName] ?? ""
        password = data[AppleLoginKey.password] ?? ""
    }
}
