//
//  YouAreAllDoneVM.swift
//  AERTRIP
//
//  Created by Admin on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

class YouAreAllDoneVM: NSObject {
    
    //Mark:- Enums
    //============
    /* TableViewCellType Enum contains all tableview cell for YouAreAllDoneVC tableview */
    enum TableViewCellType {
        case  allDoneCell, eventSharedCell, ratingCell, addressCell, phoneCell, webSiteCell , checkInOutCell , roomBedsDetailsCell ,roomBedsTypeCell, inclusionCell, otherInclusionCell, cancellationPolicyCell, paymentPolicyCell, notesCell , guestsCell , totalChargeCell, confirmationVoucherCell, whatNextCell
    }
    
    //Mark:- Variables
    //================
    var sectionData: [[TableViewCellType]] = []
    
    //Mark:- Functions
    //================
    ///Get GuestCellData
    private func getGuestCellData() ->  [TableViewCellType] {
        var guestData: [TableViewCellType] = []
        guestData.append(.roomBedsDetailsCell)
        guestData.append(.roomBedsTypeCell)
        guestData.append(.inclusionCell)
        guestData.append(.otherInclusionCell)
        guestData.append(.cancellationPolicyCell)
        guestData.append(.paymentPolicyCell)
        guestData.append(.notesCell)
        guestData.append(.guestsCell)
        return guestData
    }
    
    ///Get TableView SectionData
    internal func getTableViewSectionData() {
        // AllDone Section Cells
        self.sectionData.append([.allDoneCell, .eventSharedCell])
        
        // BookingDetails Section Cells
        self.sectionData.append([.ratingCell, .addressCell, .phoneCell, .webSiteCell, .checkInOutCell])
        
        // Guest Sections Cells
        for _ in 0..<2 {
            self.sectionData.append(self.getGuestCellData())
        }
        
        // TotalCharge Section Cells
        self.sectionData.append([.totalChargeCell, .confirmationVoucherCell, .whatNextCell])
    }
}


