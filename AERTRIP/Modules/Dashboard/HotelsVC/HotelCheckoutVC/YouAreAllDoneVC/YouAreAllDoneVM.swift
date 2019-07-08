//
//  YouAreAllDoneVM.swift
//  AERTRIP
//
//  Created by Admin on 25/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol YouAreAllDoneVMDelegate: class {
    func willGetBookingReceipt()
    func getBookingReceiptSuccess()
    func getBookingReceiptFail()
}

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
    weak var delegate: YouAreAllDoneVMDelegate?
    var hotelReceiptData: HotelReceiptModel?
    var originLat: String = ""
    var originLong: String = ""
    var whatNext: [String] = []
    var whatNextValues: [String] = []
    var itId: String = "", bookingIds: [String] = [], cId: [String] = []
    
    //Mark:- Functions
    //================
    ///Get GuestCellData
    override init() {
        self.originLat = ""
        self.originLong = ""
    }
    
    private func getGuestCellData(room: Room) ->  [TableViewCellType] {
        var guestData: [TableViewCellType] = []
        if !room.name.isEmpty{
            guestData.append(.roomBedsDetailsCell)
        }
//        guestData.append(.roomBedsTypeCell)
        if let inclusion =  room.inclusions[APIKeys.Inclusions.rawValue] as? [String], !inclusion.isEmpty {
            guestData.append(.inclusionCell)
        }
        if let otherInclusion =  room.inclusions[APIKeys.other_inclusions.rawValue] as? [String], !otherInclusion.isEmpty {
            guestData.append(.otherInclusionCell)
        }
        guestData.append(.cancellationPolicyCell)
        guestData.append(.paymentPolicyCell)
        if let notesInclusion =  room.inclusions[APIKeys.notes_inclusion.rawValue] as? [String], !notesInclusion.isEmpty {
            guestData.append(.notesCell)
        }
        guestData.append(.guestsCell)
        return guestData
    }
    
    ///Get TableView SectionData
    internal func getTableViewSectionData() {
        // AllDone Section Cells
        self.sectionData.append([.allDoneCell, .eventSharedCell])
        
        // BookingDetails Section Cells
        var sectionTwoData: [TableViewCellType] = []
        sectionTwoData.append(.ratingCell)
        if !(self.hotelReceiptData?.address == "") {
            sectionTwoData.append(.addressCell)
        }
//        sectionTwoData.append(.phoneCell)
//        sectionTwoData.append(.webSiteCell)
        sectionTwoData.append(.checkInOutCell)
        self.sectionData.append(sectionTwoData)
        
        for room in self.hotelReceiptData?.rooms ?? [Room]() {
            self.sectionData.append(self.getGuestCellData(room: room))
        }
        
        // TotalCharge Section Cells
        if self.bookingIds.isEmpty && !self.cId.isEmpty {
            self.sectionData.append([.totalChargeCell , .whatNextCell])
        } else {
            self.sectionData.append([.totalChargeCell, .confirmationVoucherCell, .whatNextCell])
        }
    }
    
    func getBookingReceipt() {
        
        let params: JSONDictionary = [APIKeys.booking_id.rawValue: self.bookingIds.first ?? "", APIKeys.it_id.rawValue: self.itId]

        self.delegate?.willGetBookingReceipt()
        APICaller.shared.bookingReceiptAPI(params: params) { [weak self](success, errors, receiptData)  in
            guard let sSelf = self else { return }
            if success {
                sSelf.hotelReceiptData = receiptData ?? HotelReceiptModel()
                sSelf.delegate?.getBookingReceiptSuccess()
            } else {
                sSelf.delegate?.getBookingReceiptFail()
            }
        }
    }
    
    func getWhatNextData() {
        self.whatNext.removeAll()
        self.whatNextValues.removeAll()
        if let flightsData = self.hotelReceiptData?.flight_link_param {
            for flightData in flightsData{
                self.whatNext.append(flightData.key)
                if let value = flightData.value as? String {
                    self.whatNextValues.append(value)
                }
            }
        }
    }
}


