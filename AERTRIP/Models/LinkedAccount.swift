//
//  LinkedAccount.swift
//  AERTRIP
//
//  Created by Admin on 15/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

struct LinkedAccount {
    
    enum SocialType: String {
        case linkedin = "linkedin_oauth2"
        case facebook = "facebook"
        case google = "google"
        case none = "none"
        
        var priority: Int {
            switch self {
                
            case .facebook:
                return 1
                
            case .google:
                return 2
                
            case .linkedin:
                return 3
                
            default:
                return 0
            }
        }
        
        var socialTitle: String {
            switch self {
                
            case .facebook:
                return LocalizedString.Facebook.localized
                
            case .google:
                return LocalizedString.Google.localized
                
            case .linkedin:
                return LocalizedString.LinkedIn.localized
                
            default:
                return ""
            }
        }
        
        var socialIconImage: UIImage? {
            switch self {
                
            case .facebook:
                return #imageLiteral(resourceName: "linkFacebook")
                
            case .google:
                return #imageLiteral(resourceName: "linkGoogle")
                
            case .linkedin:
                return #imageLiteral(resourceName: "linkLinkedIn")

            default:
                return nil
            }
        }
    }
    
    var autoShare: String = ""
    var eid: String = ""
    private var _socialType: String = ""
    var email: String = ""
    var photo: String = ""
    var socialType: SocialType {
        return SocialType(rawValue: self._socialType) ?? .none
    }
    
    init() {
        self.init(json: [:])
    }
    
    init(json: JSONDictionary) {
        if let obj = json[APIKeys.auto_share.rawValue] {
            self.autoShare = "\(obj)".removeNull
        }
        
        if let obj = json[APIKeys.eid.rawValue] {
            self.eid = "\(obj)".removeNull
        }
        
        if let obj = json[APIKeys.service.rawValue] {
            self._socialType = "\(obj)".removeNull
        }
        
        if let obj = json[APIKeys.email.rawValue] {
            self.email = "\(obj)".removeNull
        }
        
        if let obj = json[APIKeys.photo.rawValue] {
            self.photo = "\(obj)".removeNull
        }
    }
    
    static func fetchModelsForLinkedAccounts(data: JSONDictionary) -> [LinkedAccount] {
        var temp = [LinkedAccount]()
        var isFBDone: Bool = false, isGLDone: Bool = false, isLIDone: Bool = false
        for key in Array(data.keys) {
            if let dict = data[key] as? JSONDictionary {
                let laObj = LinkedAccount(json: dict)
                
                switch laObj.socialType {
                    
                case .facebook:
                    isFBDone = true
                    
                case .google:
                    isGLDone = true
                    
                case .linkedin:
                    isLIDone = true
                    
                default:
                    printDebug("")
                }
                
                temp.append(laObj)
            }
        }
        
        if !isFBDone {
            var laObj = LinkedAccount(json: [:])
            laObj._socialType = SocialType.facebook.rawValue
            temp.append(laObj)
        }
        
        if !isGLDone {
            var laObj = LinkedAccount(json: [:])
            laObj._socialType = SocialType.google.rawValue
            temp.append(laObj)
        }
        
        if !isLIDone {
            var laObj = LinkedAccount(json: [:])
            laObj._socialType = SocialType.linkedin.rawValue
            temp.append(laObj)
        }
        
        var connected = temp.filter { (la) -> Bool in
            !la.eid.isEmpty
        }
        
        var disconnected = temp.filter { (la) -> Bool in
            la.eid.isEmpty
        }
        
        connected.sort { (la1, la2) -> Bool in
            return la1.socialType.priority < la2.socialType.priority
        }
        
        disconnected.sort { (la1, la2) -> Bool in
            return la1.socialType.priority < la2.socialType.priority
        }
        
        var new: [LinkedAccount] = connected
        new.append(contentsOf: disconnected)
        return new
    }
}
