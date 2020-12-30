//
//  VersionControler.swift
//  AERTRIP
//
//  Created by Admin on 29/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class VersionControler {
    
    
    func checkForUpdate() {
        
        let params : JSONDictionary = [APIKeys.version.rawValue : self.getAppVersion(), APIKeys.deviceId.rawValue : UIDevice.uuidString, APIKeys.deviceType.rawValue : "ios"]
        
       
        
        APICaller.shared.checkFOrUpdates(params: params) { (data, codes) in
            
//            ATAlertController.alert(title: "Update", message: "Update available", buttons: ["Cancel","Ok"]) { (action, index) in
//
//                
//            }
            
            
        }
    }
    
    
    func getAppVersion() -> String {
        guard let info = Bundle.main.infoDictionary else { return "" }
        let appVersion = info["CFBundleShortVersionString"] as? String ?? ""
        return "0.5.2.5"
        return appVersion
        
    }
    
}
