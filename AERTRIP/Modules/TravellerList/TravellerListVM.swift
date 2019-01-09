//
//  TravellerListVM.swift
//  AERTRIP
//
//  Created by apple on 07/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

import UIKit
import CoreData

protocol TravellerListVMDelegate: class {
    func willSearchForTraveller()
    func searchTravellerSuccess()
    func searchTravellerFail()
}

class TravellerListVM: NSObject {
    weak var delegate: TravellerListVMDelegate?
    var travellersDict: [String: Any] = [:]
    
    var traveller:[NSManagedObject] = []
    
    
    struct Objects {
        var sectionName: String!
        var sectionObjects: [String]!
    }
    
    var objectArray = [Objects]()
    
    func searchTraveller(forText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(filterDictArrSearch(_:)), with: forText, afterDelay: 0.5)
    }
    
    @objc func filterDictArrSearch(_ forText: String) {
        print(forText)
    }
    
    func callSearchTravellerListAPI() {
        delegate?.willSearchForTraveller()
        APICaller.shared.callTravellerListAPI { isSuccess, _, travellers in
            if isSuccess {
                self.travellersDict = travellers
                self.delegate?.searchTravellerSuccess()
            }
            else {
                self.delegate?.searchTravellerFail()
            }
        }
    }
}
