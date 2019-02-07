//
//  ATDividerView.swift
//  AERTRIP
//
//  Created by Admin on 21/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

open class ATDividerView: UIView {
    
    //MARK:- View Life Cycle
    //MARK:-
    init() {
        super.init(frame: CGRect.zero)
        self.initialSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetup()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.updatedFrame()
    }
    
    //MARK:- Properties
    //MARK:- Private
    
    //MARK:- Public
    var defaultHeight: CGFloat = 1.0 {
        didSet {
            self.updatedFrame()
        }
    }
    
    var defaultBackgroundColor: UIColor = AppColors.divider.color {
        didSet {
            self.updatedBackgroundColor()
        }
    }
    
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetup() {
        
        self.updatedFrame()
        self.updatedBackgroundColor()
    }
    
    private func updatedBackgroundColor() {
        self.backgroundColor = defaultBackgroundColor
    }
    
    private func updatedFrame() {
        self.frame = CGRect(x: self.x, y: self.y, width: self.width, height: defaultHeight)
    }
}
