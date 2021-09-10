//
//  UpcomingBookingsVM.swift
//  AERTRIP
//
//  Created by Admin on 16/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol UpcomingBookingsVMDelegate: class {
    func willGetUpcomingBookingData()
    func UpcomingBookingDataSuccess()
    func UpcomingBookingDataFail()
}

class UpcomingBookingsVM {
    
    enum TableViewCellType {
        case eventTypeCell , spaceCell , queryCell
    }
    var upcomingDetails: JSONDictionary = JSONDictionary()
    var allDates: [String] {
        return Array(upcomingDetails.keys)
    }
    weak var delegate: UpcomingBookingsVMDelegate?
    
    init() {}
}

/*
 
 [
 "creationDate":  "Wed, 1 May",
 "currentEvent" : "flight",
 "placeName": "Mumbai → Delhi",
 "travellersName": "You are flying",
 "status": "pending",
 "queries": ["Add-ons request in process" , "Rescheduling request in process" , "Cancellation request in process"]
 ],
 [
 "creationDate":  "Wed, 1 May",
 "currentEvent" : "flight",
 "placeName": "BOM → DEL → GOI → MAA → BLR → BOM ",
 "travellersName": "You are flying",
 "status": "done",
 "queries": ["Add-ons successful","Rescheduling Successful","Cancellation Successful"]
 ],
 [
 "creationDate":  "Wed, 1 May",
 "currentEvent" : "flight",
 "placeName": "BOM → DEL, CCU → BLR, HYD → MAA, DEL → BOM, BLR → GOI",
 "travellersName": "You are flying",
 "status": "pending",
 "queries": ["Add-ons payment required","Rescheduling payment pending","Cancellation confirmation required"]
 ],
 [
 "creationDate":  "Wed, 1 May",
 "currentEvent" : "flight",
 "placeName": "Mumbai → Delhi",
 "travellersName": "You are flying",
 "status": "pending",
 "queries": ["Add-ons request aborted","Rescheduling request aborted","Cancellation request aborted"]
 ],

 
 */
