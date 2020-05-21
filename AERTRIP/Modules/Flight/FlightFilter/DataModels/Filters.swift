//
//  Filters.swift
//  Aertrip
//
//  Created by  hrishikesh on 01/03/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import UIKit


enum Filters : Int,  CaseIterable{
    case sort = 0
    case stops
    case Times
    case Duration
//    case Amenities
    case Airlines
    case Airport
    case Quality
    case Price
//    case API
    
}



extension Filters {
    
    var intReturnOrMCSortVC: UIViewController {
        return IntReturnAndMCSortVC()
    }
        
    var  viewController : UIViewController {
        switch self {
        case .sort:
            return FlightSortFilterViewController()
        case .stops:
            return FlightStopsFilterViewController()
        case .Times:
            return FlightFilterTimesViewController()
        case .Duration:
            return FlightDurationFilterViewController()
//        case .Amenities:
//            return FlightFilterAmenitiesViewController()
        case .Airlines:
            return AirlinesFilterViewController()
        case .Airport:
            return AirportsFilterViewController()
        case .Quality:
            return QualityFilterViewController()
        case .Price:
            return PriceFilterViewController()
//        case .API:
//            return FlightAPIFilterViewController()
        }
    }
    
    
    var title : String {
        switch  self {
        case .sort:
            return "Sort"
        case .stops:
            return "Stops"
        case .Times:
            return "Times"
        case .Duration:
            return "Duration"
//        case .Amenities:
//            return "Amenties"
        case .Airlines:
            return "Airlines"
        case .Airport:
            return "Airports"
        case .Quality:
            return "Quality"
        case .Price:
            return "Price"
//        case .API:
//            return "API"
        }
    }
}

//MARK:- UIFilters
enum UIFilters : Int,  CaseIterable {
    case refundableFares
    case hideLongerOrExpensive
    case hideOvernight
    case hideChangeAirport
    case hideOvernightLayover
    case originAirports
    case destinationAirports
    case layoverAirports
    case hideMultiAirlineItinarery
    case originDestinationSame
    case originDestinationSelectedForReturnJourney
    case allAirlinesSelected
}

extension UIFilters {
    var title : String {
        switch self {
        case .hideChangeAirport:
            return "Hide Change Airport Itineraries"
        case .hideLongerOrExpensive:
            return "Show Longer or More Expensive itineraries"
        case .refundableFares:
            return "Refundable fares only"
        case .hideOvernight:
            return "Hide Overnight Flight Itineraries"
        case .hideOvernightLayover:
            return "Hide Overnight Layover Itineraries"
        default:
            return ""
            
        }
    }
}


//MARK:- Sort
enum Sort : Int, CaseIterable {
    
    case Smart
    case Price
    case Duration
    case Depart
    case Arrival
    case ArrivalLatestFirst
    case DurationLatestFirst
    
}

extension Sort {
    var title : String {
        switch self {
        case .Smart:
         return  "Smart"
        case .Price:
        return  "Price"
        case .Depart:
         return  "Depart"
        case .Arrival:
          return "Arrival"
        case .Duration:
          return "Duration"
        default :
            return ""
        }
    }
    
    var subTitle : String {
        switch self {
        case .Smart:
            return "Recommended"
        case .Price:
            return "Low to high"
        case .Depart:
            return "Earliest first"
        case .Arrival:
            return "Earliest first"
        case .Duration:
            return "Shortest first"
        default:
            return ""
        }
    }
}

//MARK:-
enum API : Int , CaseIterable {
    case Riya
    case TP
    case Indigo
}


extension API {
    var title : String {
        switch self {
        case .Riya:
            return "Riya"
        case .TP:
            return "TP"
        case .Indigo:
            return "Indigo"
        }
    }
}

//MARK:- QualityFilter
struct QualityFilter {
    var name : String
    var filterKey : String
    var isSelected : Bool
    var filterID : UIFilters
    
    func getFilterDescription() -> String {
        switch filterKey {
        case "ovgtf":
            return "Itineraries which arrive/depart at uncomfortable hours will get filtered."
        case "ovgtlo":
            return "Itineraries which has layovers at uncomfortable hours will get filtered."
        default: return ""
        }
    }
}
