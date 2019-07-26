//
//  PKCategoryButton.swift
//  AERTRIP
//
//  Created by apple on 26/07/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class PKCategoryButton: UIButton {
    
    //Mark:- Properties
    //MARK:- Private
    private var badgeLabel: UILabel = UILabel()
    
    private var _selectedFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    private var _normalFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    private var _highlightedFont: UIFont = UIFont.systemFont(ofSize: 15.0)
    
    //MARK:- Public
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
    
    var badgeCount: Int = 0 {
        didSet {
            updateBadgeCount()
        }
    }
    
    //Mark:- Life Cycle
    //MARK:-
    init() {
        super.init(frame: CGRect.zero)
        
        self.initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialSetup()
    }
    
    
    //Mark:- Methods
    //MARK:- Private
    private func initialSetup() {
        setupForBadge()
    }
    
    private func setupForBadge() {
        badgeLabel.isHidden = true
        badgeLabel.frame = CGRect(x: 0.0, y: 0.0, width: 4.0, height: 4.0)
        badgeLabel.backgroundColor = AppColors.themeGreen
        badgeLabel.layer.cornerRadius = badgeLabel.frame.size.height / 2.0
        badgeLabel.layer.masksToBounds = true
        
        addSubview(badgeLabel)
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
    
    //MARK:- Public
    func setTitleFont(font: UIFont, for state: UIControl.State) {
        if state == .normal {
            _normalFont = font
        }
        else if state == .highlighted {
            _highlightedFont = font
        }
        else {
            _selectedFont = font
        }
    }
    
    func updateBadgeCount() {
        let textWidth = (titleLabel?.text ?? "A").sizeCount(withFont: titleLabel?.font ?? _normalFont, bundingSize: frame.size).width
        let extraWidthSpace = (frame.size.width - textWidth) / 2.0
        
        let extraHeightSpace = (frame.size.height - (titleLabel?.font ?? _normalFont).lineHeight) / 2.0
        
        badgeLabel.frame.origin.x = textWidth + extraWidthSpace + 2.0
        badgeLabel.frame.origin.y = extraHeightSpace //- badgeLabel.frame.size.height
        badgeLabel.isHidden = badgeCount == 0
    }
}
