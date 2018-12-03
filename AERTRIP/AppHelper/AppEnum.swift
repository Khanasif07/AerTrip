//
//  AppEnum.swift
//  
//
//  Created by Pramod Kumar on 24/09/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
    static let logOut = Notification.Name("logOut")
    static let dataChanged = Notification.Name("dataChanged")
    static let sessionExpired = Notification.Name("sessionExpired")
    
}

//MARK:- Applicaion Response Code From Server
//MARK:-
enum AppErrorCodeFor {
    
    static let success: Int = 200
    static let authenticationFailed: Int = 402
    static let noInternet: Int = 600
    static let parsing: Int = 601
}
