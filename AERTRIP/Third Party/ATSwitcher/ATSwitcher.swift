//
//  ATSwitcher.swift
//  SwitcherExample
//
//  Created by apple on 19/02/19.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

protocol ATSwitcherChangeValueDelegate: class {
    func switcherDidChangeValue(switcher: ATSwitcher,value: Bool)
}

class ATSwitcher: UIControl {
    
    weak var delegate: ATSwitcherChangeValueDelegate?
      
    public var onTintColor = AppColors.themeRed {
        didSet {
            self.setupUI()
        }
    }
    public var offTintColor = UIColor.white {
        didSet {
            self.setupUI()
        }
    }
//    public override var cornerRadius: CGFloat = 0.5 {
//        didSet {
//            self.layoutSubviews()
//        }
//    }
    public var thumbTintColor = UIColor.white {
        didSet {
            self.thumbView.backgroundColor = self.thumbTintColor
        }
    }
    

    public var thumbCornerRadius: CGFloat = 0.5 {
        didSet {
            self.layoutSubviews()
        }
    }

    public var thumbSize = CGSize.zero {
        didSet {
            self.layoutSubviews()
        }
    }
    public var padding: CGFloat = 1.0 {
        didSet {
            self.layoutSubviews()
        }
    }

    public var isOn = false {
        didSet {
            self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
            setPinImage()
            self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
            
        }
    }
    public var animationDuration: Double = 0.5
    
    fileprivate var thumbView = UIView(frame: CGRect.zero)
    fileprivate var thumbImageView = UIImageView(frame: CGRect.zero)
    fileprivate var onPoint = CGPoint.zero
    fileprivate var offPoint = CGPoint.zero
    fileprivate var isAnimating = false
    
    private func clear() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    
    func setupUI() {
        self.clear()
        self.clipsToBounds = false
        
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 4)
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
      
        self.thumbView.backgroundColor = .white
        self.thumbView.isUserInteractionEnabled = false
        self.addSubview(self.thumbView)
        
        setPinImage()
//        self.thumbImageView.image = self.isOn ? UIImage(named:"pushpin") :  UIImage(named:"pushpin-gray")
        self.thumbImageView.frame = CGRect(x: 0 , y: 0 , width: 28.0, height: 28.0)
        self.thumbView.addSubview(self.thumbImageView)
        self.thumbView.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        self.thumbView.layer.borderWidth = 0.5
        
        self.thumbView.layer.shadowOffset = CGSize(width: 0.0, height: 4)
        self.thumbView.layer.shadowRadius = 4.0
        self.thumbView.layer.shadowOpacity = 1.0
        self.thumbView.layer.shadowColor = UIColor.black.withAlphaComponent(0.15).cgColor
        
    }
    
    private func setPinImage() {
        if self.isOn {
            self.thumbImageView.image = #imageLiteral(resourceName: "switch_fav_on")
        } else {
            self.thumbImageView.image = #imageLiteral(resourceName: "switch_fav_on").maskWithColor(color: UIColor(displayP3Red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1))
        }
        self.thumbImageView.contentMode = .center
        //        self.thumbImageView.image = self.isOn ? UIImage(named:"pushpin") :  UIImage(named:"pushpin-gray")
    }
    
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if !self.isAnimating {
            self.layer.cornerRadius = 15.5
            self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
            
            
            // thumb managment
            
            let thumbSize =  CGSize(width:28.0 , height: 28.0)
            let yPostition = CGFloat(1.5)
            
            self.onPoint = CGPoint(x: self.bounds.size.width - thumbSize.width - self.padding, y: yPostition)
            self.offPoint = CGPoint(x: self.padding, y: yPostition)
            
            self.thumbView.frame = CGRect(origin: self.isOn ? self.onPoint : self.offPoint, size: thumbSize)
            
            self.thumbView.layer.cornerRadius = thumbSize.height * self.thumbCornerRadius
            
        }
        
    }
    
    private func animate() {
        self.isAnimating = true
        UIView.animate(withDuration: self.animationDuration, delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5, options: [UIView.AnimationOptions.curveEaseOut,
                                                             UIView.AnimationOptions.beginFromCurrentState], animations: {
                                                                self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
                                                                
                                                                self.setPinImage()
                                                                self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
        }, completion: { _ in
            self.isAnimating = false
            self.sendActions(for: UIControl.Event.valueChanged)
        })
    }
    
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        self.isOn = !self.isOn
        self.animate()
        self.delegate?.switcherDidChangeValue(switcher: self, value: self.isOn)
        return true
    }

}

/*
class ATSwitcher: UIView {

    var button: UIButton!
    weak var delegate: ATSwitcherChangeValueDelegate?
    
    @IBInspectable var on: Bool = false
    
    @IBInspectable var originalImage:UIImage?{
        didSet {
            button.setImage(originalImage, for: .normal)
        }
    }
    
    @IBInspectable var selectedImage:UIImage?{
        didSet {
            button.setImage(selectedImage, for: .selected)
        }
    }
    
    @IBInspectable var selectedColor:UIColor = UIColor.green {
        didSet {
            self.setMainBorderProperties()
        }
    }
    @IBInspectable var originalColor:UIColor = UIColor.gray {
        didSet {
            self.setMainBorderProperties()
        }
    }
    @IBInspectable var selectedBorderColor:UIColor = UIColor.clear {
        didSet {
            self.setMainBorderProperties()
        }
    }
    @IBInspectable var originalBorderColor:UIColor = UIColor.lightGray{
        didSet {
            self.setMainBorderProperties()
        }
    }
    @IBInspectable var selectedBorderWidth:CGFloat = 0.0{
        didSet {
            self.setMainBorderProperties()
        }
    }
    @IBInspectable var originalBorderWidth:CGFloat = 1.5{
        didSet {
            self.setMainBorderProperties()
        }
    }
    @IBInspectable var iconPadding:CGFloat = 3.0
    
    @IBInspectable var iconBorderWidth:CGFloat = 1.0 {
        didSet {
            button.layer.borderWidth = iconBorderWidth
        }
    }
    
    @IBInspectable var iconBorderColor:UIColor = UIColor.lightGray {
        didSet {
            button.layer.borderColor = iconBorderColor.cgColor
        }
    }
    
    var isBackgroundBlurry: Bool = false {
        didSet {
            self.updateBlurEffect()
        }
    }
    
    init(frame: CGRect, on: Bool) {
        super.init(frame: frame)
        self.on = on
        commonInit()
    }
    
    override func awakeFromNib() {
        commonInit()
    }
    
    private var blurView: UIVisualEffectView?
    
    private func commonInit() {
        button = UIButton(type: .custom)
        button.frame = self.imageButtonFrame
        self.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = true
        button.addTarget(self, action: #selector(switcherButtonTouch(_:)), for: UIControl.Event.touchUpInside)
        button.setImage(originalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        button.backgroundColor = originalColor
        
        //add a tap gesture on full switch button, so that it'll be easy to tap.
        button.isUserInteractionEnabled = false
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(switcherButtonTouch(_:)))
        self.addGestureRecognizer(tapGesture)
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowPath  = UIBezierPath(roundedRect: button.bounds, cornerRadius: button.bounds.height / 2).cgPath
        button.layer.shadowOffset = CGSize.zero//CGSize(width: 0.0, height: 1.0)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 4.0
        
        if on == true {
            self.backgroundColor = selectedColor
        } else {
            self.backgroundColor = originalColor
        }
        
        button.frame = self.imageButtonFrame
        animationSwitcherButton()
        
        self.setMainBorderProperties()
        self.updateBlurEffect()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
        self.clipsToBounds = true
        button.layer.cornerRadius = button.bounds.height / 2
    }
    
    private var imageButtonFrame: CGRect {
        let iconH = (self.frame.height - (iconPadding * 2.0))
        let switchWidth = (self.frame.width - (iconPadding * 2.0))
        return CGRect(x: iconPadding + (on ? (switchWidth - iconH) : 0.0 ), y: iconPadding, width: iconH, height: iconH)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func switcherButtonTouch(_ sender: UIGestureRecognizer) {
        on = !on
        animationSwitcherButton()
        delegate?.switcherDidChangeValue(switcher: self, value: on)
    }
    
    func setOn(isOn: Bool, animated: Bool = true, shouldNotify: Bool = true) {
        on = isOn
        animationSwitcherButton(animated: animated)
        if shouldNotify {
            delegate?.switcherDidChangeValue(switcher: self, value: on)
        }
    }
    
    private func setMainBorderProperties() {
        self.backgroundColor = self.on ? self.selectedColor : self.originalColor
        self.layer.borderColor = self.on ? self.selectedBorderColor.cgColor : self.originalBorderColor.cgColor
        self.layer.borderWidth = self.on ? self.selectedBorderWidth : self.originalBorderWidth
    }
    
    private func updateBlurEffect() {
        
        if let blrV = self.blurView {
            blrV.frame = self.bounds
        }
        else {
            let bv = self.getBlurView()
            self.blurView = bv
            
            self.insertSubview(bv, at: 0)
        }
        
        self.blurView?.alpha = 0.95
        self.blurView?.backgroundColor = AppColors.themeBlack.withAlphaComponent(0.02)
    }
    
    func animationSwitcherButton(animated: Bool = true) {
        button.backgroundColor = originalColor
        if on == true {
            UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                self.button.isSelected = true
                
                self.button.frame = self.imageButtonFrame
                
                self.setMainBorderProperties()
                
                self.layoutIfNeeded()
                }, completion: { (finish:Bool) -> Void in
            })
        } else {
            UIView.animate(withDuration: animated ? AppConstants.kAnimationDuration : 0.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                self.button.isSelected = false
                
                self.button.frame = self.imageButtonFrame
                
                self.setMainBorderProperties()

                self.layoutIfNeeded()
                }, completion: { (finish:Bool) -> Void in
            })
        }
    }
}
*/
