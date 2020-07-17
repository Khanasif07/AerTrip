//
//  BookingDetailVM.swift
//  AERTRIP
//
//  Created by apple on 10/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol BookingDetailVMDelegate: class {
    
    func willGetBookingFees()
    func getBookingFeesSuccess()
    func getBookingFeesFail()
}

class BookingDetailVM {
    
    enum BaggageInfoCell {
        case aerlineDetail
        case title
        case adult(isLast: Bool)
        case child(isLast: Bool)
        case infant(isLast: Bool)
        case layover(isLast: Bool)
        case note
    }
    
    enum FlightInfoCell: Equatable {
        case aerlineDetail
        case flightInfo
        case amenities(totalRows: Int)
        case layover
        case paxData
    }
    
    private(set) var allBaggageCells: [[BaggageInfoCell]] = []
    private(set) var allFlightInfoCells: [[FlightInfoCell]] = []
    
    weak var delegate: BookingDetailVMDelegate?
    
    var bookingDetail: BookingDetailModel? {
        didSet {
            self.fecthTableCellsForFlightInfo()
            self.fecthTableCellsForBaggageInfo()
        }
    }
    
    var legDetails: [BookingLeg] {
        return self.bookingDetail?.bookingDetail?.leg ?? []
    }
    var bookingId: String {
        return self.bookingDetail?.id ?? ""
    }
    
    var tripStr: NSMutableAttributedString = NSMutableAttributedString(string: "")
    var legSectionTap: Int = 0
    var bookingFee: [BookingFeeDetail] = []
    
    var flightAdultCount = 0
    var flightChildrenCount = 0
    var flightInfantCount = 0
    
    func getBookingFees() {
        
        let params: JSONDictionary = ["booking_id": bookingId]
        delegate?.willGetBookingFees()
        APICaller.shared.getBookingFees(params: params) { [weak self] success, errors, bookingFee in
            guard let sSelf = self else { return }
            if success {
                sSelf.bookingFee = bookingFee
                sSelf.delegate?.getBookingFeesSuccess()
            } else {
                sSelf.delegate?.getBookingFeesFail()
                printDebug(errors)
            }
        }
    }
    
    
    func fecthTableCellsForFlightInfo() {
        var temp: [FlightInfoCell] = []
        if let legs = self.bookingDetail?.bookingDetail?.leg {
            for leg in legs {
                for flight in leg.flight {
                    temp.append(.aerlineDetail)
                    temp.append(.flightInfo)
                    
//                    if !flight.amenities.isEmpty {
//                        temp.append(.amenities(totalRows: flight.totalRowsForAmenities))
//                    }
                    let result = self.getAmenities(flightDetail: flight)
                    if !result.isEmpty {
                        temp.append(.amenities(totalRows: 1))
                    }
                    
                    if flight.layoverTime > 0 {
//                        if flight.ovgtlo {
                            temp.append(.layover)
//                        }
                    }
                }
                temp.append(.paxData)
                
                self.allFlightInfoCells.append(temp)
                temp.removeAll()
            }
        }
    }
    
    func fecthTableCellsForBaggageInfo() {
        
        var temp: [BaggageInfoCell] = []
        
        for leg in self.legDetails {
            
            for flight in leg.flight {
                
                temp.append(.aerlineDetail) //aerline cell
                
                if let bg = flight.baggage?.cabinBg {
                    temp.append(.title) //info title cell
                    
                    if let _ = bg.adult {
                        let isLast = ((bg.child == nil) && (bg.infant == nil) && (flight.layoverTime <= 0) && ((flight.baggage?.checkInBg?.notes ?? "").isEmpty))
                        temp.append(.adult(isLast: isLast)) //adult details cell
                    }
                    
                    if let _ = bg.child {
                        let isLast = ((bg.infant == nil) && (flight.layoverTime <= 0) && ((flight.baggage?.checkInBg?.notes ?? "").isEmpty))
                        temp.append(.child(isLast: isLast)) //child details cell
                    }
                    
                    if let _ = bg.infant {
                        let isLast = ((flight.layoverTime <= 0) && ((flight.baggage?.checkInBg?.notes ?? "").isEmpty))
                        temp.append(.infant(isLast: isLast)) //adult details cell
                    }
                }
                
                if flight.layoverTime > 0 {
                    let isLast = ((flight.baggage?.checkInBg?.notes ?? "").isEmpty)
                    if flight.ovgtlo {
                        temp.append(.layover(isLast: isLast))
                    }
                }
                
                if let nt = flight.baggage?.checkInBg?.notes, !nt.isEmpty {
                    //temp.append(.note)
                }
                
            }
            
            self.allBaggageCells.append(temp)
            temp.removeAll()
        }
    }
    
    func fecthTableCellsForFareInfo() {
        
        // var temp: [BaggageInfoCell] = []
        flightAdultCount = 0
        flightChildrenCount = 0
        flightInfantCount = 0
        
        
        if let leg = self.legDetails.first{
            
            for pax in leg.pax {
                                
                if pax.paxType == "ADT" {
                    flightAdultCount += 1 //adult details cell
                }
                
                if pax.paxType == "CHD" {
                    flightChildrenCount += 1 //child details cell
                }
                
                if pax.paxType == "INF" {
                    flightInfantCount += 1 //adult details cell
                }
                
            }
            
        }
    }
    
    func getAmenities(flightDetail: BookingFlightDetail) -> [String] {
        var amenitiesData = [String]()
        
        if let baggage = flightDetail.baggage {
            if let adtBaggage = baggage.checkInBg?.adult{
                let weight = adtBaggage.weight
                let pieces = adtBaggage.piece
                if pieces != "" && pieces != "-9" && pieces != "-1" && pieces != "0 pc" && pieces != "0"{
                    amenitiesData.append("Check-in Baggage \n(\(pieces))")
                }else{
                    if weight != "" && weight != "-9" && weight != "-1" && weight != "0 kg"{
                        amenitiesData.append("Check-in Baggage \n(\(weight))")
                    }
                }
                
            }
            
            if let adtCabinBaggage = baggage.cabinBg?.adult{
                
                let weight = adtCabinBaggage.weight
                let pieces = adtCabinBaggage.piece
                
                if weight != "" && weight != "-9" && weight != "-1" && weight != "0 kg"{
                    amenitiesData.append("Cabbin Baggage \n(\(weight))")
                }else{
                    if pieces != "" && pieces != "-9" && pieces != "-1" && pieces != "0 pc" && pieces != "0"{
                        
                        if pieces.containsIgnoringCase(find: "pc"){
                            amenitiesData.append("Cabbin Baggage \n(\(pieces))")
                        }else{
                            amenitiesData.append("Cabbin Baggage \n(\(pieces) pc)")
                        }
                    }
                }
                
            }
            
        }
        return amenitiesData
    }
}
