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
    
}
