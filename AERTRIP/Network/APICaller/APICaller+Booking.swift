//
//  APICaller+Booking.swift
//  AERTRIP
//
//  Created by apple on 14/05/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    func getHotelInfo(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ hotel: HotelDetails?) -> Void) {
        let frameworkBundle = Bundle(for: PKCountryPicker.self)
        guard let jsonPath = frameworkBundle.path(forResource: "hotelData", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
            return completionBlock(false, [], nil)
        }
        
        do {
            if let jsonObjects = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? JSONDictionary {
                if let hotelDetail = jsonObjects["data"] as? JSONDictionary {
                    let hotel = hotelDetail["results"] as? JSONDictionary
                    let hotelInfo = HotelDetails.hotelInfo(response: hotel!)
                    
                    completionBlock(true, [], hotelInfo)
                }
                else {
                    completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], nil)
                }
            }
        }
        catch {
            completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], nil)
        }
    }
    
    func getBookingList(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.bookingList, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess, let response = jsonData[APIKeys.data.rawValue].dictionaryObject, let bookings = response["bookings"] as? [JSONDictionary] {
                    BookingData.insert(dataDictArray: bookings, completionBlock: { _ in
                        completionBlock(true, [])
                    })
                }
                else {
                    completionBlock(false, [])
                }
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
                completionBlock(false, error)
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [])
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
    
    // MARK: - Booking detail
    
    func getBookingDetail(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ bookingDetailModel: BookingDetailModel?) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.getBookingDetails, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess, let response = jsonData[APIKeys.data.rawValue].dictionaryObject {
                    let data = BookingDetailModel(json: response)
                    completionBlock(true, [], data)
                }
                else {
                    completionBlock(false, [], nil)
                }
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
                completionBlock(false, error, nil)
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
    
    func getBookingFees(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ bookingFeeDetail: [BookingFeeDetail]) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.getBookingFees, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
           
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess, let allData = jsonData[APIKeys.data.rawValue].arrayObject as? [JSONDictionary] {
                
                    let final = allData.map({ BookingFeeDetail(json: $0) })
                
                    completionBlock(true, [], final)
                }
                else {
                    completionBlock(false, [], [])
                }
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
                completionBlock(false, error, [])
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
    
    // MARK: - Get Fare detail
    
    func getFareRulesAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ rules: String, _ rute: String) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.getFareRules, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess {
                    var finalRules = "", rutes = ""
                    if let data = jsonData[APIKeys.data.rawValue].dictionaryObject {
                        for key in Array(data.keys) {
                            if let dict = data[key] as? JSONDictionary {
                                for dataKey in Array(dict.keys) {
                                    if let obj = dict[dataKey] as? String {
                                        finalRules += obj
                                        rutes = dataKey.replacingOccurrences(of: "-", with: "→")
                                    }
                                }
                            }
                            
                            if let str = data[key] as? String {
                               finalRules = str
                            }
                        }
                    }
                    finalRules = finalRules.isEmpty ? LocalizedString.na.localized : finalRules
                    completionBlock(true, [], finalRules, rutes)
                }
                else {
                    completionBlock(false, [], LocalizedString.na.localized, LocalizedString.na.localized)
                }
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
                completionBlock(false, error, LocalizedString.na.localized, LocalizedString.na.localized)
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], LocalizedString.na.localized, LocalizedString.na.localized)
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], LocalizedString.na.localized, LocalizedString.na.localized)
            }
        }
    }
    
    // MARK: - Get Preference master list
    
    func getPreferenceMaster(completionBlock: @escaping (_ success: Bool, _ seatPreferences: [String: String], _ mealPreferences: [String: String], _ errorCodes: ErrorCodes) -> Void) {
        AppNetworking.GET(endPoint: .preferenceMaster, success: { [weak self] data in
            var seatPreferencesDict = [String: String]()
            var mealPreferencesDict = [String: String]()
            guard let sSelf = self else { return }
            
            sSelf.handleResponse(data, success: { _, jsonData in
                
                if let preferences = jsonData[APIKeys.data.rawValue][APIKeys.preferences.rawValue].dictionaryObject {
                    seatPreferencesDict = preferences["seat"] as! [String: String]
                    mealPreferencesDict = preferences["meal"] as! [String: String]
                }
                
                completionBlock(true, seatPreferencesDict, mealPreferencesDict, [])
                
            }, failure: { errors in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .profile)
                completionBlock(false, [:], [:], errors)
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [:], [:], [])
            }
            else {
                completionBlock(false, [:], [:], [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
    
    // Get  Traveller Email
    func getTravellerEmail(completionBlock: @escaping (_ success: Bool, _ emails: [String], _ token: String, _ errorCodes: ErrorCodes) -> Void) {
        AppNetworking.GET(endPoint: .getTravellerEmails, success: { [weak self] data in
            
            guard let sSelf = self else { return }
            
            sSelf.handleResponse(data, success: { _, jsonData in
                
                if let data = jsonData["data"].dictionaryObject {
                    if let emails = data["emails"] as? [String], let token = data["tk"] as? String {
                        completionBlock(true, emails, token, [])
                    }
                }
                
            }, failure: { errors in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .profile)
                completionBlock(false, [], "", errors)
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], "", [])
            }
            else {
                completionBlock(false, [], "", [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
    
    // Get Email Api
    
    func sendConfirmationEmailApi(bookingID: String, params: JSONDictionary, loader: Bool = false, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ successMessage: String) -> Void) {
        let endPoint = "https://beta.aertrip.com/api/v1/dashboard/booking-action?type=email&booking_id=\(bookingID)"
        AppNetworking.POST(endPointPath: endPoint, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            
            sSelf.handleResponse(json, success: { sucess, jsonData in
                completionBlock(sucess, [], jsonData[APIKeys.data.rawValue][APIKeys.msg.rawValue].stringValue)
                
            }, failure: { errors in
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
    
    // MARK: - API Call for Add on Request
    
    // MARK: -
    
    func addOnRequest(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes) -> Void) {
        AppNetworking.POST(endPoint: APIEndPoint.addOnRequest, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            
            sSelf.handleResponse(json, success: { _, _ in
                completionBlock(true, [])
                
            }, failure: { errors in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .profile)
                completionBlock(false, errors)
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [])
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
    
    func getCaseHistory(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ history: BookingCaseHistory?) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.getCaseHistory, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess, let response = jsonData[APIKeys.data.rawValue].dictionaryObject {
                    let data = BookingCaseHistory(json: response)
                    completionBlock(true, [], data)
                }
                else {
                    completionBlock(false, [], nil)
                }
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
                completionBlock(false, error, nil)
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
    
    func abortRequestAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes) -> Void) {
        AppNetworking.POST(endPoint: APIEndPoint.abortRequest, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            
            sSelf.handleResponse(json, success: { sucess, _ in
                completionBlock(sucess, [])
                
            }, failure: { errors in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .hotelsSearch)
                completionBlock(false, errors)
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [])
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
    
    func requestConfirmationAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes) -> Void) {
        AppNetworking.POST(endPoint: APIEndPoint.requestConfirmation, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            
            sSelf.handleResponse(json, success: { sucess, _ in
                completionBlock(sucess, [])
                
            }, failure: { errors in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .hotelsSearch)
                completionBlock(false, errors)
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [])
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
    
    func addonPaymentAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ itinerary: DepositItinerary?) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.addonPayment, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess {
                    var itin: DepositItinerary?
                    if let dict = jsonData[APIKeys.data.rawValue][APIKeys.itinerary.rawValue].dictionaryObject {
                        itin = DepositItinerary(json: dict)
                    }
                    
                    completionBlock(true, [], itin)
                }
                else {
                    completionBlock(false, [], nil)
                }
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
                completionBlock(false, error, nil)
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
    
    func rescheduleRequestAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.rescheduleRequest, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                completionBlock(sucess, [])
                
            }, failure: { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .hotelsSearch)
                completionBlock(false, errors)
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [])
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
    
    //get mode and reasons for booking cancellation
    func getCancellationRefundModeReasonsAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ modes: [String], _ reasons: [String], _ userMode: String) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.cancellationRefundModeReasons, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess, let response = jsonData[APIKeys.data.rawValue].dictionaryObject {
                    print(response)
                    var modes: [String] = [], reasons: [String] = []
                    if let rModes = response["refund_mode"] as? JSONDictionary {
                        modes = rModes.map({ "\($0.1)" })
                    }
                    
                    if let reason = response["reason"] as? JSONDictionary {
                        reasons = reason.map({ "\($0.1)" })
                    }
                    
                    let userMode = (response["user_refund_mode"] as? String) ?? ""
                    
                    completionBlock(true, [], modes, reasons, userMode)
                }
                else {
                    completionBlock(false, [], [], [], "")
                }
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
                completionBlock(false, error, [], [], "")
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], [], [], "")
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], [], [], "")
            }
        }
    }
    
    func cancellationRequestAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ caseData: Case?)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.cancellationRequest, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess, let response = jsonData[APIKeys.data.rawValue].dictionaryObject {
                    completionBlock(sucess, [], Case(json: response, bookindId: ""))
                }
                else {
                    completionBlock(false, [], nil)
                }
                
            }, failure: { (errors) in
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
    
    //get all hotel special requests
    func getHotelSpecialRequestAPI(loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ requests: [String]) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.hotelSpecialRequestList, parameters: [:], success: {  json in
            printDebug(json)
            if let response = json.dictionaryObject {
                print(response)
                let rqst = response.map({ "\($0.1)" })
                completionBlock(true, [], rqst)
            }
            else {
                completionBlock(false, [], [])
            }
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
    
    func makeHotelSpecialRequestAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.makeHotelSpecialRequest, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                completionBlock(sucess, [])
                
            }, failure: { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .hotelsSearch)
                completionBlock(false, errors)
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [])
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
    
    func getcommunicationDetailAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ htmlData: String) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.communicationDetail, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess, let response = jsonData[APIKeys.data.rawValue].string {
                    print(response)
                    completionBlock(true, [], response)
                }
                else {
                    completionBlock(false, [], "")
                }
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
                completionBlock(false, error, "")
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
    
    func bookingOutstandingPaymentAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ itinerary: DepositItinerary?) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.bookingOutstandingPayment, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess {
                    var itin: DepositItinerary?
                    if let dict = jsonData[APIKeys.data.rawValue][APIKeys.itinerary.rawValue].dictionaryObject {
                        itin = DepositItinerary(json: dict)
                    }
                    
                    completionBlock(true, [], itin)
                }
                else {
                    completionBlock(false, [], nil)
                }
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
                completionBlock(false, error, nil)
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

