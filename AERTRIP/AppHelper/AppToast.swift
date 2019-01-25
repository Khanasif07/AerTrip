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
    
    static let `default` = AppToast()
    private init() {}
    static private var isPreviousView = false
    
    func showToastMessage(message: String, vc: UIViewController? = UIApplication.topViewController()) {
        
        if !AppToast.isPreviousView {
            
            AppToast.isPreviousView = true
            let ob  = ToastView.instanceFromNib()
            
            ob.showToastMessage(message: message)
            let height = AppGlobals.lines(label: ob.messageLabel) * 25 + 20
            self.showToast(vc: vc!, ob: ob, height: height)
        }
    }
    
    
    
    func showToastMessageWithRightButtonTitle(vc: UIViewController? = UIApplication.topViewController(), message: String, buttonTitle: String, delegate: ToastDelegate) {
        
        if !AppToast.isPreviousView {
            
            AppToast.isPreviousView = true
            let ob  = ToastView.instanceFromNib()
            
            ob.delegate = delegate
            ob.showToastMessageWithRightButtonTitle(message: message, buttonTitle: buttonTitle)
            let height = AppGlobals.lines(label: ob.messageLabel) * 25 + 20
            self.showToast(vc: vc!, ob: ob, height: height)
        }
    }
    
    func showToastMessageWithRightButtonImage(vc: UIViewController? = UIApplication.topViewController(), message: String, delegate: ToastDelegate) {
        
        if !AppToast.isPreviousView {
            
            AppToast.isPreviousView = true
            let ob  = ToastView.instanceFromNib()
            
            ob.delegate = delegate
            ob.showToastMessageWithRightButtonImage(message: message)
            let height = AppGlobals.lines(label: ob.messageLabel) * 25 + 20
            self.showToast(vc: vc!, ob: ob, height: height)
        }
    }
    
    func showToast(vc: UIViewController, ob: UIView, height: Int) {
        
        vc.view.addSubview(ob)
        ob.frame  = CGRect(x: 10, y: UIScreen.main.bounds.height , width: UIScreen.main.bounds.width - 20, height: CGFloat(height))
        UIView.animate(withDuration: AppConstants.kAnimationDuration) {
            ob.frame = CGRect(x: 10, y: UIScreen.main.bounds.height - (CGFloat(height) + 20) , width: UIScreen.main.bounds.width - 20, height: CGFloat(height))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
                ob.frame = CGRect(x: 10, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 20, height: CGFloat(height))
            }) { (success) in
                
                AppToast.isPreviousView = false
                ob.removeFromSuperview()
            }
        }
    }
}
