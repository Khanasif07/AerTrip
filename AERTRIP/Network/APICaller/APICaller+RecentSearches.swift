//
//  APICaller+RecentSearches.swift
//  AERTRIP
//
//  Created by Rishabh on 30/12/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation

extension APICaller {
    
    func updateFlightsRecentSearch(params: JSONDictionary, loader: Bool = false, completionBlock: @escaping(_ data: JSONDictionary?, _ errorCodes: ErrorCodes)->Void) {
        
        AppNetworking.POST(endPoint: .setRecentSearch, parameters: params, loader: loader) {[weak self] data in
            guard let self = self else {return}
            self.handleResponse(data) { (success, recentSearchData) in
                completionBlock(data[APIKeys.data.rawValue].dictionaryObject, [])
            } failure: { (errorCode) in
                completionBlock(nil, errorCode)
            }
        } failure: { (error) in
            
        }
    }
    
}
