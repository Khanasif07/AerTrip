//
//  Api+HotelCheckOut.swift
//  AERTRIP
//
//  Created by Admin on 15/03/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    
    func sendDashBoardEmailIDAPI(bookingID: String ,params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ successMessage: String)->Void ) {
        let endPoint = "https://beta.aertrip.com/api/v1/dashboard/booking-action?booking_id=\(bookingID)&type=email"
        AppNetworking.POST(endPointPath: endPoint, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                completionBlock(sucess, [], jsonData[APIKeys.data.rawValue][APIKeys.msg.rawValue].stringValue)
                
            }, failure: { (errors) in
                completionBlock(false, errors, "")
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], "")
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], "")
            }
        }
    }
    
    
    func callItenaryDataForTravellerAPI(itinaryId:String,params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ successMessage: String,_ itinerary : ItenaryModel)->Void ) {
       
        let urlPath = APIEndPoint.baseUrlPath.rawValue + APIEndPoint.hotelItinerary.rawValue + "&it_id=\(itinaryId)"
        AppNetworking.POST(endPointPath:urlPath, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                
                if sucess, let data = jsonData[APIKeys.data.rawValue].dictionary {
                    let itinary = ItenaryModel(json:data["itinerary"] ?? [])
                     printDebug("itinary is \(itinary)")
                    completionBlock(sucess, [], jsonData[APIKeys.data.rawValue][APIKeys.msg.rawValue].stringValue,itinary)
                }
                else {
                    completionBlock(sucess, [], jsonData[APIKeys.data.rawValue][APIKeys.msg.rawValue].stringValue,ItenaryModel())
                }
                
                
            }, failure: { (errors) in
                completionBlock(false, errors, "",ItenaryModel())
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], "", ItenaryModel())
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], "", ItenaryModel())
            }
        }
    }
    
    func getPaymentMethods(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes,_ paymentDetail: PaymentModal) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.getPaymentMethod, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess {
                    let paymentDetail = PaymentModal(json: jsonData[APIKeys.data.rawValue])
                    completionBlock(true, [],paymentDetail)
                }
                else {
                    completionBlock(false, [],PaymentModal())
                }
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
                completionBlock(false,[],PaymentModal())
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], PaymentModal())
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], PaymentModal())
            }
        }
    }
    
    
    func getCouponDetailsApi(params: JSONDictionary ,loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ couponDetails : [HCCouponModel])->Void) {
        AppNetworking.POST(endPoint:APIEndPoint.getCoponDetails, parameters: params, loader: loader, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            printDebug(json)
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess, let response = jsonData[APIKeys.data.rawValue].dictionaryObject , let couponsArray = response[APIKeys.coupons.rawValue] as? [JSONDictionary]  {
                    let couponDetails = HCCouponModel.getHCCouponData(jsonArr: couponsArray)
                    completionBlock(true, [], couponDetails)
                } else {
                    completionBlock(true, [], [])
                }
            }, failure:  { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .hotelsSearch)
                completionBlock(false, errors, [])
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], [])
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], [])
            }
        }
    }
    
    
    func applyCoupnCodeApi(params: JSONDictionary ,loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ couponDetails : HCCouponAppliedModel?)->Void) {
        AppNetworking.POST(endPoint:APIEndPoint.applyCouponCode, parameters: params, loader: loader, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            printDebug(json)
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess {
                    let appliedCouponData = HCCouponAppliedModel.getHCCouponAppliedModel(json: jsonData[APIKeys.data.rawValue] )
                    completionBlock(true, [], appliedCouponData)
                } else {
                    completionBlock(true, [], nil)
                }
            }, failure:  { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .hotelsSearch)
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
    
    func removeCouponApi(params: JSONDictionary ,loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ couponDetails : HCCouponAppliedModel?)->Void) {
        AppNetworking.POST(endPoint:APIEndPoint.removeCouponCode, parameters: params, loader: loader, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            printDebug(json)
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess {
                    let appliedCouponData = HCCouponAppliedModel.getHCCouponAppliedModel(json: jsonData[APIKeys.data.rawValue] )
                    completionBlock(true, [], appliedCouponData)
                } else {
                    completionBlock(true, [], nil)
                }
            }, failure:  { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .hotelsSearch)
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
    
    func makePaymentAPI(params: JSONDictionary ,loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ options: JSONDictionary)->Void) {
        AppNetworking.POST(endPoint:APIEndPoint.makePayment, parameters: params, loader: loader, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess {
                    completionBlock(true, [], jsonData[APIKeys.data.rawValue].dictionaryObject ?? [:])
                } else {
                    completionBlock(true, [], [:])
                }
            }, failure:  { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .hotelsSearch)
                completionBlock(false, errors, [:])
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], [:])
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], [:])
            }
        }
    }
    
    func paymentResponseAPI(params: JSONDictionary ,loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ bookingIds: [String] , _ cid: [String])->Void) {
        AppNetworking.POST(endPoint:APIEndPoint.paymentResponse, parameters: params, loader: loader, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            printDebug(json)
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                printDebug(json)
                if sucess {
                    
                    completionBlock(true, [], jsonData[APIKeys.data.rawValue][APIKeys.booking_id.rawValue].arrayObject as? [String] ?? [], jsonData[APIKeys.data.rawValue][APIKeys.cid.rawValue].arrayObject as? [String] ?? [])
                } else {
                    completionBlock(true, [], [], [])
                }
            }, failure:  { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .hotelsSearch)
                completionBlock(false, errors, [], [])
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], [], [])
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], [], [])
            }
        }
    }
    
    func bookingReceiptAPI(params: JSONDictionary ,loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ hotelReceiptData : HotelReceiptModel?)->Void) {
        AppNetworking.GET(endPoint:APIEndPoint.bookingReceipt, parameters: params, loader: loader, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                printDebug(jsonData)
                if sucess , let data = jsonData[APIKeys.data.rawValue].dictionaryObject , let receiptData = data[APIKeys.receipt.rawValue] as? JSONDictionary {
                    let receiptModel = HotelReceiptModel(json: receiptData)
                    completionBlock(true, [] , receiptModel)
                } else {
                    completionBlock(true, [], nil)
                }
            }, failure:  { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .hotelsSearch)
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
