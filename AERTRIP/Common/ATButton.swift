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
    
    var disabledShadowColor: UIColor = AppColors.clear {
        didSet {
            self.layoutSubviews()
        }
    }
    
    var gradientColors: [UIColor] = [AppColors.shadowBlue, AppColors.themeGreen] {
        didSet {
            self.layoutSubviews()
        }
    }
    
    var disabledGradientColors: [UIColor] = [AppColors.themeGray20, AppColors.themeGray20] {
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
        
        let shadowFrame = CGRect(x: 3.0, y: 0.0, width: bounds.width - 6.0, height: bounds.height)
        shadowLayer.path = UIBezierPath(roundedRect: shadowFrame, cornerRadius: self.cornerRadius).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        if self.isEnabled {
            
            shadowLayer.shadowColor = shadowColor.cgColor
            shadowLayer.shadowPath  = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 12.0)
            shadowLayer.shadowOpacity = 0.3
            shadowLayer.shadowRadius = 8.0
        } else {
            shadowLayer.shadowColor = UIColor.clear.cgColor
        }
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
        
        self.titleLabel?.font = AppFonts.SemiBold.withSize(15)
    }
    
    private func addRequiredAction() {
        self.addTarget(self, action: #selector(buttonPressed(_:)), for: UIControl.Event.touchDown)
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
        self.loaderIndicator.stopAnimating()
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self?.shadowLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(scaleX: 0.9, y: 0.8))
        }
        delay(seconds: 0.1) {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.transform = CGAffineTransform.identity
                self?.shadowLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform.identity)
            }
        }
    }
}
