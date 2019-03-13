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
    var sectionData: [[TypeOfReviewCell]] = []
//    var rowsData: [TypeOfReviewCell] = []
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
    
    func getTypeOfCellInSections() {
        
        guard let hotelTripAdvisorDetails = self.hotelTripAdvisorDetails else { return }
        
        self.sectionData.append([.tripAdvisorTravelerRatingCell])
        
        if !hotelTripAdvisorDetails.reviewRatingCount.isEmpty {
            var rowsData: [TypeOfReviewCell] = []
            for _ in hotelTripAdvisorDetails.reviewRatingCount{
                rowsData.append(.travellerRatingCell)
            }
            self.sectionData.append(rowsData)
        }
        
        
        if let ratingSummary = hotelTripAdvisorDetails.ratingSummary, !ratingSummary.isEmpty {
            var rowsData: [TypeOfReviewCell] = []
            for _ in ratingSummary{
                rowsData.append(.advisorRatingSummaryCell)
            }
            self.sectionData.append(rowsData)
        }
        self.sectionData.append([.reviewsOptionCell,.reviewsOptionCell,.reviewsOptionCell,.poweredByCell])
    }
}
