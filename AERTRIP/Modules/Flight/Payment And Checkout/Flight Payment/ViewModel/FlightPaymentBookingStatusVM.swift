//
//  FlightPaymentBookingStatusVM.swift
//  AERTRIP
//
//  Created by Apple  on 04.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class FlightPaymentBookingStatusVM{
    
    var itinerary = FlightItinerary()
    var sectionData: [[TableViewCellType]] = []
    var flightTicketCount = 3
    var passengerCount = 4
    var bookingId = "475892436"
    var tripName = "Trip to london"
    var whatNextString = ["Book your hotel in Amsterdam and get great deals","Book your hotel in Amsterdam and get great deals","Book your hotel in Amsterdam and get great deals"]
    var isSeatSettingAvailable = true
    //Data For API And Details
    var apiBookingId:String = ""
    
    /* TableViewCellType Enum contains all tableview cell for YouAreAllDoneVC tableview */
    enum TableViewCellType {
        case  allDoneCell, eventSharedCell, carriersCell, legInfoCell,BookingPaymentCell, pnrStatusCell, totalChargeCell, confirmationHeaderCell,confirmationVoucherCell, whatNextCell
    }
    
     func getSectionData(){
        
        // AllDone Section Cells
        self.sectionData.append([.allDoneCell, .eventSharedCell])
        
        //Adding section according to legs and passenger count
        for _ in self.itinerary.details.legsWithDetail{
            var data:[TableViewCellType] = [.carriersCell]
            data.append(contentsOf: [.legInfoCell,.BookingPaymentCell])
            for _ in 0..<self.passengerCount{
                data.append(.pnrStatusCell)
            }
            self.sectionData.append(data)
        }
        var dataForLastSection = [TableViewCellType]()
        if isSeatSettingAvailable{
            //Add seat button cell
        }
        dataForLastSection.append(contentsOf: [.totalChargeCell, .confirmationHeaderCell])
        for _ in 0..<flightTicketCount{
            dataForLastSection.append(.confirmationVoucherCell)
        }
        dataForLastSection.append(.whatNextCell)
        self.sectionData.append(dataForLastSection)
    }

}
