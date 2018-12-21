//
//  ViewProfileDetailVM.swift
//  AERTRIP
//
//  Created by apple on 19/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

protocol ViewProfileDetailVMDelegate: class {
    func willGetDetail()
    func getSuccess(_ data: TravelDetailModel)
    func getFail(errors: ErrorCodes)
}

class ViewProfileDetailVM {
    weak var delegate: ViewProfileDetailVMDelegate?
    var travelData: TravelDetailModel?
    
    func webserviceForGetTravelDetail() {
        var params = JSONDictionary()
        
        params[APIKeys.paxId.rawValue] = AppUserDefaults.value(forKey: .userId)
        
        self.delegate?.willGetDetail()
        
        APICaller.shared.getTravelDetail(params: params, completionBlock: { success, data, errorCode in
            
            if success {
                self.delegate?.getSuccess(data)
            } else {
                self.delegate?.getFail(errors: errorCode)
                debugPrint(errorCode)
            }
        })
    }
}
