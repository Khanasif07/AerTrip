//
//  APICaller+SeatMap.swift
//  AERTRIP
//
//  Created by Rishabh on 25/05/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    
    //MARK: - Api for Active user
    //MARK: -
    func callSeatMapAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ mapModel: SeatMapModel?, _ errorCodes: ErrorCodes)->Void ) {
        
        AppNetworking.GET(endPoint: .seatMap , parameters: params,
                          loader: loader, success: { [weak self] (data) in
            guard let self = self else {return}
            
            self.handleResponse(data, success: { (sucess, jsonData) in
                let seatMapModel = SeatMapModel(jsonData)
                completionBlock(seatMapModel, [])
                
            }, failure: { (error) in
                completionBlock(nil, [])

            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(nil, [])
            }
            else {
                
            }
        }
    }
    
    func callPostBookingSeatMapAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ mapModel: SeatMapModel?, _ errorCodes: ErrorCodes)->Void ) {
        
        AppNetworking.GET(endPoint: .postBookingAddOn , parameters: params,
                          loader: loader, success: { [weak self] (data) in
            guard let self = self else {return}
            
            self.handleResponse(data, success: { (sucess, jsonData) in
                let seatMapModel = SeatMapModel(jsonData)
                completionBlock(seatMapModel, [])
                
            }, failure: { (error) in
                completionBlock(nil, [])

            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(nil, [])
            }
            else {
                
            }
        }
    }
    
    func hitSeatPostConfirmationAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ mapModel: PostBookingAddOnConfModel?, _ errorCodes: ErrorCodes)->Void ) {
        
        AppNetworking.POST(endPoint: .addOnConfirmation , parameters: params,
                           loader: loader, success: { [weak self] (data) in
                            guard let self = self else {return}
                            
                            self.handleResponse(data, success: { (sucess, jsonData) in
                                
                                let addOnConfModel = PostBookingAddOnConfModel(jsonData)
                                completionBlock(addOnConfModel, [])
                                
                            }, failure: { (error) in
                                completionBlock(nil, [])
                            })
                            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(nil, [])
            }
            else {
                
            }
        }
    }
    
    
    func getAddonsQuatationApi(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ mapModel: AddonsQuotationsModel?, _ errorCodes: ErrorCodes)->Void ) {
        
        AppNetworking.GET(endPoint: .getAddonsQuatation , parameters: params,
                          loader: loader, success: { [weak self] (data) in
                            guard let self = self else {return}
                            
                            self.handleResponse(data, success: { (sucess, jsonData) in
                                
                                let addOnConfModel = AddonsQuotationsModel(jsonData[APIKeys.data.rawValue]["itinerary"])
                                completionBlock(addOnConfModel, [])
                                
                            }, failure: { (error) in
                                completionBlock(nil, [])
                            })
                            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(nil, [])
            }
            else {
                
            }
        }
    }
    
}
