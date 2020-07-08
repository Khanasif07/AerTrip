//
//  APICaller+FlightPayment.swift
//  AERTRIP
//
//  Created by Apple  on 10.06.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller{
    
    func getItineraryData(withAddons : Bool = false, params: JSONDictionary, itId:String, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ data: FlightItineraryData?)->Void ) {
        let action = withAddons ? "traveller_with_addons" : "traveller"
        let url = "\(APIEndPoint.baseUrlPath.rawValue)flights/itinerary?action=\(action)&it_id=\(itId)"
        AppNetworking.POST(endPointPath: url, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess {
                    completionBlock(true, [], FlightItineraryData(json[APIKeys.data.rawValue]))
                }
                else {
                    completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], nil)
                }
                
            }, failure: { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .flights)
                printDebug(json)
                completionBlock(false, errors, nil)
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], nil)
            } else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], nil)
            }
        }
    }
    
    
    func applyFlightCoupnCodeApi(params: JSONDictionary ,loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ couponDetails : FlightItineraryData?)->Void) {
           AppNetworking.POST(endPoint:APIEndPoint.applyFlightCouponCode, parameters: params, loader: loader, success: { [weak self] (json) in
               guard let sSelf = self else {return}
               sSelf.handleResponse(json, success: { (sucess, jsonData) in
                   if sucess {
                       let appliedCouponData = FlightItineraryData(jsonData[APIKeys.data.rawValue] )
                       completionBlock(true, [], appliedCouponData)
                   } else {
                       completionBlock(true, [], nil)
                   }
               }, failure:  { (errors) in
                   ATErrorManager.default.logError(forCodes: errors, fromModule: .flights)
                   completionBlock(false, errors, nil)
               })
           }) { (error) in
               if error.code == AppNetworking.noInternetError.code {
                   AppGlobals.shared.stopLoading()
                   AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                   completionBlock(false, [], nil)
               }
               else {
                   completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], nil)
               }
           }
       }
    
    
    func removeFlightCouponApi(params: JSONDictionary ,loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ couponDetails : FlightItineraryData?)->Void) {
        AppNetworking.POST(endPoint:APIEndPoint.removeCouponCode, parameters: params, loader: loader, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess {
                    let appliedCouponData = FlightItineraryData(jsonData[APIKeys.data.rawValue])
                    completionBlock(true, [], appliedCouponData)
                } else {
                    completionBlock(true, [], nil)
                }
            }, failure:  { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .flights)
                completionBlock(false, errors, nil)
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], nil)
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], nil)
            }
        }
    }
    
    func flightReconfirmationApi(params: JSONDictionary ,loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ couponDetails : FlightItineraryData?)->Void) {
        AppNetworking.GET(endPoint:APIEndPoint.flightReconfirmationApi, parameters: params, loader: loader, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess {
                    let appliedCouponData = FlightItineraryData(jsonData[APIKeys.data.rawValue])
                    completionBlock(true, [], appliedCouponData)
                } else {
                    completionBlock(true, [], nil)
                }
            }, failure:  { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .flights)
                completionBlock(false, errors, nil)
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], nil)
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], nil)
            }
        }
    }
    
    
    func flightBookingReceiptAPI(params: JSONDictionary ,loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ hotelReceiptData : FlightReceptModelData?)->Void) {
        AppNetworking.GET(endPoint:APIEndPoint.bookingReceipt, parameters: params, loader: loader, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            sSelf.handleResponse(json, success: { (success, jsonData) in
                printDebug(jsonData)
                if success {
                    let receiptModel = FlightReceptModelData(jsonData[APIKeys.data.rawValue])
                    completionBlock(true, [] , receiptModel)
                } else {
                    completionBlock(true, [], nil)
                }
            }, failure:  { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .flights)
                completionBlock(false, errors, nil)
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], nil)
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], nil)
            }
        }
    }
    
    
    func getAddonsReceipt(params: JSONDictionary ,loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ addonsRecept : AddonsReceiptModel?)->Void) {
        AppNetworking.GET(endPoint:APIEndPoint.getAddonsReceipt, parameters: params, loader: loader, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            sSelf.handleResponse(json, success: { (success, jsonData) in
                printDebug(jsonData)
                if success {
                    let receiptModel = AddonsReceiptModel(jsonData[APIKeys.data.rawValue])
                    completionBlock(true, [] , receiptModel)
                } else {
                    completionBlock(true, [], nil)
                }
            }, failure:  { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .flights)
                completionBlock(false, errors, nil)
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], nil)
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], nil)
            }
        }
    }
    
    
    func flightPaymentResponseAPI(params: JSONDictionary ,loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ json: JSON?)->Void) {
        AppNetworking.POST(endPoint:APIEndPoint.paymentResponse, parameters: params, loader: loader, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            printDebug(json)
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                printDebug(json)
                if sucess {
                    
                    completionBlock(true, [], jsonData[APIKeys.data.rawValue])
                } else {
                    completionBlock(true, [], nil)
                }
            }, failure:  { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .flights)
                completionBlock(false, errors, nil)
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], nil)
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], nil)
            }
        }
    }
    
    
}
