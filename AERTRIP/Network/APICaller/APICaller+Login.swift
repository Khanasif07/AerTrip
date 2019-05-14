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
    func callActiveUserAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ) {
        
        AppNetworking.GET(endPoint: APIEndPoint.isActiveUser, parameters: params, loader: loader, success: { [weak self] (data) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, [])
                
            }, failure: { (error) in
                ATErrorManager.default.logError(forCodes: error, fromModule: .login)
                completionBlock(false, error)
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue])
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
    
    //MARK: - Api for login user
    //MARK: -
    func callLoginAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.login, parameters: params, success: { [weak self] (json) in
            guard let sSelf = self else {return}

            sSelf.handleResponse(json, success: { (sucess, jsonData) in
                
                if var userData = jsonData[APIKeys.data.rawValue].dictionaryObject, let id = jsonData[APIKeys.data.rawValue][APIKeys.paxId.rawValue].int {
                    
                    UserInfo.loggedInUserId = "\(id)"
                    if let gen = userData[APIKeys.generalPref.rawValue] as? JSONDictionary {
                        userData[APIKeys.generalPref.rawValue] = AppGlobals.shared.json(from: gen)
                    }
                    _ = UserInfo(withData: userData, userId: "\(id)")
                    
                    if let acc = userData["account_data"] as? JSONDictionary {
                        //if there is account data then save it
                        UserInfo.loggedInUser?.accountData = AccountModel(json: acc)
                    }
                    
                    if let img = UserInfo.loggedInUser?.profileImagePlaceholder() {
                        UserInfo.loggedInUser?.profilePlaceholder = img
                    }
                }
                completionBlock(true, [])
                
            }, failure: { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .login)
                completionBlock(false, errors)
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue])
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
    
    //MARK: - Api for Social login
    //MARK: -
    func callSocialLoginAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool,  _ errorCodes: ErrorCodes)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.socialLogin, parameters: params, loader: loader, success: { [weak self] (data) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                
                if var userData = jsonData[APIKeys.data.rawValue].dictionaryObject, let id =
                    jsonData[APIKeys.data.rawValue][APIKeys.paxId.rawValue].int {
                    
                    if let profileName = userData["profile_name"] as? String {
                        let fullNameArr = profileName.components(separatedBy: " ")
                        userData[APIKeys.firstName.rawValue] = fullNameArr[0]
                        userData[APIKeys.lastName.rawValue] = fullNameArr[1]
                    }
                    
                    UserInfo.loggedInUserId = "\(id)"
                    if let gen = userData[APIKeys.generalPref.rawValue] as? JSONDictionary {
                        userData[APIKeys.generalPref.rawValue] = AppGlobals.shared.json(from: gen)
                    }
                    _ = UserInfo(withData: userData, userId: "\(id)")
                }
                completionBlock(true, [])
                
            }, failure: { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .login)
                completionBlock(false, errors)
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue])
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
    
    //MARK: - Api for Social login
    //MARK: -
    func callSocialLinkAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool,  _ errorCodes: ErrorCodes)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.socialLink, parameters: params, loader: loader, success: { [weak self] (data) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                
//                if var userData = jsonData[APIKeys.data.rawValue].dictionaryObject, let id =
//                    jsonData[APIKeys.data.rawValue][APIKeys.paxId.rawValue].int {
//
//                    if let profileName = userData["profile_name"] as? String {
//                        let fullNameArr = profileName.components(separatedBy: " ")
//                        userData[APIKeys.firstName.rawValue] = fullNameArr[0]
//                        userData[APIKeys.lastName.rawValue] = fullNameArr[1]
//                    }
//
//                    UserInfo.loggedInUserId = "\(id)"
//                    if let gen = userData[APIKeys.generalPref.rawValue] as? JSONDictionary {
//                        userData[APIKeys.generalPref.rawValue] = AppGlobals.shared.json(from: gen)
//                    }
//                    _ = UserInfo(withData: userData, userId: "\(id)")
//                }
                completionBlock(sucess, [])
                
            }, failure: { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .login)
                completionBlock(false, errors)
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue])
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
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
                ATErrorManager.default.logError(forCodes: errors, fromModule: .login)
                completionBlock(false, "", errors)
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, "", [ATErrorManager.LocalError.noInternet.rawValue])
            }
            else {
                completionBlock(false, "", [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
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
                ATErrorManager.default.logError(forCodes: errors, fromModule: .login)
                completionBlock(false, "", errors)
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, "", [ATErrorManager.LocalError.noInternet.rawValue])
            }
            else {
                completionBlock(false, "", [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
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
                ATErrorManager.default.logError(forCodes: errors, fromModule: .login)
                completionBlock(false, "", errors)
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, "", [ATErrorManager.LocalError.noInternet.rawValue])
            }
            else {
                completionBlock(false, "", [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
    
    //MARK: - Api for Update UserDetail
    //MARK: -
    func callUpdateUserDetailAPI(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.updateUserDetail, parameters: params, loader: loader, success: { [weak self] (data) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                if var userData = jsonData[APIKeys.data.rawValue].dictionaryObject, let id = jsonData[APIKeys.data.rawValue][APIKeys.paxId.rawValue].int {
                    
                    UserInfo.loggedInUserId = "\(id)"
                    if let gen = userData[APIKeys.generalPref.rawValue] as? JSONDictionary {
                        userData[APIKeys.generalPref.rawValue] = AppGlobals.shared.json(from: gen)
                    }
                    _ = UserInfo(withData: userData, userId: "\(id)")
                }
                completionBlock(true, [])
                
            }, failure: { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .login)
                completionBlock(false,  errors)
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue])
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
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
                ATErrorManager.default.logError(forCodes: errors, fromModule: .login)
                completionBlock(false, errors)
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue])
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
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
                ATErrorManager.default.logError(forCodes: errors, fromModule: .login)
                completionBlock(false, [""], errors)
            })
            
       }) { (error) in
        if error.code == AppNetworking.noInternetError.code {
            completionBlock(false, [""], [ATErrorManager.LocalError.noInternet.rawValue])
        }
        else {
            completionBlock(false, [""], [ATErrorManager.LocalError.requestTimeOut.rawValue])
        }
        }
    }
}

extension APICaller {

    func callFetchLinkedAccountsAPI( completionBlock: @escaping(_ success: Bool, _ accounts: [LinkedAccount], _ errorCodes: ErrorCodes)->Void ) {
        
        AppNetworking.GET(endPoint: .linkedAccounts, success: { [weak self] (data) in
            
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                let acc = LinkedAccount.fetchModelsForLinkedAccounts(data: jsonData[APIKeys.data.rawValue].dictionaryObject ?? [:])
                completionBlock(true, acc, [])
                
            }, failure: { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .login)
                completionBlock(false, [], errors)
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [], [ATErrorManager.LocalError.noInternet.rawValue])
            }
            else {
                completionBlock(false, [], [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
    
    func callDisconnectLinkedAccountsAPI(params: JSONDictionary, completionBlock: @escaping(_ success: Bool, _ errorCodes: ErrorCodes)->Void ) {
        
        AppNetworking.POST(endPoint: .unlinkSocialAccount, parameters: params, success: { [weak self] (data) in
            
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, [])
                
            }, failure: { (errors) in
                ATErrorManager.default.logError(forCodes: errors, fromModule: .login)
                completionBlock(false, errors)
            })
            
        }) { (error) in
            if error.code == AppNetworking.noInternetError.code {
                completionBlock(false, [ATErrorManager.LocalError.noInternet.rawValue])
            }
            else {
                completionBlock(false, [ATErrorManager.LocalError.requestTimeOut.rawValue])
            }
        }
    }
}
