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
            var email = appleIDCredential.email ?? ""
            let fullName = "\(firstName) \(lastName)"
            if let idTokenData = appleIDCredential.identityToken {
                do {
                    if let idTokenStr = String(data: idTokenData, encoding: .utf8) {
                        let dataDict = try decode(jwtToken: idTokenStr)
                        if let emailId = dataDict["email"] as? String {
                            email = emailId
                        }
                    }
                } catch {
                    print(error)
                }
            }
            
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
        printDebug("error: \(error)")
        // Handle error.
        failure?(error)
        success = nil
        failure = nil
    }
    
    private func decode(jwtToken jwt: String) throws -> [String: Any] {
        
        enum DecodeErrors: Error {
            case badToken
            case other
        }
        
        func base64Decode(_ base64: String) throws -> Data {
            let padded = base64.padding(toLength: ((base64.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
            guard let decoded = Data(base64Encoded: padded) else {
                throw DecodeErrors.badToken
            }
            return decoded
        }
        
        func decodeJWTPart(_ value: String) throws -> [String: Any] {
            let bodyData = try base64Decode(value)
            let json = try JSONSerialization.jsonObject(with: bodyData, options: [])
            guard let payload = json as? [String: Any] else {
                throw DecodeErrors.other
            }
            return payload
        }
        
        let segments = jwt.components(separatedBy: ".")
        return try decodeJWTPart(segments[1])
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
