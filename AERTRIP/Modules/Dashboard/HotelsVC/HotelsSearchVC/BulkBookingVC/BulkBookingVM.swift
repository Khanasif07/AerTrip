//
//  BulkBookingVM.swift
//  AERTRIP
//
//  Created by Admin on 24/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

protocol BulkBookingVMDelegate: class {
    func bulkBookingEnquirySuccess(enquiryId: String)
    func bulkBookingEnquiryFail()
}

class BulkBookingVM {
    
    //MARK:- Properties
    var roomCounts: Int = 5
    var adultsCount: Int = 10
    var childrenCounts: Int = 0
    var checkInDate = "2019-03-20" //Date().toString(dateFormat: "YYYY-MM-DD")
    var checkOutDate = "2019-03-25"
    var ratingCount: [Int] = []
    var source: String = ""
    var preferred: String = ""
    var specialRequest: String = ""
    var destination: String = ""
    var pType: String = "hotel"
    var enquiryId: String = ""
    var oldData: HotelFormPreviosSearchData = HotelFormPreviosSearchData()
    
    //MARK:- Public
    internal weak var delegate: BulkBookingVMDelegate?
    
    //MARK:- Methods
    //==============
    
    //MARK:- Private
    ///Params For Api
    private func paramsForApi() -> JSONDictionary {
        var params = JSONDictionary()
        params[APIKeys.source.rawValue] = self.source
        params[APIKeys.destination.rawValue] = self.destination
        params[APIKeys.from_date.rawValue] = self.checkInDate
        params[APIKeys.to_date.rawValue] = self.checkOutDate
        params[APIKeys.room_count.rawValue] = self.roomCounts
        params[APIKeys.adt.rawValue] = self.adultsCount
        params[APIKeys.chd.rawValue] = self.childrenCounts
        params[APIKeys.preferred.rawValue] = self.preferred
        params[APIKeys.special_request.rawValue] = self.specialRequest
        params[APIKeys.pType.rawValue] = self.pType
        params[APIKeys.stars.rawValue] = self.ratingCount
        return params
    }
    
    //MARK:- Public
    ///Hotel List Api
    func bulkBookingEnquiryApi() {
        
        APICaller.shared.bulkBookingEnquiryApi(params: self.paramsForApi()) { [weak self] (success, errors, enquiryId) in
            guard let sSelf = self else { return }
            if success {
                sSelf.enquiryId = enquiryId
                sSelf.delegate?.bulkBookingEnquirySuccess(enquiryId: enquiryId)
            } else {
                printDebug(errors)
                sSelf.delegate?.bulkBookingEnquiryFail()
            }
        }
    }
}
