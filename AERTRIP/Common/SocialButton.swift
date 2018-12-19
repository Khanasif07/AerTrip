//
//  SocialButton.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 18/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import Foundation
import UIKit

class SocialButton: UIButton {
    
    //MARK:- Properties
    //MARK:- Private
    private var loaderIndicator: UIActivityIndicatorView!
    private var titleDuringLoading: String = ""
    
    var isLoading: Bool = false {
        didSet {
            isLoading ? self.startLoading() : self.stopLoading()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.setupLoader()
    }
    
    private func setupLoader() {
        if self.loaderIndicator == nil {
            let size = min(self.frame.size.width, self.frame.size.height)
            self.loaderIndicator = UIActivityIndicatorView(frame: CGRect(x: (self.frame.size.width - size) / 2.0, y: 0.0, width: size, height: size))
            self.loaderIndicator.style = .white
            
            self.addSubview(self.loaderIndicator)
        }
        self.loaderIndicator.hidesWhenStopped = true
        self.loaderIndicator.color = self.titleLabel?.textColor ?? AppColors.themeWhite
    }
    
    private func startLoading() {
        self.titleDuringLoading = self.titleLabel?.text ?? ""
        self.setTitle(nil, for: UIControl.State.normal)
        self.loaderIndicator.startAnimating()
        self.isUserInteractionEnabled = false
    }
    
    private func stopLoading() {
        self.isUserInteractionEnabled = true
        self.setTitle(self.titleDuringLoading, for: UIControl.State.normal)
        //        self.titleDuringLoading = ""
        self.loaderIndicator.stopAnimating()
    }
}
