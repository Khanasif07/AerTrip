//
//  PostBookingAddonsPaymentStatusVM.swift
//  AERTRIP
//
//  Created by Apple  on 26.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class PostBookingAddonsPaymentStatusVM{
    var bookingIds:[String] = []
    var itId = ""
    private(set) var bookingDetails:[BookingDetailModel?] = []
    private(set) var addonsReceipt = AddonsReceiptModel()
    var availableSeatMaps = [AvailableSeatMap]()
    weak var delegate:FlightPaymentBookingStatusVMDelegate?
    var pax = [Pax]()
    var sectionData = [[CellType]]()
    var cellDataToShow = [[CustomDetail]]()
    var perAPIPersentage:Double{
        0.8/Double(self.bookingIds.count + 1)
    }
    var bookingAPIGroup = DispatchGroup()
    
    enum CellType{
        case seatBooked, empty, passenger, flightTitle, accessBooking
    }
    
    func getSectionData(){
        
        sectionData.removeAll()
        cellDataToShow.removeAll()
        sectionData.append([.seatBooked])
        for leg in self.addonsReceipt.addonsDetails.leg{
            var section = [CellType]()
            var cellData = [CustomDetail]()
            for flight in leg.flights{
                section.removeAll()
                cellData.removeAll()
                section.append(.flightTitle)
                cellData.append(self.createCustomDetail(type: 0, flight: flight, pax: QTPax()))
                for pax in flight.pax{
                    if !pax.addon.seat.name.isEmpty{
                        section.append(.passenger)
                        cellData.append(self.createCustomDetail(type: 1, flight: flight, pax: pax))
                    }
                }
                if section.count > 1{
                    sectionData.append(section)
                    cellDataToShow.append(cellData)
                }
            }
        }
        sectionData.append([.empty,.accessBooking, .empty])
    }
    
    
    func getPax(){
        if let pax = self.bookingDetails.first??.bookingDetail?.leg.first?.pax{
            self.pax = pax
        }
    }
    
    func  createCustomDetail(type:Int, flight:QTFlights, pax:QTPax) ->  CustomDetail{
        
        var customDetail = CustomDetail()
        if type == 0{
            customDetail.type = .title
            customDetail.flight = flight
        }else{
            customDetail.type = .passenger
            customDetail.addonPax = pax
            customDetail.pax = self.pax.first(where: {$0.paxId == "\(pax.paxId)"})
        }
        
        return customDetail
        
    }
    
    func getBookingReceipt() {
        
        let params: JSONDictionary = [APIKeys.it_id.rawValue: itId]
        
        self.delegate?.willGetBookingReceipt()
        APICaller.shared.getAddonsReceipt(params: params) { [weak self](success, errors, receiptData)  in
            guard let self = self else { return }
            if success {
                self.addonsReceipt = receiptData ?? AddonsReceiptModel()
                self.delegate?.getBookingReceiptSuccess()
            } else {
                self.delegate?.getBookingReceiptFail(error: errors)
            }
        }
    }
    
    func getBookingDetail(){
        guard !self.bookingIds.isEmpty else{
            AppGlobals.shared.stopLoading()
            return
        }
        
        //Multiple booking Ids details fetch
        if bookingIds.count == 1{
            self.bookingDetails.append(nil)
            self.getBookingDetails(self.bookingIds[0], index:0)
        }else{
            for _ in 0..<self.bookingIds.count{
                self.bookingDetails.append(nil)
            }
            self.getBookingDetailsWithMultipleIds(self.bookingIds)
        }
        
//        for i in 0..<self.bookingIds.count{
//            self.bookingDetails.append(nil)
//            self.getBookingDetails(self.bookingIds[i], index:i)
//        }
    }
    
    func getBookingDetails(_ bookingId: String, index: Int) {
        var params: JSONDictionary = ["booking_id": bookingId]
        if UserInfo.loggedInUserId == nil{
            params["is_guest_user"] = true
        }
        self.bookingAPIGroup.enter()
        delegate?.willGetBookingDetail()
        APICaller.shared.getBookingDetail(params: params) { [weak self] success, errors, bookingDetail in
            guard let self = self else { return }
            self.delegate?.getBookingResponseWithIndex(success: success)
            self.bookingAPIGroup.leave()
            if success {
                self.bookingDetails[index] = bookingDetail
                self.setSeatMapAvailability(bookingId, booking: bookingDetail)
                self.getPax()
            }
            self.bookingAPIGroup.notify(queue: .main) {
                delay(seconds: 0.2) {
                    if success {
                        self.delegate?.getBookingDetailSuccess()
                    }else{
                        self.delegate?.getBookingDetailFailure(error: errors)
                    }
                }
            }
        }
    }
    
    
    func getBookingDetailsWithMultipleIds(_ bookingIds: [String]) {
        var params: JSONDictionary = ["booking_id": bookingIds.joined(separator: ",")]
        if UserInfo.loggedInUserId == nil{
            params["is_guest_user"] = true
        }
        delegate?.willGetBookingDetail()
        APICaller.shared.getBookingDetailWithMultipleIds(params: params) { [weak self] success, errors, bookingsData in
            guard let self = self else { return }
            self.delegate?.getBookingResponseWithIndex(success: success)
            if success {
                for (index, bookingId) in bookingIds.enumerated(){
                    let bookingDetail = bookingsData?[bookingId]
                    self.bookingDetails[index] = bookingDetail
                    self.setSeatMapAvailability(bookingId, booking: bookingDetail)
                    self.getPax()
                }
            }
            delay(seconds: 0.2) {
                if success {
                    self.delegate?.getBookingDetailSuccess()
                }else{
                    self.delegate?.getBookingDetailFailure(error: errors)
                }
            }
        }
    }
    
    
    func setSeatMapAvailability(_ bookingId: String, booking: BookingDetailModel?){//→
        guard let booking = booking else {return}//booking.displaySeatMap//Add conditions after check
        var seatMap = AvailableSeatMap(bookingId: bookingId, name: "")
        for leg in booking.bookingDetail?.leg ?? []{
            //            guard (leg.pax.first?.status ?? "") == "booked" else {return}
            let name = "\(leg.origin) → \(leg.destination)"
            seatMap.name = name
            self.availableSeatMaps.append(seatMap)
        }
    }
    
}


struct CustomDetail{
    
    enum DetailsType{
        case title, passenger
    }
    var type = DetailsType.title
    var flight = QTFlights()
    var pax:Pax?
    var addonPax:QTPax = QTPax()
    
}
