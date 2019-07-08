//
//  FlightBookingsDetailsVM.swift
//  AERTRIP
//
//  Created by Admin on 27/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

class FlightBookingsDetailsVM {
    
    enum TableViewCell {
        case notesCell, requestCell , cancellationsReqCell , addOnRequestCell , reschedulingRequestCell , flightCarriersCell , flightBoardingAndDestinationCell , travellersPnrStatusTitleCell , travellersPnrStatusCell ,documentCell , paymentInfoCell , bookingCell , addOnsCell , cancellationCell , paidCell , refundCell , paymentPendingCell , nameCell , emailCell , mobileCell , gstCell , billingAddressCell , flightsOptionsCell , weatherHeaderCell , weatherInfoCell
    }
    var cityName: [String] = ["","Mumbai, IN", "Bangkok, TH","Bangkok, TH","Mumbai, IN","Chennai, IN"]
    var sectionData: [[TableViewCell]] = []
    var flightBookingData: FlightBookingsDataModel?
    var documentDownloadingData = [DocumentDownloadingModel]()
    var currentDocumentPath: String = ""
    var urlOfDocuments: String = ""
    var urlLink: URL?
    
    func getSectionData() {
        self.getDocumentDownloadingData()
//        self.sectionData.append([.notesCell,.requestCell])
//        self.sectionData.append([.cancellationsReqCell , .addOnRequestCell , .reschedulingRequestCell, .reschedulingRequestCell])
//        var sjd = [TableViewCell] = []
        
        self.sectionData.append([.flightCarriersCell, .flightBoardingAndDestinationCell, .travellersPnrStatusTitleCell , .travellersPnrStatusCell , .travellersPnrStatusCell , .travellersPnrStatusCell , .travellersPnrStatusCell])
        self.sectionData.append([.flightCarriersCell, .flightBoardingAndDestinationCell, .travellersPnrStatusTitleCell , .travellersPnrStatusCell , .travellersPnrStatusCell , .travellersPnrStatusCell , .travellersPnrStatusCell])
        self.sectionData.append([.documentCell])
        self.sectionData.append([.paymentInfoCell , .bookingCell , .addOnsCell , .cancellationCell , .paidCell , .refundCell , .paymentPendingCell])
        self.sectionData.append([.flightsOptionsCell])
        self.sectionData.append([.weatherHeaderCell,.weatherInfoCell,.weatherInfoCell,.weatherInfoCell,.weatherInfoCell,.weatherInfoCell])
        self.sectionData.append([.nameCell , .emailCell , .mobileCell , .gstCell , .billingAddressCell])
    }
    
    func getDocumentDownloadingData() {
        for _ in 0..<9 {
            self.documentDownloadingData.append(DocumentDownloadingModel())
        }
    }
    
}
