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
    var currentDocumentPath: String = ""
    var urlOfDocuments: String = ""
    var urlLink: URL?
    
    var noOfLegCellAboveLeg: Int {
        var count = 0
        if !(self.bookingDetail?.bookingDetail?.note.isEmpty ?? false) {
            count += 1
        }
        if !(self.bookingDetail?.cases.isEmpty ?? false) {
            count += 1
        }
        return count
    }
    
    func getSectionDataForFlightProductType() {
        // logic for add note cell
        if !(self.bookingDetail?.bookingDetail?.note.isEmpty ?? false) {
            self.sectionDataForFlightProductType.append([.notesCell])
        }
        
        // logic for add case cell
        
        if !(self.bookingDetail?.cases.isEmpty ?? false) {
            var temp: [TableViewCellForFlightProductType] = []
            for (index, _) in (self.bookingDetail?.cases ?? []).enumerated() {
                if index == 0 {
                    temp.append(.requestCell)
                    temp.append(.cancellationsReqCell)
                } else {
                    temp.append(.cancellationsReqCell)
                }
            }
            self.sectionDataForFlightProductType.append(temp)
        }
        
        // logic for add leg Cell
        
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
        
        if !(self.bookingDetail?.documents.isEmpty ?? false) {
            self.sectionDataForFlightProductType.append([.documentCell])
        }
        // self.sectionDataForFlightProductType.append([.paymentInfoCell, .bookingCell, .addOnsCell, .cancellationCell, .paidCell, .refundCell, .paymentPendingCell])
        
        self.sectionDataForFlightProductType.append([.paymentInfoCell, .bookingCell])
        
        if self.bookingDetail?.addOnAmount ?? 0.0 > 0.0 {
            self.sectionDataForFlightProductType.append([.addOnsCell])
        }
        
        if self.bookingDetail?.cancellationAmount ?? 0.0 > 0.0 {
            self.sectionDataForFlightProductType.append([.cancellationCell])
        }
        
        if self.bookingDetail?.paid ?? 0.0 > 0.0 {
            self.sectionDataForFlightProductType.append([.paidCell])
        }
        
        if self.bookingDetail?.refundAmount ?? 0.0 > 0.0 {
            self.sectionDataForFlightProductType.append([.refundCell])
        }
        
        self.sectionDataForFlightProductType.append([.paymentPendingCell])
        
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
