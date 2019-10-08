//
//  UIPickerViewExtension.swift
//  AERTRIP
//
//  Created by Apple on 01/10/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

//MARK:- UIPickerView Extension
extension UIPickerView {
    
    static var pickerSize: CGSize {
        var bottomSafeArea: CGFloat = 0
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.keyWindow {
                bottomSafeArea = window.safeAreaInsets.bottom
            }
        }
        return CGSize(width: UIScreen.main.bounds.size.width, height: 216.0 + bottomSafeArea)
    }
}
