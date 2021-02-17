//
//  VersionControler.swift
//  AERTRIP
//
//  Created by Admin on 29/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class VersionControler {
    
    static let shared = VersionControler()
    var shouldCheckForUpdate : Bool
    var isForceUpdate = false
    
    init(){
        shouldCheckForUpdate = true
    }
    
    func checkForUpdate() {
        return
        if !shouldCheckForUpdate { return }
        let params : JSONDictionary = [APIKeys.version.rawValue : self.getAppVersion(), APIKeys.deviceId.rawValue : UIDevice.uuidString, APIKeys.deviceType.rawValue : "ios"]
                
        APICaller.shared.checkFOrUpdates(params: params) { (data, codes) in
            
            guard let version = data else { return }
            if version.latestVersion == version.installedVersion { return }
            
            if version.updateRequired == "1" {
                
                self.isForceUpdate = true
                self.shouldCheckForUpdate = true
                
               _ = ATAlertController.alert(title: LocalizedString.Update_Aertrip.localized, message: LocalizedString.Force_Update_Msg.localized, buttons: [LocalizedString.Update_Now.localized]){ (action, index) in
                            
                    guard let url = URL(string: "itms-apps://apple.com/app/1369238862") else { return }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
                    }
                
            } else if version.updateRequired == "0" {
                self.isForceUpdate = false
                self.shouldCheckForUpdate = false

                _ = ATAlertController.alert(title: LocalizedString.Update_Aertrip.localized, message: LocalizedString.Force_Update_Msg.localized, buttons: [LocalizedString.Update_Later.localized,LocalizedString.Update_Now.localized]){ (action, index) in
            
                    if index == 1{
                        guard let url = URL(string: "itms-apps://apple.com/app/1369238862") else { return }
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        }
    }
    
    func getAppVersion() -> String {
        guard let info = Bundle.main.infoDictionary else { return "" }
        let appVersion = info["CFBundleShortVersionString"] as? String ?? ""
//        return "0.5.2.5"
        return appVersion
        
    }
    
}
