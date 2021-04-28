//
//  FlightDetailsInfoVM.swift
//  AERTRIP
//
//  Created by Appinventiv  on 11/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

protocol  FlightInfoVMDelegate : NSObjectProtocol {
    func flightBaggageDetailsApiResponse(details:[JSONDictionary])
    func flightPerformance(performanceData: flightPerfomanceResultData, index: [Int], fkk:String)
}

extension FlightInfoVMDelegate{
    func flightPerformance(performanceData: flightPerfomanceResultData, index: [Int], fkk:String){}
}
 
class FlightDetailsInfoVM{

    weak var delegate: FlightInfoVMDelegate?
    var itineraryId = ""

    func callAPIforBaggageInfo(sid:String, fk:String, count: Int = 3){
        guard count >= 0 else {return}
        var param = [APIKeys.sid.rawValue:sid, "fk[]":fk]
        if !self.itineraryId.isEmpty{
            param[APIKeys.it_id.rawValue] = self.itineraryId
        }
        APICaller.shared.getFlightbaggageDetails(params: param) {[weak self] (data, error) in
            guard let self = self else {return}
            if let bgData = data {
//                let keys = bgData.keys
//                var baggageData = [JSONDictionary]()
//                if keys.count > 0{
//                    for key in keys{
//                        if let datas = bgData["\(key)"] as? JSONDictionary{
//                            baggageData += [datas]
//                        }
//                    }
//                }
                
//                self.delegate?.flightBaggageDetailsApiResponse(details: baggageData)
                
                
                self.delegate?.flightBaggageDetailsApiResponse(details: [bgData])

            }else{
                self.callAPIforBaggageInfo(sid: sid, fk: fk, count: (count - 1))
            }
            
        }
    }

    func callAPIforFlightsOnTimePerformace(origin: String, destination: String, airline: String, flight_number: String, index:[Int],FFK:String, count:Int = 3){
        guard count >= 0 else {return}
        let param = ["origin": origin,"destination":destination,"airline":airline,"flight_number":flight_number]
        APICaller.shared.getFlightPerformanceData(params: param){[weak self](prData, error) in
            guard let self = self else {return}
            if let data = prData{
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                DispatchQueue.main.async {
                    if let currentParsedResponse = parse(data: data, into: flightPerformaceResponse.self, with:decoder) {

                        if (currentParsedResponse.success ?? false) ,let data = currentParsedResponse.data?.delayIndex {
                            self.delegate?.flightPerformance(performanceData: data, index: index, fkk: FFK)
                        }
                    }
                }
            }else{
                self.callAPIforFlightsOnTimePerformace(origin: origin, destination: destination, airline: airline, flight_number: flight_number, index: index, FFK:FFK, count: (count - 1))
            }
        }
    }


}

