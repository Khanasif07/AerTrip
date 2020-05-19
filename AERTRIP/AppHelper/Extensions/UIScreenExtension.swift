//
//  UIScreenExtension.swift
//  Aertrip
//
//  Created by Apple  on 17.04.20.
//  Copyright © 2020 Aertrip. All rights reserved.
//

import Foundation
import UIKit
 
extension UIScreen{
    
    static var size: CGSize{
        UIScreen.main.bounds.size
    }
    
    static var width:CGFloat{
        UIScreen.main.bounds.width
    }
    
    static var height:CGFloat{
        UIScreen.main.bounds.height
    }
    
}
