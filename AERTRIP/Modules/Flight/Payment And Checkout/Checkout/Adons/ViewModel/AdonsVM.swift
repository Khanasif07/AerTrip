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
    func failedToBookBlight(error:ErrorCodes)
}

class AdonsVM  {
    
    enum AdonsType : Int  {
        case meals = 0
        case baggage
        case seat
        case otheres
    }
    
    struct AddonsData{
        var heading : String
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
    
    var addonsData : [AddonsData] = []
    var parmsForItinerary:JSONDictionary = [:]
    var afCount = 0
    weak var delegate : BookFlightDelegate?
    var bookingObject = BookFlightObject()
    var isSkipButtonTap = false
    var isComplementaryMealAdded : Bool {
        let dataStore = AddonsDataStore.shared
        return dataStore.isFreeMeal
    }
    
    var getComplementaryMealString : String {
        
        if isComplementaryMealAdded {
            var isMealGreaterThenOne = false
            
            AddonsDataStore.shared.flightsWithData.forEach { (flight) in
                if flight.meal.addonsArray.count > 1 && !isMealGreaterThenOne {
                    isMealGreaterThenOne = true
                }
            }
            
            return isMealGreaterThenOne ? LocalizedString.Complementary_Meal_Available.localized : LocalizedString.Complementary_Meal_Added.localized
            
        }else{
            return ""
        }
      }
        
    var isFreeSeatsAdded : Bool {
          let dataStore = AddonsDataStore.shared
            return dataStore.isFreeSeat
         // return dataStore.itinerary.freeSeats || dataStore.itinerary.freeMealSeat
      }
      
       var getFreeSeatsString : String {
        return isFreeSeatsAdded ? LocalizedString.Free_Seats_Available.localized : ""
       }
    
    private var priceDict : [String : Int] = [:]

    
    func setAdonsOptions(){
        
        let flightsWithData = AddonsDataStore.shared.flightsWithData
        let flightsWithMeals = flightsWithData.filter { !$0.meal.addonsArray.isEmpty }
        let flightsWithBaggage = flightsWithData.filter {!$0.bags.addonsArray.isEmpty }
        let flightsWithOthers = flightsWithData.filter { !$0.special.addonsArray.isEmpty }
        
        if !flightsWithMeals.isEmpty {
            addonsData.append(AdonsVM.AddonsData(type: .meals, heading: LocalizedString.Meals.localized, description: LocalizedString.Choose_Meal.localized, complementString: getComplementaryMealString, shouldShowComp: isComplementaryMealAdded))
        }
        
        if !flightsWithBaggage.isEmpty {
            addonsData.append(AdonsVM.AddonsData(type: .baggage, heading: LocalizedString.Baggage.localized, description: LocalizedString.Choose_Baggage.localized, complementString: "", shouldShowComp: false))
        }
        
        addonsData.append(AdonsVM.AddonsData(type: .seat, heading: LocalizedString.Seat.localized, description: LocalizedString.Reserve_Seat.localized, complementString: getFreeSeatsString, shouldShowComp: isFreeSeatsAdded))
        
     //   if !flightsWithOthers.isEmpty{
            addonsData.append(AdonsVM.AddonsData(type: .otheres, heading: LocalizedString.Other.localized, description: LocalizedString.PreBook_Services.localized, complementString: "", shouldShowComp: false))
      //  }
        
    }
    
    func getAddonsPriceDict()-> [String : Int]{
        var newDict = [String:Int]()
        for (key, value) in self.priceDict{
            if value != 0{
                newDict[key] = value
            }
        }
        return newDict
    }
    
    func updatePriceDict(key : String, value : String?){
        guard let val = value else {
            priceDict[key] = nil
            return
        }
        priceDict[key] = Int(val)

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
        var legFKs = [String]()
        if !AddonsDataStore.shared.itinerary.isInternational {
            legFKs = AddonsDataStore.shared.itinerary.details.leg
        }
        let viewModel = SeatMapContainerVM(AddonsDataStore.shared.itinerary.sid, AddonsDataStore.shared.itinerary.id, AddonsDataStore.shared.itinerary.details.fk, legFKs)
        return viewModel
    }
    

    func initializeFreeMealsToPassengers(){
         
        let dataStore = AddonsDataStore.shared
        
        dataStore.flightsWithData.enumerated().forEach { (flightINdex, flight) in
            
            if !flight.freeMeal || flight.meal.addonsArray.count > 1 { return }
            
            var mealsSelectedFor : [ATContact] = []
            
            if let firstMeal = flight.meal.addonsArray.firstIndex(where: { (meal) -> Bool in
                return meal.price == 0
            }){
                guard let allPassengers = GuestDetailsVM.shared.guests.first else { return }
                
                allPassengers.forEach { (contact) in
                    
                    if contact.passengerType == .Adult && flight.meal.addonsArray[firstMeal].isAdult {
                        mealsSelectedFor.append(contact)
                    }
                    
                    if contact.passengerType == .Child && flight.meal.addonsArray[firstMeal].isChild {
                        mealsSelectedFor.append(contact)
                    }
                    
                    if contact.passengerType == .Infant && flight.meal.addonsArray[firstMeal].isInfant {
                        mealsSelectedFor.append(contact)
                    }
                }
                AddonsDataStore.shared.flightsWithData[flightINdex].meal.addonsArray[firstMeal].mealsSelectedFor = mealsSelectedFor
            }
        }
      }
}

//MARK:- MAeals
extension AdonsVM {

    func isMealSelected() -> Bool {
          
          let dataStore = AddonsDataStore.shared
          
          var isMealSelected = false
          
          dataStore.flightsWithData.forEach { (flight) in
              let meals = flight.meal.addonsArray.filter { !$0.mealsSelectedFor.isEmpty }
              if !isMealSelected{
                  isMealSelected = !meals.isEmpty
              }
            
          }
          
          return isMealSelected
      }
      
      func setMealsString() {
          
          let dataStore = AddonsDataStore.shared
          
          var description = ""
          var count = 0
            var mealsTotal = 0
        
          if self.isMealSelected(){
              dataStore.flightsWithData.forEach { (flight) in
                  let others = flight.meal.addonsArray.filter { !$0.mealsSelectedFor.isEmpty }
                  others.forEach { (other) in
                    
                    mealsTotal += other.price * other.mealsSelectedFor.count
                    
                      other.mealsSelectedFor.forEach { (passenger) in
                          count += 1
//                          guard let desc = other.ssrName?.name else { return }
//                          description += "\(desc), "
                      }
                  }
              }
            description = "\(LocalizedString.Total.localized) : ₹\(mealsTotal.commaSeprated)"
          }
          
          if description.isEmpty {
              description = LocalizedString.Choose_Meal.localized
          }
          
          if let ind = self.addonsData.firstIndex(where: { (addonsData) -> Bool in
              return addonsData.addonsType == .meals
          }){
              self.addonsData[ind].heading = count != 0 ? LocalizedString.Meals.localized + "  " + "x\(count)" : LocalizedString.Meals.localized
            self.addonsData[ind].description = description.replacingLastOccurrenceOfString(", ", with: "")
            
                //description.replacingLastOccurrenceOfString(", ", with: "")
          }
      }
    
    
    func updateMealsSelectionInMainArray(){
        AddonsDataStore.shared.flightsWithDataForMeals.forEach { (flightDataForMeals) in
            
            if let ind =  AddonsDataStore.shared.flightsWithData.lastIndex(where: { (flightMainData) -> Bool in
                flightDataForMeals.flightId == flightMainData.flightId
            }) {
                AddonsDataStore.shared.flightsWithData[ind].meal = flightDataForMeals.meal
            }
        }
        
    }
    
}

//MARK:- Baggage
extension AdonsVM {
    
    func isBaggageSelected() -> Bool {
        let dataStore = AddonsDataStore.shared
        
        var isBaggageSelected = false
        
        dataStore.flightsWithData.forEach { (flight) in
            let baggages = flight.bags.addonsArray.filter { !$0.bagageSelectedFor.isEmpty }
            if !isBaggageSelected{
                isBaggageSelected = !baggages.isEmpty
            }
        }
        
        return isBaggageSelected
    }
    
    func setBaggageStrings() {
        
        let dataStore = AddonsDataStore.shared
        
        var description = ""
        var count = 0
        var baggageTotal = 0

        
        if self.isBaggageSelected(){
            dataStore.flightsWithData.forEach { (flight) in
                let baggage = flight.bags.addonsArray.filter { !$0.bagageSelectedFor.isEmpty }
                baggage.forEach { (bag) in
                    
                    baggageTotal += bag.price * bag.bagageSelectedFor.count

                    
                    bag.bagageSelectedFor.forEach { (passenger) in
                        count += 1
//                        guard let desc = bag.ssrName?.name else { return }
//                        description += "\(desc), "
                    }
                }
            }
            description = "\(LocalizedString.Total.localized) : ₹\(baggageTotal.commaSeprated)"

        }
        
        if description.isEmpty {
            description = LocalizedString.Choose_Baggage.localized
        }
        
        if let ind = self.addonsData.firstIndex(where: { (addonsData) -> Bool in
            return addonsData.addonsType == .baggage
        }){
            self.addonsData[ind].heading = count != 0 ? LocalizedString.Baggage.localized + "  " + "x\(count)" : LocalizedString.Baggage.localized
            self.addonsData[ind].description = description.replacingLastOccurrenceOfString(", ", with: "")
        }
    }
    
    func updateBaggageSelectionInMainArray(){
        AddonsDataStore.shared.flightsWithDataForBaggage.forEach { (flightDataForBaggage) in
            
            if let ind =  AddonsDataStore.shared.flightsWithData.lastIndex(where: { (flightMainData) -> Bool in
                flightDataForBaggage.flightId == flightMainData.flightId
            }) {
                AddonsDataStore.shared.flightsWithData[ind].bags = flightDataForBaggage.bags
            }
        }
    }
    
}

//MARK:- Others
extension AdonsVM {
    
      func isOthersSelected() -> Bool {
          
          let dataStore = AddonsDataStore.shared
          
          var isOtherSelected = false
          
          dataStore.flightsWithData.forEach { (flight) in
              let others = flight.special.addonsArray.filter { !$0.othersSelectedFor.isEmpty }
              if !isOtherSelected{
                  isOtherSelected = !others.isEmpty
              }
          }
          return isOtherSelected
      }
    
    func isSpecialRequestAdded() -> Bool {
        let dataStore = AddonsDataStore.shared
        var isSpecialRequestAdded = false

        dataStore.flightsWithData.forEach { (flight) in
            if !isSpecialRequestAdded{
                isSpecialRequestAdded = !flight.specialRequest.isEmpty
            }
        }
        return isSpecialRequestAdded
    }
      
    
    func setOthersString() {
        
        let dataStore = AddonsDataStore.shared
        var description = ""
        var count = 0
        var othersTotal = 0

        
        if self.isOthersSelected(){
            
            dataStore.flightsWithData.forEach { (flight) in
                let others = flight.special.addonsArray.filter { !$0.othersSelectedFor.isEmpty }
                others.forEach { (other) in
                    
                    othersTotal += other.price * other.othersSelectedFor.count

                    other.othersSelectedFor.forEach { (passenger) in
                        count += 1
//                        guard let desc = other.ssrName?.name else { return }
//                        description += "\(desc), "
                    }
                }
            }
            description = "\(LocalizedString.Total.localized) : ₹\(othersTotal.commaSeprated) "
        }
        
        if self.isSpecialRequestAdded() {
            
            let speReq = description.isEmpty ? "Special Request" : "+ Special Request"
            description = speReq
        }
        
        if description.isEmpty {
            description = LocalizedString.PreBook_Services.localized.localized
        }
        
        if let ind = self.addonsData.firstIndex(where: { (addonsData) -> Bool in
            return addonsData.addonsType == .otheres
        }){
            self.addonsData[ind].heading = count != 0 ? LocalizedString.Other.localized + "  " + "x\(count)" : LocalizedString.Other.localized
            self.addonsData[ind].description = description.replacingLastOccurrenceOfString(", ", with: "")
        }
        
    }
    
//    func updateOthersSelectionInMainArray(){
//        AddonsDataStore.shared.flightsWithDataForOthers.forEach { (flightDataForOthers) in
//
//            if let ind =  AddonsDataStore.shared.flightsWithData.lastIndex(where: { (flightMainData) -> Bool in
//                flightDataForOthers.flightId == flightMainData.flightId
//            }) {
//                AddonsDataStore.shared.flightsWithData[ind].special = flightDataForOthers.special
//            }
//        }
//    }
    
    
}


//MARK:- Seat
extension AdonsVM {
    
      func setSeatsString() {
           let dataStore = AddonsDataStore.shared
           var headingStr = ""
           var descStr = ""
           let selectedSeatsCount = dataStore.seatsArray.count
           if selectedSeatsCount > 0 {
               headingStr = "x\(selectedSeatsCount)"
           }
           let flightSequenceArr = dataStore.allFlights.map { $0.ffk }
            var seatsTotal = 0

        
           if selectedSeatsCount > 0 {
    
               flightSequenceArr.forEach { (flightKey) in
                    var seats = dataStore.seatsArray.filter { $0.ffk == flightKey }
                    if seats.count > 0 {
                        seats.sort(by: { $0.columnData.ssrCode < $1.columnData.ssrCode })
                      
                        
                        if let seatTo = priceDict["Seat"] {
                            seatsTotal = seatTo
                        }
                        
                        seats.forEach { (seatData) in
//                            var rowStr: String {
//                                if let number = Int(seatData.columnData.ssrCode.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
//                                    print(number)
//                                    return "\(number)"
//                                }
//                                return ""
//                            }
//                            let columnStr = seatData.columnData.ssrCode.components(separatedBy: CharacterSet.letters.inverted).joined()
//
//                            let seatNumber = rowStr + columnStr
//
//                            if let passenger = seatData.columnData.passenger {
//                                descStr.append(seatNumber + " - " + passenger.firstName + ", ")
//                            }
                        }
                    }
                }
               if descStr.hasSuffix(", ") {
                   descStr.removeLast(2)
               }
            descStr = "\(LocalizedString.Total.localized) : ₹\(seatsTotal.commaSeprated)"

           }
           
           if descStr.isEmpty {
               descStr = LocalizedString.Reserve_Seat.localized.localized
           }

           if let ind = self.addonsData.firstIndex(where: { (addonsData) -> Bool in
                     return addonsData.addonsType == .seat
                 }){
                     self.addonsData[ind].heading = selectedSeatsCount > 0 ? LocalizedString.Seat.localized + "  " + headingStr : LocalizedString.Seat.localized
                     self.addonsData[ind].description = descStr
                 }
       }
       
}


//MARK:- Api related functions
extension AdonsVM {
    
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
                    self.parmsForItinerary["t[\(i)][\(APIKeys.mobile.rawValue)]"] = dataStore.passengers[i].contact
                    self.parmsForItinerary["t[\(i)][\(APIKeys.isd.rawValue)]"] = dataStore.passengers[i].isd
                    self.parmsForItinerary["t[\(i)][\(APIKeys.email.rawValue)]"] = dataStore.passengers[i].emailLabel
                }
                if dataStore.itinerary.isInternational{
                    self.parmsForItinerary["t[\(i)][\(APIKeys.dob.rawValue)]"] = dataStore.passengers[i].dob
                    self.parmsForItinerary["t[\(i)][\(APIKeys.passportNumber.rawValue)]"] = dataStore.passengers[i].passportNumber
                    self.parmsForItinerary["t[\(i)][\(APIKeys.passportExpiryDate.rawValue)]"] = dataStore.passengers[i].passportExpiryDate
                    self.parmsForItinerary["t[\(i)][\(APIKeys.passportCountry.rawValue)]"] = dataStore.passengers[i].countryCode
                }else{
                    if type == .Infant || type == .Child{
                        self.parmsForItinerary["t[\(i)][\(APIKeys.dob.rawValue)]"] = dataStore.passengers[i].dob
                    }
                }
                let id = dataStore.passengers[i].apiId
                self.parmsForItinerary["t[\(i)][\(APIKeys.paxId.rawValue)]"] = id
                self.parmsForItinerary["t[\(i)][upid]"] = id
                self.checkForMealPreferences(id: id, passenger: dataStore.passengers[i])
                self.checkForFrequentFlyer(id: id, passenger: dataStore.passengers[i])
             }
            if dataStore.isGSTOn{
                self.parmsForItinerary["gst[number]"] = dataStore.gstDetail.GSTInNo
                self.parmsForItinerary["gst[company_name]"] = dataStore.gstDetail.companyName
                self.parmsForItinerary["gst[address_line1]"] = dataStore.gstDetail.billingName
                self.parmsForItinerary["gst[address_line2]"] = ""
                self.parmsForItinerary["gst[city]"] = "maharastra"
                self.parmsForItinerary["gst[postal_code]"] = "400001"
                
            }
         }

        
        func checkForMeals() {
            let dataStore = AddonsDataStore.shared
            dataStore.flightsWithData.forEach { (flight) in
                let meals = flight.meal.addonsArray.filter { !$0.mealsSelectedFor.isEmpty }
                meals.forEach { (meal) in
                    meal.mealsSelectedFor.forEach { (passenger) in
                        self.parmsForItinerary["apf[\(self.afCount)]"] = "\(flight.legId)|\(flight.flightId)|\(passenger.apiId)|addon|meal|\(meal.ssrName?.code ?? "")|\(meal.price)|\(meal.ssrName?.isReadOnly ?? 0)"
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
                        self.parmsForItinerary["apf[\(self.afCount)]"] = "\(flight.legId)|\(flight.flightId)|\(passenger.apiId)|addon|baggage|\(baggage.ssrName?.code ?? "")|\(baggage.price)|\(baggage.ssrName?.isReadOnly ?? 0)"
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
                        self.parmsForItinerary["apf[\(self.afCount)]"] = "\(flight.legId)|\(flight.flightId)|\(passenger.apiId)|addon|special|\(other.ssrName?.code ?? "")|\(other.price)|\(other.ssrName?.isReadOnly ?? 0)"
                        self.afCount += 1
                    }
                }
            }
        }
        
    func checkForSpecialRequest() {
        let dataStore = AddonsDataStore.shared

        dataStore.flightsWithData.forEach { (flight) in
            
            if flight.specialRequest.isEmpty{
                return
            }
            
            self.parmsForItinerary["flight_special_request[\(flight.legId)]"] = flight.specialRequest
            
//                  let others = flight.special.addonsArray.filter { !$0.othersSelectedFor.isEmpty }
                 
        }
    }
    
    
        private func checkForSelectedSeats() {
            let dataStore = AddonsDataStore.shared
            dataStore.seatsArray.forEach { (seatData) in
                let passengerId = seatData.columnData.passenger?.apiId ?? ""
                
                var rowStr: String {
                    if let number = Int(seatData.columnData.ssrCode.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
                        print(number)
                        return "\(number)"
                    }
                    return ""
                }
                let columnStr = seatData.columnData.ssrCode.components(separatedBy: CharacterSet.letters.inverted).joined()
            
                let seatNumber = rowStr + columnStr
                
                let priceStr = "\(seatData.columnData.amount)"
                parmsForItinerary["apf[\(self.afCount)]"] = "\(seatData.lfk)|\(seatData.ffk)|\(passengerId)|addon|seatmap_ex|\(seatNumber)|\(priceStr)"
                afCount += 1
                            
                let seatParamBaseStr = "seatmap[\(seatData.lfk)][\(seatData.ffk)][\(passengerId)]"
                parmsForItinerary[seatParamBaseStr+"[row]"] = rowStr
                parmsForItinerary[seatParamBaseStr+"[column]"] = columnStr
                parmsForItinerary[seatParamBaseStr+"[price]"] = priceStr
                parmsForItinerary[seatParamBaseStr+"[isOverwing]"] = "\(seatData.isWindowSeat)"
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
        
         /// To get Itenerary Data from API
    //    func bookFlightWithAddons(){
    //        self.delegate?.willBookFlight()
    //        // self.createParamForItineraryApi()
    //        self.checkForMeals()
    //        self.checkForBaggage()
    //        self.checkForOthers()
    //        APICaller.shared.getItineraryData(params: self.parmsForItinerary, itId: AddonsDataStore.shared.itinerary.id) { (success, error, itinerary) in
    //            if success, let iteneraryData = itinerary{
    //                AddonsDataStore.shared.appliedCouponData = iteneraryData
    //                self.delegate?.bookFlightSuccessFully()
    //                //AddonsDataStore.shared.taxesDataDisplay()
    //            }else{
    //                self.delegate?.failedToBookBlight()
    //            }
    //        }
    //    }
        
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
                    self.delegate?.failedToBookBlight(error: error)
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
            self.checkForSelectedSeats()
            checkForSpecialRequest()
  
            APICaller.shared.getItineraryData(withAddons : true, params: self.parmsForItinerary, itId: AddonsDataStore.shared.itinerary.id) { (success, error, itinerary) in
                if success, let iteneraryData = itinerary{
                    AddonsDataStore.shared.appliedCouponData = iteneraryData
                    self.delegate?.bookFlightSuccessFully()
                }else{
                    self.delegate?.failedToBookBlight(error:error)
                }
            }
        }
    
}
