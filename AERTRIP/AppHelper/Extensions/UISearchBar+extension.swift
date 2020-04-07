//
//  UISearchBar+extension.swift
//  AERTRIP
//
//  Created by Appinventiv on 11/10/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import Foundation

extension UISearchBar {
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
 
    func setTextField(color: UIColor) {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }
    
    
    func setBookMarkButton(width : CGFloat, height : CGFloat){
         let searchBarView = subviews[0]
        
        for subView in self.subviews[0].subviews{
            if subView.isKind(of: UITextField.self){
                let rightView = (subView as? UITextField)?.rightView
                rightView?.subviews
            }
        }
        
//        for i in 0..<self.subviews.count{
//            if searchBarView.subviews[i].isKind(of: UITextField.self) {
//                for subView in searchBarView.subviews[i].subviews{
//                    if let button = subView as? UIButton{
//                        button.frame = CGRect(x: 10, y: 0, width: width, height: height)
//                        button.backgroundColor = UIColor.green
//                        button.isHidden = true
//                    }
//                }
//            }
//        }
    }
}
