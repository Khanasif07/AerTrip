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
    func moveFurtherWhenallRequiredInformationSubmited()
    
    func willGetRecentSearchHotel()
    func getRecentSearchHotelSuccessFully()
    func failedToGetRecentSearchApi()
    
    func willGetRecentSearchFlights()
    func getRecentSearchFlightsSuccessFully()
    func failedToGetRecentSearchedFlightsApi()
    
}


class ChatVM {

    enum RecentSearchFor : String {
        case hotel = "hotel"
        case flight = "flight"
    }
    
    var messages : [MessageModel] = []
    var typingCellTimerCounter = 0
    var sessionId : String = ""
    weak var delegate : ChatBotDelegatesDelegate?
    var msgToBeSent : String = ""
    var recentSearchesData : [RecentSearchesModel] = []

    
    func getRandomSessionId(length : Int) -> String{
        let letters = "0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func sendMessageToChatBot(message : String){
        sessionId.isEmpty ? startaSessionWithChatBot(message : message)  : communicateWithChatBot(message : message)
    }
    
    func startaSessionWithChatBot(message : String){
       
        self.delegate?.willstarttChatBotSession()
        
        let params : JSONDictionary = [APIKeys.session_id.rawValue : getRandomSessionId(length : 13), "q" : message]
        APICaller.shared.startChatBotSession(params: params) { (success, message, sessionId) in
          
            if success {
//                self.delegate?.hideTypingCell()
                self.sessionId = sessionId
                guard let msg = message else { return }
                self.messages.append(msg)
                self.delegate?.chatBotSessionCreatedSuccessfully()
                if !msg.depart.isEmpty && !msg.origin.isEmpty && !msg.destination.isEmpty {
                    self.delegate?.moveFurtherWhenallRequiredInformationSubmited()
                }
                
                
            }else{
                self.delegate?.failedToCreateChatBotSession()
            }
        }
    }
    
    func communicateWithChatBot(message : String){
        
        self.delegate?.willCommunicateWithChatBot()
        
        let params : JSONDictionary = [APIKeys.session_id.rawValue : self.sessionId, "q" : message]

        APICaller.shared.communicateWithChatBot(params: params) { (success, message, sessionId) in
           
             if success {
//                self.delegate?.hideTypingCell()
                 self.sessionId = sessionId
                 guard let msg = message else { return }
                 self.messages.append(msg)
                 self.delegate?.chatBotCommunicatedSuccessfully()
                if !msg.depart.isEmpty && !msg.origin.isEmpty && !msg.destination.isEmpty {
                          self.delegate?.moveFurtherWhenallRequiredInformationSubmited()
                      }
             }else{
                 self.delegate?.failedToCommunicateWithChatBot()
             }
         }
    }
    
    
    func getRecentFlights(){
        APICaller.shared.recentSearchesApi(searchFor: RecentSearchFor.flight) { (success, error, obj) in
        }
    }
    
    func getRecentHotels(){
        self.delegate?.willGetRecentSearchHotel()
        APICaller.shared.recentSearchesApi(searchFor: RecentSearchFor.hotel) { (success, error, obj) in
            if success {
                self.recentSearchesData = obj
                self.delegate?.getRecentSearchHotelSuccessFully()
            }else{
                self.delegate?.failedToGetRecentSearchApi()
            }
        }
    }
}
