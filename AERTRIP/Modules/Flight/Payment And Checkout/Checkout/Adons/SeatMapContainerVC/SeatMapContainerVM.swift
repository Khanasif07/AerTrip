//
//  SeatMapContainerVM.swift
//  AERTRIP
//
//  Created by Rishabh on 25/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

class SeatMapContainerVM {
    
    func fetchSeatMapData() {
        
        APICaller.shared.callSeatMapAPI(params: [:]) { (status, error) in
            
        }
    }
    
}
