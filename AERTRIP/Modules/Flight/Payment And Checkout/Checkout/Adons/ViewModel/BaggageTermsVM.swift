//
//  BaggageTermsVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 29/06/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation


class BaggageTermsVM {

    enum SetupFor {
        case baggage
        case seats
    }
    
    var setupFor: SetupFor = .baggage
    
    private let seatTermsPoints: [String] =
        [LocalizedString.emergencySeatTerms1.localized,
    LocalizedString.emergencySeatTerms2.localized,
    LocalizedString.emergencySeatTerms3.localized,
    LocalizedString.emergencySeatTerms4.localized,
    LocalizedString.emergencySeatTerms5.localized,
    LocalizedString.emergencySeatTerms6.localized,
    LocalizedString.emergencySeatTerms7.localized,
    LocalizedString.emergencySeatTerms8.localized,
    LocalizedString.emergencySeatTerms9.localized]
    
    private let baggageTermsPoints : [String] = [LocalizedString.Baggage_Terms_Point1.localized, LocalizedString.Baggage_Terms_Point2.localized, LocalizedString.Baggage_Terms_Point3.localized, LocalizedString.Baggage_Terms_Point4.localized]
    
    var agreeCompletion : ((Bool) -> Void) = {_ in (false)}
    
    var conditionPointers: [String] {
        if setupFor == .seats {
            return seatTermsPoints
        } else {
            return baggageTermsPoints
        }
    }
    
}
