//
//  Webservice.swift
//  Aertrip
//
//  Created by  hrishikesh on 13/03/19.
//  Copyright © 2019 Aertrip. All rights reserved.
//

import Foundation

enum WebService {
    case flightSearchResult(sid: String , display_group_id : String)
    case flightPerformanceResult(origin: String, destination: String, airline: String, flight_number: String)
    case baggageResult(sid: String , fk : String)
    case fareInfoResult(sid: String , fk : String)
    case fareRulesResult(sid: String , fk : String)
    case upgradeAPIResult(sid: String , fk : String, oldFare:String)
    case tripList(ass:String)
    case addToTrip(postData:Data)
    case createTrip(tripData:Data)
}

extension WebService : APIProtocol {
    func getUrlRequest() -> URLRequest? {
        guard let URLObj = URL(string: path) else {return nil}
        var urlRequestObj = URLRequest(url: URLObj)
        urlRequestObj.httpBody = data
        urlRequestObj.httpMethod = httpMethod
        urlRequestObj.allHTTPHeaderFields = httpHeader
        return urlRequestObj
    }
    
    
    var path: String {
        switch self {
        case .flightSearchResult(let sid ,let display_group_id):
            return flightBaseUrl+"results?sid=" + sid + "&display_group_id=" + display_group_id
            
        case .flightPerformanceResult(origin: _, destination: _, airline: _, flight_number: _):
            return flightBaseUrl+"delay-index"
            
        case .baggageResult(sid: let sid, fk: let fk):
            return flightBaseUrl+"baggage?sid=\(sid)&fk[]=\(fk)"
            
        case .fareInfoResult(sid: _, fk: _):
            return flightBaseUrl+"get-minifare-rules"
            
        case .fareRulesResult(sid: _, fk: _):
            return flightBaseUrl+"fare-rules"
            
        case .upgradeAPIResult(sid: let sid, fk: let fk, oldFare: let oldFare):
            return flightBaseUrl+"otherfares?sid=\(sid)&fk[]=\(fk)&old_farepr[]=\(oldFare)"
            
        case .tripList(ass: _):
            return tripsBaseUrl+"list"
            
        case .addToTrip(postData: _):
            return tripsBaseUrl+"event/flights/save"
            
        case .createTrip(tripData: _):
            return tripsBaseUrl+"add"
        }
    }
    
    var httpMethod: String
    {
        switch self {
        case .flightSearchResult( _ , _):
            return "get"
            
        case .flightPerformanceResult(origin: _, destination: _, airline: _, flight_number: _):
            return "POST"
            
        case .baggageResult( _,  _):
            return "get"
            
        case .fareInfoResult(_, _):
            return "POST"
            
        case .fareRulesResult(_, _):
            return "POST"
            
        case .upgradeAPIResult(sid: _, fk: _, oldFare: _):
            return "get"
            
        case .tripList(ass: _):
            return "get"
            
        case .addToTrip(postData: _):
            return "POST"
        
        case .createTrip(tripData: _):
            return "POST"
        }
    }
    
    var data: Data? {
        switch self {
        case .flightSearchResult( _ , _):
            return nil
            
        case .flightPerformanceResult(origin: let origin, destination: let destination, airline: let airline, flight_number: let flight_number):
            let postData = NSMutableData(data: "origin=\(origin)".data(using: String.Encoding.utf8) ?? Data())
            postData.append("&destination=\(destination)".data(using: String.Encoding.utf8) ?? Data())
            postData.append("&airline=\(airline)".data(using: String.Encoding.utf8) ?? Data())
            postData.append("&flight_number=\(flight_number)".data(using: String.Encoding.utf8) ?? Data())
            return postData as Data
            
        case .baggageResult(_, _):
            return nil
            
        case .fareInfoResult(sid: let sid, fk: let fk):
            let postData = NSMutableData(data: "sid=\(sid)".data(using: String.Encoding.utf8) ?? Data())
            postData.append("&fk[]=\(fk)".data(using: String.Encoding.utf8) ?? Data())
            return postData as Data
            
        case .fareRulesResult(sid: let sid, fk: let fk):
            let postData = NSMutableData(data: "sid=\(sid)".data(using: String.Encoding.utf8) ?? Data())
            postData.append("&fk[]=\(fk)".data(using: String.Encoding.utf8) ?? Data())
            return postData as Data
            
        case .upgradeAPIResult(sid: _, fk: _, oldFare: _):
            return nil
            
        case .tripList(ass: _):
            return nil
            
        case .addToTrip(postData: let data):
            return data
            
        case .createTrip(tripData: let data):
            return data
        }
    }
    
    var successCode: Int {
        return 200
    }
    
    var httpHeader: [String:String]?
    {
        switch self {
        case .flightSearchResult( _ , _):
            return [
                "api-key": apiKey
            ]
            
        case .flightPerformanceResult(origin: _, destination: _, airline: _, flight_number: _):
            let headers = [
                "api-key": apiKey,
                "Cache-Control": "no-cache",
                "Content-Type": "application/x-www-form-urlencoded",
            ]
            return headers
            
        case .baggageResult(_, _):
            return nil
            
        case .fareInfoResult(_, _):
            let headers = [
                "api-key": apiKey,
                "Cache-Control": "no-cache",
                "Content-Type": "application/x-www-form-urlencoded",
            ]
            return headers
            
        case .fareRulesResult(_, _):
            let headers = [
                "api-key": apiKey,
                "Cache-Control": "no-cache",
                "Content-Type": "application/x-www-form-urlencoded",
            ]
            return headers
            
        case .upgradeAPIResult(sid: _, fk: _, oldFare: _):
            return nil
            
        case .tripList(ass: _):
            let headers = [
                "api-key": apiKey,
                "Cache-Control": "no-cache",
                "Content-Type": "application/x-www-form-urlencoded",
                "Cookie": "AT_R_STAGE_SESSID=fjl4nnbhbsprbdef44rnsj19l5"
            ]
            return headers
            
        case .addToTrip(postData: _):
            let headers = [
              "content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
              "Content-Type": "application/x-www-form-urlencoded",
              "api-key": apiKey,
              "Referer": "http://beta.aertrip.com",
              "Cache-Control": "no-cache",
              "Host": "beta.aertrip.com",
              "Accept-Encoding": "gzip, deflate",
              "Cookie": "AT_R_STAGE_SESSID=fjl4nnbhbsprbdef44rnsj19l5",
              "Content-Length": "3786",
              "Connection": "keep-alive",
              "cache-control": "no-cache"
            ]
            return headers
            
        case .createTrip(tripData: _):

            let headers = [
              "content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
              "Content-Type": "application/x-www-form-urlencoded",
              "api-key": apiKey,
              "Referer": "http://beta.aertrip.com",
              "Accept": "*/*",
              "Cache-Control": "no-cache",
              "Host": "beta.aertrip.com",
              "Accept-Encoding": "gzip, deflate",
              "Cookie": "AT_R_STAGE_SESSID=fjl4nnbhbsprbdef44rnsj19l5",
              "Content-Length": "166",
              "Connection": "keep-alive",
              "cache-control": "no-cache"
            ]
            return headers
        }
    }
}
