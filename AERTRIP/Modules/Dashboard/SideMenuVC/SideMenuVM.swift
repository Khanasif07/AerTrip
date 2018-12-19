//
//  SideMenuVM.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 12/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

class SideMenuVM {
    
    let userData = UserModel(json: AppUserDefaults.value(forKey: .userData))
    let isLogin = !AppUserDefaults.value(forKey: .userId).stringValue.isEmpty
    let displayCellsForGuest = [ LocalizedString.WhyAertrip.localized,
                                 LocalizedString.SmartSort.localized,
                                 LocalizedString.Offers.localized,
                                 LocalizedString.ContactUs.localized,
                                 LocalizedString.Settings.localized]
    let cellForLoginUser = [ LocalizedString.Bookings.localized,
                             LocalizedString.Offers.localized,
                             LocalizedString.Notification.localized,
                             LocalizedString.ReferAndEarn.localized,
                             LocalizedString.Settings.localized,
                             LocalizedString.WhyAertrip.localized,
                             LocalizedString.SmartSort.localized,
                             LocalizedString.ContactUs.localized]
}
