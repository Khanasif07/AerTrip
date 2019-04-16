//
//  UpcomingBookingsVM.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol UpcomingBookingsVMDelegate {
    func willGetUpcomingBookingData()
    func UpcomingBookingDataSuccess()
    func UpcomingBookingDataFail()
}

class UpcomingBookingsVM {
    
    enum TableViewCellType {
        case eventTypeCell , spaceCell , queryCell
    }
    var upcomingBookingData: [UpComingBookingEvent] = []
    var upcomingBooking: JSONDictionary = [:]
    
    init() {
    }
    
    func getSectionData() {
        let jsonData: [JSONDictionary] = [
            [
                "creationDate":  "Tue, 30 Apr",
                "currentEvent" : "flight",
                "placeName": "Burj Khalifa - At the Top",
                "travellersName": "You and Bhushan",
                "queries": []
            ],
            [
                "creationDate":  "Wed, 1 May",
                "currentEvent" : "flight",
                "placeName": "Mumbai → Delhi",
                "travellersName": "YYou are flying",
                "queries": ["Booking in process" , "Booking on hold - Confirm by Sat, 25 Mar 2017"]
            ],
            [
                "creationDate":  "1 Jan 2019",
                "currentEvent" : "flight",
                "placeName": "Burj Khalifa - At the Top",
                "travellersName": "You and Bhushan",
                "queries": []
            ]
            
        ]
        self.upcomingBookingData = UpComingBookingEvent.getEventData(jsonDictArray: jsonData)
        //        "Mumbai → Delhi","BOM → DEL → GOI → MAA → BLR → BOM ","BOM → DEL, CCU → BLR, HYD → MAA, DEL → BOM, BLR → GOI","Mumbai → Delhi","Mumbai → Delhi"], subtitles: ["You are flying","You are flying","You are flying","You are flying","You are flying"], allQueries: [["Add-ons request in process" , "Rescheduling request in process" , "Cancellation request in process"],["Add-ons request on hold","Rescheduling request on hold","Cancellation request on hold"],["Add-ons successful","Rescheduling Successful","Cancellation Successful"],["Add-ons payment required","Rescheduling payment pending","Cancellation confirmation required"],["Add-ons request aborted","Rescheduling request aborted","Cancellation request aborted"]]),"1 Jan 2019" : EventData(title: "Burj Khalifa - At the Top", subtitle: "You and Bhushan",queries: [])]
    }
}
