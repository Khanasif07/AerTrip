//
//  ATButton.swift
//  AERTRIP
//
//  Created by Admin on 04/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

@objc class ATButton: UIButton {
    
    enum ActionState {
        case pressing
        case pressed
        case releasing
        case released
    }
    //MARK:- Properties
    //MARK:- Private
    private var shadowLayer: CAShapeLayer!
    private var gradientLayer: CAGradientLayer!
    private var loaderContainer:UIView!
    private var loaderIndicator:UIActivityIndicatorView!
    private var loaderGradientLayer: CAGradientLayer!
    
    private var _selectedFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    private var _normalFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    private var _highlightedFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    
    private var isFingerUp: Bool = false
    private(set) var currentActionState: ActionState = ActionState.released
    
    //MARK:- Public
    var shadowColor: UIColor = AppColors.themeBlack.withAlphaComponent(0.16) {
        didSet {
            self.layoutSubviews()
        }
    }
    
    var disabledShadowColor: UIColor = AppColors.clear {
        didSet {
            self.layoutSubviews()
        }
    }
    
    var gradientColors: [UIColor] = AppConstants.appthemeGradientColors {
        didSet {
            self.layoutSubviews()
        }
    }
    
    var disabledGradientColors: [UIColor] = AppConstants.appthemeDisableGradientColors {
        didSet {
            self.layoutSubviews()
        }
    }
    
    var shouldShowPressAnimation: Bool = true
    

    override var isEnabled: Bool {
        didSet {
            self.layoutSubviews()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            setFotAsState()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            setFotAsState()
        }
    }
    
    var isEnabledShadow: Bool = false {
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
            if !self.isSocial {
                 self.addShadowLayer()
            }
            self.addGradientLayer()
        }
    }
    var isShadowColorNeeded = false
    var fontForTitle: UIFont = AppFonts.SemiBold.withSize(17.0) {
        didSet {
            self.titleLabel?.font = fontForTitle
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
        
        if !self.isSocial {
          self.addShadowLayer()
        }
        self.addGradientLayer()
        self.setupLoader()
    }
    
    private func addShadowLayer() {
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            layer.insertSublayer(shadowLayer, at: 0)
        }
        
        let shadowFrame = self.isSocial ? CGRect(x: 0.0, y:1.0, width: bounds.width, height: bounds.height) : CGRect(x: 3.0, y: 0.0, width: bounds.width - 6.0, height: bounds.height)
        shadowLayer.path = UIBezierPath(roundedRect: shadowFrame, cornerRadius: self.cornerradius).cgPath
        shadowLayer.fillColor = AppColors.clear.cgColor
        if self.isEnabled {
            if isEnabledShadow {
                shadowLayer.shadowColor = AppShadowProperties().shadowColor.cgColor//AppColors.clear.cgColor
                shadowLayer.shadowOffset = CGSize.zero
                shadowLayer.shadowOpacity = 0.0
                shadowLayer.shadowRadius = 0.0
            } else {
                shadowLayer.shadowColor = (!isShadowColorNeeded) ? AppShadowProperties().shadowColor.cgColor : shadowColor.cgColor//shadowColor.cgColor
            shadowLayer.shadowPath  = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: self.isSocial ? 2.0 : 12.0)
            shadowLayer.shadowOpacity = self.isSocial ? 0.16 : 0.5
            shadowLayer.shadowRadius = self.isSocial ? 3.0 : 15.0
            }
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
    
    private func setFotAsState() {
        if state == .selected {
            self.titleLabel?.font = _selectedFont
        }
        else if state == .highlighted {
            self.titleLabel?.font = _highlightedFont
        }
        else {
            self.titleLabel?.font = _normalFont
        }
    }
    
    private func updateGradientLayer(gLayer: CAGradientLayer) {
        gLayer.frame = self.bounds
        gLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        gLayer.cornerRadius = self.cornerradius
        gLayer.masksToBounds = true
        
        if self.isEnabled {
            if isEnabledShadow {
                gLayer.colors = disabledGradientColors.map { (clr) -> CGColor in
                    clr.cgColor
                }
            } else {
                gLayer.colors = gradientColors.map { (clr) -> CGColor in
                    clr.cgColor
                }
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
        if !self.isLoading, self.imageView != nil {
            self.bringSubviewToFront(self.imageView!)
        }
    }
    
    override func setTitleColor(_ color: UIColor?, for state: UIControl.State) {
        super.setTitleColor(color, for: .normal)
        super.setTitleColor(color, for: .highlighted)
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: .normal)
        super.setTitle(title, for: .highlighted)
    }
    
    override func setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State) {
        super.setAttributedTitle(title, for: .normal)
        super.setAttributedTitle(title, for: .highlighted)
    }
    
    private func initialSetup() {
        fontForTitle = AppFonts.SemiBold.withSize(17.0)
        addRequiredAction()
    }
    
    private func addRequiredAction() {
        self.adjustsImageWhenHighlighted = false
        self.isMultipleTouchEnabled = false
        self.addTarget(self, action: #selector(buttonPressed(_:)), for: UIControl.Event.touchDown)
        self.addTarget(self, action: #selector(buttonReleased(_:)), for: UIControl.Event.touchUpInside)
        self.addTarget(self, action: #selector(buttonReleased(_:)), for: UIControl.Event.touchUpOutside)
        self.addTarget(self, action: #selector(buttonReleased(_:)), for: .touchCancel)
    }
    
    private func setupLoader() {
        if self.loaderIndicator == nil {
            
            self.loaderContainer = UIView(frame: self.bounds)
            self.loaderContainer.isUserInteractionEnabled = false
            self.loaderContainer.isHidden = true
            self.loaderGradientLayer = self.getGradientLayer()
            self.loaderContainer.layer.addSublayer(self.loaderGradientLayer)
            self.loaderContainer.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            let size = min(self.frame.size.width, self.frame.size.height)
            self.loaderIndicator = UIActivityIndicatorView(frame: CGRect(x: (self.frame.size.width - size) / 2.0, y: 0.0, width: size, height: size))
            self.loaderIndicator.style = .medium//.white
            
            self.loaderContainer.addSubview(self.loaderIndicator)
            self.addSubview(self.loaderContainer)
        }else{
            self.loaderContainer.frame = self.bounds
              let size = min(self.frame.size.width, self.frame.size.height)
            loaderIndicator.frame = CGRect(x: (self.frame.size.width - size) / 2.0, y: 0.0, width: size, height: size)
//            self.loaderContainer.center = self.center
//            loaderIndicator.center = self.loaderContainer.center
        }
        
        self.loaderContainer.layer.cornerRadius = self.cornerradius
        self.loaderContainer.layer.masksToBounds = true
        self.updateGradientLayer(gLayer: self.loaderGradientLayer)
        
        self.loaderIndicator.hidesWhenStopped = true
        
        self.loaderIndicator.color = AppColors.themeGray40
        self.setLoaderColor()
    }
    
    private func setLoaderColor() {
        if let clr = self.titleLabel?.textColor {
            self.loaderIndicator.color = (clr == AppColors.themeBlack) ? AppColors.themeGray40 : clr
        }
    }
    
    private func startLoading() {
        self.setLoaderColor()
        self.loaderContainer.isHidden = false
        self.loaderIndicator.isHidden = false
        self.loaderIndicator.startAnimating()
        self.isUserInteractionEnabled = false
        self.loaderIndicator.center = self.loaderContainer.center
        self.bringSubviewToFront(self.loaderContainer)
        if let imageView = self.imageView {
            self.sendSubviewToBack(imageView)
        }
    }
    
    private func stopLoading() {
        self.loaderContainer.isHidden = true
        self.isUserInteractionEnabled = true
        self.loaderIndicator.stopAnimating()
        if let imageView = self.imageView {
            self.bringSubviewToFront(imageView)
        }
    }
    
    // decreased animation duration so that there  is  feel of pressed and released state .
    
    private func animateToPressedSatate() {
        disable(forSeconds: 1)
        guard self.shouldShowPressAnimation else {return}
        //AppConstants.kAnimationDuration / 3.5
        UIView.animate(withDuration: 0, animations: { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            self?.shadowLayer?.transform = CATransform3DMakeAffineTransform(CGAffineTransform(scaleX: 0.9, y: 0.8))
        }) { (isDone) in
            if self.currentActionState == .releasing {
                self.currentActionState = .pressed
                self.animateToReleasedSatate()
            }
            else {
                self.currentActionState = .pressed
            }
        }
    }
    
    @objc private func animateToReleasedSatate() {
        guard self.shouldShowPressAnimation, (self.currentActionState == .pressed) || self.isFingerUp else {return}
        UIView.animate(withDuration: AppConstants.kAnimationDuration / 3.5, animations: { [weak self] in
            self?.transform = CGAffineTransform.identity
            self?.shadowLayer?.transform = CATransform3DMakeAffineTransform(CGAffineTransform.identity)
        }) { (isDone) in
            self.currentActionState = .released
            self.isFingerUp = false
        }
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        self.currentActionState = .pressing
        self.animateToPressedSatate()
        
        delay(seconds: 0.3) { [weak self] in
            guard let sSelf = self, sSelf.isFingerUp else {return}
            sSelf.currentActionState = .pressed
            sSelf.animateToReleasedSatate()
        }
    }
    
    @objc private func buttonReleased(_ sender: UIButton) {
        
        self.isFingerUp = self.currentActionState == .pressed
        self.currentActionState = .releasing
        self.animateToReleasedSatate()
    }
    
    func setTitleFont(font: UIFont, for state: UIControl.State) {
        if state == .normal {
            _normalFont = font
            self.titleLabel?.font = font
        }
        else if state == .highlighted {
            _highlightedFont = font
        }
        else {
            _selectedFont = font
        }
    }
    
    
     @objc func configureCommonGreenButton() {
       
        self.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .normal)
        self.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .selected)
        self.setTitleFont(font: AppFonts.SemiBold.withSize(17.0), for: .highlighted)
        
        self.setTitleColor(AppColors.whiteColorForButton, for: UIControl.State.normal)
        self.setTitleColor(AppColors.whiteColorForButton, for: UIControl.State.selected)
        self.setTitleColor(AppColors.whiteColorForButton, for: UIControl.State.highlighted)

        self.shadowColor = AppColors.themeBlack.withAlphaComponent(0.16)
        
        self.layer.cornerRadius = self.height / 2
        self.layer.applySketchShadow(color: AppColors.themeBlack, alpha: 0.16, x: 0, y: 2, blur: 6, spread: 0)
        self.shadowColor = AppColors.themeBlack.withAlphaComponent(0.16)
        
    }
    
    
}




//MARK:- ATBlurButton
class ATBlurButton: UIButton {
    //MARK:- Properties
    //MARK:- Private
    private var blurView: UIVisualEffectView?
    
    //MARK:- Public
    var isCircular: Bool = true {
        didSet {
            self.makeCircle()
        }
    }
    
    var borderWidth: CGFloat = 2.0 {
        didSet {
            self.updateBorder()
        }
    }
    
    var borderColor: UIColor = .white {
        didSet {
            self.updateBorder()
        }
    }
    
    var blurStyle: UIBlurEffect.Style = .dark {
        didSet {
            self.removeBlurEffect()
            self.updateBlurEffect()
        }
    }
    
    var blurColor: UIColor = .white {
        didSet {
            self.updateBlurEffect()
        }
    }
    
    var blurAlpha: CGFloat = 1.0 {
        didSet {
            self.updateBlurEffect()
        }
    }
    
    var shouldShowBlurView: Bool = true {
        didSet {
            self.removeBlurEffect()
            if shouldShowBlurView {
               self.updateBlurEffect()
            }
        }
    }
    
    //MARK:- Life Cycle
    //MARK:-
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let bv = self.blurView {
            self.sendSubviewToBack(bv)
        }
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetup() {
        
        self.updateBlurEffect()
        self.makeCircle()
        self.updateBorder()
    }
    
    private func updateBlurEffect() {
        
        if let blrV = self.blurView {
            blrV.frame = self.bounds
        }
        else {
            let bv = self.getBlurView(style: self.blurStyle)
            bv.isUserInteractionEnabled = false
            self.blurView = bv
            
            self.insertSubview(bv, at: 0)
        }
        
        self.blurView?.alpha = self.blurAlpha
        self.blurView?.backgroundColor = self.blurColor
    }
    
    private func removeBlurEffect() {
        self.blurView?.removeFromSuperview()
        self.blurView = nil
    }
    
    private func makeCircle() {
        self.cornerradius = self.isCircular ? (self.width / 2.0) : 0.0
    }
    
    private func updateBorder() {
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.borderWidth = self.borderWidth
    }
    
    //MARK:- Public
}


extension CALayer {
    @objc func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        x: CGFloat = 0,
        y: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
