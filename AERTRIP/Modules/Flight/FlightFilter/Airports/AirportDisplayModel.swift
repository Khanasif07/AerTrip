//
//  AirportDisplayModel.swift
//  Aertrip
//
//  Created by  hrishikesh on 11/03/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import Foundation


struct Airport: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(IATACode)
    }
    
    let name : String
    let IATACode : String
    let city : String
    var isSelected : Bool
    init (name: String , IATACode : String , city : String , isSelected : Bool = false ){
        self.name = name
        self.IATACode = IATACode
        self.city = city
        self.isSelected = isSelected
    }
}


struct AirportsGroupedByCity {
    let name : String
    var airports : [Airport]
    
    mutating func selectAll(_ isSelected : Bool) {
        
        airports = airports.map{
            var airport = $0
            airport.isSelected = isSelected
            return airport
        }
    }

    var airportsCount : Int {
        return airports.count
    }
    
    func filterApplied()-> Bool {
        return airports.reduce(false){ $0 || $1.isSelected }
    }
    
    func allSelected()-> Bool {
         return airports.reduce(true){ $0 && $1.isSelected }
    }
}


struct  LayoverDisplayModel {
    let country : String
    var airports : [Airport]
    
    mutating func selectAll(_ isSelected : Bool) {
        
        airports = airports.map{
            var airport = $0
            airport.isSelected = isSelected
            return airport
        }
    }
    
    var airportsCount : Int {
        return airports.count
    }
    
    func filterApplied()-> Bool {
        return airports.reduce(false){ $0 || $1.isSelected }
    }
    
    func allSelected()-> Bool {
         return airports.reduce(true){ $0 && $1.isSelected }
    }
}



struct AirportLegFilter {
    
    let leg : Leg
    var originCities : [AirportsGroupedByCity]
    var destinationCities : [AirportsGroupedByCity]
    var layoverCities : [LayoverDisplayModel]
    var sameDepartReturnSelected = false
    var allLayoverSelectedByUserInteraction = false
    
    var originCitiesSortedArray : [AirportsGroupedByCity]{
        return originCities.sorted(by: { $0.name < $1.name })
    }
    
    
    var destinationCitiesSortedArray : [AirportsGroupedByCity]{
        return destinationCities.sorted(by: { $0.name < $1.name })
    }
    
    var originAirportsCount : Int {
        return originCities.reduce( 0 ) { $0 + $1.airportsCount }
    }
    
    var destinationAirportsCount : Int {
        return destinationCities.reduce( 0 ) { $0 + $1.airportsCount}
    }

    var layoverAirportsCount : Int {
        return layoverCities.reduce( 0 ) { $0 + $1.airportsCount }
    }
    
    func filterApplied() ->Bool {
      
        // Rishabh
        var isApplied = false
   
        if originAirportsCount > 1 {
            isApplied = isApplied || originCities.reduce( false ) { $0 || $1.filterApplied()}
        }
        
        if destinationAirportsCount > 1 {
            isApplied = isApplied ||  destinationCities.reduce( false ) { $0 || $1.filterApplied()}
        }
        
        if layoverAirportsCount > 1 {
            isApplied = isApplied || layoverCities.reduce( false ) { $0 || $1.filterApplied() }
        }
        
        return isApplied
    }
    
    func allLayoverSelected() -> Bool {
        return layoverCities.reduce(true) { $0 && $1.allSelected() }
    }
    
    func allOriginDestinationSelected() -> Bool {
        let allOriginSelected = originCities.reduce(true) { $0 && $1.allSelected() }
        let allDestinationSelected = destinationCities.reduce(true) { $0 && $1.allSelected() }
        return allOriginSelected && allDestinationSelected
    }
    
    /// to get list of all selected airports
    var allSelectedAirports: [Airport] {
        var selectedAirports = [Airport]()
        originCities.forEach { (city) in
            selectedAirports.append(contentsOf: city.airports.filter { $0.isSelected })
        }
        destinationCities.forEach { (city) in
            selectedAirports.append(contentsOf: city.airports.filter { $0.isSelected })
        }
        layoverCities.forEach { (city) in
            selectedAirports.append(contentsOf: city.airports.filter { $0.isSelected })
        }
        return selectedAirports
    }
}
