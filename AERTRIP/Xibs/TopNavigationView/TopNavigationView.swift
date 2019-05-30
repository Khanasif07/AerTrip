//
//  TopNavigationView.swift
//  Banani
//
//  Created by Appinventiv mac on 22/08/18.
//  Copyright © 2018 Appinventiv mac. All rights reserved.
//

import UIKit

protocol TopNavigationViewDelegate : class {
    func topNavBarLeftButtonAction(_ sender: UIButton)
    func topNavBarFirstRightButtonAction(_ sender: UIButton)
    func topNavBarSecondRightButtonAction(_ sender: UIButton)
}

extension TopNavigationViewDelegate {
    func topNavBarFirstRightButtonAction(_ sender: UIButton) { }
    func topNavBarSecondRightButtonAction(_ sender: UIButton) { }
}


class TopNavigationView: UIView {
    
    enum BackgroundType {
        case clear
        case blurMainView(isDark: Bool)
        case blurAnimatedView(isDark: Bool)
        case color(color: UIColor)
    }
    
    //MARK:- Properties
    //MARK:- Public
    weak var delegate: TopNavigationViewDelegate?

    var backgroundType: BackgroundType = BackgroundType.blurMainView(isDark: false) {
        didSet {
            self.setBackground()
        }
    }
    
    //MARK:- Private
    private var isHidingBackView: Bool = false
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var firstRightButton: UIButton!
    @IBOutlet weak var secondRightButton: UIButton!
    @IBOutlet weak var titleLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var dividerView: ATDividerView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var backViewHeightConstraint: NSLayoutConstraint!
    
    
    //MARK:- View Life Cycle
    //MARK:-
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.updateTitleFrames()
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetup() {
        
        Bundle.main.loadNibNamed("TopNavigationView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        self.navTitleLabel.font = AppFonts.SemiBold.withSize(18.0)
        
        self.configureNavBar(title: "")
    }
    
    private func setBackground() {
        
        switch self.backgroundType {
        case .clear:
            self.backgroundColor = UIColor.clear
            self.backView.backgroundColor = UIColor.clear
            
        case .color(let color):
            self.backgroundColor = color
            self.backView.backgroundColor = color
            
        case .blurMainView(let isDark):
            self.addBlurEffect(onView: self, isDark: isDark)
            self.addBlurEffect(onView: self.backView, isDark: isDark)
            
        case .blurAnimatedView(let isDark):
            self.removeBlur(fromView: self)
            self.addBlurEffect(onView: self.backView, isDark: isDark)
        }
    }
    
    private func removeBlur(fromView: UIView) {
        for vw in fromView.subviews {
            if vw.isKind(of: UIVisualEffectView.self) {
                vw.removeFromSuperview()
                break
            }
        }
    }
    
    private func addBlurEffect(onView: UIView, isDark: Bool) {
        onView.backgroundColor = AppColors.clear
        if let _ = onView.subviews.first as? UIVisualEffectView {
            //blur is already added
        }
        else {
            onView.insertSubview(getBlurView(forView: onView, isDark: isDark), at: 0)
        }
    }
    
    private func getBlurView(forView: UIView, isDark: Bool) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: isDark ? UIBlurEffect.Style.dark : UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = forView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }
    
    private func updateTitleFrames() {
        
        var trail: CGFloat = 10.0, lead: CGFloat = 10.0
        
        if !self.leftButton.isHidden {
            lead = CGFloat(self.leftButton.width)
        }
        
        if !self.firstRightButton.isHidden {
            trail = self.firstRightButton.width
        }
        if !self.secondRightButton.isHidden {
            trail += self.secondRightButton.width
        }

        self.titleTrailingConstraint.constant = max(trail, lead)
        self.titleLeadingConstraint.constant = max(trail, lead)
    }
    
    //MARK:- Public
    func animateBackView(isHidden: Bool, completion: ((Bool) -> Void)?) {
        guard !self.isHidingBackView else {return}
        self.isHidingBackView = true
        self.backView.isHidden = false

        completion?(true)
        UIView.animate(withDuration: AppConstants.kAnimationDuration, animations: {
            self.backViewHeightConstraint.constant = isHidden ? 0.0 : self.height
            self.backView.alpha = isHidden ? 0.0 : 1.0
            self.layoutIfNeeded()
        }) { (isDone) in
            self.isHidingBackView = false
            self.backView.isHidden = isHidden
        }
    }
    
    func configureNavBar(title: String?, isLeftButton: Bool = true, isFirstRightButton: Bool = false, isSecondRightButton: Bool = false, isDivider: Bool = true, backgroundType: BackgroundType = BackgroundType.blurMainView(isDark: false)) {
        
        self.navTitleLabel.text = title
        
        self.leftButton.isHidden = !isLeftButton
        self.firstRightButton.isHidden = !isFirstRightButton
        self.secondRightButton.isHidden = !isSecondRightButton
        self.dividerView.isHidden = !isDivider
        self.backView.isHidden = true
        self.backgroundType = backgroundType
        
        self.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil)
        self.configureSecondRightButton(normalImage: nil, selectedImage: nil, normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil)
    }
    
    func configureLeftButton(normalImage: UIImage? = nil, selectedImage: UIImage? = nil, normalTitle: String? = nil, selectedTitle: String? = nil, normalColor: UIColor? = nil, selectedColor: UIColor? = nil, font: UIFont = AppFonts.Regular.withSize(18.0)) {
        
        self.leftButton.setTitle(normalTitle, for: .normal)
        self.leftButton.setTitle(selectedTitle, for: .selected)
        
        self.leftButton.setTitleColor(normalColor, for: .normal)
        self.leftButton.setTitleColor(selectedColor, for: .selected)
        
        self.leftButton.setImage(normalImage, for: .normal)
        self.leftButton.setImage(selectedImage, for: .selected)
        
        self.leftButton.titleLabel?.font = font
        
        self.backView.isHidden = true
        self.backView.alpha = 0.0
        
        self.updateTitleFrames()
    }
    
    func configureFirstRightButton(normalImage: UIImage? = nil, selectedImage: UIImage? = nil, normalTitle: String? = nil, selectedTitle: String? = nil, normalColor: UIColor? = nil, selectedColor: UIColor? = nil, font: UIFont = AppFonts.Regular.withSize(18.0)) {
        
        self.firstRightButton.setTitle(normalTitle, for: .normal)
        self.firstRightButton.setTitle(selectedTitle, for: .selected)
        
        self.firstRightButton.setTitleColor(normalColor, for: .normal)
        self.firstRightButton.setTitleColor(selectedColor, for: .selected)
        
        self.firstRightButton.setImage(normalImage, for: .normal)
        self.firstRightButton.setImage(selectedImage, for: .selected)
        
        self.firstRightButton.titleLabel?.font = font
        
        self.updateTitleFrames()
    }
    
    func configureSecondRightButton(normalImage: UIImage? = nil, selectedImage: UIImage? = nil, normalTitle: String? = nil, selectedTitle: String? = nil, normalColor: UIColor? = nil, selectedColor: UIColor? = nil, font: UIFont = AppFonts.Regular.withSize(18.0)) {
        
        self.secondRightButton.setTitle(normalTitle, for: .normal)
        self.secondRightButton.setTitle(selectedTitle, for: .selected)
        
        self.secondRightButton.setTitleColor(normalColor, for: .normal)
        self.secondRightButton.setTitleColor(selectedColor, for: .selected)
        
        self.secondRightButton.setImage(normalImage, for: .normal)
        self.secondRightButton.setImage(selectedImage, for: .selected)
        
        self.secondRightButton.titleLabel?.font = font
        
        self.updateTitleFrames()
    }
    
    
    //MARK:- Actions
    @IBAction private func leftBtnTapped(_ sender: UIButton) {
        self.delegate?.topNavBarLeftButtonAction(sender)
    }
    
    @IBAction private func right1BtnTapped(_ sender: UIButton) {
        self.delegate?.topNavBarFirstRightButtonAction(sender)
    }
    
    @IBAction private func right2BtnTapped(_ sender: UIButton) {
        self.delegate?.topNavBarSecondRightButtonAction(sender)
    }
}
