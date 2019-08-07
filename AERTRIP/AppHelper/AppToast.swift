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
    
    static var `default` = AppToast()
    private init() {}
    static private var isPreviousView = false
    private let spaceFromBottom: CGFloat = 10.0
    
    private var toastHeight: CGFloat = 0.0
    private var toastDidClose: (()->Void)? = nil
    private var parentViewController: UIViewController?
    
    let tagAsSubview: Int = 5932
    
    mutating func showToastMessage(message: String, title: String = "", onViewController: UIViewController? = UIApplication.topViewController(), duration: Double = 3.0, buttonTitle: String = "", buttonImage: UIImage? = nil,spaceFromBottom: CGFloat = 10.0, buttonAction: (()->Void)? = nil,toastDidClose: (()->Void)? = nil) {
        
        if !AppToast.isPreviousView, !message.isEmpty {
            
            self.parentViewController = onViewController
            self.toastDidClose = toastDidClose
            
            AppToast.isPreviousView = true
            let ob  = ToastView.instanceFromNib()
            
            ob.tag = tagAsSubview
            ob.buttonAction = buttonAction
            if message.lowercased() == LocalizedString.Deleted.localized.lowercased() {
                ob.setupToastForDelete(buttonAction: buttonAction)
            }
            else {
                ob.setupToastMessage(title: title, message: message, buttonTitle: buttonTitle, buttonImage: buttonImage, buttonAction: buttonAction)
            }
            
            let lines = AppGlobals.lines(label: ob.messageLabel)
            self.toastHeight = CGFloat(lines * 25 + 20)
            let maxW: CGFloat = UIDevice.screenWidth - 20.0
            var width: CGFloat = maxW
            
            if lines <= 1 {
                let tempW = message.sizeCount(withFont: ob.messageLabel.font, bundingSize: CGSize(width: 10000.0, height: self.toastHeight)).width + 42.0
                width = max(45.0, tempW)
            }
            width = min(width, maxW)
            
            let newX: CGFloat = max(((maxW - width) / 2.0), 10.0)
            
            let rect = CGRect(x: newX, y: UIScreen.main.bounds.height - (self.toastHeight + AppFlowManager.default.safeAreaInsets.bottom + spaceFromBottom) , width: width, height: self.toastHeight)
            
            self.showToast(vc: onViewController!, ob: ob, toastFrame: rect, duration: duration, spaceFromBottom: spaceFromBottom,toastDidClose: toastDidClose)
        }
    }
    
    private func showToast(vc: UIViewController, ob: UIView, toastFrame: CGRect, duration: Double,spaceFromBottom: CGFloat,toastDidClose: (()->Void)? = nil) {
        ob.frame = toastFrame
        ob.frame.origin.y = UIScreen.main.bounds.height

        vc.view.addSubview(ob)
        
        UIView.animate(withDuration: AppConstants.kAnimationDuration) {
            ob.frame = toastFrame
            vc.view.layoutIfNeeded()
        }
        delay(seconds: duration) {
            self.hideToast(vc, animated: true)
        }
    }
    
    func hideToast(_ fromViewController: UIViewController?, animated: Bool) {
        
        let parent = fromViewController ?? self.parentViewController
        guard let vc = parent, let ob = vc.view.subView(withTag: self.tagAsSubview) else { return }
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        if animated {
            UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
                ob.frame.origin.y = UIScreen.main.bounds.height//CGRect(x: 10, y: UIScreen.main.bounds.height, width: UIDevice.screenWidth - 20, height: self.toastHeight)
            }) { (success) in
                if let handel = self.toastDidClose {
                    handel()
                }
                AppToast.isPreviousView = false
                ob.removeFromSuperview()
            }
        }
        else {
            AppToast.isPreviousView = false
            ob.frame.origin.y = UIScreen.main.bounds.height
            if let handel = self.toastDidClose {
                handel()
            }
            ob.removeFromSuperview()
        }
    }
}
