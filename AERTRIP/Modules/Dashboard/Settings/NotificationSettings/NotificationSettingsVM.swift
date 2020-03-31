//
//  NotificationSettingsVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 26/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class NotificationSettingsVM {
    
    enum NotificationSettingsType : String{
        case allNotifications = "All Notifications"
        case bookings = "Bookings"
        case tripEvents = "Trip Events"
        case offers = "Offers"
    }
    
    var notificationSettingsDataSource = [0 : [(type : NotificationSettingsType.allNotifications, desc : "")], 1 : [(type : NotificationSettingsType.bookings, desc : LocalizedString.GetNotifiedAboutYourBookings.localized),(type : NotificationSettingsType.tripEvents, desc : LocalizedString.GetNotifiedAboutYourTripEvents.localized), (type : NotificationSettingsType.offers, desc : LocalizedString.GetNotifiedAboutNewOffersAndDeals.localized)]]
    
    
    
}
