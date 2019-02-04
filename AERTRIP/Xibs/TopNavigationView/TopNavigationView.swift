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

@IBDesignable
class TopNavigationView: UIView {
    
    //MARK:- Properties
    //MARK:- Public
    weak var delegate: TopNavigationViewDelegate?
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var firstRightButton: UIButton!
    @IBOutlet weak var secondRightButton: UIButton!
    @IBOutlet weak var titleLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTrailingConstraint: NSLayoutConstraint!
    
    
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
        
        self.configureNavBar(title: "")
    }
    
    private func updateTitleFrames() {
        
        let trail = (!self.firstRightButton.isHidden && !self.secondRightButton.isHidden) ? CGFloat(self.firstRightButton.width + self.secondRightButton.width) : CGFloat(self.leftButton.width)
        
        self.titleTrailingConstraint.constant = trail
        self.titleLeadingConstraint.constant = trail
    }
    
    //MARK:- Public
    func configureNavBar(title: String?, isLeftButton: Bool = true, isFirstRightButton: Bool = false, isSecondRightButton: Bool = false) {
        
        self.navTitleLabel.text = title
        
        self.leftButton.isHidden = !isLeftButton
        self.firstRightButton.isHidden = !isFirstRightButton
        self.secondRightButton.isHidden = !isSecondRightButton
        
        self.configureFirstRightButton(normalImage: nil, selectedImage: nil, normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil)
        self.configureSecondRightButton(normalImage: nil, selectedImage: nil, normalTitle: nil, selectedTitle: nil, normalColor: nil, selectedColor: nil)
    }
    
    func configureLeftButton(normalImage: UIImage? = nil, selectedImage: UIImage? = nil, normalTitle: String? = nil, selectedTitle: String? = nil, normalColor: UIColor? = nil, selectedColor: UIColor? = nil) {
        
        self.leftButton.setTitle(normalTitle, for: .normal)
        self.leftButton.setTitle(selectedTitle, for: .selected)
        
        self.leftButton.setTitleColor(normalColor, for: .normal)
        self.leftButton.setTitleColor(selectedColor, for: .selected)
        
        self.leftButton.setImage(normalImage, for: .normal)
        self.leftButton.setImage(selectedImage, for: .selected)
        
        self.updateTitleFrames()
    }
    
    func configureFirstRightButton(normalImage: UIImage? = nil, selectedImage: UIImage? = nil, normalTitle: String? = nil, selectedTitle: String? = nil, normalColor: UIColor? = nil, selectedColor: UIColor? = nil) {
        
        self.firstRightButton.setTitle(normalTitle, for: .normal)
        self.firstRightButton.setTitle(selectedTitle, for: .selected)
        
        self.firstRightButton.setTitleColor(normalColor, for: .normal)
        self.firstRightButton.setTitleColor(selectedColor, for: .selected)
        
        self.firstRightButton.setImage(normalImage, for: .normal)
        self.firstRightButton.setImage(selectedImage, for: .selected)
        
        self.updateTitleFrames()
    }
    
    func configureSecondRightButton(normalImage: UIImage? = nil, selectedImage: UIImage? = nil, normalTitle: String? = nil, selectedTitle: String? = nil, normalColor: UIColor? = nil, selectedColor: UIColor? = nil) {
        
        self.secondRightButton.setTitle(normalTitle, for: .normal)
        self.secondRightButton.setTitle(selectedTitle, for: .selected)
        
        self.secondRightButton.setTitleColor(normalColor, for: .normal)
        self.secondRightButton.setTitleColor(selectedColor, for: .selected)
        
        self.secondRightButton.setImage(normalImage, for: .normal)
        self.secondRightButton.setImage(selectedImage, for: .selected)
        
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
