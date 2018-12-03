//
//  NSErrorExtension.swift
//
//  Created by Pramod Kumar on 04/04/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation

extension NSError {
    
    convenience init(localizedDescription : String) {
        
        self.init(domain: "AppNetworkingError", code: 0, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
    
    convenience init(code : Int, localizedDescription : String) {
        
        self.init(domain: "AppNetworkingError", code: code, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
    
    class func networkConnectionError(urlString: String) -> NSError{
        let errorUserInfo =
            [   NSLocalizedDescriptionKey : LocalizedString.NoInternet.localized,
                NSURLErrorFailingURLErrorKey : "\(urlString)"
        ]
        return NSError(domain: NSCocoaErrorDomain, code: AppErrorCodeFor.noInternet, userInfo:errorUserInfo)
    }
    
    class func jsonParsingError(urlString: String) -> NSError{
        let errorUserInfo =
            [   NSLocalizedDescriptionKey : "Error In Parsing JSON",
                NSURLErrorFailingURLErrorKey : "\(urlString)"
        ]
        return NSError(domain: NSCocoaErrorDomain, code: AppErrorCodeFor.parsing, userInfo:errorUserInfo)
    }
}
