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
    func willSearchForTraveller(_ isShowLoader: Bool)
    func searchTravellerSuccess(_ isShowLoader: Bool)
    func searchTravellerFail(errors: ErrorCodes, _ isShowLoader: Bool)
    func willCallDeleteTravellerAPI()
    func deleteTravellerAPISuccess()
    func deleteTravellerAPIFailure(errors: ErrorCodes)
}

class TravellerListVM: NSObject {
    weak var delegate: TravellerListVMDelegate?
    var travellersDict: [String: Any] = [:]
    
    // var traveller:[NSManagedObject] = []
    var travelData: [TravellerData] = []
    var paxIds: [String] = []
    
    func callSearchTravellerListAPI(isShowLoader: Bool = false) {
        self.delegate?.willSearchForTraveller(isShowLoader)
        APICaller.shared.callTravellerListAPI { [weak self] isSuccess, errorCodes, travellers in
            if isSuccess {
//                 self?.travellersDict = travellers
                    TravellerData.insert(dataDictArray: travellers, completionBlock: { (all) in
                        DispatchQueue.mainAsync {
                            self?.delegate?.searchTravellerSuccess(isShowLoader)
                        }
                    })

//                for traveller in travellers {
//                    if let logId = UserInfo.loggedInUserId, traveller.id.lowercased() != logId.lowercased(), traveller.label.lowercased() != AppConstants.kMe.lowercased() {
//                         _ = TravellerData.insert(dataDict: traveller.jsonDict)
//                    }
//                }
//                self?.delegate?.searchTravellerSuccess()
            } else {
                self?.delegate?.searchTravellerFail(errors: errorCodes, isShowLoader)
            }
        }
    }
    
    func callDeleteTravellerAPI() {
        var params = JSONDictionary()
        
        params["pax_ids"] = self.paxIds
        delegate?.willCallDeleteTravellerAPI()
        APICaller.shared.callDeleteTravellerAPI(params: params) { [weak self] success,errors in
            if success {
                self?.delegate?.deleteTravellerAPISuccess()
            } else {
                self?.delegate?.deleteTravellerAPIFailure(errors: errors)
            }
        }
    }
}
