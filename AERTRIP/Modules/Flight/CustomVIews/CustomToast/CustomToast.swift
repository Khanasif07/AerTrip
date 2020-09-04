//
//  CustomToast.swift
//  Rish
//
//  Created by Rishabh on 02/09/20.
//  Copyright © 2020 Rishabh. All rights reserved.
//

import UIKit

@objc open class CustomToast: NSObject {
    
    ///to keep a single instance throughout the application
    @objc static let shared = CustomToast()
        
    /// adds animated toast over the window
    /// - Parameter msg: Message to be displayed within the toast
    @objc func showToast(_ msg: String) {
        guard let window = AppDelegate.shared.window else { return }
        
        fadeAllToasts()
        let toastView = CustomToastView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 100, width: UIScreen.main.bounds.width, height: 100))
        toastView.toastLbl.text = msg
        toastView.transform = CGAffineTransform(translationX: 0, y: 100)
        window.addSubview(toastView)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            toastView.transform = .identity
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.hideToast(toastView)
        }
    }
    
    /// hides all existing toasts with fade animation
    func fadeAllToasts() {
        guard let window = AppDelegate.shared.window else { return }
        func fade(_ subView: CustomToastView) {
            UIView.animate(withDuration: 0.3, animations: {
                subView.alpha = 0
            }) { (_) in
                subView.removeFromSuperview()
            }
        }
        window.subviews.forEach { (subView) in
            if let subview = subView as? CustomToastView {
                fade(subview)
            }
        }
    }
    
    /// Hides toast with bottom animation
    /// - Parameter toastView: pass the view to hide
    func hideToast(_ toastView: CustomToastView?) {
        if let subView = toastView {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                subView.transform = CGAffineTransform(translationX: 0, y: 100)
            }) { (_) in
                subView.removeFromSuperview()
            }
        }
    }
    
}

class CustomToastView: UIView {
    
    // MARK: IBOutlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var toastView: UIView!
    @IBOutlet weak var toastLbl: UILabel!
    
    // MARK: View Life Cycle
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    //Mark:- Function
    //===============
    private func commonInit() {
        //.InitialSetUp
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomToastView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        self.setupViews()
    }
    
    private func setupViews() {
        toastView.layer.cornerRadius = 10
        toastView.clipsToBounds = true
        toastLbl.font = AppFonts.Regular.withSize(16)
    }
    
    // MARK: IBActions
    @IBAction func dismissBtnAction(_ sender: Any) {
        CustomToast.shared.hideToast(self)
    }
}
