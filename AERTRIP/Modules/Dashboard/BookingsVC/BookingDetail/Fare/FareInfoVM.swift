//
//  FareInfoVM.swift
//  AERTRIP
//
//  Created by Admin on 18/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

class FareInfoVM {
    
    var legDetails: Leg?
    var bookingFee: BookingFeeDetail?

    
    let fareInfoNotes: [String] = ["Cancellation or change of only one of the flights in this itinerary may not be allowed.",
                                   "Cancellation or change of later flights may be not be allowed if previous flight(s) are not flown.",
                                   "These charges are per passenger per sector and applicable only on refundable tickets.",
                                   "Total Rescheduling Charges also include Fare Difference (if applicable).",
                                   "NA means Not Available. Please check with airline for penalty information.",
                                   "Partial cancellation is not allowed on tickets booked under special discounted fares.",
                                   "If cancellation fee is more than the booking amount, then only statutory taxes are refundable.",
                                   "In case of no-show or ticket not cancelled within the stipulated time, only statutory taxes are refundable."
                                ]

    let fareInfoDisclamer: [String] = ["Airlines stop accepting cancellation/rescheduling requests 3 - 75 hours before departure of the flight, depending on the airline, fare basis and booking fare policy.",
        "In case of restricted fares, no amendments/cancellation may be allowed.",
        "In case of combo fares or round-trip special fares, cancellation or change of only onward journey is not allowed. Cancellation or change of future sectors is allowed only if previous sectors are flown.",
        "Airline Cancellation/Rescheduling Charges needs to be reconfirmed prior to any amendments or cancellation.","Cancellation/Rescheduling Charges are indicative, subject to currency fluctuations and can change without prior notice. Aertrip does not guarantee or warrant this information."]
}
