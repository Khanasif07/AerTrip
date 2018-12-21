//
//  AppToast.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 12/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit
import TTGSnackbar

struct AppToast {
    
    static let `default` = AppToast()
    private init() {}
    
    func showToastMessage(message: String, vc: UIViewController) {
        
        let ob  = ToastView.instanceFromNib()
        
        ob.showToastMessage(message: message)
        let height = AppGlobals.lines(label: ob.messageLabel) * 25 + 20
        
        
//        let snackbar = TTGSnackbar(customContentView: ob, duration: .middle)
//        snackbar.backgroundColor = .clear
//        snackbar.frame = ob.frame
//        snackbar.show()
        ob.frame = CGRect(x: 10, y: UIScreen.main.bounds.height + CGFloat(height) , width: UIScreen.main.bounds.width - 20, height: CGFloat(height))
        vc.view.addSubview(ob)
        
        UIView.animate(withDuration: 0.5) {
            ob.frame = CGRect(x: 10, y: UIScreen.main.bounds.height - (ob.height + 20) , width: UIScreen.main.bounds.width - 20, height: CGFloat(height))
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            UIView.animate(withDuration: 0.5, animations: {
                ob.frame = CGRect(x:10, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 20, height: CGFloat(height))
            }) { (success) in
                ob.removeFromSuperview()
            }
        }
//        vc.view.showToast(ob)
    }
    

    
    func showToastMessageWithRightButtonTitle(vc: UIViewController, message: String, buttonTitle: String, delegate: ToastDelegate) {
        
        let ob  = ToastView.instanceFromNib()
        
        ob.delegate = delegate
        ob.showToastMessageWithRightButtonTitle(message: message, buttonTitle: buttonTitle)
        let height = AppGlobals.lines(label: ob.messageLabel) * 25 + 20
        ob.frame = CGRect(x: 10, y: UIScreen.main.bounds.height - (ob.height + 20) , width: UIScreen.main.bounds.width - 20, height: CGFloat(height))
        let snackbar = TTGSnackbar(customContentView: ob, duration: .middle)
        snackbar.backgroundColor = .clear
        snackbar.show()
//        vc.view.showToast(ob)
    }
    
    func showToastMessageWithRightButtonImage(vc: UIViewController, message: String, delegate: ToastDelegate) {
        
        let ob  = ToastView.instanceFromNib()
        
        ob.delegate = delegate
        ob.showToastMessageWithRightButtonImage(message: message)
        let height = AppGlobals.lines(label: ob.messageLabel) * 25 + 20
        ob.frame = CGRect(x: 10, y: UIScreen.main.bounds.height - (ob.height + 20) , width: UIScreen.main.bounds.width - 20, height: CGFloat(height))
        
        let snackbar = TTGSnackbar(customContentView: ob, duration: .middle)
        snackbar.backgroundColor = .clear
        snackbar.show()
//        vc.view.showToast(ob)
    }
}
