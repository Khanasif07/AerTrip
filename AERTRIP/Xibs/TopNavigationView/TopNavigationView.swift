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
    
    //MARK:- Properties
    //MARK:- Public
    weak var delegate: TopNavigationViewDelegate?
    
    var shouldAddBlurEffect: Bool = false {
        didSet {
            self.addBlurEffect()
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
        
        //add blur on backView
        self.addBlurEffect()
        
        self.configureNavBar(title: "")
    }
    
    private func addBlurEffect() {
        guard shouldAddBlurEffect else {return}
        if let backClr = self.backgroundColor, backClr != AppColors.clear {
            self.insertSubview(getBlurView(forView: self), at: 0)
            self.backgroundColor = AppColors.clear
        }
        
        self.backView.addSubview(getBlurView(forView: self.backView))
        self.backView.backgroundColor = AppColors.clear
    }
    
    private func getBlurView(forView: UIView) -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = forView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }
    
    private func updateTitleFrames() {
        
        let trail = (!self.firstRightButton.isHidden && !self.secondRightButton.isHidden) ? CGFloat(self.firstRightButton.width + self.secondRightButton.width) : CGFloat(self.leftButton.width)
        
        self.titleTrailingConstraint.constant = trail
        self.titleLeadingConstraint.constant = trail
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
    
    func configureNavBar(title: String?, isLeftButton: Bool = true, isFirstRightButton: Bool = false, isSecondRightButton: Bool = false, isDivider: Bool = true) {
        
        self.navTitleLabel.text = title
        
        self.leftButton.isHidden = !isLeftButton
        self.firstRightButton.isHidden = !isFirstRightButton
        self.secondRightButton.isHidden = !isSecondRightButton
        self.dividerView.isHidden = !isDivider
        self.backView.isHidden = true
        
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
