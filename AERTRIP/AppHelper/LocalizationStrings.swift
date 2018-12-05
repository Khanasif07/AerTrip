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
    
    // MARK:- SocialLoginVC
    //MARK:-
    case I_am_new_register  = "I_am_new_register"
    case Existing_User_Sign = "Existing_User_Sign"
    
    
}

