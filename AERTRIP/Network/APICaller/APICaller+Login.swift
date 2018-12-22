//
//  APICaller.swift
//  
//
//  Created by Pramod Kumar on 11/05/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    
    //MARK: - Api for Active user
    //MARK: -
    func callActiveUserAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ message: String)->Void ) {
        
        AppNetworking.GET(endPoint: APIEndPoint.isActiveUser, parameters: params, loader: loader, success: { [weak self] (data) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, "")
                
            }, failure: { (error) in
                completionBlock(false, "")
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription)
        }
    }
    
    //MARK: - Api for login user
    //MARK: -
    func callLoginAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.login, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}

            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                
                let userSettings = jsonData[APIKeys.data.rawValue].dictionaryObject
                if let userData = userSettings{
                    AppUserDefaults.save(value: userData, forKey: .userData)
                }
                AppUserDefaults.save(value: jsonData[APIKeys.data.rawValue]["pax_id"].stringValue, forKey: .userId)
                completionBlock(true, [])
                
            }, failure: { (errors) in
                completionBlock(false, errors)
            })
            
        }) { (error) in
        }
    }
    
    //MARK: - Api for Social login
    //MARK: -
    func callSocialLoginAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool,  _ errorCodes: ErrorCodes)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.socialLogin, parameters: params, loader: loader, success: { [weak self] (data) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                
                let userSettings = jsonData[APIKeys.data.rawValue].dictionaryObject
                if let userData = userSettings{
                    AppUserDefaults.save(value: userData, forKey: .userData)
                }
                AppUserDefaults.save(value: jsonData[APIKeys.data.rawValue]["pax_id"].stringValue, forKey: .userId)
                completionBlock(true, [])
                
            }, failure: { (errors) in
                completionBlock(false, errors)
            })
            
        }) { (error) in
            
        }
    }
    
    //MARK: - Api for Register
    //MARK: -
    func callRegisterNewUserAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ email: String, _ errorCodes: ErrorCodes)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.register, parameters: params, loader: loader, success: { [weak self] (data) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                
                let email = jsonData[APIKeys.data.rawValue][APIKeys.email.rawValue].stringValue
                completionBlock(true, email, [])
                
            }, failure: { (errors) in
                completionBlock(false, "", errors)
            })
            
        }) { (error) in
            
        }
    }
    
    //MARK: - Api for ForgotPassword
    //MARK: -
    func callForgotPasswordAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ email: String, _ errorCodes: ErrorCodes)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.forgotPassword, parameters: params, loader: loader, success: { [weak self] (data) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                
                let email = jsonData[APIKeys.data.rawValue][APIKeys.email.rawValue].stringValue
                completionBlock(true, email, [])
                
            }, failure: { (errors) in
                completionBlock(false, "", errors)
            })
            
        }) { (error) in
        }
    }
    
    //MARK: - Api for UpdatePassword
    //MARK: -
    func callUpdatePasswordAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ data: String, _ errorCodes: ErrorCodes)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.updateUserPassword, parameters: params, loader: loader, success: { [weak self] (data) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                
                let data = jsonData[APIKeys.data.rawValue].stringValue
                completionBlock(true, data, [])
                
            }, failure: { (errors) in
                completionBlock(false, "", errors)
            })
            
        }) { (error) in
        }
    }
    
    //MARK: - Api for Update UserDetail
    //MARK: -
    func callUpdateUserDetailAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.updateUserDetail, parameters: params, loader: loader, success: { [weak self] (data) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                
//                let userSettings = jsonData[APIKeys.data.rawValue].dictionary
//                AppUserDefaults.save(value: userSettings, forKey: .userData)
//                AppUserDefaults.save(value: jsonData[APIKeys.data.rawValue]["pax_id"].stringValue, forKey: .userId)
                
                
                completionBlock(true, [])
                
            }, failure: { (errors) in
                completionBlock(false,  errors)
            })
            
        }) { (error) in
        }
    }
    
    //MARK: - Api for Update UserDetail
    //MARK: -
    func callVerifyRegistrationApi(type: ThankYouRegistrationVM.VerifyRegistrasion, params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ) {
        
        var endPoint = APIEndPoint.verifyRegistration
        if type == .deeplinkResetPassword {
            endPoint = .resetPassword
        }
        
        AppNetworking.GET(endPoint: endPoint, parameters: params, loader: loader, success: { [weak self] (data) in
            
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, [])
                
            }, failure: { (errors) in
                completionBlock(false, errors)
            })
            
        }) { (error) in
        }
    }
    
    //MARK: - Api for Update UserDetail
    //MARK: -
    func callGetSalutationsApi( completionBlock: @escaping(_ success: Bool, _ salutations: [String], _ errorCodes: ErrorCodes)->Void ) {
        
       AppNetworking.GET(endPoint: .dropDownSalutation, success: { [weak self] (data) in
            
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                
                let saluDict = jsonData[APIKeys.data.rawValue][APIKeys.salutation.rawValue].dictionaryObject
                var salutation = [String]()
                if let keys = saluDict?.keys {
                    
                    for key in keys {
                        
                        salutation.append(key)
                    }
                }
                completionBlock(true, salutation, [])
                
            }, failure: { (errors) in
                completionBlock(false, [""], errors)
            })
            
        }) { (error) in
        }
    }
}
