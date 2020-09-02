//
//  AppToast.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 12/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

class AppToast: NSObject {
    
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
    private override init() {}
    static private var isPreviousView = false
    private let spaceFromBottom: CGFloat = 10.0
    
    private var toastHeight: CGFloat = 0.0
    private var toastDidClose: (()->Void)? = nil
    private var parentViewController: UIViewController?
    private var buttonAction: (()->Void)? = nil

    
    let tagAsSubview: Int = 5932
    
     func showToastMessage(message: String, title: String = "", onViewController: UIViewController? = UIApplication.topViewController(), duration: Double = 3.0, buttonTitle: String = "",spaceFromBottom: CGFloat = 10.0, buttonAction: (()->Void)? = nil,toastDidClose: (()->Void)? = nil) {
        
        CustomToast.shared.showToast(message)
        return
        
        if !AppToast.isPreviousView, !message.isEmpty {

            self.toastDidClose = toastDidClose
            self.buttonAction = buttonAction
            if let view = onViewController?.view {
                if buttonTitle.isEmpty {
                    self.hideToast(onViewController, animated: true)
                    //Gurpreet
                    delay(seconds: 0.3) {
                        AertripToastView.toast(in: view, withText: message)
                    }
                } else {
                    self.parentViewController = onViewController
                    AertripToastView.toast(in: view, withText: message, buttonTitle: buttonTitle, delegate: self)
                }
            }
            
//            AppToast.isPreviousView = true
//            let ob  = ToastView.instanceFromNib()
//
//            ob.tag = tagAsSubview
//            ob.buttonAction = buttonAction
//            if message.lowercased() == LocalizedString.Deleted.localized.lowercased() {
//                ob.setupToastForDelete(buttonAction: buttonAction)
//            }
//            else {
//                ob.setupToastMessage(title: title, message: message, buttonTitle: buttonTitle, buttonImage: buttonImage, buttonAction: buttonAction)
//            }
//
//            let lines = AppGlobals.lines(label: ob.messageLabel)
//            self.toastHeight = CGFloat(lines * 25 + 20)
//            let maxW: CGFloat = UIDevice.screenWidth - 20.0
//            var width: CGFloat = maxW
//
//            // uncomment below code,if you want to use toast view based on string
////            if lines <= 1 {
////                let tempW = message.sizeCount(withFont: ob.messageLabel.font, bundingSize: CGSize(width: 10000.0, height: self.toastHeight - 20)).width + 42.0
////                width = max(45.0, tempW)
////            }
//            width = min(width, maxW)
//
//            let newX: CGFloat = max(((maxW - width) / 2.0), 10.0)
//
//            let rect = CGRect(x: newX, y: UIScreen.main.bounds.height - (self.toastHeight + AppFlowManager.default.safeAreaInsets.bottom + spaceFromBottom) , width: width, height: self.toastHeight)
//
//            self.showToast(vc: onViewController!, ob: ob, toastFrame: rect, duration: duration, spaceFromBottom: spaceFromBottom, toastDidClose: toastDidClose)
        }
    }
    
//    private func showToast(vc: UIViewController, ob: UIView, toastFrame: CGRect, duration: Double,spaceFromBottom: CGFloat,toastDidClose: (()->Void)? = nil) {
//
//        func finalCall() {
//            ob.frame = toastFrame
//            ob.frame.origin.y = UIScreen.main.bounds.height
//
//            vc.view.addSubview(ob)
//            ob.frame = toastFrame
//            UIView.animate(withDuration: AppConstants.kAnimationDuration) {
//                ob.frame = toastFrame
//                vc.view.layoutIfNeeded()
//            }
//            delay(seconds: duration) {
//                self.hideToast(vc, animated: true)
//            }
//        }
//
//        if let mainHomeVc = UIApplication.topViewController() as? MainHomeVC, let dashboardVC = mainHomeVc.sideMenuController?.mainViewController as? DashboardVC, !dashboardVC.overlayView.isHidden {
//            delay(seconds: 1.0) {
//                finalCall()
//            }
//        }
//        else {
//            finalCall()
//        }
//    }
    
    func hideToast(_ fromViewController: UIViewController?, animated: Bool) {
        
        let parent = fromViewController ?? self.parentViewController
        
        if let view = parent?.view {
            AertripToastView.hideToast(in: view)
        }
        
        
        /*
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
 */
    }
}

extension AppToast: AertripToastViewDelegate {
    
    func buttonTapped() {
        if let handler = self.buttonAction {
            handler()
        }
        self.buttonAction = nil
        self.parentViewController = nil
    }
    
    func toastRemoved() {
        if let handler = self.toastDidClose {
            handler()
        }
        self.toastDidClose = nil
        self.parentViewController = nil
    }
}

