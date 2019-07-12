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
    
    let fareInfoNotes: [String] = ["Some fares may be non-refundable and non-amendable.",
                                   "Cancellation / Rescheduling Charges are indicative and can change without prior notice. Aertrip does not guarantee or warrant this information.",
                                   "They may be subject to currency fluctuations.",
                                   "They need to be reconfirmed prior to any amendments or cancellation.",
                                   "Total Rescheduling Charges also include Fare Difference (if applicable).",
                                   "Airlines stop accepting cancellation/rescheduling requests 3 - 75 hours before departure of the flight, depending on the airline.",
                                   "For confirming cancellation/change fee, please call us at our customer care."]

    let fareInfoDisclamer: [String] = ["Airlines stop accepting cancellation/rescheduling requests 3 - 75 hours before departure of the flight, depending on the airline, fare basis and booking fare policy.",
        "In case of restricted fares, no amendments/cancellation may be allowed.",
        "In case of combo fares or round-trip special fares, cancellation or change of only onward journey is not allowed. Cancellation or change of future sectors is allowed only if previous sectors are flown.",
        "Airline Cancellation/Rescheduling Charges needs to be reconfirmed prior to any amendments or cancellation.","Cancellation/Rescheduling Charges are indicative, subject to currency fluctuations and can change without prior notice. Aertrip does not guarantee or warrant this information."]
}
