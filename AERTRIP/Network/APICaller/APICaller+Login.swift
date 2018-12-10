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
    func callActiveUserAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ message: String)->Void ) {
        
        AppNetworking.GET(endPoint: APIEndPoint.isActiveUser, parameters: params, loader: loader, success: { [weak self] (data) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, jsonData[""].stringValue)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription)
        }
    }
    
    //MARK: - Api for login user
    //MARK: -
    func callLoginAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ message: String)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.login, parameters: params, loader: loader, success: { [weak self] (data) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, jsonData[""].stringValue)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription)
        }
    }
    
    //MARK: - Api for Social login
    //MARK: -
    func callSocialLoginAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ message: String)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.socialLogin, parameters: params, loader: loader, success: { [weak self] (data) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, jsonData[""].stringValue)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription)
        }
    }
    
    //MARK: - Api for Register
    //MARK: -
    func callRegisterNewUserAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ message: String)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.register, parameters: params, loader: loader, success: { [weak self] (data) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, jsonData[""].stringValue)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription)
        }
    }
    
    //MARK: - Api for ForgotPassword
    //MARK: -
    func callForgotPasswordAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ message: String)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.forgotPassword, parameters: params, loader: loader, success: { [weak self] (data) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, jsonData[""].stringValue)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription)
        }
    }
    
    //MARK: - Api for UpdatePassword
    //MARK: -
    func callUpdatePasswordAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ message: String)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.updateUserPassword, parameters: params, loader: loader, success: { [weak self] (data) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, jsonData[""].stringValue)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription)
        }
    }
    
    //MARK: - Api for Update UserDetail
    //MARK: -
    func callUpdateUserDetailAPI(params: JSONDictionary, loader: Bool = true, completionBlock: @escaping(_ success: Bool, _ message: String)->Void ) {
        
        AppNetworking.POST(endPoint: APIEndPoint.updateUserDetail, parameters: params, loader: loader, success: { [weak self] (data) in
            guard let sSelf = self else {return}
            
            sSelf.handleResponse(data, success: { (sucess, jsonData) in
                completionBlock(true, jsonData[""].stringValue)
                
            }, failure: { (error) in
                completionBlock(false, error.localizedDescription)
            })
            
        }) { (error) in
            completionBlock(false, error.localizedDescription)
        }
    }
}
