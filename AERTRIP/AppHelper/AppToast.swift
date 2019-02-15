//
//  AppToast.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 12/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

struct AppToast {
    
    enum ButtonIcon {
        case cross
        
        var image: UIImage {
            switch self {
            case .cross:
                return #imageLiteral(resourceName: "ic_toast_cross").withRenderingMode(.alwaysOriginal)
            }
        }
        
    }
    
    static let `default` = AppToast()
    private init() {}
    static private var isPreviousView = false
    
    func showToastMessage(message: String, title: String = "", onViewController: UIViewController? = UIApplication.topViewController(), duration: Double = 3.0, buttonTitle: String = "", buttonImage: UIImage? = nil, buttonAction: (()->Void)? = nil) {
        
        if !AppToast.isPreviousView {
            
            AppToast.isPreviousView = true
            let ob  = ToastView.instanceFromNib()
            
            if message.lowercased() == LocalizedString.Deleted.localized.lowercased() {
                ob.setupToastForDelete(buttonAction: buttonAction)
            }
            else {
                ob.setupToastMessage(title: title, message: message, buttonTitle: buttonTitle, buttonImage: buttonImage, buttonAction: buttonAction)
            }
            let height = AppGlobals.lines(label: ob.messageLabel) * 25 + 20
            self.showToast(vc: onViewController!, ob: ob, height: height, duration: duration)
        }
    }
    
    private func showToast(vc: UIViewController, ob: UIView, height: Int, duration: Double) {
        
        vc.view.addSubview(ob)
        ob.frame  = CGRect(x: 10, y: UIScreen.main.bounds.height , width: UIScreen.main.bounds.width - 20, height: CGFloat(height))
        UIView.animate(withDuration: AppConstants.kAnimationDuration) {
            ob.frame = CGRect(x: 10, y: UIScreen.main.bounds.height - (CGFloat(height) + UIApplication.shared.statusBarFrame.height) , width: UIScreen.main.bounds.width - 20, height: CGFloat(height))
        }
        
        delay(seconds: duration) {
            UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
                ob.frame = CGRect(x: 10, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 20, height: CGFloat(height))
            }) { (success) in
                
                AppToast.isPreviousView = false
                ob.removeFromSuperview()
            }
        }
    }
}
