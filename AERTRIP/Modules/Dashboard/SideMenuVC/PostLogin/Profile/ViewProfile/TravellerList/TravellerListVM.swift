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
    func willCallDeleteTravellerAPI()
    func deleteTravellerAPISuccess()
    func deleteTravellerAPIFailure()
}

class TravellerListVM: NSObject {
    weak var delegate: TravellerListVMDelegate?
    var travellersDict: [String: Any] = [:]
    
    // var traveller:[NSManagedObject] = []
    var travelData: [TravellerData] = []
    var paxIds: [String] = []
    
    func callSearchTravellerListAPI() {
        self.delegate?.willSearchForTraveller()
        APICaller.shared.callTravellerListAPI { [weak self] isSuccess, errorCodes, travellers in
            if isSuccess {
//                 self?.travellersDict = travellers
                    TravellerData.insert(dataDictArray: travellers, completionBlock: { (all) in
                        DispatchQueue.mainAsync {
                            self?.delegate?.searchTravellerSuccess()
                        }
                    })

//                for traveller in travellers {
//                    if let logId = UserInfo.loggedInUserId, traveller.id.lowercased() != logId.lowercased(), traveller.label.lowercased() != AppConstants.kMe.lowercased() {
//                         _ = TravellerData.insert(dataDict: traveller.jsonDict)
//                    }
//                }
//                self?.delegate?.searchTravellerSuccess()
            } else {
                self?.delegate?.searchTravellerFail(errors: errorCodes)
            }
        }
    }
    
    func callDeleteTravellerAPI() {
        var params = JSONDictionary()
        
        params["pax_ids"] = self.paxIds
        delegate?.willCallDeleteTravellerAPI()
        APICaller.shared.callDeleteTravellerAPI(params: params) { [weak self] success, _ in
            if success {
                self?.delegate?.deleteTravellerAPISuccess()
            } else {
                self?.delegate?.deleteTravellerAPIFailure()
            }
        }
    }
}
