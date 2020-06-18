//
//  SeatMapContainerVM.swift
//  AERTRIP
//
//  Created by Rishabh on 25/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol SeatMapContainerDelegate: AnyObject {
    func willFetchSeatMapData()
    func didFetchSeatMapData()
    func failedToFetchSeatMapData()
}

class SeatMapContainerVM {
    
    weak var delegate: SeatMapContainerDelegate?
    private let sid: String
    private let itId: String
    private let fk: String
    var seatMapModel = SeatMapModel()
    
    var allTabsStr = [NSAttributedString]()
    var currentIndex = 0
    var allFlightsData = [SeatMapModel.SeatMapFlight]()
    var originalAllFlightsData = [SeatMapModel.SeatMapFlight]()
    
    var selectedSeats = [SeatMapModel.SeatMapRow]()
    
    convenience init() {
        self.init("", "", "")
    }
    
    init(_ sid: String,_ itId: String,_ fk: String) {
        self.sid = sid
        self.itId = itId
        self.fk = fk
    }
    
    func fetchSeatMapData() {
        self.delegate?.willFetchSeatMapData()
        let params: JSONDictionary = [FlightSeatMapKeys.sid.rawValue: sid,
                                      FlightSeatMapKeys.itId.rawValue: itId,
                                      FlightSeatMapKeys.fk.rawValue: fk]
        APICaller.shared.callSeatMapAPI(params: params) { [weak self] (seatModel, error) in
            if let model = seatModel {
                self?.seatMapModel = model
                self?.delegate?.didFetchSeatMapData()
            }else {
                self?.delegate?.failedToFetchSeatMapData()
            }
        }
    }
    
    func getSeatTotal(_ seatTotal: @escaping ((Int) -> ())) {
        
        func calculateSeatTotal() -> Int {
            var seatTotal = 0
            selectedSeats.removeAll()
            allFlightsData.forEach { (flight) in
                let rows = flight.md.rows.flatMap { $0.value } + flight.ud.rows.flatMap { $0.value }
                rows.forEach { (_, rowData) in
                    if rowData.columnData.passenger != nil {
                        seatTotal += rowData.columnData.amount
                        selectedSeats.append(rowData)
                    }
                }
            }
            return seatTotal
        }
        
        DispatchQueue.global(qos: .background).async {
            let totalAmount = calculateSeatTotal()
            DispatchQueue.main.async {
                seatTotal(totalAmount)
            }
        }
    }
    
}
