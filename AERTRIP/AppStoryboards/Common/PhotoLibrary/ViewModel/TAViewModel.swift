//
//  TAViewModel.swift
//  AERTRIP
//
//  Created by Apple  on 30.07.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation
class TAViewModel{
    
    var hotelTripAdvisorDetails: HotelDetailsReviewsModel?
    var hotelId: String = ""
    static var shared = TAViewModel()
    private init(){}
    func getTripAdvisorDetails() {
        let params: JSONDictionary = [APIKeys.hid.rawValue : self.hotelId]
        APICaller.shared.getHotelTripAdvisorDetailsApi(params: params, loader: false) { [weak self] (success, errors, tripAdvisorDetails) in
            guard let self = self else {return}
            if success {
                if let safeTripAdvisorDetails = tripAdvisorDetails {
                    self.hotelTripAdvisorDetails = safeTripAdvisorDetails
                }
            } else {
                printDebug(errors)
            }
        }
    }
    
    func clearData(){
        self.hotelTripAdvisorDetails = nil
        self.hotelId = ""
    }
    
}
