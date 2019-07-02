//
//  BookingRequestAddOnsFFVM.swift
//  AERTRIP
//
//  Created by apple on 22/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

protocol BookingRequestAddOnsFFVMDelegate: class {
    func willGetPreferenceMaster()
    func getPreferenceMasterSuccess()
    func getPreferenceMasterFail()
}

import Foundation

class BookingRequestAddOnsFFVM {
    
    
    
    // MARK: - Variables
    weak var delegate: BookingRequestAddOnsFFVMDelegate?
    var bookingDetails: BookingDetailModel?
    
    static let shared = BookingRequestAddOnsFFVM()
    
    private init() {}
    
    // check whether UI to be Used for   LCC or FCC
    var isLCC: Bool {
        var temp: Bool = false
        outerLoop: for leg in self.bookingDetails?.bookingDetail?.leg ?? [] {
            for flight in leg.flight {
                if flight.lcc == 1 {
                    temp = true
                } else {
                    temp = false
                    break outerLoop
                     
                }
            }
        }
        
         return temp
    }

    
    // preferences
    var seatPreferences = [String: String]()
    var mealPreferences = [String: String]()
    
    
    // FrequentFlyer Data
    var sectionData: [(profileImage: UIImage, userName: String)] = [(profileImage: UIImage(named: "boy")!, userName: "Mr. Alan McCarthy"), (profileImage: UIImage(named: "boy")!, userName: "Mrs. Jane McCarthy"), (profileImage: UIImage(named: "boy")!, userName: "Mr. Steve McCarthy"), (profileImage: UIImage(named: "boy")!, userName: "Miss. June McCarthy")]
    
    var ffAirlineData: [(airlineImage: UIImage, airlineName: String)] = [(airlineImage: UIImage(named: "aertripGreenLogo")!, airlineName: "Air India"), (airlineImage: UIImage(named: "aertripGreenLogo")!, airlineName: "Jet Airways")]
    
    // AddOn Data
    
    var sectionDataAddOns: [(title: String, info: String)] = [(title: "Mumbai → Delhi", info: "12 Oct 2018 | Non-refundable"), (title: "Delhi → Mumbai", info: "12 Oct 2018 | Non-refundable")]
    
    // Picker Data
    
    var pickerData: [String] = ["Child Meal (CHML)", "Bland Meal (BLML)", "Baby / Infant meal (BBML) ", "Diabetic Meal (DML)", "Asian Vegetarian Meal (AVML)"]
    
    func getPreferenceMaster() {
        delegate?.willGetPreferenceMaster()
        
        APICaller.shared.getPreferenceMaster { [weak self] (success, seatPreferences, mealPreferences, errors) in
            guard let sSelf = self else { return }
            if success {
                sSelf.seatPreferences = seatPreferences
                sSelf.mealPreferences = mealPreferences
                sSelf.delegate?.getPreferenceMasterSuccess()
            } else {
                sSelf.delegate?.getPreferenceMasterFail()
            }
        }
        
        
    }
    
    func createParams() -> JSONDictionary {
        
//        for leg in self.bookingDetails?.bookingDetail?.leg ?? [] {
//            for pax in leg.pax {
//                for frequentflyerData in self.bookingDetails?.frequentFlyerData ?? [] {
//                    if pax.paxId == frequentflyerData.passenger?.paxId ?? "" {
//                        pax.flight = frequentflyerData.flights ?? []
//                    }
//                }
//            }
//        }
        
         var params = JSONDictionary()
        
    
        return params
    }
    
    func postAddOnRequest() {
        
        
        
     
//        addon[15841][seat]: window
//        addon[15841][meal]: sandwich
//        addon[15841][baggage]: none
//        addon[15841][other]: none
//        preference[18682][seat]: A
//        preference[18682][meal]: FPML
//        ff[18682][AI]: 123456
//        booking_id: 8926

//        params["addon[15841][seat]"] = "window"
//        params["addon[15841][meal]"] = "sandwich"
//        params["booking_id"] = 8926
        
        APICaller.shared.addOnRequest(params: createParams()) { (success, errorCodes) in
            if success {
                
            } else {
                
            }
        }
      
    
        
    }
    
}
