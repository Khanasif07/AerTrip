//
//  SearchVM.swift
//  AERTRIP
//
//  Created by apple on 26/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation


protocol SearchVMDelegate: class {
    func willGetDetail()
    func getSuccess(_ data: [FlyerModel])
    func getFail(errors: ErrorCodes)
}

class FFSearchVM {
    weak var delegate: SearchVMDelegate?
    var flyer: FlyerModel?
    
    func webserviceForGetTravelDetail(_ searchText:String) {
        var params = JSONDictionary()
    
           params[APIKeys.query.rawValue] = searchText
            self.delegate?.willGetDetail()
        
        APICaller.shared.getFlyerList(params: params, completionBlock: { success, data, errorCode in
            
            if success {
                self.delegate?.getSuccess(data)
            } else {
                self.delegate?.getFail(errors: errorCode)
                debugPrint(errorCode)
            }
        })
    }
}


