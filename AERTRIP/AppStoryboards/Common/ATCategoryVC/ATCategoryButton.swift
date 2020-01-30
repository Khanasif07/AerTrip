//
//  ATCategoryButton.swift
//  AERTRIP
//
//  Created by Admin on 28/03/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ATCategoryButton: UIButton {

    //Mark:- Properties
    //MARK:- Private
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
        super.tintColor = .clear
        self.tintColor = .clear
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
}
