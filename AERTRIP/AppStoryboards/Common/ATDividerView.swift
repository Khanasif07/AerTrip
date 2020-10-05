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
    private var isFrameUpdated = false
    private let dividerView = UIView()
    
    //MARK:- Public
    var defaultHeight: CGFloat = 0.5 {
        didSet {
            self.updatedFrame()
        }
    }
    
    var defaultBackgroundColor: UIColor = AppColors.divider.color {
        didSet {
            self.updatedBackgroundColor()
        }
    }
    
    override open var backgroundColor: UIColor? {
        willSet {
            if let color = newValue, color != .clear {
                self.backgroundColor = .clear
            }
        }
    }
    
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetup() {
        self.addSubview(dividerView)
        self.updatedFrame()
        self.updatedBackgroundColor()
        self.dividerView.clipsToBounds = true
    }
    
    private func updatedBackgroundColor() {
        self.backgroundColor = .clear
        dividerView.backgroundColor = AppColors.themeRed //defaultBackgroundColor
    }
    
    private func updatedFrame() {
        //self.translatesAutoresizingMaskIntoConstraints = true
//        let height = (1.0 / self.contentScaleFactor)
        dividerView.frame = CGRect(x: 0, y: 0, width: self.width, height: defaultHeight)
    }
}

open class ATVerticalDividerView: UIView {
    
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
    private var isFrameUpdated = false
    private let dividerView = UIView()
    
    //MARK:- Public
    var defaultWidth: CGFloat = 0.5 {
        didSet {
            self.updatedFrame()
        }
    }
    
    var defaultBackgroundColor: UIColor = AppColors.divider.color {
        didSet {
            self.updatedBackgroundColor()
        }
    }
    
    override open var backgroundColor: UIColor? {
        willSet {
            if let color = newValue, color != .clear {
                self.backgroundColor = .clear
            }
        }
    }
    
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetup() {
        self.addSubview(dividerView)
        self.updatedFrame()
        self.updatedBackgroundColor()
        self.dividerView.clipsToBounds = true
    }
    
    private func updatedBackgroundColor() {
        self.backgroundColor = .clear
        dividerView.backgroundColor = AppColors.themeRed //defaultBackgroundColor
    }
    
    private func updatedFrame() {
        //self.translatesAutoresizingMaskIntoConstraints = true
//        let height = (1.0 / self.contentScaleFactor)
        dividerView.frame = CGRect(x: 0, y: 0, width: self.defaultWidth, height: self.height)
    }
}
