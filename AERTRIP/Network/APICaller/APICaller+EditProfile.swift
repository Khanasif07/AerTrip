//
//  APICaller+EditProfile.swift
//  AERTRIP
//
//  Created by apple on 24/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    // MARK: - Get DropDown Keys
    
    func callGetDropDownKeysApi(completionBlock: @escaping (_ success: Bool, _ addresses: [String], _ emails: [String], _ mobiles: [String], _ salutations: [String], _ socials: [String], _ errorCodes: ErrorCodes) -> Void) {
        AppNetworking.GET(endPoint: .dropDownSalutation, success: { [weak self] data in
            
            guard let sSelf = self else { return }
            
            sSelf.handleResponse(data, success: { _, jsonData in
                
                let saluDict = jsonData[APIKeys.data.rawValue][APIKeys.salutation.rawValue].dictionaryObject
                let emailDict = jsonData[APIKeys.data.rawValue][APIKeys.email.rawValue].dictionaryObject
                let addressDict = jsonData[APIKeys.data.rawValue][APIKeys.address.rawValue].dictionaryObject
                let mobileDict = jsonData[APIKeys.data.rawValue][APIKeys.mobile.rawValue].dictionaryObject
                let socialDict = jsonData[APIKeys.data.rawValue][APIKeys.social.rawValue].dictionaryObject
                
                var salutations = [String]()
                var addresses = [String]()
                var emails = [String]()
                var mobiles = [String]()
                var socials = [String]()
                
                if let keys = saluDict?.keys {
                    for key in keys {
                        salutations.append(key)
                    }
                }
                
                if let keys = addressDict?.keys {
                    for key in keys {
                        addresses.append(key)
                    }
                }
                
                if let keys = emailDict?.keys {
                    for key in keys {
                        emails.append(key)
                    }
                }
                
                if let keys = mobileDict?.keys {
                    for key in keys {
                        mobiles.append(key)
                    }
                }
                
                if let keys = socialDict?.keys {
                    for key in keys {
                        socials.append(key)
                    }
                }
                
                completionBlock(true, addresses, emails, mobiles, salutations, socials, [])
                
            }, failure: { errors in
                completionBlock(false, [""], [], [], [], [], errors)
            })
            
        }) { _ in
        }
    }
    
    // MARK: - Get preferences list
    
    func callGetPreferencesListApi(completionBlock: @escaping (_ success: Bool, _ seatPreferences: [String: String], _ mealPreferences: [String: String], _ errorCodes: ErrorCodes) -> Void) {
        AppNetworking.GET(endPoint: .flightsPreferences, success: { [weak self] data in
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
                completionBlock(false, [:], [:], errors)
            })
            
        }) { _ in
        }
    }
    
    // MARK: - Get Countries list
    
    func callGetCountriesListApi(completionBlock: @escaping (_ success: Bool, _ countries: [String: String], _ errorCodes: ErrorCodes) -> Void) {
        AppNetworking.GET(endPoint: .countryList, success: { [weak self] data in
            var countriesDict = [String: String]()
            
            guard let sSelf = self else { return }
            
            sSelf.handleResponse(data, success: { _, jsonData in
                
                countriesDict = jsonData["data"].dictionaryObject as! [String : String]
                
                completionBlock(true, countriesDict, [])
                
            }, failure: { errors in
                completionBlock(false, [:], errors)
            })
            
        }) { _ in
        }
    }
    
    // MARK: - Get Default airline
    
    func getDefaultAirlines(loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ data: [FlyerModel], _ errorCodes: ErrorCodes)->Void ) {
        
        
        AppNetworking.GET(endPoint: .defaultAirlines,loader: loader, success: { [weak self] (data) in
            
            
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                
                let data = FlyerModel.retunsFlyerArray(jsonArr: jsonData["data"].arrayValue)
                completionBlock(true, data, [])
                
            }, failure: { (errors) in
                print(errors)
            })
            
        }) { (error) in
        }
    }
    
    
    
    //MARK: - Api for Save Edit profile user
    //MARK: -
    func callSaveProfileAPI(params: JSONDictionary,filePath:String, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ) {
        
        let headers = [
            "content-type": "multipart/form-data; boundary=----WebKitFormBoundary7MA4YWxkTrZu0gW",
            "api-key": "3a457a74be76d6c3603059b559f6addf",
            ]
        
        
        
        
        if filePath.isEmpty {
            AppNetworking.POST(endPoint: APIEndPoint.saveProfile, parameters: params, success: { [weak self] (json) in
                guard let sSelf = self else {return}
                
                sSelf.handleResponse(json, success: { (sucess, jsonData) in
                    
                    //                let userSettings = jsonData[APIKeys.data.rawValue].dictionaryObject
                    //                if let userData = userSettings{
                    //                    AppUserDefaults.save(value: userData, forKey: .userData)
                    //                }
                    //                AppUserDefaults.save(value: jsonData[APIKeys.data.rawValue]["pax_id"].stringValue, forKey: .userId)
                    completionBlock(true, [])
                    
                }, failure: { (errors) in
                    completionBlock(false, errors)
                })
                
            }) { (error) in
                print(error)
            }
            
        } else {
            AppNetworking.POSTWithMultiPart(endPoint: APIEndPoint.saveProfile, parameters: params, multipartData: [(key: "profile_image", filePath:filePath, fileExtention: "png", fileType: AppNetworking.MultiPartFileType.image)], loader: true, success: { (data) in
                print(data)
            }, progress: { (progress) in
                NSLog("progress is \(progress)")
            }) { (error) in
                print(error)
            }
        }
    }
}


