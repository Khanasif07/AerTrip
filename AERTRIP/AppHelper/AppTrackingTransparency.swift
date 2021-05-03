//
//  AppTrackingTransparency.swift
//  AERTRIP
//
//  Created by Admin on 03/05/21.
//  Copyright © 2021 Pramod Kumar. All rights reserved.
//

import Foundation
import  AppTrackingTransparency

@objc class AppTransparencyManager:NSObject{
    
    
    @objc class func askForPermission(){
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { (status) in
                switch status{
                case .notDetermined: printDebug("Not Determined status")
                case .restricted:
                    printDebug("Not Determined status")
                case .denied:
                    printDebug("Denied status")
                case .authorized:
                    printDebug("Authorized status")
                @unknown default:
                    printDebug("unknown status")
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    @available(iOS 14, *)
    @objc class var currentStatus:ATTrackingManager.AuthorizationStatus{
        ATTrackingManager.trackingAuthorizationStatus
    }
    
    
}


