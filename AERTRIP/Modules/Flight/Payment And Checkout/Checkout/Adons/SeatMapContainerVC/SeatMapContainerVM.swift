//
//  SeatMapContainerVM.swift
//  AERTRIP
//
//  Created by Rishabh on 25/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol SeatMapContainerDelegate: AnyObject {
    func didFetchSeatMapData()
}

class SeatMapContainerVM {
    
    weak var delegate: SeatMapContainerDelegate?
    var seatMapModel = SeatMapModel()
    
    func fetchSeatMapData() {
        
        APICaller.shared.callSeatMapAPI(params: [:]) { [weak self] (seatModel, error) in
            if let model = seatModel {
                self?.seatMapModel = model
                self?.delegate?.didFetchSeatMapData()
            }
        }
    }
    
}
