//
//  HotelDetailsReviewsVM.swift
//  AERTRIP
//
//  Created by Admin on 08/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

protocol HotelTripAdvisorDetailsDelegate: class {
    func getHotelTripAdvisorDetailsSuccess()
    func getHotelTripAdvisorFail()
    
}

class HotelDetailsReviewsVM {
    
    enum TypeOfReviewCell {
        case tripAdvisorTravelerRatingCell , travellerRatingCell , advisorRatingSummaryCell , reviewsOptionCell , poweredByCell
    }
    
    internal weak var delegate: HotelTripAdvisorDetailsDelegate?
    var rowsData: [TypeOfReviewCell] = [.tripAdvisorTravelerRatingCell , .travellerRatingCell , .advisorRatingSummaryCell , .reviewsOptionCell , .reviewsOptionCell , .reviewsOptionCell , .poweredByCell]
    var hotelTripAdvisorDetails: HotelDetailsReviewsModel?
    var hotelId: String = ""
    
    func getTripAdvisorDetails() {
        let params: JSONDictionary = [APIKeys.hid.rawValue : self.hotelId]
        APICaller.shared.getHotelTripAdvisorDetailsApi(params: params, loader: false) { [weak self] (success, errors, tripAdvisorDetails) in
            guard let sSelf = self else {return}
            if success {
                if let safeTripAdvisorDetails = tripAdvisorDetails {
                    sSelf.hotelTripAdvisorDetails = safeTripAdvisorDetails
                    sSelf.delegate?.getHotelTripAdvisorDetailsSuccess()
                }
            } else {
                printDebug(errors)
                sSelf.delegate?.getHotelTripAdvisorFail()
            }
        }
    }
}
