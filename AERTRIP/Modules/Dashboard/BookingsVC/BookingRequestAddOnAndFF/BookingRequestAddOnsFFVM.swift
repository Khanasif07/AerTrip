//
//  BookingRequestAddOnsFFVM.swift
//  AERTRIP
//
//  Created by apple on 22/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

class BookingRequestAddOnsFFVM {
    
    
    // FrequentFlyer Data
    var sectionData: [(profileImage: UIImage, userName: String)] = [(profileImage:UIImage(named:"boy")!,userName:"Mr. Alan McCarthy"),(profileImage:UIImage(named:"boy")!,userName:"Mrs. Jane McCarthy"),(profileImage:UIImage(named:"boy")!,userName:"Mr. Steve McCarthy"),(profileImage:UIImage(named:"boy")!,userName:"Miss. June McCarthy")]
    
    var ffAirlineData: [(airlineImage: UIImage, airlineName: String)] = [(airlineImage:UIImage(named:"aertripGreenLogo")!,airlineName:"Air India"),(airlineImage:UIImage(named:"aertripGreenLogo")!,airlineName:"Jet Airways")]
    
    // AddOn Data
    
    var sectionDataAddOns : [(title: String, info: String)] = [(title:"Mumbai → Delhi",info:"12 Oct 2018 | Non-refundable"),(title:"Delhi → Mumbai",info:"12 Oct 2018 | Non-refundable")]
    
    // Picker Data
    
    var pickerData: [String] = ["Child Meal (CHML)","Bland Meal (BLML)","Baby / Infant meal (BBML) ","Diabetic Meal (DML)","Asian Vegetarian Meal (AVML)"]

    
    
    
}
