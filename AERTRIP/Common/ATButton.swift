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
    private var loaderContainer:UIView!
    private var loaderIndicator:UIActivityIndicatorView!
    private var loaderGradientLayer: CAGradientLayer!
    
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
    
    var isSocial: Bool = false {
        didSet {
            self.layoutSubviews()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            isLoading ? self.startLoading() : self.stopLoading()
        }
    }
    
    var myCornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = self.myCornerRadius
            self.addShadowLayer()
            self.addGradientLayer()
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
        
        self.titleLabel?.font = AppFonts.SemiBold.withSize(15)
        self.addShadowLayer()
        self.addGradientLayer()
        self.setupLoader()
    }
    
    private func addShadowLayer() {
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            layer.insertSublayer(shadowLayer, at: 0)
        }
        
        let shadowFrame = self.isSocial ? self.bounds : CGRect(x: 3.0, y: 0.0, width: bounds.width - 6.0, height: bounds.height)
        shadowLayer.path = UIBezierPath(roundedRect: shadowFrame, cornerRadius: self.cornerRadius).cgPath
        shadowLayer.fillColor = AppColors.clear.cgColor
        if self.isEnabled {
            
            shadowLayer.shadowColor = shadowColor.cgColor
            shadowLayer.shadowPath  = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: self.isSocial ? 1.0 : 12.0)
            shadowLayer.shadowOpacity = self.isSocial ? 0.2 : 0.5
            shadowLayer.shadowRadius = self.isSocial ? 2.0 : 15.0
        } else {
            shadowLayer.shadowColor = AppColors.clear.cgColor
            shadowLayer.shadowOffset = CGSize.zero
            shadowLayer.shadowOpacity = 0.0
            shadowLayer.shadowRadius = 0.0
        }
    }
    
    private func getGradientLayer() -> CAGradientLayer {
        
        let gLayer = CAGradientLayer()
        
        self.updateGradientLayer(gLayer: gLayer)
        
        return gLayer
    }
    
    private func updateGradientLayer(gLayer: CAGradientLayer) {
        gLayer.frame = self.bounds
        gLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        gLayer.cornerRadius = self.cornerRadius
        gLayer.masksToBounds = true
        
        if self.isEnabled {
            gLayer.colors = gradientColors.map { (clr) -> CGColor in
                clr.cgColor
            }
        }
        else {
            gLayer.colors = disabledGradientColors.map { (clr) -> CGColor in
                clr.cgColor
            }
        }
    }
    
    private func addGradientLayer() {
        if gradientLayer == nil {
            
            gradientLayer = CAGradientLayer()
            self.layer.insertSublayer(gradientLayer, at: 1)
        }
        
        self.updateGradientLayer(gLayer: self.gradientLayer)
    }
    
    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        super.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        super.setImage(image?.withRenderingMode(.alwaysOriginal), for: .highlighted)
        self.bringSubviewToFront(self.imageView!)
    }
    
    override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        super.setTitleColor(color, for: .normal)
        super.setTitleColor(color, for: .highlighted)
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: .normal)
        super.setTitle(title, for: .highlighted)
    }
    
    private func addRequiredAction() {
        self.adjustsImageWhenHighlighted = false
        
        self.addTarget(self, action: #selector(buttonPressed(_:)), for: UIControl.Event.touchDown)
        self.addTarget(self, action: #selector(buttonReleased(_:)), for: UIControl.Event.touchUpInside)
        self.addTarget(self, action: #selector(buttonReleased(_:)), for: UIControl.Event.touchUpOutside)
    }
    
    private func setupLoader() {
        if self.loaderIndicator == nil {
            
            self.loaderContainer = UIView(frame: self.bounds)
            self.loaderContainer.isUserInteractionEnabled = false
            self.loaderContainer.isHidden = true
            self.loaderGradientLayer = self.getGradientLayer()
            self.loaderContainer.layer.addSublayer(self.loaderGradientLayer)
            
            let size = min(self.frame.size.width, self.frame.size.height)
            self.loaderIndicator = UIActivityIndicatorView(frame: CGRect(x: (self.frame.size.width - size) / 2.0, y: 0.0, width: size, height: size))
            self.loaderIndicator.style = .white
            
            self.loaderContainer.addSubview(self.loaderIndicator)
            self.addSubview(self.loaderContainer)
        }
        
        self.loaderContainer.layer.cornerRadius = self.cornerRadius
        self.loaderContainer.layer.masksToBounds = true
        self.updateGradientLayer(gLayer: self.loaderGradientLayer)
        
        self.loaderIndicator.hidesWhenStopped = true
        
        self.loaderIndicator.color = AppColors.themeGray40
        if let clr = self.titleLabel?.textColor {
            self.loaderIndicator.color = (clr == AppColors.themeBlack) ? AppColors.themeGray40 : AppColors.themeWhite
        }
    }
    
    private func startLoading() {
        self.loaderContainer.isHidden = false
        self.loaderIndicator.startAnimating()
        self.isUserInteractionEnabled = false
        self.bringSubviewToFront(self.loaderContainer)
    }
    
    private func stopLoading() {
        self.loaderContainer.isHidden = true
        self.isUserInteractionEnabled = true
        self.loaderIndicator.stopAnimating()
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: AppConstants.kAnimationDuration / 2.0) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self?.shadowLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(scaleX: 0.9, y: 0.8))
        }
    }
    
    @objc private func buttonReleased(_ sender: UIButton) {
        UIView.animate(withDuration: AppConstants.kAnimationDuration / 2.0) { [weak self] in
            self?.transform = CGAffineTransform.identity
            self?.shadowLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform.identity)
        }
    }
}
