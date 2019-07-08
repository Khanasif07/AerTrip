//
//  AppProtocols.swift
//  
//
//  Created by Pramod Kumar on 27/09/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

protocol Cloneable {
    func clone() -> Cloneable
}

protocol DataChanedProtocol {
    
    func dataUpdate(data: Any?) // to be followed in ViewModels to update the data when data changed revied
}
