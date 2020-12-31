//
//  VersionControlData.swift
//  AERTRIP
//
//  Created by Admin on 31/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation


struct VersionControlData {

    let installedVersion : String
    let updateRequired : String
    let latestVersion : String
    
    init(json : JSON) {
        installedVersion = json[APIKeys.userInstalledVersion.rawValue].stringValue
        latestVersion = json[APIKeys.currentLatestVersion.rawValue].stringValue
        updateRequired = json[APIKeys.updateRequired.rawValue].stringValue
    }
    
    
}
