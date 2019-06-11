//
//  BookingProductDetailVM.swift
//  AERTRIP
//
//  Created by apple on 10/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol BookingProductDetailVMDelegate: class {
    func willGetBookingDetail()
    func getBookingDetailSucces()
    func getBookingDetailFaiure()
}

class BookingProductDetailVM {
    
    //MARK: - Variables
    
    weak var delegate: BookingProductDetailVMDelegate?
    var bookingId: String = ""
    var bookingDetail: BookingDetailModel?
    
    enum TableViewCellForFlightProductType {
        case notesCell, requestCell, cancellationsReqCell, addOnRequestCell, reschedulingRequestCell, flightCarriersCell, flightBoardingAndDestinationCell, travellersPnrStatusTitleCell, travellersPnrStatusCell, documentCell, paymentInfoCell, bookingCell, addOnsCell, cancellationCell, paidCell, refundCell, paymentPendingCell, nameCell, emailCell, mobileCell, gstCell, billingAddressCell, flightsOptionsCell, weatherHeaderCell, weatherInfoCell
    }

    var cityName: [String] = ["", "Mumbai, IN", "Bangkok, TH", "Bangkok, TH", "Mumbai, IN", "Chennai, IN"]
    var sectionDataForFlightProductType: [[TableViewCellForFlightProductType]] = []
    var flightBookingData: FlightBookingsDataModel?
    var documentDownloadingData = [DocumentDownloadingModel]()
    var currentDocumentPath: String = ""
    var urlOfDocuments: String = ""
    var urlLink: URL?

    func getSectionDataForFlightProductType() {
        self.getDocumentDownloadingData()
        // It will be for the notes cell type
        //        self.sectionData.append([.notesCell,.requestCell])
        //        self.sectionData.append([.cancellationsReqCell , .addOnRequestCell , .reschedulingRequestCell, .reschedulingRequestCell])
        self.sectionDataForFlightProductType.append([.flightCarriersCell, .flightBoardingAndDestinationCell, .travellersPnrStatusTitleCell, .travellersPnrStatusCell, .travellersPnrStatusCell, .travellersPnrStatusCell, .travellersPnrStatusCell])
        self.sectionDataForFlightProductType.append([.flightCarriersCell, .flightBoardingAndDestinationCell, .travellersPnrStatusTitleCell, .travellersPnrStatusCell, .travellersPnrStatusCell, .travellersPnrStatusCell, .travellersPnrStatusCell])
        self.sectionDataForFlightProductType.append([.documentCell])
        self.sectionDataForFlightProductType.append([.paymentInfoCell, .bookingCell, .addOnsCell, .cancellationCell, .paidCell, .refundCell, .paymentPendingCell])
        self.sectionDataForFlightProductType.append([.flightsOptionsCell])
        self.sectionDataForFlightProductType.append([.weatherHeaderCell, .weatherInfoCell, .weatherInfoCell, .weatherInfoCell, .weatherInfoCell, .weatherInfoCell])
        self.sectionDataForFlightProductType.append([.nameCell, .emailCell, .mobileCell, .gstCell, .billingAddressCell])
    }
    

    
    enum TableViewCellForOtherProductType {
        case insurenceCell , policyDetailCell , travellersDetailCell , documentCell , paymentInfoCell , bookingCell , paidCell , nameCell , emailCell , mobileCell , gstCell , billingAddressCell
    }
    
    var sectionDataForProductType: [[TableViewCellForOtherProductType]] = []
    
    
    func getSectionDataForOtherProductType() {
        self.sectionDataForProductType.append([.insurenceCell , .policyDetailCell , .travellersDetailCell , .documentCell])
        self.sectionDataForProductType.append([.paymentInfoCell , .bookingCell , .paidCell])
        self.sectionDataForProductType.append([.nameCell , .emailCell , .mobileCell , .gstCell , .billingAddressCell])
    }
    
    func getDocumentDownloadingData() {
        for _ in 0..<9 {
            self.documentDownloadingData.append(DocumentDownloadingModel())
        }
    }
    
   
    
    func getBookingDetail(id: String) {
        let params: JSONDictionary = ["booking_id": 10490]
         delegate?.willGetBookingDetail()
        APICaller.shared.getBookingDetail(params: params) { [weak self] success, errors, bookingDetail in
            guard let sSelf = self else { return }
            if success {
                sSelf.bookingDetail = bookingDetail
                sSelf.delegate?.getBookingDetailSucces()
            } else {
                sSelf.delegate?.getBookingDetailFaiure()
                printDebug(errors)
            }
        }
    }
}
