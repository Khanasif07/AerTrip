//
//  AppLoader.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 18/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

class __Loader : UIView {
    
    var activityIndicator : UIActivityIndicatorView!
    
    var isLoading = false
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        
        
        self.backgroundColor = UIColor(white: 0.0, alpha: 0.25)
        self.activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        self.activityIndicator.color = AppColors.themeGray60
        self.activityIndicator.backgroundColor = AppColors.themeGray20
        
        let innerView = UIView(frame: CGRect(x:0,y:0,width:130,height:50))
        
        innerView.addSubview(self.activityIndicator)
        self.activityIndicator.center = CGPoint(x: innerView.center.x, y:innerView.center.y)
        innerView.center = self.center
        
        //  innerView.center = CGPoint(x: frame.midX  , y: frame.midY )
        innerView.addSubview(self.activityIndicator)
        //   innerView.addSubview(lbl)
        
        self.addSubview(innerView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start(sender: UIWindow) {
        
        if self.isLoading { return }
        
        sender.addSubview(self)
        self.activityIndicator.startAnimating()
        
        self.isLoading = true
    }
    
    func stop() {
        
        self.activityIndicator.stopAnimating()
        self.removeFromSuperview()
        self.isLoading = false
    }
    
}
