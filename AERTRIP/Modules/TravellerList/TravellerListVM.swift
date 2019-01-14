//
//  TravellerListVM.swift
//  AERTRIP
//
//  Created by apple on 07/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

import CoreData
import UIKit

protocol TravellerListVMDelegate: class {
    func willSearchForTraveller()
    func searchTravellerSuccess()
    func searchTravellerFail(errors: ErrorCodes)
}

class TravellerListVM: NSObject {
    weak var delegate: TravellerListVMDelegate?
    var travellersDict: [String: Any] = [:]
    
    // var traveller:[NSManagedObject] = []
    var travelData: [TravellerData] = []
    
    func searchTraveller(forText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(self.filterDictArrSearch(_:)), with: forText, afterDelay: 0.5)
    }
    
    @objc func filterDictArrSearch(_ forText: String) {
        print(forText)
        self.travelData.removeAll()
        if let travelsData = TravellerData.fetch(id: forText) {
            self.travelData = travelsData
        }
        
        self.delegate?.searchTravellerSuccess()
        
        printDebug(self.travelData)
    }
    
    func callSearchTravellerListAPI() {
        self.delegate?.willSearchForTraveller()
        APICaller.shared.callTravellerListAPI { [weak self] isSuccess, errorCodes, travellers in
            if isSuccess {
                // self?.travellersDict = travellers
                for traveller in travellers {
                    TravellerData.insert(dataDict: traveller.jsonDict)
                }
                self?.delegate?.searchTravellerSuccess()
            }
            else {
                self?.delegate?.searchTravellerFail(errors: errorCodes)
            }
        }
    }
}
