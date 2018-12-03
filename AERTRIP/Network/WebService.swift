//
//  UserService.swift
//  Veme
//
//  Created by Pramod Kumar on 04/02/16.
//  Copyright © 2016 AppInventiv. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import JSONDecoder_Keypath
import SwiftyJSON

//let ROOT_URL = "http://52.44.52.235:7000/" //Staging Server
let ROOT_URL = "http://52.44.52.235:7002/" //Dev Server

private let API_VERSION = "api/v1.0/"

var BASE_URL:String{
    return ROOT_URL+API_VERSION
}

class WebService {
    
    //webservice complition clouser, will call for success and failure both
    internal typealias CompletionClosure = (_ success : Bool, _ errorMessage: String?, _ data: Any?) -> Void
    internal typealias Progress = (_ progress : Double) -> Void
    
    enum EndPoint : String {
        
        case signup = "registration"
        case loginNormal = "login"
        case loginViaOTP = "login-by-otp"
        case verifyPhone = "verify-phone"
        case resendOTP = "resend-otp"
        case feedPost = "post-feed"
        case revemePost = "reveme"
        case resetpassword = "resetpass"
        case updateProfile = "update-profile"
        case feedList = "get-home-feeds"
        case revemesList = "get-revemes"
        case userFeedList = "get-user-feeds"
        case userDetail = "get-user-detail"
        case userLikedVemeList = "get-liked-veme"
        case followings = "get-followings"
        case followers = "get-followers"
        case saveReaction = "save-reaction-veme"
        case feedComments = "get-feed-comments"
        case feedReactions = "get-veme-reactions"
        case saveComment = "comment"
        case increaseViewCount = "increase-view-count"
        case increaseShareCount = "increase-share-count"
        case followUser = "follow-user"
        case reportFeed = "report-feed"
        case hashtags = "hashtags"
        case feedNotification = "feed-notification"
        case category = "get-category"
        case showHideVeme = "hide-feed"
        case logout = "logout"
        case forgotPass = "forgot-pass"
        case deleteFeed = "delete-feed"
        case editVeme = "edit-feed"
        case feedDetail = "get-feed-detail"
        case feedsByCaption = "get-caption-vemes"
        case popularCaption = "get-popular-caption"
        case notification = "get-activity"
        case exploreSearch = "explore-search"
        case changePassword = "change-password"
        case inviteCode = "invite-code"
        case blockUserList = "get-blocked-users"
        case blockUser = "block-user"
        case unblockUser = "unblock-user"
        case urlParser = "url-parser"
        case uploadClip = "save-clip"
        case userClips = "get-user-clips"
        case favouriteClips = "get-favourite-clips"
        case favouriteUnfavouriteClip = "favourite-clip"
        case editClip = "edit-clip"
        case deleteClip = "delete-clip"
        case updateDeviceData = "update-device-data"
        case contactSync = "contact-sync"
        case getPhoneContacts = "get-user-contacts"
        case inviteUser = "invite-user"
        case checkHandle = "check-handle"
        case clipBoard = "clip-board"
        case getCategoryClips = "get-category-clips"
        case clipBoardSearch = "clip-board-search"
        case getRelatedClips = "get-related-clips"
        case randomClipCaption = "get-random-clip-caption"
        case randomClipCategory = "get-caption-category"
        case randomClips = "get-random-clips"
        case getRevemeUsers = "get-reveme-user"
        case searchUsers = "get-user-list"
        case subcategory = "get-sub-category"
        var path : String {
            return BASE_URL + self.rawValue
        }
    }
    
    enum BlockUnblock {
        case block
        case unblock
    }
    
}

//MARK:-***************************************
//MARK:***************************************
//MARK: Web Services using GET HTTP method
//MARK:***************************************
//MARK:-***************************************

extension WebService {
    
    //MARK: - Delete Clip API -
    static func deleteClip(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ message: String)->Void ) {
        AppNetworking.DELETE(endPoint: WebService.EndPoint.deleteClip, parameters: params, loader: loader, success: { (data) in
            handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(sucess, jsonData["message"].stringValue)
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription)
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription)
        }
    }
    
    //MARK: - EditClip API -
    static func callEditClipAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ message: String)->Void ) {
        let endpoint = WebService.EndPoint.editClip
        AppNetworking.PUT(endPoint: endpoint, parameters: params, loader: loader, success: { (data) in
            handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, jsonData["error_string"].stringValue)
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription)
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription)
        }
    }
    
    
    //MARK: - Block/Unblock a user API -
    static func callBlockOrUnBlockUserAPI(params: JSONDictionary,blockUnblock:BlockUnblock,  loader:Bool = true, completionBlock: @escaping(_ success: Bool, _ message: String)-> Void) {
        
        let point = blockUnblock == .block ? WebService.EndPoint.blockUser : WebService.EndPoint.unblockUser
        
        AppNetworking.POST(endPoint: point, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, jsonData["error_string"].stringValue)
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription)
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription)
        }
    }
    
    //MARK: - Blocked User List API -
    static func callBlockedUserListAPI(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String, _ data: [UserInfo], _ nextCount:Int?)->Void)){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.blockUserList, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                var commentItemArr = [UserInfo]()
                data["result"].arrayValue.forEach({ (value) in
                    let commentItem = UserInfo(json: value)
                    commentItemArr.append(commentItem)
                })
                completionBlock(true, "", commentItemArr, data["next_count"].intValue)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, [], nil)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, [], nil)
        }
    }
    
    //MARK:- Invite code API -
    static func callInviteCodeAPI(params: JSONDictionary, locader:Bool = true, completionBlock: @escaping(_ success: Bool, _ message: String)-> Void ) {
        AppNetworking.POST(endPoint: WebService.EndPoint.inviteCode, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(sucess, jsonData["message"].stringValue)
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription)
        }
    }
    //MARK:- Invite code API -
    static func updateDeviceData(completionBlock: @escaping(_ success: Bool, _ message: String)-> Void ) {
        
        AppNetworking.POST(endPoint: WebService.EndPoint.updateDeviceData, parameters: [:], headers: [:], loader: false, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                completionBlock(sucess, jsonData["message"].stringValue)
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription)
        }
    }
    //MARK:- ChangePassword API -
    static func callChangePasswordAPI(params: JSONDictionary, locader:Bool = true, completionBlock: @escaping(_ success: Bool, _ message: String)-> Void ) {
        
        AppNetworking.POST(endPoint: WebService.EndPoint.changePassword,parameters:params, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(sucess, jsonData["error_string"].stringValue)
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription)
        }
    }
    
    
    //MARK:- Get the Clips For Perticular Category
    class func getClipCategories(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.getCategoryClips, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                guard sucess else {return}
                
                var clipCategoryItemArr = [ClipCategoryItem]()
                let clipCategoryItems = data["result"]["subcategory"].arrayValue
                clipCategoryItems.forEach({ (value) in
                    clipCategoryItemArr.append(ClipCategoryItem(json: value))
                })
                
                var clipItemArr = [ClipItem]()
                let clips = data["result"]["clips"]["result"].arrayValue
                clips.forEach({ (value) in
                    clipItemArr.append(ClipItem(json: value))
                })
                
                var nextUrl = data["result"]["clips"]["next_url"].stringValue
                if !nextUrl.isEmpty{
                    nextUrl = ROOT_URL+nextUrl
                }
                let nextCount = data["result"]["clips"]["next_count"].intValue
                
                completionBlock(true, nil, (clipCategoryItemArr, clipItemArr, nextUrl, nextCount))
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- Get Next Page Data for clips
    class func hitPagginURLForClips(_ paggingURL: String, loader:Bool = true, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.GET(endPoint: paggingURL, parameters: [:], loader:false, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                guard sucess else {return}
                
                var clipCategoryItemArr = [ClipCategoryItem]()
                let clipCategoryItems = data["result"]["subcategory"].arrayValue
                clipCategoryItems.forEach({ (value) in
                    clipCategoryItemArr.append(ClipCategoryItem(json: value))
                })
                
                var clipItemArr = [ClipItem]()
                let clips = data["result"]["clips"]["result"].arrayValue
                clips.forEach({ (value) in
                    clipItemArr.append(ClipItem(json: value))
                })
                
                var nextUrl = data["result"]["clips"]["next_url"].stringValue
                if !nextUrl.isEmpty{
                    nextUrl = ROOT_URL+nextUrl
                }
                let nextCount = data["result"]["clips"]["next_count"].intValue
                
                completionBlock(true, nil, (clipCategoryItemArr, clipItemArr, nextUrl, nextCount))
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- Get the Clips For Perticular Category
    class func getSubCategories(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.subcategory, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                guard sucess else {return}
                
                var clipCategoryItemArr = [ClipCategoryItem]()
                let clipCategoryItems = data["result"].arrayValue
                clipCategoryItems.forEach({ (value) in
                    clipCategoryItemArr.append(ClipCategoryItem(json: value))
                })
                
//                var clipItemArr = [ClipItem]()
//                let clips = data["result"]["clips"]["result"].arrayValue
//                clips.forEach({ (value) in
//                    clipItemArr.append(ClipItem(json: value))
//                })
//
//                var nextUrl = data["result"]["clips"]["next_url"].stringValue
//                if !nextUrl.isEmpty{
//                    nextUrl = ROOT_URL+nextUrl
//                }
//                let nextCount = data["result"]["clips"]["next_count"].intValue
                
                completionBlock(true, nil, clipCategoryItemArr)
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- Get the Clips based on search text
    class func getSearchedClips(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.clipBoardSearch, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                guard sucess else {return}
                
                var clipItemArr = [ClipItem]()
                let clips = data["result"]["clips"].arrayValue
                clips.forEach({ (value) in
                    clipItemArr.append(ClipItem(json: value))
                })
                
                var tagArr = [String]()
                let tags = data["result"]["tags"].arrayValue
                tags.forEach({ (value) in
                    tagArr.append(value["key"].stringValue)
                })
                
                completionBlock(true, nil, (clipItemArr, tagArr))
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- Get data from clip library
    class func getCategories(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?)->Void)){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.category, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                var newData = jsonData.dictionaryObject ?? [:]
                let clipData = ClipCategoryItem.createClipLibraryItems(info: jsonData["result"].arrayValue)
                newData["stored_data"] = clipData
                completionBlock(true, nil,newData)
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- Get User Details
    class func getUserDetail(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?, _ nextCount:Int?)->Void)){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.userDetail, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                if !jsonData["result"]["user_id"].stringValue.isEmpty {
                    
                    if let loggedInUser = UserInfo.loggedInUser, jsonData["result"]["user_id"].stringValue == loggedInUser.userId {
                        
                        loggedInUser.update(withJSON: jsonData["result"])
                        UserDefaults.setObject(loggedInUser.toDict, forKey: UserDefaultKeys.loggedInUser)
                        completionBlock(true, nil, loggedInUser, nil)
                    }
                    else {
                        completionBlock(true, nil, UserInfo(json: jsonData["result"]), nil)
                    }
                }
                completionBlock(false, "result not found", nil, nil)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil, nil)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil, nil)
        }
    }
    
    //MARK:- Get feeds
    class func getFeeds(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?, _ nextCount:Int?)->Void)){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.feedList, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                var feedItemArr = [VemeItem]()
                data["result"].arrayValue.forEach({ (value) in
                    let feedItem = VemeItem(json: value)
                    feedItemArr.append(feedItem)
                })
                completionBlock(true, nil, feedItemArr, data["next_count"].intValue)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil, nil)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil, nil)
        }
    }
    
    //MARK:- Get feeds by caption
    class func getFeedsByCaption(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?, _ nextCount:Int?)->Void)){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.feedsByCaption, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                var feedItemArr = [VemeItem]()
                data["result"].arrayValue.forEach({ (value) in
                    let feedItem = VemeItem(json: value)
                    feedItemArr.append(feedItem)
                })
                completionBlock(true, nil, feedItemArr, data["next_count"].intValue)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil, nil)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil, nil)
        }
    }
    //MARK:- Get feed detail
    class func getFeedDetail(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?)->Void)){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.feedDetail, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                let feedItem = VemeItem(json: data["result"])
                completionBlock(true, nil, feedItem)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- Get feeds
    class func getExploreData(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?, _ nextCount:Int?)->Void)){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.popularCaption, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                do{
                    let decoder = JSONDecoder()
                    
                    //                    let formatter = DateFormatter()
                    //                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    //                    decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.formatted(formatter)
                    decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.secondsSince1970
                    let feedItemArr = try decoder.decode([SearchItem].self, from: data.toData!, keyPath: "result")
                    completionBlock(true, nil, feedItemArr, data["next_count"].intValue)
                }
                catch let error{
                    printD(error)
                    completionBlock(false, error.localizedDescription, nil, nil)
                }
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil, nil)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil, nil)
        }
    }
    //MARK:- Get feeds
    class func getExploreSearchData(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?, _ nextCount:Int?)->Void)){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.exploreSearch, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                do{
                    let decoder = JSONDecoder()
                    
                    //                    let formatter = DateFormatter()
                    //                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    //                    decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.formatted(formatter)
                    decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.secondsSince1970
                    let captionArr = try decoder.decode([SearchItem].self, from: data.toData!, keyPath: "result.caption")
                    let channelArr = try decoder.decode([SearchItem].self, from: data.toData!, keyPath: "result.channels")
                    let hashtagArr = try decoder.decode([SearchItem].self, from: data.toData!, keyPath: "result.hashtags")
                    let influencerArr = try decoder.decode([SearchItem].self, from: data.toData!, keyPath: "result.influencers")
                    
                    completionBlock(true, nil, (captionArr,channelArr,hashtagArr,influencerArr), data["next_count"].intValue)
                }
                catch let error{
                    printD(error)
                    completionBlock(false, error.localizedDescription, nil, nil)
                }
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil, nil)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil, nil)
        }
    }
    //MARK:- Get Revemes Listing
    class func getRevemeList(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?, _ nextCount:Int?)->Void)){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.revemesList, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                var feedItemArr = [VemeItem]()
                data["result"].arrayValue.forEach({ (value) in
                    let feedItem = VemeItem(json: value)
                    feedItemArr.append(feedItem)
                })
                completionBlock(true, nil, feedItemArr, data["next_count"].intValue)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil, nil)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil, nil)
        }
    }
    
    //MARK:- Get feeds of a user / liked vemes of a user
    class func getUserFeeds(_ params: JSONDictionary, forType: ProfileVemesVC.VemeRenderType, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?, _ nextCount:Int?)->Void)){
        
        let endPoint = (forType == ProfileVemesVC.VemeRenderType.likes) ? WebService.EndPoint.userLikedVemeList : WebService.EndPoint.userFeedList
        
        AppNetworking.GET(endPoint: endPoint, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                var feedItemArr = [VemeItem]()
                data["result"].arrayValue.forEach({ (value) in
                    let feedItem = VemeItem(json: value)
                    feedItemArr.append(feedItem)
                })
                completionBlock(true, nil, feedItemArr, data["next_count"].intValue)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil, nil)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil, nil)
        }
    }
    
    //MARK:- Get followers of a user
    class func getFollowers(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?, _ nextCount:Int?)->Void)){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.followers, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                var commentItemArr = [UserInfo]()
                data["result"].arrayValue.forEach({ (value) in
                    let commentItem = UserInfo(json: value)
                    commentItemArr.append(commentItem)
                })
                completionBlock(true, nil, commentItemArr, data["next_count"].intValue)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil, nil)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil, nil)
        }
    }
    
    //MARK:- Get followers of a user
    class func getFollowings(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?, _ nextCount:Int?)->Void)){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.followings, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                var commentItemArr = [UserInfo]()
                data["result"].arrayValue.forEach({ (value) in
                    let commentItem = UserInfo(json: value)
                    commentItemArr.append(commentItem)
                })
                completionBlock(true, nil, commentItemArr, data["next_count"].intValue)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil, nil)
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil, nil)
        }
    }
    //MARK:- Get clips of a user
    class func getUserClips(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?, _ nextCount:Int?)->Void)){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.userClips, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                var clipItemArr = [ClipItem]()
                let clips = data["result"].arrayValue
                clips.forEach({ (value) in
                    clipItemArr.append(ClipItem(json: value))
                })
                completionBlock(true, nil, clipItemArr, data["next_count"].intValue)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil, nil)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil, nil)
        }
    }
    
    //MARK:- Get clips of a user
    class func getFavouriteClips(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?, _ nextCount:Int?)->Void)){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.favouriteClips, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                var clipItemArr = [ClipItem]()
                let clips = data["result"].arrayValue
                clips.forEach({ (value) in
                    clipItemArr.append(ClipItem(json: value))
                })
                completionBlock(true, nil, clipItemArr, data["next_count"].intValue)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil, nil)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil, nil)
        }
    }
    
    //MARK:- Get feed reactions
    class func getFeedReactions(_ params: JSONDictionary, loader:Bool = false, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?, _ nextCount:Int?)->Void)){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.feedReactions, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                var commentItemArr = [UserInfo]()
                data["result"].arrayValue.forEach({ (value) in
                    let commentItem = UserInfo(json: value)
                    commentItemArr.append(commentItem)
                })
                completionBlock(true, nil, commentItemArr, data["next_count"].intValue)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil, nil)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil, nil)
        }
    }
    
    //MARK:- Get feed comments
    class func getFeedComments(_ params: JSONDictionary, loader:Bool = false, loaderContainerView: UIView? = nil, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?, _ nextCount:Int?)->Void)){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.feedComments, parameters: params, loader: loader, loaderContainerView: loaderContainerView, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in

                var items = [FeedCommentItem]()
                    data["result"].arrayValue.forEach({ (value) in
                        let item = FeedCommentItem(json: value)
                        items.append(item)
                    })
                    completionBlock(true, nil, items, jsonData["next_count"].intValue)
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil, nil)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil, nil)
        }
    }
    
    //MARK:- Get hash tags
    class func getHashTags(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?)->Void)){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.hashtags, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                if let arr = (data.dictionaryObject)?["result"] as? [String] {
                    completionBlock(true, nil, arr)
                }
                else {
                    completionBlock(false, "no response", nil)
                }
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    class func getUsers(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?)->Void)){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.searchUsers, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                var commentItemArr = [UserInfo]()
                data["result"].arrayValue.forEach({ (value) in
                    
                    let commentItem = UserInfo(json: value)
                    commentItemArr.append(commentItem)
                })
                completionBlock(true, nil, commentItemArr)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    //MARK: Get url to parse video
    class func getParsedURL(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?)->Void)) {
        
        AppNetworking.POST(endPoint: WebService.EndPoint.urlParser, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                completionBlock(true, nil, jsonData)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- Get trending tags
    class func getTrendingData(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?)->Void)){
        
        let peopleArr = [SearchItem]()
        //        peopleArr.append(SearchItem(id: "1", title: "Sherlock Holmes", description: nil, image: "https://pmctvline2.files.wordpress.com/2017/01/sherlock-season-4-finale-benedict-cumberbatch.jpg"))
        //        peopleArr.append(SearchItem(id: "2", title: "Future Man (Hulu)", description: nil, image: "https://assets3.thrillist.com/v1/image/2703941/size/tl-horizontal_main.jpg"))
        //        peopleArr.append(SearchItem(id: "3", title: "Godless (Netflix)", description: nil, image: "https://assets3.thrillist.com/v1/image/2741161/size/tl-horizontal_main.jpg"))
        //        peopleArr.append(SearchItem(id: "4", title: "The Crown (Netflix)", description: nil, image: "https://assets3.thrillist.com/v1/image/2718312/size/tl-horizontal_main.jpg"))
        //        peopleArr.append(SearchItem(id: "5", title: "Sherlock Holmes", description: nil, image: "https://pmctvline2.files.wordpress.com/2017/01/sherlock-season-4-finale-benedict-cumberbatch.jpg"))
        //        peopleArr.append(SearchItem(id: "6", title: "Future Man (Hulu)", description: nil, image: "https://assets3.thrillist.com/v1/image/2703941/size/tl-horizontal_main.jpg"))
        //        peopleArr.append(SearchItem(id: "7", title: "Godless (Netflix)", description: nil, image: "https://assets3.thrillist.com/v1/image/2741161/size/tl-horizontal_main.jpg"))
        //        peopleArr.append(SearchItem(id: "8", title: "The Crown (Netflix)", description: nil, image: "https://assets3.thrillist.com/v1/image/2718312/size/tl-horizontal_main.jpg"))
        
        
        
        var tempData = JSONDictionary()
        tempData["peoples"] = peopleArr
        
        if let tabbar = Global.rootTabBarController, let homeNav = tabbar.viewControllers?.first as? UINavigationController, let feedVC = homeNav.viewControllers.first as? FeedListViewController {
            tempData["vemes"] = feedVC.feedItemArr
            for itm in feedVC.feedItemArr{
                printD(itm.nsfw)
            }
        }
        completionBlock(true, nil, tempData)
        
        
        //        printServiceCalling(endPoint: WebService.EndPoint.hashtags, parameters: params)
        //        AppNetworking.GET(endPoint: WebService.EndPoint.hashtags, parameters: params, loader: loader, success: { (data) in
        //
        //            printServiceResponse(endPoint: WebService.EndPoint.hashtags, data: data)
        //
        //            handleResponse(data.toJSON as? JSONDictionary, success: { (sucess, jsonData) in
        //                if let arr = (data.toJSON as? JSONDictionary)?["result"] as? [String] {
        //                    completionBlock(true, nil, arr)
        //                }
        //                else {
        //                    completionBlock(false, "no response", nil)
        //                }
        //            }, failure: { (error) in
        //                completionBlock(false, error.localizedDescription, nil)
        //
        //            })
        //        }) { (error) in
        //            completionBlock(false, error.localizedDescription, nil)
        //        }
    }
    
    
    //MARK:- Get hash tags
    class func getNotifications(_ params: JSONDictionary, loader:Bool = false, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?, _ nextCount:Int?)->Void)){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.notification, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                var notificationInfoArr = [NotificationInfo]()
                data["result"].arrayValue.forEach({ (value) in
                    let notificationInfo = NotificationInfo(json: value)
                    notificationInfoArr.append(notificationInfo)
                })
                completionBlock(true, nil, notificationInfoArr, data["next_count"].intValue)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil, -1)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil, -1)
        }
    }
    
    //MARK:- Get Next Page Data for clips
    class func hitPagginURLForClip(_ paggingURL: String, loader:Bool = true, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.GET(endPoint: paggingURL, parameters: [:], loader:false, success: { (data) in
            
            self.handleResponse(data, success: { (sucess, jsonData) in
                
                var newData = jsonData.dictionaryObject ?? [:]
                let clips = ClipCategoryItem.createClipLibraryItems(info: jsonData["result"].arrayValue)
                newData["stored_data"] = clips as AnyObject
                completionBlock(true, nil, newData)
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    
    //MARK:- Get user's phone contacts
    class func getPhonebookContatcs(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?, _ nextCount:Int?)->Void)){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.getPhoneContacts, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                do{
                    let decoder = JSONDecoder()
                    let itemArr = try decoder.decode([ContactUser].self, from: data.toData!, keyPath: "result")
                    completionBlock(true, nil, itemArr, data["next_count"].intValue)
                }
                catch let error{
                    printD(error)
                    completionBlock(false, error.localizedDescription, nil, nil)
                }
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil, nil)
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil, nil)
        }
    }
    
    //MARK:- Get user's phone contacts
    class func getGoogleContatcs(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?, _ nextCount:Int?)->Void)){
        
        let url = "https://www.google.com/m8/feeds/contacts/default/full"
        
        AppNetworking.GET(endPoint:url, parameters: params, loader: loader, success: { (data) in
            
            let contactsJSON = data["feed"]["entry"].arrayValue
            let contacts = ContactUser.contactUsers(from: contactsJSON)
            completionBlock(true, nil, contacts, -1)
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil, nil)
        }
    }
    
    //MARK:- Get clips
    class func getClips(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?, _ nextCount:Int?)->Void)){
        
        AppNetworking.GET(endPoint:WebService.EndPoint.clipBoard, parameters: params, loader: loader, success: { (json) in
            
            let clipData = ClipCategoryItem.createClipLibraryItems(info: json["result"]["category"].arrayValue)
            
            var channels = [ClipChannel]()
            json["result"]["channels"].arrayValue.forEach({ (item) in
                channels.append(ClipChannel(json: item))
            })
            completionBlock(true, nil, (clipData, channels, json["result"]["trending_clip"]["tag"].stringValue), json["next_count"].intValue)
            
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil, nil)
        }
    }
    
    //MARK:- Get clips
    class func getRelatedClipsOfAClip(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?)->Void)){
        
        AppNetworking.GET(endPoint:WebService.EndPoint.getRelatedClips, parameters: params, loader: loader, success: { (json) in
            
            var clipItemArr = [ClipItem]()
            let clips = json["result"].arrayValue
            clips.forEach({ (value) in
                clipItemArr.append(ClipItem(json: value))
            })
            
            var nextUrl = json["next_url"].stringValue
            if !nextUrl.isEmpty{
                nextUrl = ROOT_URL+nextUrl
            }
            let nextCount = json["next_count"].intValue
            
            completionBlock(true, nil, (clipItemArr, nextUrl, nextCount))
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    class func getMoreRelatedClipsOfAClip(url: String, loader:Bool = false, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?)->Void)){
        
        AppNetworking.GET(endPoint: url, parameters: [:], loader: loader, success: { (json) in
            
            var clipItemArr = [ClipItem]()
            let clips = json["result"].arrayValue
            clips.forEach({ (value) in
                clipItemArr.append(ClipItem(json: value))
            })
            
            var nextUrl = json["next_url"].stringValue
            if !nextUrl.isEmpty{
                nextUrl = ROOT_URL+nextUrl
            }
            let nextCount = json["next_count"].intValue
            
            completionBlock(true, nil, (clipItemArr, nextUrl, nextCount))
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- GET RANDOM CLIP CAPTION
    class func getRandomClipCaption(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?)->Void)){
        
        AppNetworking.GET(endPoint:WebService.EndPoint.randomClipCaption, parameters: params, loader: loader, success: { (json) in
            
            var captions = [RandomCaption]()
            json["result"].arrayValue.forEach({ (item) in
                captions.append(RandomCaption(json: item))
            })
            completionBlock(true, nil, captions)
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    //MARK:- GET RANDOM CLIPS
    class func getRandomClips(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?)->Void)){
        
        AppNetworking.GET(endPoint:WebService.EndPoint.randomClips, parameters: params, loader: loader, success: { (json) in
            
            var clips = [ClipItem]()
            json["result"].arrayValue.forEach({ (item) in
                clips.append(ClipItem(json: item))
            })
            completionBlock(true, nil, (clips, json["next_url"].stringValue, json["next_count"].intValue))
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    //MARK:- GET RANDOM CLIP CATEGOIRES
    class func getRandomClipCategories(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?)->Void)){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.randomClipCategory, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                var newData = jsonData.dictionaryObject ?? [:]
                let clipData = ClipCategoryItem.createClipLibraryItems(info: jsonData["result"].arrayValue)
                newData["stored_data"] = clipData
                completionBlock(true, nil,newData)
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- GET RANDOM CLIP CATEGOIRES
    class func getRevemeUsers(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping ((_ success : Bool, _ errorMessage: String?, _ data: Any?)->Void)){
        
        AppNetworking.GET(endPoint: WebService.EndPoint.getRevemeUsers, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                var commentItemArr = [UserInfo]()
                data["result"].arrayValue.forEach({ (value) in
                    let commentItem = UserInfo(json: value)
                    commentItemArr.append(commentItem)
                })
                completionBlock(true, "", commentItemArr)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, [])
                
            })
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
}

//MARK:-***************************************
//MARK:***************************************
//MARK: Web Services using POST HTTP method
//MARK:***************************************
//MARK:-***************************************

extension WebService {
    
    //MARK:- Signup User
    class func signupUser(_ params: JSONDictionary, feedPath:String, loader:Bool = true, completionBlock: @escaping CompletionClosure){
        
        let multiPartTuple = (key: "user_image", filePath: feedPath, fileExtention: "png", fileType: AppNetworking.MultiPartFileType.image)
        
        AppNetworking.POSTWithMultiPart(endPoint: WebService.EndPoint.signup, parameters: params, multipartData: [multiPartTuple], success: { (data) in
            
            FileManager.removeFile(atPath: feedPath)
            handleResponse(data, success: { (sucess, jsonData) in
                
                if !jsonData["result"]["user_id"].stringValue.isEmpty {
                    
                    let loggedInUser = UserInfo(json: jsonData["result"])
                    UserDefaults.setObject(loggedInUser.toDict, forKey: UserDefaultKeys.loggedInUser)
                    
                    completionBlock(true, nil, nil)
                }
                completionBlock(false, nil, nil)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
            
        }, progress: { (prgrs) in
            printD("Uploading... \(prgrs)")
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- Update User Profile
    class func updateProfile(_ params: JSONDictionary, feedPath:String, loader:Bool = true, completionBlock: @escaping CompletionClosure){
        
        let multiPartTuple = (key: "user_image", filePath: feedPath, fileExtention: "png", fileType: AppNetworking.MultiPartFileType.image)
        
        AppNetworking.POSTWithMultiPart(endPoint: WebService.EndPoint.updateProfile, parameters: params, multipartData: [multiPartTuple], success: { (data) in
            
            FileManager.removeFile(atPath: feedPath)
            handleResponse(data, success: { (sucess, jsonData) in
                
                if !jsonData["result"]["user_id"].stringValue.isEmpty {
                    if let loggedInUser = UserInfo.loggedInUser{
                        loggedInUser.update(withJSON: jsonData["result"])
                        UserDefaults.setObject(loggedInUser.toDict, forKey: UserDefaultKeys.loggedInUser)
                    }
                    completionBlock(true, nil, nil)
                }
                completionBlock(false, nil, nil)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
            
        }, progress: { (prgrs) in
            printD("Uploading... \(prgrs)")
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- Login
    class func loginUser(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.POST(endPoint: WebService.EndPoint.loginNormal, parameters: params, headers: [:], loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                if !jsonData["result"]["user_id"].stringValue.isEmpty{
                    if let _ = params["calling_code"] as? String {
                        //calling from login by contact
                        completionBlock(true, nil, jsonData["result"]["user_id"].stringValue)
                    }
                    else {
                        //calling from login by email
                        let loggedInUser = UserInfo(json: jsonData["result"])
                        UserDefaults.setObject(loggedInUser.toDict, forKey: UserDefaultKeys.loggedInUser)
                        completionBlock(true, nil, nil)
                    }
                }
                completionBlock(false, nil, nil)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- Login via otp
    class func loginViaOTP(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.POST(endPoint: WebService.EndPoint.loginViaOTP, parameters: params, headers: [:], loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                if !jsonData["result"]["user_id"].stringValue.isEmpty{
                    
                    let loggedInUser = UserInfo(json: jsonData["result"])
                    UserDefaults.setObject(loggedInUser.toDict, forKey: UserDefaultKeys.loggedInUser)
                    
                    completionBlock(true, nil, nil)
                }
                completionBlock(false, nil, nil)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- resend otp for verification
    class func resendOtpForVerification(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.POST(endPoint: WebService.EndPoint.resendOTP, parameters: params, headers: [:], loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, nil, nil)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- resend otp for verification
    class func verifyPhoneNo(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.POST(endPoint: WebService.EndPoint.verifyPhone, parameters: params, headers: [:], loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, nil, nil)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- forgotpassword
    class func forgotPassword(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.POST(endPoint: WebService.EndPoint.forgotPass, parameters: params, headers: [:], loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, jsonData["error_string"].string ?? "A reset link has been sent to your registered email.", nil)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- Login
    class func logoutUser(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.POST(endPoint: WebService.EndPoint.logout, parameters: params, headers: [:], loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                if sucess {
                    completionBlock(true, nil, nil)
                }
                completionBlock(false, nil, nil)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- Post Veme
    class func postVeme(_ params: JSONDictionary, multipartData : [(key:String, filePath:String, fileExtention:String, fileType:AppNetworking.MultiPartFileType)]? = [], loader:Bool = false, progress: @escaping Progress, completionBlock: @escaping CompletionClosure){
        
        var endPoint = WebService.EndPoint.feedPost
        if let id = params["veme_id"] as? String, !id.isEmpty {
            endPoint = WebService.EndPoint.revemePost
        }
        
        AppNetworking.POSTWithMultiPart(endPoint: endPoint, parameters: params, multipartData: multipartData, loader: loader, success: { (data) in
            
            completionBlock(true, nil, nil)
            
        }, progress: { (prgrs) in
            progress(prgrs)
            printD("Uploading... \(prgrs)")
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- Post Veme
    class func postClip(_ params: JSONDictionary, multipartData : [(key:String, filePath:String, fileExtention:String, fileType:AppNetworking.MultiPartFileType)]? = [], loader:Bool = false, progress: @escaping Progress, completionBlock: @escaping CompletionClosure){
        
        let endPoint = WebService.EndPoint.uploadClip
        
        AppNetworking.POSTWithMultiPart(endPoint: endPoint, parameters: params, multipartData: multipartData, loader: loader, success: { (data) in
            
            completionBlock(true, nil, nil)
            
        }, progress: { (prgrs) in
            progress(prgrs)
            printD("Uploading... \(prgrs)")
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    //MARK:- make Clip Favourite Unfavourite
    class func makeClipFavouriteUnfavourite(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.POST(endPoint: WebService.EndPoint.favouriteUnfavouriteClip, parameters: params, headers: [:], loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, nil, nil)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- Get feeds
    class func saveReaction(_ params: JSONDictionary, loader:Bool = false, completionBlock: @escaping CompletionClosure){
        
        
        AppNetworking.POST(endPoint: WebService.EndPoint.saveReaction, parameters: params, headers: [:], loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, nil, jsonData)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- Save Comment
    class func saveComment(_ params: JSONDictionary, loader:Bool = false, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.POST(endPoint: WebService.EndPoint.saveComment, parameters: params, headers: [:], loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, nil, nil)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- Increase Veme veme count
    class func increaseViewCount(_ params: JSONDictionary, loader:Bool = false, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.POST(endPoint: WebService.EndPoint.increaseViewCount, parameters: params, headers: [:], loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, nil, nil)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- Increase Veme share count
    class func increaseShareCount(_ params: JSONDictionary, loader:Bool = false, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.POST(endPoint: WebService.EndPoint.increaseShareCount, parameters: params, headers: [:], loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, nil, nil)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- Follow User
    class func followUser(_ params: JSONDictionary, loader:Bool = false, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.POST(endPoint: WebService.EndPoint.followUser, parameters: params, headers: [:], loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, nil, nil)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- Report veme
    class func reportVeme(_ params: JSONDictionary, loader:Bool = false, completionBlock: @escaping CompletionClosure){
        
        
        AppNetworking.POST(endPoint: WebService.EndPoint.reportFeed, parameters: params, headers: [:], loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, nil, jsonData)
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    //MARK:- Turn notification on/off for veme
    class func changeVemeNotificationStatus(_ params: JSONDictionary, loader:Bool = false, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.POST(endPoint: WebService.EndPoint.feedNotification, parameters: params, headers: [:], loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, nil, jsonData)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    //MARK:- Show/Hide a veme
    class func changeVemeVisibilityStatus(_ params: JSONDictionary, loader:Bool = false, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.POST(endPoint: WebService.EndPoint.showHideVeme, parameters: params, headers: [:], loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, nil, jsonData)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    class func syncPhoneContacts(_ params: JSONDictionary, loader:Bool = false, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.POST(endPoint: WebService.EndPoint.contactSync, parameters: params, headers: [:], loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, nil, jsonData)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    class func inviteFriends(_ params: JSONDictionary, loader:Bool = false, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.POST(endPoint: WebService.EndPoint.inviteUser, parameters: params, headers: [:], loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, nil, jsonData)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
    
    class func checkHandleAvailability(_ params: JSONDictionary, loader:Bool = false, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.POST(endPoint: WebService.EndPoint.checkHandle, parameters: params, headers: [:], loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, nil, jsonData)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
}


//MARK:-***************************************
//MARK:***************************************
//MARK: Web Services using DELETE HTTP method
//MARK:***************************************
//MARK:-***************************************

extension WebService {
    
    //MARK:- Signup User
    class func deleteVeme(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.DELETE(endPoint: WebService.EndPoint.deleteFeed, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                completionBlock(true, nil, jsonData)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
}

//MARK:-***************************************
//MARK:***************************************
//MARK: Web Services using PUT HTTP method
//MARK:***************************************
//MARK:-***************************************

extension WebService {
    
    class func updateVeme(_ params: JSONDictionary, loader:Bool = true, completionBlock: @escaping CompletionClosure){
        
        AppNetworking.PUT(endPoint: WebService.EndPoint.editVeme, parameters: params, loader: loader, success: { (data) in
            
            handleResponse(data, success: { (sucess, jsonData) in
                
                completionBlock(sucess, nil, nil)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription, nil)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription, nil)
        }
    }
}


//MARK:- Extension For Handling Response For All Webservices
//MARK:-
extension WebService {
    
    internal typealias complitionClosure = ((_ success : Bool, _ JSON : JSON) -> Void)
    internal typealias failureClosure = ((_ error : NSError) -> Void)
    
    //Common handler/parser for all webservices response
    fileprivate class func handleResponse(_ response: JSON, success: complitionClosure, failure: failureClosure) {
        
        if response["error_code"].intValue == AppResponseCodeFor.Success {
            //Success Handling
            success(true, response)
        }
        else if response["error_code"].intValue == AppResponseCodeFor.AuthenticationFailed {
            //logout the user forcely and send user to home screen.
            
            //delete all logged in user data
            Global.clearLoginData()
            DispatchQueue.mainAsync {
                Global.setupRootViewController(ignoreProfileCompletion: true)
            }
        }
        else if !response["error_code"].stringValue.isEmpty {
            //Handling for other cases
            let errorstr = response["errorstr"].string ?? response["error_string"].stringValue
            //let err = NSError(domain: errorstr, code: status, userInfo: [:])
            let err = NSError(localizedDescription: errorstr, domain: errorstr, code: response["error_code"].intValue)
            failure(err)
        }
    }
}
