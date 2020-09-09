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
    func getBookingDetailFaiure(error: ErrorCodes)
    
    func willGetTripOwner()
    func getBTripOwnerSucces()
    func getTripOwnerFaiure(error: ErrorCodes)
}

class BookingProductDetailVM {
    // MARK: - Variables
    
    // hotel details related
    enum TableViewCellForHotel {
        case notesCell, requestCell, cancellationsReqCell, addOnRequestCell, reschedulingRequestCell, hotelBookingInfoCell, roomNameAndTypeCell, travellersCell, documentCell, paymentInfoCell, bookingCell, addOnsCell, cancellationCell, paidCell, refundCell, paymentPendingCell, nameCell, emailCell, mobileCell, gstCell, billingAddressCell, flightsOptionsCell, weatherHeaderCell, weatherInfoCell, weatherFooterCell, tripChangeCell, addToCalenderCell, addToAppleWallet, bookAnotherRoomCell
    }
    
    var sectionDataForHotelDetail: [[TableViewCellForHotel]] = []
    var allTrips: [TripModel] = []
    var isSeeAllWeatherButtonTapped: Bool = false
    var showWaletLoader = false
    
    var noOfCellAboveHotelDetail: Int {
        var count = 1
        if !(self.bookingDetail?.bookingDetail?.note.isEmpty ?? false) {
            count += 1
        }
        if let cases = self.bookingDetail?.cases, !cases.isEmpty {
            count += 1
        }
        return count
    }
    
    // hotel details
    var documentDownloadingData = [DocumentDownloadingModel]()
    
    func getSectionDataForHotelDetail() {
        
        self.sectionDataForHotelDetail.removeAll()
        // note details
        if let note = self.bookingDetail?.bookingDetail?.note, !note.isEmpty {
            self.sectionDataForHotelDetail.append([.notesCell])
        }
        
        // logic for add case cell i.e add on request,special and cancellation request.
        
        if let cases = self.bookingDetail?.cases, !cases.isEmpty {
            var temp: [TableViewCellForHotel] = []
            for (index, _) in cases.enumerated() {
                if index == 0 {
                    temp.append(.requestCell)
                    temp.append(.cancellationsReqCell)
                } else {
                    temp.append(.cancellationsReqCell)
                }
            }
            self.sectionDataForHotelDetail.append(temp)
        }
        
        // hotel Booking Address Detail Cell Card i.e Hotel name, Rating , Address and Checkout Card.
        self.sectionDataForHotelDetail.append([.hotelBookingInfoCell])
        
        // room details
        if let roomDetails = self.bookingDetail?.bookingDetail?.roomDetails {
            var temp: [TableViewCellForHotel] = []
            for room in roomDetails {
                temp.append(.roomNameAndTypeCell)
                for _ in room.guest {
                    temp.append(.travellersCell)
                }
                self.sectionDataForHotelDetail.append(temp)
                temp.removeAll()
            }
        }
        // documents details
        if let docs = self.bookingDetail?.documents, !docs.isEmpty {
            self.sectionDataForHotelDetail.append([.documentCell])
        }
        
        // TODO: payment card logic: Need to check transaction key : sometimes coming as null
        
        self.sectionDataForHotelDetail.append([.paymentInfoCell, .bookingCell])
        
        if self.bookingDetail?.addOnAmount ?? 0.0 > 0.0 {
            self.sectionDataForHotelDetail.append([.addOnsCell])
        }
        
        if self.bookingDetail?.cancellationAmount ?? 0.0 < 0.0 {
            self.sectionDataForHotelDetail.append([.cancellationCell])
        }
        
        if self.bookingDetail?.rescheduleAmount ?? 0.0 > 0.0 {
            self.sectionDataForHotelDetail.append([.reschedulingRequestCell])
        }
        
        if self.bookingDetail?.paid ?? 0.0 >= 0.0 {
            self.sectionDataForHotelDetail.append([.paidCell])
        }
        
        if self.bookingDetail?.refundAmount ?? 0.0 != 0.0 {
            self.sectionDataForHotelDetail.append([.refundCell])
        }
        
        if self.bookingDetail?.totalOutStanding != 0.0 {
            self.sectionDataForHotelDetail.append([.paymentPendingCell])
        }
        
        // additional info details i.e direction ,call and Add to trips
        
        self.sectionDataForHotelDetail.append([.flightsOptionsCell])
        
        self.sectionDataForHotelDetail.append([.addToCalenderCell])
        self.sectionDataForHotelDetail.append([.bookAnotherRoomCell])
        if self.bookingDetail?.bookingStatus == .booked {
            self.sectionDataForHotelDetail.append([.addToAppleWallet])
        }
        
        // logic for add trip change cell
        if self.bookingDetail?.tripInfo != nil {
            self.sectionDataForHotelDetail.append([.tripChangeCell])
        }
        
        // logic for add weather Data
        var temp: [TableViewCellForHotel] = []
        for (index, _) in (self.bookingDetail?.tripWeatherData.enumerated())! {
            if index == 0 {
                temp.append(.weatherHeaderCell)
                temp.append(.weatherInfoCell)
            } else {
                if index == 5 {
                    if self.isSeeAllWeatherButtonTapped {
                        temp.append(.weatherInfoCell)
                    } else {
                        break
                    }
                } else {
                    temp.append(.weatherInfoCell)
                }
            }
        }
        
        if self.bookingDetail?.weatherDisplayedWithin16Info ?? false {
            temp.append(.weatherFooterCell)
        }
        
        if self.bookingDetail?.tripWeatherData.isEmpty ?? false {
            temp.remove(object: .weatherFooterCell)
        }
        
        // Weather Cell  finally
        self.sectionDataForHotelDetail.append(temp)
        
        // Name ,Email , Mobile , Gst and Billing Address Cell
        self.sectionDataForHotelDetail.append([.nameCell, .emailCell, .mobileCell, .gstCell, .billingAddressCell])
    }
    
    // hotel details related
    
    weak var delegate: BookingProductDetailVMDelegate?
    var bookingId: String = "9705"
    var bookingDetail: BookingDetailModel?
    var tripCitiesStr: NSMutableAttributedString = NSMutableAttributedString(string: "")
    
    enum TableViewCellForFlightProductType {
        case notesCell, requestCell, cancellationsReqCell, addOnRequestCell, reschedulingRequestCell, flightCarriersCell, flightBoardingAndDestinationCell, travellersPnrStatusTitleCell, travellersPnrStatusCell, documentCell, paymentInfoCell, bookingCell, addOnsCell, cancellationCell, paidCell, refundCell, paymentPendingCell, nameCell, emailCell, mobileCell, gstCell, billingAddressCell, flightsOptionsCell, weatherHeaderCell, weatherInfoCell, weatherFooterCell, tripChangeCell, addToCalenderCell, addToTripCell, bookSameFlightCell, addToAppleWallet
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
    
    // MARK: - Get Section For Flight Product Type.
    
    func getSectionDataForFlightProductType() {

        // logic for add note cell
        self.sectionDataForFlightProductType.removeAll()
        if let note = self.bookingDetail?.bookingDetail?.note, !note.isEmpty {
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
        
        self.sectionDataForFlightProductType.append([.paymentInfoCell, .bookingCell])
        
        
        //TODO: - Payment :- transaction key sometimes coming null that's why commenting
        if self.bookingDetail?.addOnAmount ?? 0.0 > 0.0 {
            self.sectionDataForFlightProductType.append([.addOnsCell])
        }
        
        if self.bookingDetail?.cancellationAmount ?? 0.0 < 0.0 {
            self.sectionDataForFlightProductType.append([.cancellationCell])
        }
        
        if self.bookingDetail?.rescheduleAmount ?? 0.0 > 0.0 {
            self.sectionDataForFlightProductType.append([.reschedulingRequestCell])
        }
        
        if self.bookingDetail?.paid ?? 0.0 >= 0.0 {
            self.sectionDataForFlightProductType.append([.paidCell])
        }
        
        if self.bookingDetail?.refundAmount ?? 0.0 != 0.0 {
            self.sectionDataForFlightProductType.append([.refundCell])
        }
        
        if self.bookingDetail?.totalOutStanding != 0.0 {
            self.sectionDataForFlightProductType.append([.paymentPendingCell])
        }
        self.sectionDataForFlightProductType.append([.flightsOptionsCell])
        
       
         self.sectionDataForFlightProductType.append([.addToCalenderCell])
        if self.bookingDetail?.tripInfo == nil {
            self.sectionDataForFlightProductType.append([.addToTripCell])
        }
       
        self.sectionDataForFlightProductType.append([.bookSameFlightCell])
        if self.bookingDetail?.bookingStatus == .booked {
            self.sectionDataForFlightProductType.append([.addToAppleWallet])
        }
        
        if self.bookingDetail?.tripInfo != nil {
            self.sectionDataForFlightProductType.append([.tripChangeCell])
        }
        
        // logic for add weather Data
        var temp: [TableViewCellForFlightProductType] = []
        for (index, _) in (self.bookingDetail?.tripWeatherData.enumerated())! {
            if index == 0 {
                temp.append(.weatherHeaderCell)
                temp.append(.weatherInfoCell)
            } else {
                if index == 5 {
                    if self.isSeeAllWeatherButtonTapped {
                        temp.append(.weatherInfoCell)
                    } else {
                        break
                    }
                } else {
                    temp.append(.weatherInfoCell)
                }
            }
        }
        
        if self.bookingDetail?.weatherDisplayedWithin16Info ?? false {
            temp.append(.weatherFooterCell)
        }
        if self.bookingDetail?.tripWeatherData.isEmpty ?? false {
            temp.remove(object: .weatherFooterCell)
        }
        
        self.sectionDataForFlightProductType.append(temp)
        self.sectionDataForFlightProductType.append([.nameCell, .emailCell, .mobileCell, .gstCell, .billingAddressCell])
    }
    
    enum TableViewCellForOtherProductType {
        case insurenceCell, policyDetailCell, travellersDetailCell, documentCell, paymentInfoCell, bookingCell, paidCell, nameCell, emailCell, mobileCell, gstCell, billingAddressCell
    }
    
    var sectionDataForOtherProductType: [[TableViewCellForOtherProductType]] = []
    
    // MARK: - Get Section for other product type
    
    func getSectionDataForOtherProductType() {
        
        self.sectionDataForOtherProductType.removeAll()
        
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
    
    func getBookingDetail(shouldCallWillDelegate: Bool = true) {
        var params: JSONDictionary = ["booking_id": bookingId]
        if UserInfo.loggedInUserId == nil{
            params["is_guest_user"] = true
        }
//        if shouldCallWillDelegate {
//            delegate?.willGetBookingDetail()
//        }
        delegate?.willGetBookingDetail()
        APICaller.shared.getBookingDetail(params: params) { [weak self] success, errors, bookingDetail in
            guard let sSelf = self else { return }
            if success {
                sSelf.bookingDetail = bookingDetail
                sSelf.delegate?.getBookingDetailSucces()
            } else {
                sSelf.delegate?.getBookingDetailFaiure(error: errors)
                printDebug(errors)
            }
        }
    }
    
    func getTripOwnerApi() {
        delegate?.willGetTripOwner()
        APICaller.shared.getOwnedTripsAPI(params: ["trip_id": self.bookingDetail?.tripInfo?.tripId ?? ""]) {[weak self] success, error, trips, _ in
            guard let sSelf = self else { return }
            if success {
                printDebug("trips are \(trips), default trip ")
                sSelf.allTrips = trips
                sSelf.delegate?.getBTripOwnerSucces()
            } else {
                printDebug("error are \(error)")
                sSelf.delegate?.getTripOwnerFaiure(error: error)
            }
        }
    }
}
