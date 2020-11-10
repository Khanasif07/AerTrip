//
//  ChatVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 19/03/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol ChatBotDelegatesDelegate: class {
    
    func willstarttChatBotSession()
    func chatBotSessionCreatedSuccessfully()
    func failedToCreateChatBotSession()
    
    func willCommunicateWithChatBot()
    func chatBotCommunicatedSuccessfully()
    func failedToCommunicateWithChatBot()
    
    func hideTypingCell()
    func moveFurtherWhenallRequiredInformationSubmited(data : MessageModel)
    
    func willGetRecentSearchHotel()
    func getRecentSearchHotelSuccessFully()
    func failedToGetRecentSearchApi()
    
    func willGetRecentSearchFlights()
    func getRecentSearchFlightsSuccessFully()
    func failedToGetRecentSearchedFlightsApi()
    
    func triggerSpeechRecognizer()
    
}

extension ChatBotDelegatesDelegate {
    func triggerSpeechRecognizer() { }
}


class ChatVM {
    
    enum RecentSearchFor : String {
        case hotel = "hotel"
        case flight = "flight"
    }
    
    enum LastMessageType {
        case text
        case voice
    }
    
    var messages : [MessageModel] = []
    var typingCellTimerCounter = 0
    var sessionId : String = ""
    weak var delegate : ChatBotDelegatesDelegate?
    var msgToBeSent : String = ""
    var recentSearchesData : [RecentSearchesModel] = []
    var lastCachedResultModel: MessageModel?
    
    var lastMessageSentType: LastMessageType = .text
    
    private var updatedFiltersJSON = JSON()
    private let locationManager = CLLocationManager()
    
    private let speechSynthesizer = SpeechSynthesizer()
    var shouldProduceVoiceOutput = true
    private var shouldTriggerSpeechRecognizer = false
    
    init() {
        speechSynthesizer.onSpeechFinish = { [weak self] in
            guard let self = self else { return }
            if self.shouldTriggerSpeechRecognizer {
                self.delegate?.triggerSpeechRecognizer()
            }
        }
    }
    
    func getMylastMessageIndex() -> Int {
        
        let lastIndex = messages.lastIndex { (msg) -> Bool in
            msg.msgSource == .me
        }
        
        return lastIndex ?? messages.count - 1
    }
    
    func getRandomSessionId(length : Int) -> String{
        let letters = "0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func sendMessageToChatBot(message : String){
        sessionId.isEmpty ? startaSessionWithChatBot(message : message)  : communicateWithChatBot(message : message)
    }
    
    func startaSessionWithChatBot(message : String){
        
        self.delegate?.willstarttChatBotSession()
        
        var params : JSONDictionary = [APIKeys.session_id.rawValue : getRandomSessionId(length : 13), "q" : message]
        
        let curLoc = LocationManager.getMyLocation
        let defaultLoc = LocationManager.defaultCoordinate
        
        if curLoc.latitude != defaultLoc.latitude || curLoc.longitude != defaultLoc.longitude {
            params["latitude"] = curLoc.latitude
            params["longitude"] = curLoc.longitude
        }
        
        APICaller.shared.startChatBotSession(params: params) {[weak self] (success, message, sessionId, filters) in
            
            guard let self = self else { return }
            
            if success {
                //                self.delegate?.hideTypingCell()
                self.sessionId = sessionId
                guard let msg = message else { return }
                self.messages.append(msg)
                self.checkToProvideVoiceFeedback(msg)
                self.updatedFiltersJSON = filters
                self.delegate?.chatBotSessionCreatedSuccessfully()
                if !msg.depart.isEmpty && !msg.origin.isEmpty && !msg.destination.isEmpty {
                    self.delegate?.moveFurtherWhenallRequiredInformationSubmited(data: msg)
                }
                
                
            }else{
                self.delegate?.failedToCreateChatBotSession()
            }
        }
    }
    
    func communicateWithChatBot(message : String){
        
        self.delegate?.willCommunicateWithChatBot()
        
        var params : JSONDictionary = [APIKeys.session_id.rawValue : self.sessionId, "q" : message]
        
        let curLoc = LocationManager.getMyLocation
        let defaultLoc = LocationManager.defaultCoordinate
        
        if curLoc.latitude != defaultLoc.latitude || curLoc.longitude != defaultLoc.longitude {
            params["latitude"] = curLoc.latitude
            params["longitude"] = curLoc.longitude
        }
        
        APICaller.shared.communicateWithChatBot(params: params) {[weak self] (success, message, sessionId, filters) in
            
            guard let self = self else { return }
            
            if success {
                //                self.delegate?.hideTypingCell()
                self.sessionId = sessionId
                guard let msg = message else { return }
                self.messages.append(msg)
                self.checkToProvideVoiceFeedback(msg)
                self.updatedFiltersJSON = filters
                self.delegate?.chatBotCommunicatedSuccessfully()
                if !msg.depart.isEmpty && !msg.origin.isEmpty && !msg.destination.isEmpty {
                    self.delegate?.moveFurtherWhenallRequiredInformationSubmited(data: msg)
                    
                }
            }else{
                self.delegate?.failedToCommunicateWithChatBot()
            }
        }
    }
    
    
    func getRecentFlights(){
        APICaller.shared.recentSearchesApi(searchFor: RecentSearchFor.flight) { (success, error, obj) in
            
            self.delegate?.willGetRecentSearchHotel()
            APICaller.shared.recentSearchesApi(searchFor: RecentSearchFor.flight) { [weak self] (success, error, obj) in
                print("obj.....\(obj)")
                if success {
                    //self?.recentSearchesData = obj
                    self?.arrangeHotelAndFlightsRecentSearch(obj)
                    self?.delegate?.getRecentSearchHotelSuccessFully()
                }else{
                    self?.delegate?.failedToGetRecentSearchApi()
                }
                
            }
        }
    }
    
    private func arrangeHotelAndFlightsRecentSearch(_ array: [RecentSearchesModel]) {
        self.recentSearchesData.append(contentsOf: array)
        self.recentSearchesData.sort { (object1, object2) -> Bool in
            return object1.added_on > object2.added_on
        }
        filterRecentSearchesForElapsedDates()
    }
    
    private func filterRecentSearchesForElapsedDates() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let reverseDateFormatter = DateFormatter()
        reverseDateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.recentSearchesData = self.recentSearchesData.filter({ (model) in
            let startDateStr = model.startDate
            guard let startDate = dateFormatter.date(from: startDateStr) ?? reverseDateFormatter.date(from: startDateStr) else { return false }
            return startDate.daysFrom(Date()) >= 0
        })
    }
    
    func getRecentHotels(){
        self.delegate?.willGetRecentSearchHotel()
        APICaller.shared.recentSearchesApi(searchFor: RecentSearchFor.hotel) { (success, error, obj) in
            APICaller.shared.recentSearchesApi(searchFor: RecentSearchFor.hotel) { [weak self] (success, error, obj) in
                if success {
                    //self?.recentSearchesData = obj
                    self?.arrangeHotelAndFlightsRecentSearch(obj)
                    self?.delegate?.getRecentSearchHotelSuccessFully()
                }else{
                    self?.delegate?.failedToGetRecentSearchApi()
                }
            }
        }
    }
    
    func createFlightSearchDictionaryAndPushToVC(_ model: MessageModel) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        var departDate = dateFormatter.date(from: model.depart)
        if departDate == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            departDate = dateFormatter.date(from: model.depart)
        }
        let newDepartDate = departDate?.toString(dateFormat: "dd-MM-yyyy") ?? ""
        
        var newModel = model
        
        var jsonDict = JSONDictionary()
        jsonDict["adult"] = newModel.adult
        jsonDict["child"] = newModel.child
        jsonDict["infant"] = newModel.infant
        jsonDict["cabinclass"] = newModel.cabinclass
        jsonDict["trip_type"] = newModel.tripType.lowercased()
        if newModel.tripType.lowercased().isEmpty {
            if newModel.returnDate.isEmpty {
                jsonDict["trip_type"] = "single"
            } else {
                jsonDict["trip_type"] = "return"
                newModel.tripType = "return"
            }
        }
        jsonDict["origin"] = newModel.origin
        jsonDict["destination"] = newModel.destination
        jsonDict["depart"] = newDepartDate
        if newModel.tripType.lowercased() == "return" {
            dateFormatter.dateFormat = "yyyyMMdd"
            var returnDate = dateFormatter.date(from: newModel.returnDate)
            if returnDate == nil {
                dateFormatter.dateFormat = "yyyy-MM-dd"
                returnDate = dateFormatter.date(from: newModel.returnDate)
            }
            let newReturnDate = returnDate?.toString(dateFormat: "dd-MM-yyyy") ?? ""
            jsonDict["return"] = newReturnDate
        } else {
            jsonDict["totalLegs"] = 1
        }
        
        addFiltersAndPushToResults(jsonDict)
        
    }
    
    func createFlightSearchDictFromRecentSearches(_ dict: JSONDictionary) {
        var jsonDict = JSONDictionary()
        let json = JSON(dict)
        jsonDict["adult"] = dict["adult"]
        jsonDict["child"] = dict["child"]
        jsonDict["infant"] = dict["infant"]
        jsonDict["cabinclass"] = "\(dict["cabinclass"] ?? "")"
        jsonDict["trip_type"] = "\(dict["trip_type"] ?? "")"
        
        if json["trip_type"].stringValue == "multi" {
            let destinations = json["origin"].arrayValue.map { $0.stringValue }
            destinations.enumerated().forEach { (index, element) in
                jsonDict["origin[\(index)]"] = element
            }
        } else {
            jsonDict["origin"] = "\(dict["origin"] ?? "")"
        }
        
        if json["trip_type"].stringValue == "multi" {
            let destinations = json["destination"].arrayValue.map { $0.stringValue }
            destinations.enumerated().forEach { (index, element) in
                jsonDict["destination[\(index)]"] = element
            }
        } else {
            jsonDict["destination"] = "\(dict["destination"] ?? "")"
        }
        
        if json["trip_type"].stringValue == "multi" {
            let depart = json["depart"].arrayValue.map { $0.stringValue }
            depart.enumerated().forEach { (index, element) in
                jsonDict["depart[\(index)]"] = element
            }
        } else {
            jsonDict["depart"] = "\(dict["depart"] ?? "")"
        }
        
        if json["trip_type"].stringValue == "return" {
            jsonDict["return"] = "\(dict["return"] ?? "")"
        } else if json["trip_type"].stringValue == "multi" {
            
        } else {
            jsonDict["totalLegs"] = dict["totalLegs"]
        }
        
        let filtersDict = dict.filter { $0.key.contains("filters") }
        filtersDict.forEach { (key, val) in
            jsonDict[key] = "\(val)"
        }
        
        SwiftObjCBridgingController.shared.sendFlightFormData(jsonDict)
    }
    
    private func addFiltersAndPushToResults(_ dict: JSONDictionary) {
        var jsonDict = dict
        let oneWayFilters = updatedFiltersJSON["0"]
        let returnFilters = updatedFiltersJSON["1"]
        if let stops = oneWayFilters["stp"].array {
            stops.enumerated().forEach { (index, stop) in
                jsonDict["filters[0][stp][\(index)]"] = stop.stringValue
            }
        }
        if let stops = returnFilters["stp"].array {
            stops.enumerated().forEach { (index, stop) in
                jsonDict["filters[1][stp][\(index)]"] = stop.stringValue
            }
        }
        
        if let depDt = oneWayFilters["dep_dt"].array {
            if let leftVal = depDt[0].int {
                jsonDict["filters[0][dep_dt][0]"] = leftVal.toString
            }
            if let rightVal = depDt[1].int {
                let convertedVal = rightVal == 0 ? 1440 : rightVal
                jsonDict["filters[0][dep_dt][1]"] = convertedVal.toString
            }
        }
        
        if let depDt = returnFilters["dep_dt"].array {
            if let leftVal = depDt[0].int {
                jsonDict["filters[1][dep_dt][0]"] = leftVal.toString
            }
            if let rightVal = depDt[1].int {
                let convertedVal = rightVal == 0 ? 1440 : rightVal
                jsonDict["filters[1][dep_dt][1]"] = convertedVal.toString
            }
        }
        
        if let arDt = oneWayFilters["ar_dt"].array {
            if let leftVal = arDt[0].int {
                jsonDict["filters[0][ar_dt][0]"] = leftVal.toString
            }
            if let rightVal = arDt[1].int {
                jsonDict["filters[0][ar_dt][1]"] = rightVal.toString
            }
        }
        
        if let arDt = returnFilters["ar_dt"].array {
            if let leftVal = arDt[0].int {
                jsonDict["filters[1][ar_dt][0]"] = leftVal.toString
            }
            if let rightVal = arDt[1].int {
                jsonDict["filters[1][ar_dt][1]"] = rightVal.toString
            }
        }
        
        if let airlines = oneWayFilters["al"].array {
            airlines.enumerated().forEach { (index, airline) in
                jsonDict["filters[0][al][\(index)]"] = airline.stringValue
            }
        }
        
        if let airlines = returnFilters["al"].array {
            airlines.enumerated().forEach { (index, airline) in
                jsonDict["filters[1][al][\(index)]"] = airline.stringValue
            }
        }
        
        if let minTime = oneWayFilters["duration"]["min"].int {
            jsonDict["filters[0][tt][0]"] = ((minTime)/216000).toString
        }
        
        if let maxTime = oneWayFilters["duration"]["max"].int {
            jsonDict["filters[0][tt][1]"] = ((maxTime)/216000).toString
        }
        
        if let minTime = oneWayFilters["layoverDuration"]["min"].int {
            jsonDict["filters[0][lott][0]"] = ((minTime)/216000).toString
        }
        
        if let maxTime = oneWayFilters["layoverDuration"]["max"].int {
            jsonDict["filters[0][lott][1]"] = ((maxTime)/216000).toString
        }
        
        if let minTime = returnFilters["duration"]["min"].int {
            jsonDict["filters[1][tt][0]"] = ((minTime)/216000).toString
        }
        
        if let maxTime = returnFilters["duration"]["max"].int {
            jsonDict["filters[1][tt][1]"] = ((maxTime)/216000).toString
        }
        
        if let minTime = returnFilters["layoverDuration"]["min"].int {
            jsonDict["filters[1][lott][0]"] = ((minTime)/216000).toString
        }
        
        if let maxTime = returnFilters["layoverDuration"]["max"].int {
            jsonDict["filters[1][lott][1]"] = ((maxTime)/216000).toString
        }
        
        if let price = oneWayFilters["pr"].array {
            if let leftVal = price[0].int {
                jsonDict["filters[0][pr][0]"] = leftVal.toString
            }
            if let rightVal = price[1].int {
                jsonDict["filters[0][pr][1]"] = rightVal.toString
            }
        }
        
        if let price = returnFilters["pr"].array {
            if let leftVal = price[0].int {
                jsonDict["filters[1][pr][0]"] = leftVal.toString
            }
            if let rightVal = price[1].int {
                jsonDict["filters[1][pr][1]"] = rightVal.toString
            }
        }
        
        if let loap = oneWayFilters["loap"].array {
            loap.enumerated().forEach { (index, airline) in
                jsonDict["filters[0][loap][\(index)]"] = airline.stringValue
            }
        }
        
        if let loap = returnFilters["loap"].array {
            loap.enumerated().forEach { (index, airline) in
                jsonDict["filters[1][loap][\(index)]"] = airline.stringValue
            }
        }
        
        SwiftObjCBridgingController.shared.sendFlightFormData(jsonDict)
    }
}

extension ChatVM {
    
    func checkToProvideVoiceFeedback(_ model: MessageModel) {
        if lastMessageSentType == .voice && shouldProduceVoiceOutput {
            if model.fullfilment.isEmpty && !model.depart.isEmpty && !model.origin.isEmpty && !model.destination.isEmpty {
                speechSynthesizer.synthesizeToSpeech("Here are your results")
                shouldTriggerSpeechRecognizer = false
            } else {
                speechSynthesizer.synthesizeToSpeech(model.fullfilment)
                shouldTriggerSpeechRecognizer = true
            }
        } else {
            shouldTriggerSpeechRecognizer = false
        }
        lastMessageSentType = .text
    }
}
