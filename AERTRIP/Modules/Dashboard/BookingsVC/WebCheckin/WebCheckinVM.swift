//
//  WebCheckinVM.swift
//  AERTRIP
//
//  Created by Admin on 15/07/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation


class WebCheckinVM {
    var section: [String] = []
//    var aertripData: [(image: UIImage, title: String, number: String)] = [(UIImage(named: "aertripGreenLogo")!, "Customer Care", "119-164-1011"), (UIImage(named: "aertripGreenLogo")!, "Mr. Alex Gomes (RM)", "119-164-1011")]
//    var airlineData: [(image: UIImage, title: String, number: String)] = [(UIImage(named: "aertripGreenLogo")!, "Jet Airways", "119-164-1011"), (UIImage(named: "aertripGreenLogo")!, "Air India", "503-799-2816"), (UIImage(named: "aertripGreenLogo")!, "Vistara", "401-203-45736"), (UIImage(named: "aertripGreenLogo")!, "Emirates", "541-144-9238")]
//    var airportData: [(airPortTitle: String, title: String, number: String)] = [("VIE", "Athens, GR", "119-164-1011"), ("GOI", "Venice, IT", "503-799-2816"), ("VCE", "Monclova, MX", "401-203-4573"), ("TSF", "Fort Worth Alliance Air…", "541-144-9238")]
    
    var airlineData: [BookingAirline] = []
    var contactInfo: ContactInfo?
    var webCheckins: [String] = []

    func getIntialData() {
        if let contactInfo = self.contactInfo {
                
                
//                self.aertripData = contactInfo.aertrip
                self.airlineData = contactInfo.airlines
            self.airlineData.removeAll()
            contactInfo.airlines.forEach { (airline) in
                if !airline.airlineName.isEmpty {
                    self.airlineData.append(airline)
                }
            }
            
//                self.airportData.removeAll()
//                contactInfo.airport.forEach { (airport) in
//                    if !airport.phone.isEmpty {
//                        self.airportData.append(airport)
//                    }
//                }
//                //self.airportData = contactInfo.airport
//                if !contactInfo.aertrip.isEmpty {
//                    self.section.append(LocalizedString.Aertip.localized)
//                }
                if !contactInfo.airlines.isEmpty {
                    self.section.append(LocalizedString.Airlines.localized)
                }
//                if !airportData.isEmpty {
//                    self.section.append(LocalizedString.Airports.localized)
//                }
           
        }
    }
}
