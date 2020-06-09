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
    
}
