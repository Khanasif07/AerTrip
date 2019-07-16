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
    
    private(set) var allBaggageCells: [[BaggageInfoCell]] = []
    
    weak var delegate: BookingDetailVMDelegate?
    
    var bookingDetail: BookingDetailModel? {
        didSet {
            self.fecthTableCellsForBaggageInfo()
        }
    }
    
    var legDetails: [Leg] {
        return self.bookingDetail?.bookingDetail?.leg ?? []
    }
    var bookingId: String {
        return self.bookingDetail?.id ?? ""
    }
    
    var tripStr: NSMutableAttributedString = NSMutableAttributedString(string: "")
    
    var bookingFee: [BookingFeeDetail] = []

    
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
                    temp.append(.layover(isLast: isLast))
                }
                
                if let nt = flight.baggage?.checkInBg?.notes, !nt.isEmpty {
                    temp.append(.note)
                }
                
            }
            
            self.allBaggageCells.append(temp)
            temp.removeAll()
        }
    }
}
