
//  GoogleLoginController.swift
//  GoogleLogin
//
//  Created by Appinventiv on 10/09/17.
//  Copyright © 2017 Appinventiv. All rights reserved.

import GoogleSignIn
import UIKit
import Alamofire

class GoogleLoginController : NSObject {
    
    // MARK: Variables and properties...
    static let shared = GoogleLoginController()
    var accessToken = ""
    fileprivate(set) var currentGoogleUser: GoogleUser?
    fileprivate weak var contentViewController:UIViewController!
    fileprivate var hasAuthInKeychain: Bool {
        let hasAuth = GIDSignIn.sharedInstance()?.hasPreviousSignIn() ?? false
        return hasAuth
    }
    
    var success : ((_ googleUser : GoogleUser) -> ())?
    var failure : ((_ error : Error) -> ())?
    
    private override init() {}
    
    func configure() {
        let clientId = AppKeys.googleClientID
        GIDSignIn.sharedInstance().clientID = clientId
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func handleUrl(_ url: URL, options: [UIApplication.OpenURLOptionsKey : Any])->Bool{
        
        return GIDSignIn.sharedInstance()?.handle(url) ?? false
//        return GIDSignIn.sharedInstance().handle(url,
//                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    // MARK: - Method for google login...
    // MARK: ============================
    func login(fromViewController viewController : UIViewController = (UIApplication.shared.delegate as! AppDelegate).window!.rootViewController!,
               success : @escaping(_ googleUser : GoogleUser) -> (),
               failure : @escaping(_ error : Error) -> ()) {
        
        //GIDSignIn.sharedInstance().signOut()
         GIDSignIn.sharedInstance().presentingViewController = viewController

        if hasAuthInKeychain {
            GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        } else {
            GIDSignIn.sharedInstance()?.signIn()
        }
        
        contentViewController = viewController
        self.success = success
        self.failure = failure
    }
    
    func logout(){
        GIDSignIn.sharedInstance().signOut()
    }
}

// MARK: - GIDSignInUIDelegate and GIDSignInDelegate delegare methods...
// MARK: ===============================================================
extension GoogleLoginController : GIDSignInDelegate {
    
    // MARK: To get user details like name, email etc.
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            
            if (GIDSignIn.sharedInstance().currentUser != nil) {
                GoogleLoginController.shared.accessToken = GIDSignIn.sharedInstance().currentUser.authentication.accessToken
                // Use accessToken in your URL Requests Header
            }
    
            let googleUser = GoogleUser(user)
            currentGoogleUser = googleUser
            success?(googleUser)
            self.logout()
            
        } else {
            failure?(error)
        }
        
        success = nil
        failure = nil
    }
    
    // MARK: - To present to your controller
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        contentViewController.present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - To dismiss from your controller
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        contentViewController.dismiss(animated: true, completion: nil)
        self.logout()
    }
    
}

// MARK: - Fetch google contacts
// MARK: ==============================================
extension GoogleLoginController {
    func fetchContacts(fromViewController: UIViewController, success : @escaping(_ data : JSONDictionary) -> (), failure : @escaping(_ error : Error) -> ()) {
        
        GIDSignIn.sharedInstance().scopes = ["https://www.google.com/m8/feeds", "https://www.googleapis.com/auth/contacts.readonly"]
        self.login(fromViewController: fromViewController, success: { (logedinUser) in
            guard let token = GIDSignIn.sharedInstance().currentUser.authentication.accessToken else {
                return
            }
            let urlString = "https://www.google.com/m8/feeds/contacts/default/full?access_token=\(token)&alt=json&max-results=10000"
            
            printDebug(GIDSignIn.sharedInstance().scopes)
            
            let request = AF.request(urlString, method: .get)
            request.responseString { (data) in
                    printDebug(data)
            }
            
            request.responseData { (response:DataResponse) in
                
                switch(response.result) {
                    
                case .success(let value):
                    
                    do {
                        if let dict = try JSONSerialization.jsonObject(with: value, options: JSONSerialization.ReadingOptions.allowFragments) as? JSONDictionary {
                            success(dict)
                        }
                    }
                    catch let err {
                        failure(err as NSError)
                    }
                    
                case .failure(let e):
                    failure(e as NSError)
                }
            }
        }, failure: { (error) in
            failure(error)
        })
    }
}

// MARK: - Model class to store the user information...
// MARK: ==============================================
class GoogleUser {
    
    let id   : String
    let name : String
    let email: String
    let image: URL?
    let accessToken = GoogleLoginController.shared.accessToken
//    let authKey : String
    
    required init(_ googleUser: GIDGoogleUser) {
        
        id       = googleUser.userID
        name      = googleUser.profile.name
        email     = googleUser.profile.email
        image     = googleUser.profile.imageURL(withDimension: 200)
    }
    
    var dictionaryObject: [String:Any] {
        var dictionary          = [String:Any]()
        dictionary["_id"]       = id
        dictionary["email"]     = email
        dictionary["image"]     = image?.absoluteString ?? ""
        dictionary["name"]      = name
        return dictionary
    }
}
