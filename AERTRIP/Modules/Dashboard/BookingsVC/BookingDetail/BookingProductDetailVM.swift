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
    // MARK: - Variables
    
    weak var delegate: BookingProductDetailVMDelegate?
    var bookingId: String = "9705"
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
        for leg in self.bookingDetail?.bookingDetail?.leg ?? [] {
            var temp: [TableViewCellForFlightProductType] = [.flightCarriersCell, .flightBoardingAndDestinationCell]
            for (index, _) in leg.pax.enumerated() {
                if index == 0 {
                    temp.append(.travellersPnrStatusTitleCell)
                    temp.append(.travellersPnrStatusCell)
                } else {
                    temp.append(.travellersPnrStatusCell)
                }
            }
            self.sectionDataForFlightProductType.append(temp)
        }
        
        self.sectionDataForFlightProductType.append([.documentCell])
        self.sectionDataForFlightProductType.append([.paymentInfoCell, .bookingCell, .addOnsCell, .cancellationCell, .paidCell, .refundCell, .paymentPendingCell])
        self.sectionDataForFlightProductType.append([.flightsOptionsCell])
        self.sectionDataForFlightProductType.append([.weatherHeaderCell, .weatherInfoCell, .weatherInfoCell, .weatherInfoCell, .weatherInfoCell, .weatherInfoCell])
        self.sectionDataForFlightProductType.append([.nameCell, .emailCell, .mobileCell, .gstCell, .billingAddressCell])
    }
    
    enum TableViewCellForOtherProductType {
        case insurenceCell, policyDetailCell, travellersDetailCell, documentCell, paymentInfoCell, bookingCell, paidCell, nameCell, emailCell, mobileCell, gstCell, billingAddressCell
    }
    
    var sectionDataForOtherProductType: [[TableViewCellForOtherProductType]] = []
    
    func getSectionDataForOtherProductType() {
        self.sectionDataForOtherProductType.append([.insurenceCell, .policyDetailCell])
        var tempTravellers: [TableViewCellForOtherProductType] = []
        for _ in self.bookingDetail?.bookingDetail?.travellers ?? [] {
            tempTravellers.append(.travellersDetailCell)
        }
        self.sectionDataForOtherProductType.append(tempTravellers)
        if !(self.bookingDetail?.documents.isEmpty ?? false) {
            self.sectionDataForOtherProductType.append([.documentCell])
        }
        
        self.sectionDataForOtherProductType.append([.paymentInfoCell, .bookingCell, .paidCell])
        self.sectionDataForOtherProductType.append([.nameCell, .emailCell, .mobileCell, .gstCell, .billingAddressCell])
    }
    
    // Created for testing purpose
    func getDocumentDownloadingData() {
        for _ in 0..<9 {
            self.documentDownloadingData.append(DocumentDownloadingModel())
        }
    }

    func getBookingDetail() {
        let params: JSONDictionary = ["booking_id": bookingId]
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
