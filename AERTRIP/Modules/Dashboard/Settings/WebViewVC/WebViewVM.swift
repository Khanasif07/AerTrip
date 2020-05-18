//
//  WebViewVM.swift
//  AERTRIP
//
//  Created by Appinventiv on 02/04/20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import Foundation


class WebViewVM {
    
    enum WebViewType : String {
        case aboutUs = "About Us"
        case legal = "Legal"
        case privacypolicy = "Privacy Policy"
    }
    
    var webViewType = WebViewType.aboutUs
    
    
    func getUrlToLoad() -> String{
        
        switch webViewType{
            
            case .aboutUs: return APIEndPoint.about.rawValue
            
            case .legal: return APIEndPoint.legal.rawValue
            
            case .privacypolicy: return APIEndPoint.privacy.rawValue
                        
        }
        
    }
    
}
