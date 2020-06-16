//
//  AdonsVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 25/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

protocol BookFlightDelegate : class {
    func willBookFlight()
    func bookFlightSuccessFully()
    func failedToBookBlight()
}

class AdonsVM  {

    enum AdonsType : Int  {
        case meals = 0
        case baggage
        case seat
        case otheres
    }
    
    struct AddonsData{
        let heading : String
        var description : String
        var complementString : String
        var shouldShowComp : Bool
        let addonsType : AdonsType
        
        init(type : AdonsType, heading : String, description : String, complementString : String, shouldShowComp : Bool){
            self.addonsType = type
            self.heading = heading
            self.description = description
            self.complementString = complementString
            self.shouldShowComp = shouldShowComp
        }
        
    }
    
    let adOnsTitles = [LocalizedString.Meals.localized, LocalizedString.Baggage.localized, LocalizedString.Seat.localized, LocalizedString.Others.localized]
    
   // let addOnsData : [(heading : String,desc : String,complement : String, shouldShowComp : Bool)] = [( LocalizedString.Meals.localized, "Choose a meal from the menu.","Complementary meal added Complementary meal added",true), ( LocalizedString.Baggage.localized, "Choose the extra baggage service and take everything you need Choose the extra baggage service and take everything you need Choose the extra baggage service and take everything you need.","Complementary meal added",false),( LocalizedString.Seat.localized, "Reserve a seat of your choice.","Free Seats Available",true),( LocalizedString.Others.localized, "Pre-book more services for a  convenient journey","Complementary meal added",false)]
    
//    var itineraryData = FlightItineraryData()

    var addonsData : [AddonsData] = []
    
    var parmsForItinerary:JSONDictionary = [:]
    var afCount = 0
    weak var delegate : BookFlightDelegate?
    var bookingObject = BookFlightObject()
    
    func setAdonsOptions(){
        
        let flightsWithData = AddonsDataStore.shared.flightsWithData
        
           let flightsWithMeals = flightsWithData.filter { !$0.meal.addonsArray.isEmpty }
           let flightsWithBaggage = flightsWithData.filter {!$0.bags.addonsArray.isEmpty }
           let flightsWithOthers = flightsWithData.filter {!$0.special.addonsArray.isEmpty }

        if !flightsWithMeals.isEmpty{
            addonsData.append(AdonsVM.AddonsData(type: .meals, heading: LocalizedString.Meals.localized, description: LocalizedString.Choose_Meal.localized, complementString: "", shouldShowComp: false))
        }
           
        if !flightsWithBaggage.isEmpty{
            addonsData.append(AdonsVM.AddonsData(type: .baggage, heading: LocalizedString.Baggage.localized, description: LocalizedString.Choose_Baggage.localized, complementString: "", shouldShowComp: false))
        }
        
        addonsData.append(AdonsVM.AddonsData(type: .seat, heading: LocalizedString.Seat.localized, description: LocalizedString.Reserve_Seat.localized, complementString: "", shouldShowComp: false))

        if !flightsWithOthers.isEmpty{
            addonsData.append(AdonsVM.AddonsData(type: .otheres, heading: LocalizedString.Other.localized, description: LocalizedString.PreBook_Services.localized, complementString: "", shouldShowComp: false))
          }
       }
    
    func getCellHeight(index : Int) -> CGFloat {
        
            let labelWidth = UIScreen.main.bounds.width - (16 + 104 + 19 + 46)
                    
             let headingHeight = addonsData[index].heading.getTextHeight(width: labelWidth,font: AppFonts.SemiBold.withSize(18),  numberOfLines: 1)
                     
             let descHeight = addonsData[index].description.getTextHeight(width: labelWidth,font: AppFonts.Regular.withSize(14),  numberOfLines: 2)

             let complementHeight = addonsData[index].complementString.getTextHeight(width: labelWidth,font: AppFonts.Regular.withSize(12),  numberOfLines: 1) + 4
        
             let complementHeightToBeAddedOrNot : CGFloat = addonsData[index].shouldShowComp ? complementHeight : 0

             let midSpacing : CGFloat = 7
             
             let topAndBottomSpacing : CGFloat = 19 + 19
             
             let totalHeight = headingHeight + descHeight + complementHeightToBeAddedOrNot + midSpacing + topAndBottomSpacing
             
             let finalheight = totalHeight <= 104 ? 104 : totalHeight
        
        return finalheight
    }
    
    func getSeatMapContainerVM() -> SeatMapContainerVM {
        
        let viewModel = SeatMapContainerVM(AddonsDataStore.shared.itinerary.sid, AddonsDataStore.shared.itinerary.id, AddonsDataStore.shared.itinerary.details.fk)
        return viewModel
    }
    
    
    func createParamForItineraryApi(){
        let dataStore = AddonsDataStore.shared
        self.parmsForItinerary[APIKeys.mobile.rawValue] = dataStore.mobile
         self.parmsForItinerary[APIKeys.isd.rawValue] = dataStore.isd
         self.parmsForItinerary[APIKeys.email.rawValue] = dataStore.email
         self.parmsForItinerary[APIKeys.it_id.rawValue] = dataStore.itinerary.id
         self.afCount = 0
         for i in 0..<dataStore.passengers.count{
             self.parmsForItinerary["t[\(i)][\(APIKeys.firstName.rawValue)]"] = dataStore.passengers[i].firstName
             self.parmsForItinerary["t[\(i)][\(APIKeys.lastName.rawValue)]"] = dataStore.passengers[i].lastName
             let type = dataStore.passengers[i].passengerType
             self.parmsForItinerary["t[\(i)][\(APIKeys.pax_type.rawValue)]"] = type.rawValue
            self.parmsForItinerary["t[\(i)][\(APIKeys.salutation.rawValue)]"] = dataStore.passengers[i].salutation
             if type == .Adult{
                 self.parmsForItinerary["t[\(i)][\(APIKeys.mobile.rawValue)]"] = ""
                 self.parmsForItinerary["t[\(i)][\(APIKeys.isd.rawValue)]"] = ""
                 self.parmsForItinerary["t[\(i)][\(APIKeys.email.rawValue)]"] = ""
             }
             if dataStore.itinerary.isInternational{
                 self.parmsForItinerary["t[\(i)][\(APIKeys.dob.rawValue)]"] = dataStore.passengers[i].dob
                 self.parmsForItinerary["t[\(i)][\(APIKeys.passportNumber.rawValue)]"] = dataStore.passengers[i].passportNumber
                 self.parmsForItinerary["t[\(i)][\(APIKeys.passportExpiryDate.rawValue)]"] = dataStore.passengers[i].passportExpiryDate
                 self.parmsForItinerary["t[\(i)][\(APIKeys.passportCountry.rawValue)]"] = dataStore.passengers[i].countryCode
             }else{
                 if type == .infant || type == .child{
                     self.parmsForItinerary["t[\(i)][\(APIKeys.dob.rawValue)]"] = dataStore.passengers[i].dob
                 }
             }
            let id = dataStore.passengers[i].id
             self.parmsForItinerary["t[\(i)][\(APIKeys.paxId.rawValue)]"] = id
             self.parmsForItinerary["t[\(i)][upid]"] = id
            self.checkForMealPreferences(id: id, passenger: dataStore.passengers[i])
            self.checkForFrequentFlyer(id: id, passenger: dataStore.passengers[i])
         }
         if dataStore.isGSTOn{
             self.parmsForItinerary["gst[number]"] = dataStore.gstDetail.GSTInNo
             self.parmsForItinerary["gst[company_name]"] = dataStore.gstDetail.companyName
             self.parmsForItinerary["gst[address_line1]"] = dataStore.gstDetail.billingName
         }
     }
     
//     private func generatePaasengerId(index:Int, type:PassengersType)-> String{
//         switch type{
//         case .Adult:
//             return "NT_a\(index - 1)"
//         case .child:
//             return "NT_c\(index - 1)"
//         case .infant:
//             return "NT_i\(index - 1)"
//         }
//     }
     
    
    func checkForMeals() {
        let dataStore = AddonsDataStore.shared
        dataStore.flightsWithData.forEach { (flight) in
            let meals = flight.meal.addonsArray.filter { !$0.mealsSelectedFor.isEmpty }
            meals.forEach { (meal) in
                meal.mealsSelectedFor.forEach { (passenger) in
                    self.parmsForItinerary["apf[\(self.afCount)]"] = "\(flight.legId)|\(flight.flightId)|\(passenger.id)|addon|meal|\(meal.ssrName?.code ?? "")|\(meal.price)|\(meal.ssrName?.isReadOnly ?? 0)"
                    self.afCount += 1
                }
            }
        }
    }
    
    func checkForBaggage() {
        let dataStore = AddonsDataStore.shared
        dataStore.flightsWithData.forEach { (flight) in
            let baggages = flight.bags.addonsArray.filter { !$0.bagageSelectedFor.isEmpty }
            baggages.forEach { (baggage) in
                baggage.bagageSelectedFor.forEach { (passenger) in
                    self.parmsForItinerary["apf[\(self.afCount)]"] = "\(flight.legId)|\(flight.flightId)|\(passenger.id)|addon|baggage|\(baggage.ssrName?.code ?? "")|\(baggage.price)|\(baggage.ssrName?.isReadOnly ?? 0)"
                    self.afCount += 1
                }
            }
        }
    }
    
    func checkForOthers() {
        let dataStore = AddonsDataStore.shared
        dataStore.flightsWithData.forEach { (flight) in
            let others = flight.special.addonsArray.filter { !$0.othersSelectedFor.isEmpty }
            others.forEach { (other) in
                other.othersSelectedFor.forEach { (passenger) in
                    self.parmsForItinerary["apf[\(self.afCount)]"] = "\(flight.legId)|\(flight.flightId)|\(passenger.id)|addon|special|\(other.ssrName?.code ?? "")|\(other.price)|\(other.ssrName?.isReadOnly ?? 0)"
                    self.afCount += 1
                }
            }
        }
    }
    
    
     private func checkForMealPreferences(id:String, passenger:ATContact){
         let meals = passenger.mealPreference.filter{!($0.preferenceCode.isEmpty)}
         for meal in meals{
             for ffk in meal.ffk{
                 self.parmsForItinerary["apf[\(self.afCount)]"] = "\(meal.lfk)|\(ffk)|\(id)|preference|meal|\(meal.preferenceCode)|null"
                 self.afCount += 1
             }
         }
     }
     
     private func checkForFrequentFlyer(id:String, passenger:ATContact){
         let ffs = passenger.frequentFlyer.filter{!($0.number.isEmpty)}
         for ff in ffs{
             let code = ff.airlineCode.uppercased()
            for legs in AddonsDataStore.shared.addonsMaster.legs.values{
                 for flight in legs.flight{
                     if flight.frequenFlyer[code] != nil{
                         self.parmsForItinerary["apf[\(self.afCount)]"] = "\(legs.legId)|\(flight.flightId)|\(id)|ff|\(code)|\(ff.number)|null"
                         self.afCount += 1
                     }
                 }
             }
         }
     }
    
    /// To get Itenerary Data from API
       func bookFlight(){
        self.parmsForItinerary.removeAll()
        self.afCount = 0
        self.delegate?.willBookFlight()
            self.createParamForItineraryApi()
            APICaller.shared.getItineraryData(params: self.parmsForItinerary, itId: AddonsDataStore.shared.itinerary.id) { (success, error, itinerary) in
                if success, let iteneraryData = itinerary{
                    AddonsDataStore.shared.appliedCouponData = iteneraryData
                    self.delegate?.bookFlightSuccessFully()
//                    AddonsDataStore.shared.taxesDataDisplay()
                }else{
                    self.delegate?.failedToBookBlight()
                }
            }
            
        }
    
     /// To get Itenerary Data from API
           func bookFlightWithAddons(){
            self.delegate?.willBookFlight()
            self.parmsForItinerary.removeAll()
            self.afCount = 0
                self.createParamForItineraryApi()
                self.checkForMeals()
                self.checkForBaggage()
                self.checkForOthers()
            
                APICaller.shared.getItineraryData(withAddons : true, params: self.parmsForItinerary, itId: AddonsDataStore.shared.itinerary.id) { (success, error, itinerary) in
                    if success, let iteneraryData = itinerary{
                        AddonsDataStore.shared.appliedCouponData = iteneraryData
                        self.delegate?.bookFlightSuccessFully()
    //                    AddonsDataStore.shared.taxesDataDisplay()
                    }else{
                        self.delegate?.failedToBookBlight()
                    }
                }
                
            }
    
    
    
}
