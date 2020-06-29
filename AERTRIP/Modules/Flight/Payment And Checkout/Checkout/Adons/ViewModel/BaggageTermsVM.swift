//
//  BaggageTermsVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 29/06/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation


class BaggageTermsVM {

    
    let baggageTermsPoints : [String] = [LocalizedString.Baggage_Terms_Point1.localized, LocalizedString.Baggage_Terms_Point2.localized, LocalizedString.Baggage_Terms_Point3.localized, LocalizedString.Baggage_Terms_Point4.localized]
    
    var agreeComplition : ((Bool) -> Void) = {_ in (false)}

    
}
