//
//  SettingsVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 25/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class SettingsVM {

    enum SettingsOptions : String {
        case country = "Country"
        case currency = "Currency"
        case notification = "Notification"
        case calenderStyle = "Calender Style"
        case aboutUs = "About Us"
        case legal = "Legal"
        case privacyPolicy = "Privacy Policy"
    }
    
    let settingsDataToPopulate = [
        0 : [SettingsOptions.country, SettingsOptions.currency, SettingsOptions.notification],
        1 : [SettingsOptions.calenderStyle],
        2 : [SettingsOptions.aboutUs, SettingsOptions.legal, SettingsOptions.privacyPolicy]
    ]
    
    
    
 
}
