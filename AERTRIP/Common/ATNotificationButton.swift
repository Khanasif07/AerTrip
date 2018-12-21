//
//  ATNotificationButton.swift
//  Pramod Kumar
//
//  Created by Admin on 06/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit

class ATNotificationButton: UIButton {
    
    //MARK:- Properties
    //MARK:- Public
//    var cornerRadius: CGFloat = 0.0 {
//        didSet {
//            self.addBackImageLayer()
//        }
//    }
    
    var cornerRadi: Double {
        get {
            return Double(self.imageView?.layer.cornerRadius ?? 0.0)
        }
        set {
            self.imageView?.layer.cornerRadius = CGFloat(newValue)
            self.imageView?.layer.masksToBounds = true
        }
    }
    
    var bedgeLabel: ATBedgeLabel = ATBedgeLabel()
    var bedgeCount: Int {
        return self.bedgeLabel.count
    }
    
    //MARK:- Private

    
    //MARK:- View Life Cycle
    //MARK:-
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initialSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialSetup()
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetup() {
        //default setup
        self.defaultSetup()
    }
    
    private func defaultSetup() {
        let bedgeHeight = self.frame.size.height/2.0
        self.bedgeLabel.frame = CGRect(x: self.frame.size.width/2.0, y: -(bedgeHeight)/2.0, width: bedgeHeight, height: bedgeHeight)
        self.bedgeLabel.cornerRadi = Double(bedgeHeight / 2.0)
        self.addSubview(self.bedgeLabel)
    }
    
    //MARK:- Public
    func set(count: Int, animated: Bool = true) {
        self.bedgeLabel.set(count: count, animated: animated)
    }
}
