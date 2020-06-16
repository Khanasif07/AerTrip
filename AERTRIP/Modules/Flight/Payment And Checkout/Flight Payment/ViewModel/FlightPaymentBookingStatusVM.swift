//
//  FlightPaymentBookingStatusVM.swift
//  AERTRIP
//
//  Created by Apple  on 04.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol FlightPaymentBookingStatusVMDelegate:NSObjectProtocol{
    func getBookingReceiptSuccess()
    func willGetBookingReceipt()
    func getBookingReceiptFail()
    func willGetBookingDetail()
    func getBookingDetailSucces()
    func getBookingDetailFaiure(error: ErrorCodes)
}

class FlightPaymentBookingStatusVM{
    
    var itinerary = FlightRecept()
    var itId = ""
    var sectionData: [[TableViewCellType]] = []
    var isSeatSettingAvailable = false
    weak var delegate:FlightPaymentBookingStatusVMDelegate?
    var bookingDetail: BookingDetailModel?
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
            for _ in 0..<self.itinerary.travellerDetails.t.count{
                data.append(.pnrStatusCell)
            }
            self.sectionData.append(data)
        }
        var dataForLastSection = [TableViewCellType]()
//        if isSeatSettingAvailable{
//            //Add seat button cell
//        }
        if self.itinerary.bookingStatus.status != "pending"{
            dataForLastSection.append(contentsOf: [.totalChargeCell, .confirmationHeaderCell])
            for _ in 0..<(self.itinerary.details.legsWithDetail.count){
                dataForLastSection.append(.confirmationVoucherCell)
            }
        }else{
            dataForLastSection.append(contentsOf: [.totalChargeCell])
        }
        
        dataForLastSection.append(.whatNextCell)
        self.sectionData.append(dataForLastSection)
    }

    func getBookingReceipt() {
        
        let params: JSONDictionary = [APIKeys.booking_id.rawValue: self.apiBookingId, APIKeys.it_id.rawValue: itId]
        
        self.delegate?.willGetBookingReceipt()
        APICaller.shared.flightBookingReceiptAPI(params: params) { [weak self](success, errors, receiptData)  in
            guard let self = self else { return }
            if success {
                self.itinerary = receiptData?.receipt ?? FlightRecept()
                self.delegate?.getBookingReceiptSuccess()
            } else {
                self.delegate?.getBookingReceiptFail()
            }
        }
    }
    
    func getBookingDetail() {
            let params: JSONDictionary = ["booking_id": apiBookingId]
            delegate?.willGetBookingDetail()
            APICaller.shared.getBookingDetail(params: params) { [weak self] success, errors, bookingDetail in
                guard let self = self else { return }
                if success {
                    self.bookingDetail = bookingDetail
                    self.delegate?.getBookingDetailSucces()
                } else {
                    self.delegate?.getBookingDetailFaiure(error: errors)
                }
            }
        }
    
}
