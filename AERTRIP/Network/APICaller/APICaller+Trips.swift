//
//  APICaller+Trips.swift
//  AERTRIP
//
//  Created by Admin on 26/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    
    func getOwnedTripsAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ trips: [TripModel], _ defaultTrip: TripModel?) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.ownedTrips, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess {
                    let (trips, defTrip) = TripModel.models(jsonArr: jsonData[APIKeys.data.rawValue].arrayObject as? [JSONDictionary] ?? [[:]])
                    completionBlock(true, [], trips, defTrip)
                }
                else {
                    completionBlock(false, [], [], nil)
                }
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
                completionBlock(false, error, [], nil)
            })
        }) { error in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue], [], nil)
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], [], nil)
            }
        }
    }
    
    func getAllTripsAPI(loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ trips: [TripModel], _ defaultTrip: TripModel?) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.tripsList, parameters: [:], success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess {
                    let (trips, defTrip) = TripModel.models(jsonArr: jsonData[APIKeys.data.rawValue]["active"].arrayObject as? [JSONDictionary] ?? [[:]])
                    completionBlock(true, [], trips, defTrip)
                }
                else {
                    completionBlock(false, [], [], nil)
                }
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
                completionBlock(false, error, [], nil)
            })
        }) { error in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue], [], nil)
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], [], nil)
            }
        }
    }
    
    func addNewTripAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ trip: TripModel?)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.addTrip, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                let trp = TripModel(json: (jsonData[APIKeys.data.rawValue].arrayObject as? [JSONDictionary])?.first ?? [:])
                completionBlock(sucess, [], trp)
                
            }, failure: { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .hotelsSearch)
                completionBlock(false, errors, nil)
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue], nil)
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], nil)
            }
        }
    }
}
