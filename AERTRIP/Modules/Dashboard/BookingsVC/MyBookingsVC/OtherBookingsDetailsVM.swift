//
//  OtherBookingsDetailsVM.swift
//  AERTRIP
//
//  Created by Admin on 17/04/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

class OtherBookingsDetailsVM {
    
    enum TableViewCell {
        case insurenceCell , policyDetailCell , travellersDetailCell , documentCell , paymentInfoCell , bookingCell , paidCell , nameCell , emailCell , mobileCell , gstCell , billingAddressCell
    }
    
    var sectionData: [[TableViewCell]] = []
    var urlOfDocuments: String = ""
    var urlLink: URL?
    
    func getSectionData() {
        self.sectionData.append([.insurenceCell , .policyDetailCell , .travellersDetailCell , .documentCell])
        self.sectionData.append([.paymentInfoCell , .bookingCell , .paidCell])
        self.sectionData.append([.nameCell , .emailCell , .mobileCell , .gstCell , .billingAddressCell])
    }
}
