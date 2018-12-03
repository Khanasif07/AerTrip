//
//  Strings.swift
//  
//
//  Created by Pramod Kumar on 04/08/17.
//  Copyright © 2017 Pramod Kumar. All rights reserved.
//

import Foundation

extension LocalizedString {
    var localized: String {
        return self.rawValue.localized
    }
}

enum LocalizedString: String {
    
    //MARK:- Strings For Profile Screen
    case NoInternet = "NoInternet"
    case ParsingError = "ParsingError"
    case error = "error"
}

