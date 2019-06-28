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
                    let hotelInfo = HotelDetails.hotelInfo(response: hotel!) as? HotelDetails
                    
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
        }) { error in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue])
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
        }) { error in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue], nil)
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], nil)
            }
        }
    }
    
    func getBookingFees(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping (_ success: Bool, _ errorCodes: ErrorCodes, _ bookingFeeDetail: BookingFeeDetail?) -> Void) {
        AppNetworking.GET(endPoint: APIEndPoint.getBookingFees, parameters: params, success: { [weak self] json in
            guard let sSelf = self else { return }
            printDebug(json)
            sSelf.handleResponse(json, success: { sucess, jsonData in
                if sucess, let response = jsonData[APIKeys.data.rawValue].dictionaryObject {
                    let data = BookingFeeDetail(json: response)
                    completionBlock(true, [], data)
                }
                else {
                    completionBlock(false, [], nil)
                }
            }, failure: { error in
                ATErrorManager.default.logError(forCodes: error, fromModule: .hotelsSearch)
                completionBlock(false, error, nil)
            })
        }) { error in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue], nil)
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], nil)
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
                                        rutes = dataKey
                                    }
                                }
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
        }) { error in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue], LocalizedString.na.localized, LocalizedString.na.localized)
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], LocalizedString.na.localized, LocalizedString.na.localized)
            }
        }
    }
    
    
    // MARK: - Get Preference master list
    
    func getPreferenceMaster(completionBlock: @escaping (_ success: Bool,_ seatPreferences: [String: String], _ mealPreferences: [String: String], _ errorCodes: ErrorCodes) -> Void) {
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
                completionBlock(false, [:], [:],errors)
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [:],[:], [ATErrorManager.LocalError.noInternet.rawValue])
            }
            else {
                completionBlock(false, [:],[:], [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
    
    // Get  Traveller Email
    func getTravellerEmail(completionBlock: @escaping (_ success: Bool,_ emails: [String],_ token: String, _ errorCodes: ErrorCodes) -> Void) {
        AppNetworking.GET(endPoint: .getTravellerEmails, success: { [weak self] data in
         
            guard let sSelf = self else { return }
            
            sSelf.handleResponse(data, success: { _, jsonData in
                
                if let data = jsonData["data"].dictionaryObject {
                    if let emails = data["emails"] as? [String],let token = data["tk"] as? String {
                       completionBlock(true, emails, token, [])
                    }
                }
                
               
                
            }, failure: { errors in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .profile)
                completionBlock(false,[],"",errors)
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false,[],"", [ATErrorManager.LocalError.noInternet.rawValue])
            }
            else {
                completionBlock(false,[],"", [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
    
    
    // Get Email Api
    
    func sendConfirmationEmailApi(bookingID: String ,params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ successMessage: String)->Void ) {
        let endPoint = "https://beta.aertrip.com/api/v1/dashboard/booking-action?type=email&booking_id=\(bookingID)"
        AppNetworking.POST(endPointPath: endPoint, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                completionBlock(sucess, [], jsonData[APIKeys.data.rawValue][APIKeys.msg.rawValue].stringValue)
                
            }, failure: { (errors) in
                completionBlock(false, errors, "")
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue], "")
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], "")
            }
        }
    }
   
}
