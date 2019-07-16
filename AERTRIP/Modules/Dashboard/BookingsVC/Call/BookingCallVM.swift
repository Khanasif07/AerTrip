//
//  BookingCallVM.swift
//  AERTRIP
//
//  Created by apple on 20/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

enum BookingCallVCUsingFor {
    case hotel
    case flight
}


class BookingCallVM {
    var section: [String] = []
//    var aertripData: [(image: UIImage, title: String, number: String)] = [(UIImage(named: "aertripGreenLogo")!, "Customer Care", "119-164-1011"), (UIImage(named: "aertripGreenLogo")!, "Mr. Alex Gomes (RM)", "119-164-1011")]
//    var airlineData: [(image: UIImage, title: String, number: String)] = [(UIImage(named: "aertripGreenLogo")!, "Jet Airways", "119-164-1011"), (UIImage(named: "aertripGreenLogo")!, "Air India", "503-799-2816"), (UIImage(named: "aertripGreenLogo")!, "Vistara", "401-203-45736"), (UIImage(named: "aertripGreenLogo")!, "Emirates", "541-144-9238")]
//    var airportData: [(airPortTitle: String, title: String, number: String)] = [("VIE", "Athens, GR", "119-164-1011"), ("GOI", "Venice, IT", "503-799-2816"), ("VCE", "Monclova, MX", "401-203-4573"), ("TSF", "Fort Worth Alliance Air…", "541-144-9238")]
    
    var aertripData: [Aertrip] = []
    var airlineData: [Airline] = []
    var airportData: [Airport] = []
    var hotelData: [Hotel] = []
    var contactInfo: ContactInfo?
    var usingFor: BookingCallVCUsingFor = .flight
    var hotelName: String = ""
    
    func getIntialData() {
        if let contactInfo = self.contactInfo {
            if usingFor == .flight {
                if !contactInfo.aertrip.isEmpty {
                    self.section.append(LocalizedString.Aertip.localized)
                }
                if !contactInfo.airlines.isEmpty {
                    self.section.append(LocalizedString.Airlines.localized)
                }
                if !contactInfo.airport.isEmpty {
                    self.section.append(LocalizedString.Airports.localized)
                }
                
                self.aertripData = contactInfo.aertrip
                self.airlineData = contactInfo.airlines
                self.airportData = contactInfo.airport
            } else {
                if !contactInfo.aertrip.isEmpty {
                    self.section.append(LocalizedString.Aertip.localized)
                }
                if !contactInfo.hotel.isEmpty {
                    self.section.append(LocalizedString.Hotel.localized)
                }
                self.aertripData = contactInfo.aertrip
                self.hotelData = contactInfo.hotel
            }
           
        }
    }
}
