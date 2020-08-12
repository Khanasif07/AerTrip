//
//  GetSharableUrl.swift
//  Aertrip
//
//  Created by Monika Sonawane on 31/07/20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

protocol getSharableUrlDelegate : AnyObject {
    func returnSharableUrl(url:String)
    func returnEmailView(view:String)
}

import Foundation
import UIKit

class GetSharableUrl
{
    weak var delegate : getSharableUrlDelegate?
    var semaphore = DispatchSemaphore (value: 0)
    
    func getUrl(adult:String, child:String, infant:String,isDomestic:Bool, journey: [Journey])
    {
        let cc = journey.first?.cc
        let trip_type = getTripType(journey: journey)
        
        let origin = getOrigin(journey: journey)
        let destination = getDestination(journey: journey)
        let departureDate = getDepartureDate(journey: journey)
        let returnDate = getReturnDate(journey: journey)
        
        
        //        if journey.count == 1{
        //            origin.append("origin=\(journey[0].ap[0])&")
        //            destination.append("destination=\(journey[0].ap[1])&")
        //
        //            let inputFormatter = DateFormatter()
        //            inputFormatter.dateFormat = "yyyy-MM-dd"
        //            let showDate = inputFormatter.date(from: journey[0].ad)
        //            inputFormatter.dateFormat = "dd-MM-yyyy"
        //            let newAd = inputFormatter.string(from: showDate!)
        //
        //            departureDate.append("depart=\(newAd)&")
        //
        //            returnDate.append("return=&")
        //        }else{
        //            for i in 0..<journey.count{
        //                origin.append("origin[\(i)]=\(journey[i].ap[0])&")
        //                destination.append("destination[\(i)]=\(journey[i].ap[1])&")
        //
        //                let inputFormatter = DateFormatter()
        //                inputFormatter.dateFormat = "yyyy-MM-dd"
        //                let showDate = inputFormatter.date(from: journey[i].ad)
        //                inputFormatter.dateFormat = "dd-MM-yyyy"
        //                let newAd = inputFormatter.string(from: showDate!)
        //
        //                departureDate.append("depart[\(i)]=\(newAd)&")
        //
        //
        //                inputFormatter.dateFormat = "yyyy-MM-dd"
        //                let showDate1 = inputFormatter.date(from: journey[i].dd)
        //                inputFormatter.dateFormat = "dd-MM-yyyy"
        //                let newDd = inputFormatter.string(from: showDate1!)
        //
        //                returnDate.append("return[\(i)]=\(newDd)&")
        //            }
        //        }
        
        //        trip_type = getTripType(journey: journey)
        
        //        if trip_type == "return"{
        //            origin.append("origin=\(journey[0].ap[0])&")
        //            destination.append("destination=\(journey[0].ap[1])&")
        //
        //            let inputFormatter = DateFormatter()
        //            inputFormatter.dateFormat = "yyyy-MM-dd"
        //            let showDate = inputFormatter.date(from: journey[0].ad)
        //            inputFormatter.dateFormat = "dd-MM-yyyy"
        //            let newAd = inputFormatter.string(from: showDate!)
        //
        //            departureDate.append("depart=\(newAd)&")
        //
        //            inputFormatter.dateFormat = "yyyy-MM-dd"
        //            let showDate1 = inputFormatter.date(from: journey[1].dd)
        //            inputFormatter.dateFormat = "dd-MM-yyyy"
        //            let newDd = inputFormatter.string(from: showDate1!)
        //
        //            returnDate.append("return=\(newDd)&")
        //        }
        
        let pinnedFlightFK = getPinnedFlightFK(journey: journey)
        
//        for i in 0..<journey.count{
//            if i == journey.count-1{
//                pinnedFlightFK.append("PF[\(i)]=\(journey[i].fk)")
//            }else{
//                pinnedFlightFK.append("PF[\(i)]=\(journey[i].fk)&")
//            }
//        }
        
        //        print("https://beta.aertrip.com/flights?trip_type=\(trip_type)&adult=\(adult)&child=\(child)&infant=\(infant)&\(origin)\(destination)\(departureDate)\(returnDate)cabinclass=\(cc!)&pType=flight&isDomestic=\(isDomestic)&\(pinnedFlightFK)")
        
        
        let pinnedUrl = flightBaseUrl+"get-pinned-url"
        
        let parameters = [
            [
                "key": "u",
                "value": "https://beta.aertrip.com/flights?trip_type=\(trip_type)&adult=\(adult)&child=\(child)&infant=\(infant)&\(origin)\(destination)\(departureDate)\(returnDate)&cabinclass=\(cc!)&pType=flight&isDomestic=\(isDomestic)&\(pinnedFlightFK)",
                "type": "text"
            ]] as [[String : Any]]
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var _: Error? = nil
        for param in parameters {
            if param["disabled"] == nil {
                let paramName = param["key"]!
                body += "--\(boundary)\r\n"
                body += "Content-Disposition:form-data; name=\"\(paramName)\""
                let paramType = param["type"] as! String
                if paramType == "text" {
                    let paramValue = param["value"] as! String
                    body += "\r\n\r\n\(paramValue)\r\n"
                } else {
                    let paramSrc = param["src"] as! String
                    let fileData = try! NSData(contentsOfFile:paramSrc, options:[]) as Data
                    let fileContent = String(data: fileData, encoding: .utf8)!
                    body += "; filename=\"\(paramSrc)\"\r\n"
                        + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
                }
            }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: pinnedUrl)!,timeoutInterval: Double.infinity)
        request.addValue(apiKey, forHTTPHeaderField: "api-key")
        request.addValue("AT_R_STAGE_SESSID=cba8fbjvl52c316a4b24tuank4", forHTTPHeaderField: "Cookie")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            print(String(data: data, encoding: .utf8)!)

            do{
                let jsonResult:AnyObject?  = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
                
                DispatchQueue.main.async {
                    if let result = jsonResult as? [String: AnyObject] {
                        if result["success"] as? Bool == true{
                            if let link = (result["data"] as? NSDictionary)?.value(forKey: "u") as? String{
                                self.delegate?.returnSharableUrl(url: link)
                            }
                        }
                    }
                }
            }catch{
            }
            
            self.semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
    
    
    
    func getUrlForMail(adult:String, child:String, infant:String,isDomestic:Bool, journey: [Journey], sid:String)
    {
        let cc = journey.first?.cc
        let trip_type = getTripType(journey: journey)
        
        let origin = getOrigin(journey: journey)
        let destination = getDestination(journey: journey)
        let departureDate = getDepartureDate(journey: journey)
        let returnDate = getReturnDate(journey: journey)
        
        //        if journey.count == 1{
        //            origin.append("origin=\(journey[0].ap[0])&")
        //            destination.append("destination=\(journey[0].ap[1])&")
        //
        //            let inputFormatter = DateFormatter()
        //            inputFormatter.dateFormat = "yyyy-MM-dd"
        //            let showDate = inputFormatter.date(from: journey[0].ad)
        //            inputFormatter.dateFormat = "dd-MM-yyyy"
        //            let newAd = inputFormatter.string(from: showDate!)
        //
        //            departureDate.append("depart=\(newAd)&")
        //
        //            returnDate.append("return=&")
        //        }else{
        //            for i in 0..<journey.count{
        //                origin.append("origin[\(i)]=\(journey[i].ap[0])&")
        //                destination.append("destination[\(i)]=\(journey[i].ap[1])&")
        //
        //                let inputFormatter = DateFormatter()
        //                inputFormatter.dateFormat = "yyyy-MM-dd"
        //                let showDate = inputFormatter.date(from: journey[i].ad)
        //                inputFormatter.dateFormat = "dd-MM-yyyy"
        //                let newAd = inputFormatter.string(from: showDate!)
        //
        //                departureDate.append("depart[\(i)]=\(newAd)&")
        //
        //
        //                inputFormatter.dateFormat = "yyyy-MM-dd"
        //                let showDate1 = inputFormatter.date(from: journey[i].dd)
        //                inputFormatter.dateFormat = "dd-MM-yyyy"
        //                let newDd = inputFormatter.string(from: showDate1!)
        //
        //                returnDate.append("return[\(i)]=\(newDd)&")
        //            }
        //        }
        
        //        trip_type = getTripType(journey: journey)
        
        //        if trip_type == "return"{
        //            origin.append("origin=\(journey[0].ap[0])&")
        //            destination.append("destination=\(journey[0].ap[1])&")
        //
        //            let inputFormatter = DateFormatter()
        //            inputFormatter.dateFormat = "yyyy-MM-dd"
        //            let showDate = inputFormatter.date(from: journey[0].ad)
        //            inputFormatter.dateFormat = "dd-MM-yyyy"
        //            let newAd = inputFormatter.string(from: showDate!)
        //
        //            departureDate.append("depart=\(newAd)&")
        //
        //            inputFormatter.dateFormat = "yyyy-MM-dd"
        //            let showDate1 = inputFormatter.date(from: journey[1].dd)
        //            inputFormatter.dateFormat = "dd-MM-yyyy"
        //            let newDd = inputFormatter.string(from: showDate1!)
        //
        //            returnDate.append("return=\(newDd)&")
        //        }
        

//        for i in 0..<journey.count{
//            if i == journey.count-1{
//                pinnedFlightFK.append("PF[\(i)]=\(journey[i].fk)")
//            }else{
//                pinnedFlightFK.append("PF[\(i)]=\(journey[i].fk)&")
//            }
//        }
        
        let pinnedFlightFK = getPinnedFlightFK(journey: journey)
        
        var parameters = [[String : Any]]()
        for i in 0..<journey.count{
            let test = [
                "key": "fk[\(i)]",
                "value": journey[i].fk,
                "type": "text"
            ]
            
            parameters.append(test)
        }
        
        parameters.append([
            "key": "u",
            "value": "https://beta.aertrip.com/flights?trip_type=\(trip_type)&adult=\(adult)&child=\(child)&infant=\(infant)&\(origin)\(destination)\(departureDate)\(returnDate)&cabinclass=\(cc!)&pType=flight&isDomestic=\(isDomestic)&\(pinnedFlightFK)",
            "type": "text"
        ])
        
        parameters.append([
            "key": "sid",
            "value": sid,
            "type": "text"
        ])
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var _: Error? = nil
        for param in parameters {
            if param["disabled"] == nil {
                let paramName = param["key"]!
                body += "--\(boundary)\r\n"
                body += "Content-Disposition:form-data; name=\"\(paramName)\""
                let paramType = param["type"] as! String
                if paramType == "text" {
                    let paramValue = param["value"] as! String
                    body += "\r\n\r\n\(paramValue)\r\n"
                } else {
                    let paramSrc = param["src"] as! String
                    let fileData = try! NSData(contentsOfFile:paramSrc, options:[]) as Data
                    let fileContent = String(data: fileData, encoding: .utf8)!
                    body += "; filename=\"\(paramSrc)\"\r\n"
                        + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
                }
            }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "https://beta.aertrip.com/api/v1/flights/get-pinned-template")!,timeoutInterval: Double.infinity)
        request.addValue(apiKey, forHTTPHeaderField: "api-key")
        request.addValue("AT_R_STAGE_SESSID=2vrftci1u2q2arn56d8fnap92c", forHTTPHeaderField: "Cookie")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            
            do{
                let jsonResult:AnyObject?  = try JSONSerialization.jsonObject(with: data, options: []) as AnyObject
                
                DispatchQueue.main.async {
                    if let result = jsonResult as? [String: AnyObject] {
                        if result["success"] as? Bool == true{
                            if let view = (result["data"] as? NSDictionary)?.value(forKey: "view") as? String{
                                self.delegate?.returnEmailView(view: view)
                            }
                        }
                    }
                }
            }catch{
            }
            self.semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
    
    
    
    
    func getTripType(journey:[Journey])->String{
        if journey.count == 1{
            return "single"
        }else if journey.count > 2{
            return "multi"
        }else{
            return "return"
        }
    }
    
    func getReturnDate(journey:[Journey])->String{
        var returnDate = ""
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if journey.count == 1{
            returnDate.append("return=&")
        }else if journey.count > 2{
            for i in 0..<journey.count{
                let showDate1 = inputFormatter.date(from: journey[i].dd)
                inputFormatter.dateFormat = "dd-MM-yyyy"
                let newDd = inputFormatter.string(from: showDate1!)
                returnDate.append("return[\(i)]=\(newDd)&")
            }
        }else{
            let showDate1 = inputFormatter.date(from: journey[1].dd)
            inputFormatter.dateFormat = "dd-MM-yyyy"
            let newDd = inputFormatter.string(from: showDate1!)
            returnDate.append("return=\(newDd)&")
        }

        return returnDate
    }
    
    func getDepartureDate(journey:[Journey])->String{
        var departureDate = ""
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if journey.count == 1{
            let showDate = inputFormatter.date(from: journey[0].ad)
            inputFormatter.dateFormat = "dd-MM-yyyy"
            let newAd = inputFormatter.string(from: showDate!)
            departureDate.append("depart=\(newAd)&")
            
        }else if journey.count > 2{
            for i in 0..<journey.count{
                let showDate = inputFormatter.date(from: journey[i].ad)
                inputFormatter.dateFormat = "dd-MM-yyyy"
                let newAd = inputFormatter.string(from: showDate!)
                departureDate.append("depart[\(i)]=\(newAd)&")
            }
        }else{
            let showDate = inputFormatter.date(from: journey[0].ad)
            inputFormatter.dateFormat = "dd-MM-yyyy"
            let newAd = inputFormatter.string(from: showDate!)
            departureDate.append("depart=\(newAd)&")
        }
        
        return departureDate
    }
    
    func getOrigin(journey:[Journey])->String{
        var origin = ""
        if journey.count == 1{
            origin.append("origin=\(journey[0].ap[0])&")
        }else if journey.count > 2{
            for i in 0..<journey.count{
                origin.append("origin[\(i)]=\(journey[i].ap[0])&")
            }
        }else{
            origin.append("origin=\(journey[0].ap[0])&")
        }
        
        return origin
    }
    
    func getDestination(journey:[Journey])->String{
        var destination = ""
        if journey.count == 1{
            destination.append("destination=\(journey[0].ap[1])&")
        }else if journey.count > 2{
            for i in 0..<journey.count{
                destination.append("destination[\(i)]=\(journey[i].ap[1])&")
            }
        }else{
            destination.append("destination=\(journey[0].ap[1])&")
        }
        
        return destination
    }
    
    func getPinnedFlightFK(journey:[Journey])->String{
        var pinnedFlightFK = ""
        
        for i in 0..<journey.count{
            if i == journey.count-1{
                pinnedFlightFK.append("PF[\(i)]=\(journey[i].fk)")
            }else{
                pinnedFlightFK.append("PF[\(i)]=\(journey[i].fk)&")
            }
        }
        
        return pinnedFlightFK
    }
}
