//
//  ATButton.swift
//  AERTRIP
//
//  Created by Admin on 04/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class ATButton: UIButton {
    
    //MARK:- Properties
    //MARK:- Private
    private var shadowLayer: CAShapeLayer!
    private var gradientLayer: CAGradientLayer!
    private var loaderIndicator:UIActivityIndicatorView!
    private var titleDuringLoading: String = ""
    
    //MARK:- Public
    var shadowColor: UIColor = AppColors.themeGreen {
        didSet {
            self.layoutSubviews()
        }
    }
    
    var disabledShadowColor: UIColor = AppColors.themeGray60 {
        didSet {
            self.layoutSubviews()
        }
    }
    
    var gradientColors: [UIColor] = [AppColors.shadowBlue, AppColors.themeGreen] {
        didSet {
            self.layoutSubviews()
        }
    }
    
    var disabledGradientColors: [UIColor] = [AppColors.themeGray60, AppColors.themeGray04] {
        didSet {
            self.layoutSubviews()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            self.layoutSubviews()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            isLoading ? self.startLoading() : self.stopLoading()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addRequiredAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.addRequiredAction()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addShadowLayer()
        self.addGradientLayer()
        self.setupLoader()
    }
    
    private func addShadowLayer() {
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            layer.insertSublayer(shadowLayer, at: 0)
        }
        
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornerRadius).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        
        shadowLayer.shadowColor = self.isEnabled ? shadowColor.cgColor : disabledShadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 7.0)
        shadowLayer.shadowOpacity = 0.4
        shadowLayer.shadowRadius = 5.0
    }
    
    private func addGradientLayer() {
        if gradientLayer == nil {
            
            gradientLayer = CAGradientLayer()
            self.layer.insertSublayer(gradientLayer, at: 1)
        }
        
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        gradientLayer.cornerRadius = self.cornerRadius
        gradientLayer.masksToBounds = true
        
        if self.isEnabled {
            gradientLayer.colors = gradientColors.map { (clr) -> CGColor in
                clr.cgColor
            }
        }
        else {
            gradientLayer.colors = disabledGradientColors.map { (clr) -> CGColor in
                clr.cgColor
            }
        }
        
        self.titleLabel?.font = AppFonts.SemiBold.withSize(17)
    }
    
    private func addRequiredAction() {
        self.addTarget(self, action: #selector(buttonPressed(_:)), for: UIControl.Event.touchDown)
        self.addTarget(self, action: #selector(buttonReleased(_:)), for: UIControl.Event.touchUpInside)
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
        self.titleDuringLoading = self.currentTitle ?? ""
        self.setTitle(nil, for: UIControl.State.normal)
        self.loaderIndicator.startAnimating()
    }
    
    private func stopLoading() {
        self.setTitle(self.titleDuringLoading, for: UIControl.State.normal)
        self.titleDuringLoading = ""
        self.loaderIndicator.stopAnimating()
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }
    
    @objc private func buttonReleased(_ sender: UIButton) {
        self.transform = CGAffineTransform.identity
    }
}

