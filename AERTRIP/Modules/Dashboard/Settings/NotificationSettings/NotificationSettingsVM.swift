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
    
    
    func handleNotificationToggles(section : Int, row : Int, isOn : Bool){
        if section == 0{
            toggleSettings.allNotificationS = isOn
            toggleSettings.bookingNotifications = isOn
            toggleSettings.tripEventsNotifications = isOn
            toggleSettings.otherNotifications = isOn
        }else{
            switch row {
                case 0: toggleSettings.bookingNotifications = isOn
                case 1: toggleSettings.tripEventsNotifications = isOn
                case 2: toggleSettings.otherNotifications = isOn
            default:
                break
            }
            
            toggleSettings.allNotificationS = toggleSettings.bookingNotifications &&  toggleSettings.tripEventsNotifications && toggleSettings.otherNotifications
            
        }
    }
    
    func isSepratorHidden(section : Int, row : Int) -> Bool {
        if section == 0 && row == 1{
            return true
        }else if section == 1 && row == 2 {
            return true
        }else{
            return false
        }
    }
    
}
