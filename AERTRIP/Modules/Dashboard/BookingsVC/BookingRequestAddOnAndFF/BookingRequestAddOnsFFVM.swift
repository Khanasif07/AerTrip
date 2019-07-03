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
    func willSendAddOnFFRequest()
    func sendAddOnFFRequestSuccess()
    func failAddOnFFRequestFail(errorCode: ErrorCodes)
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
        self.delegate?.willGetPreferenceMaster()
        
        APICaller.shared.getPreferenceMaster { [weak self] success, seatPreferences, mealPreferences, _ in
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
        // create for Finat Params for Add on VC and RequestVC.
        var params = JSONDictionary()
        if !self.isLCC {
            for frequentFlyerData in self.bookingDetails?.frequentFlyerData ?? [] {
                for flight in frequentFlyerData.flights {
                    if !flight.frequentFlyerNumber.isEmpty {
                        params["ff[\(frequentFlyerData.passenger?.paxId ?? "")][\(flight.carrierCode)]"] = flight.frequentFlyerNumber
                    }
                }
            }
            
            for leg in self.bookingDetails?.bookingDetail?.leg ?? [] {
                for pax in leg.pax {
                    if !pax.seatPreferences.isEmpty {
                        params["preference[\(pax.paxId)][seat]"] = self.seatPreferences.someKey(forValue: pax.seatPreferences)
                    }
                    
                    if !pax.mealPreferenes.isEmpty {
                        params["preference[\(pax.paxId)][meal]"] = self.mealPreferences.someKey(forValue: pax.mealPreferenes)
                    }
                    if !pax.baggage.isEmpty {
                        params["addon[\(pax.paxId)][baggage]"] = pax.baggage
                    }
                    if !pax.other.isEmpty {
                        params["addon[\(pax.paxId)][other]"] = pax.other
                    }
                }
            }
            
        } else {
            for leg in self.bookingDetails?.bookingDetail?.leg ?? [] {
                for pax in leg.pax {
                    if !pax.seat.isEmpty {
                        params["addon[\(pax.paxId)][seat]"] = pax.seat
                    }
                    if !pax.meal.isEmpty {
                        params["addon[\(pax.paxId)][meal]"] = pax.meal
                    }
                    
                    if !pax.baggage.isEmpty {
                        params["addon[\(pax.paxId)][baggage]"] = pax.baggage
                    }
                    if !pax.other.isEmpty {
                        params["addon[\(pax.paxId)][other]"] = pax.other
                    }
                }
            }
        }
        params["booking_id"] = self.bookingDetails?.id
        
        return params
    }
    
    func postAddOnRequest() {
        self.delegate?.willSendAddOnFFRequest()
        APICaller.shared.addOnRequest(params: self.createParams()) { [weak self] success, errorCodes in
            guard let sSelf = self else {
                fatalError("self not found")
            }
            if success {
                sSelf.delegate?.sendAddOnFFRequestSuccess()
            } else {
                sSelf.delegate?.failAddOnFFRequestFail(errorCode: errorCodes)
            }
        }
    }
}
