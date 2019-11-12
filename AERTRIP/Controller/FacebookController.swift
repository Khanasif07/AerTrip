//
//  FacebookController.swift
//  FacebookLogin
//
//  Created by Appinventiv on 10/08/17.
//  Copyright © 2017 Appinventiv. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Social
import Accounts
import SwiftyJSON

class FacebookController {
    
    // MARK:- VARIABLES
    //==================
    static let shared = FacebookController()
    var facebookAccount: ACAccount?
    var currentAccessToken = ""
    
    private init() {}
    
    // MARK:- FACEBOOK LOGIN
    //=========================
    func loginWithFacebook(fromViewController viewController: UIViewController, shouldFetchFriends: Bool = false, completion: @escaping FBSDKLoginManagerRequestTokenHandler) {
        
        facebookLogout()
        
        var permissions = ["email", "public_profile"]
        
        if shouldFetchFriends {
            permissions.append("user_friends")
        }
        
        let login = FBSDKLoginManager()
        login.loginBehavior = FBSDKLoginBehavior.native
        
        login.logIn(withReadPermissions: permissions, from: viewController, handler: {
            result, error in
            
            if let res = result,res.isCancelled {
                completion(nil,error)
            }else{
            
                if let token = result?.token.tokenString {
                    self.currentAccessToken = token
                }
                completion(result,error)
            }
            
        })
    }
    
    // MARK:- FACEBOOK LOGIN WITH SHARE PERMISSIONS
    //================================================
    func loginWithSharePermission(fromViewController viewController: UIViewController, completion: @escaping FBSDKLoginManagerRequestTokenHandler) {
        
        if let current = FBSDKAccessToken.current(), current.hasGranted("publish_actions") {
            
            let result = FBSDKLoginManagerLoginResult(token: FBSDKAccessToken.current(), isCancelled: false, grantedPermissions: nil, declinedPermissions: nil)
            
            completion(result,nil)
        } else {
            
            let login = FBSDKLoginManager()
            login.loginBehavior = FBSDKLoginBehavior.native
            
            FBSDKLoginManager().logIn(withPublishPermissions: ["publish_actions"], from: viewController, handler: { (result, error) in
                
                if let res = result,res.isCancelled {
                    completion(nil,error)
                }else{
                    completion(result,error)
                }
            })
        }
    }
    
    // MARK:- GET FACEBOOK USER INFO
    //================================
    func getFacebookUserInfo(fromViewController viewController: UIViewController,
                             success: @escaping ((FacebookModel) -> Void),
                             failure: @escaping ((Error?) -> Void)) {
        
            self.loginWithFacebook(fromViewController: viewController, completion: { (result, error) in
                
                if error == nil,let _ = result?.token {
                    self.getInfo(success: { (result) in
                        
                        success(result)
                    }, failure: { (e) in
                        failure(e)
                    }) 
                    
                } else {
                    failure(error)
                }
            })
    }
    
    private func getInfo(success: @escaping ((FacebookModel) -> Void),
                         failure: @escaping ((Error?) -> Void)){
        
        // FOR MORE PARAMETERS:- https://developers.facebook.com/docs/graph-api/reference/user
        let params = ["fields": "email, name, gender, first_name, last_name, birthday, cover, currency, devices, education, hometown, is_verified, link, locale, location, relationship_status, website, work, picture.type(large)"]

        let request = self.getGraphRequest(graphPath: "me", parameters: params, httpMethod: "GET")
        request.start(completionHandler: {
            connection, result, error in
            
            if let result = result {
                success(FacebookModel(withJSON: JSON(result)))
            } else {
                failure(error)
            }
        })
    }
    
    // MARK:- GET IMAGE FROM FACEBOOK
    //=================================
    func getProfilePicFromFacebook(userId:String,_ completionBlock:@escaping (UIImage?)->Void){
        
        guard let url = URL(string:"https://graph.facebook.com/\(userId)/picture?type=large") else {
            return
        }
        let request = SLRequest(forServiceType: SLServiceTypeFacebook, requestMethod: SLRequestMethod.GET, url: url, parameters: nil)
        request?.account = self.facebookAccount
        
        request?.perform(handler: { (responseData: Data?, _, error: Error?) in
            if let data = responseData{
                let userImage=UIImage(data: data)
                completionBlock(userImage)
            }
        })
    }
    
    
    // MARK:- SHARE WITH FACEBOOK
    //=============================
    func shareMessageOnFacebook(withViewController vc : UIViewController,
                                _ message: String,
                                success: @escaping (([String:Any]) -> Void),
                                failure: @escaping ((Error?) -> Void)) {
        
            self.loginWithSharePermission(fromViewController: vc, completion: { (result, error) in
                
                if error == nil,let token = result?.token,let tokenString = token.tokenString {
                    let param: [String:Any] = ["message" : message, "access_token" : tokenString]
                    
                    let request = self.getGraphRequest(graphPath: "me/feed", parameters: param, httpMethod: "POST")
                    request.start(completionHandler: { (connection, result, error) -> Void in
                        if let error = error {
                            failure(error)
                        } else {
                            if let result = result as? [String : Any] {
                                success(result)
                            }else{
                                let err = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Something went wrong"])
                                failure(err)
                            }
                        }
                    })
                }else{
                    failure(error)
                }
            })
    }
    
    func shareImageWithCaptionOnFacebook(withViewController vc : UIViewController,
                                         _ imageUrl: String,
                                         _ captionText: String,
                                         success: @escaping (([String:Any]) -> Void),
                                         failure: @escaping ((Error?) -> Void)) {
        
        self.loginWithSharePermission(fromViewController: vc, completion: { (result, error) in
            
            if error == nil,let token = result?.token,let tokenString = token.tokenString {
                let param: [String:Any] = [ "url" : imageUrl, "caption" : captionText, "access_token" : tokenString]
                let request = self.getGraphRequest(graphPath: "me/photos", parameters: param, httpMethod: "POST")
                request.start(completionHandler: { (connection, result, error) -> Void in
                    if let error = error {
                        failure(error)
                    } else {
                        if let result = result as? [String : Any] {
                            success(result)
                        }else{
                            let err = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Something went wrong"])
                            failure(err)
                        }
                    }
                })
            }else{
                failure(error)
            }
        })
    }

    func shareVideoWithCaptionOnFacebook(withViewController vc : UIViewController,
                                         _ videoUrl: String,
                                         _ captionText: String,
                                         success: @escaping (([String:Any]) -> Void),
                                         failure: @escaping ((Error?) -> Void)) {
        
        self.loginWithSharePermission(fromViewController: vc, completion: { (result, error) in
            
            if error == nil,let token = result?.token,let tokenString = token.tokenString {
                let param: [String:Any] = [ "url" : videoUrl, "caption" : captionText, "access_token" : tokenString]
                
                let request = self.getGraphRequest(graphPath: "me/videos", parameters: param, httpMethod: "POST")
                request.start(completionHandler: { (connection, result, error) -> Void in
                    if let error = error {
                        failure(error)
                    } else {
                        if let result = result as? [String : Any] {
                            success(result)
                        }else{
                            let err = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "Something went wrong"])
                            failure(err)
                        }
                    }
                })
            }else{
                failure(error)
            }
        })
    }

    
    // MARK:- FACEBOOK FRIENDS
    //==========================
    func fetchFacebookFriendsUsingThisAPP(withViewController vc: UIViewController, shouldFetchFriends: Bool = false, success: @escaping (([String:Any]) -> Void),
                              failure: @escaping ((Error?) -> Void)){
        
            self.loginWithFacebook(fromViewController: vc, shouldFetchFriends: shouldFetchFriends, completion: { (result, err) in
                
                self.fetchFriends(success: { (result) in
                    
                    success(result)
                    
                }, failure: { (err) in
                    
                    failure(err)
                    
                })

            })
    }
    
    private func fetchFriends(success: @escaping (([String:Any]) -> Void),
                              failure: @escaping ((Error?) -> Void)){

        let params = ["fields": "email, name, gender, first_name, last_name, birthday, cover, currency, devices, education, hometown, is_verified, link, locale, location, relationship_status, website, work, picture.type(large)"]
        let request: FBSDKGraphRequest = self.getGraphRequest(graphPath: "me/friends", parameters: params, httpMethod: "GET")
        
        request.start { (connection: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
            
            if let result = result as? [String:Any] {
                success(result)
            } else {
                failure(error)
            }
        }

    }
    
    private func getGraphRequest(graphPath: String, parameters: [String: Any], httpMethod: String) -> FBSDKGraphRequest {
        return FBSDKGraphRequest(graphPath: graphPath, parameters: parameters, tokenString: FBSDKAccessToken.current()?.tokenString, version: nil, httpMethod: httpMethod)
    }
    
    func fetchFacebookFriendsNotUsingThisAPP(viewController : UIViewController, success: @escaping (([String:Any]) -> Void),
                                          failure: @escaping ((Error?) -> Void)){
        
        FBSDKLoginManager().logIn(withPublishPermissions: ["taggable_friends"], from: viewController, handler: { (result, error) in
            
            if let res = result,res.isCancelled {
                failure(error)
            }else{
                if error == nil {
                    let request: FBSDKGraphRequest = self.getGraphRequest(graphPath: "me/taggable_friends", parameters: ["fields": "name"], httpMethod: "GET")
                    
                    request.start { (connection: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
                        
                        if let result = result as? [String:Any] {
                            success(result)
                        } else {
                            failure(error)
                        }
                    }
                }else{
                    failure(error)
                }
            }
        })

    }

    // MARK:- FACEBOOK LOGOUT
    //=========================
    func facebookLogout(){
        FBSDKAccessToken.setCurrent(nil)
        FBSDKLoginManager().logOut()
//        let cooki  : HTTPCookieStorage! = HTTPCookieStorage.shared
//        if let strorage = HTTPCookieStorage.shared.cookies{
//            for cookie in strorage{
//                cooki.deleteCookie(cookie)
//            }
//        }
    }
    
}

// MARK: FACEBOOK MODEL
//=======================
struct FacebookModel {
    
    var dictionary : [String:Any]!
    let id: String
    var email = ""
    var name = ""
    var first_name = ""
    var last_name = ""
    var currency = ""
    var link = ""
//    var gender: Gender
    var verified = ""
    var password = ""
    var cover: URL?
    var picture: URL?
    var is_verified : Bool
    var image : String = ""
    let authToken = FacebookController.shared.currentAccessToken
    
//    FBSDKAccessToken.current()
    
    init(withJSON json: JSON) {
        
        self.dictionary = json.dictionaryValue
        
        self.id         = json["id"].stringValue
        self.name       = json["name"].stringValue
        self.first_name = json["first_name"].stringValue
        self.email      = json["email"].stringValue
        
//        self.gender     = Gender(stringValue: json["gender"].stringValue)
        
        if let currencyDict = json["currency"].dictionary{
            
            self.currency = (currencyDict["user_currency"]?.stringValue)!
        }
        
        if let picture = json["picture"].dictionary, let data = picture["data"] {
            
            self.image = data["url"].stringValue
            self.picture = URL(string: data["url"].stringValue)
            
        }
        
        if let cover = json["cover"].dictionary {
            
            self.cover = URL(string: (cover["source"]?.stringValue)!)
            
        }
        
        self.link        = json["link"].stringValue
        self.last_name   = json["last_name"].stringValue
        self.is_verified = json["is_verified"].string == "0" ? false : true
        self.password    = json["password"].stringValue
    }
    
}

