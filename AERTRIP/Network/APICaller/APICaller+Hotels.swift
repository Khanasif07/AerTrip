//
//  APICaller+Hotels.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 02/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    
    //MARK: - Api for login user
    //MARK: -
    func getHotelPreferenceList(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ city: [CityHotels], _ stars: [Int])->Void ) {
        
        AppNetworking.GET(endPoint: APIEndPoint.hotelPreferenceList, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess {
                    let array =  CityHotels.models(json: jsonData[APIKeys.data.rawValue][APIKeys.hotels.rawValue])
                    var stars: [Int] = []
                    if let arr = jsonData[APIKeys.data.rawValue][APIKeys.stars.rawValue].arrayObject {
                        stars = arr.map({ (item) -> Int in
                            "\(item)".toInt ?? 0
                        })
                    }
                    if stars.contains(0) {
                        stars.remove(at: stars.firstIndex(of: 0)!)
                    }
                    completionBlock(true, [], array, stars)
                }
                else {
                    completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], [], [])
                }
                
            }, failure: { (errors) in
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
    
    func getHotelsByStarPreference(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ city: [CityHotels])->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.hotelStarPreference, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess {
                    completionBlock(true, [], [])
                }
                else {
                    completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], [])
                }
                
            }, failure: { (errors) in
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
    
    func callSearchHotelsAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ hotels: [HotelsModel])->Void ) {
        
        AppNetworking.GET(endPoint: APIEndPoint.searchHotels, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess {
                    let array =  HotelsModel.models(json: jsonData[APIKeys.data.rawValue])
                    completionBlock(true, [], array)
                }
                else {
                    completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], [])
                }
                
            }, failure: { (errors) in
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
    
    func callUpdateFavouriteAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ successMessage: String)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.favourite, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                completionBlock(sucess, [], jsonData[APIKeys.data.rawValue][APIKeys.msg.rawValue].stringValue)
                
            }, failure: { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .hotelsSearch)
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
    
    func getPinnedTemplateAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ shortTemplateUrl: String)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.getPinnedTemplate, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess, let response = jsonData[APIKeys.data.rawValue].dictionaryObject {
                    let shortUrl = response[APIKeys.shortUrl.rawValue] as? String
                    completionBlock(true, [],shortUrl ?? "")
                } else {
                    completionBlock(false, [],"")
                }
            }, failure: { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .hotelsSearch)
                completionBlock(false, errors, "")
            })
        }) { (error) in
//            if error.code == AppNetworking.noInternetError.code {
//                AppGlobals.shared.stopLoading()
//                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
//                completionBlock(false, [], "")
//            }
//            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], "")
//            }
        }
    }
    
    func saveHotelWithTripAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ isAlredyAdded: Bool)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.tripEventHotelsSave, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess {
                    completionBlock(true, [], jsonData[APIKeys.data.rawValue].isEmpty)
                } else {
                    completionBlock(false, [], false)
                }
            }, failure: { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .hotelsSearch)
                completionBlock(false, errors, false)
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], false)
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], false)
            }
        }
    }
    
    func loginForPaymentAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool,_ logInId: String , _ isGuestUser: String  ,_ errorCodes: ErrorCodes)->Void ) {
        AppNetworking.POST(endPoint: APIEndPoint.login, parameters: params, success: { [weak self] (json) in
            printDebug(json)
            guard let sSelf = self else {return}
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess {
                    if let data = jsonData[APIKeys.data.rawValue].dictionaryObject, let email = data[APIKeys.loginid.rawValue] as? String , let isGuestUser = data[APIKeys.isGuestUser.rawValue] as? String {
                        completionBlock(true, email , isGuestUser , [])
                    }
                    completionBlock(true, "" , "true" , [])
                } else {
                    completionBlock(false, "" , "true" , [])
                }
            }, failure: { (errors) in
                completionBlock(false, "" , "false" , errors)
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, "", "false", [])
            }
            else {
                completionBlock(false, "", "false", [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
    
    
    func callShareTextAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ successMessage: String,_ shareText: String)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.shareText, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                if sucess {
                    if let data = jsonData[APIKeys.data.rawValue].dictionaryObject, let su = data["su"] as? String {
                        completionBlock(true,[],"",su)
                    }
                  
                } else {
                    completionBlock(false,[], "" ,"")
                }
                
            }, failure: { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .hotelsSearch)
                completionBlock(false, errors,"","")
            })
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                AppGlobals.shared.stopLoading()
                AppToast.default.showToastMessage(message: ATErrorManager.LocalError.noInternet.message)
                completionBlock(false, [], "", "")
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], "", "")
            }
        }
    }
    
    func getShareLinkAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes, _ shortTemplateUrl: String)->Void ) {
            
            AppNetworking.POST(endPoint: APIEndPoint.getShareLink, parameters: params, success: { [weak self] (json) in
                guard let sSelf = self else {return}
                
                printDebug(json)
                sSelf.handleResponse(json, success: { (sucess, jsonData) in
                    if sucess, let response = jsonData[APIKeys.data.rawValue].dictionaryObject {
                        let shortUrl = response[APIKeys.url.rawValue] as? String
                        completionBlock(true, [],shortUrl ?? "")
                    } else {
                        completionBlock(false, [],"")
                    }
                }, failure: { (errors) in
                    ATErrorManager.default.logError(forCodes: errors, fromModule: .hotelsSearch)
                    completionBlock(false, errors, "")
                })
            }) { (error) in
                    completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue], "")
            }
        }
}


extension APICaller {
    func saveLocallyFavToServer() {
        var param: JSONDictionary = ["status": 1]
        for (idx,id) in UserInfo.locallyFavHotels.enumerated() {
            param["hid[\(idx)]"] = id
        }
        APICaller.shared.callUpdateFavouriteAPI(params: param) { (isSuccess, errors, successMessage) in
            if isSuccess {
                UserInfo.locallyFavHotels.removeAll()
            }
        }
    }
}

