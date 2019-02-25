//
//  UnderLineView.swift
//  BmoViewPager
//
//  Created by LEE ZHE YU on 2017/6/4.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit

@IBDesignable
class ATUnderLineView: UIView {
    @IBInspectable var strokeColor: UIColor = UIColor.black {
        didSet {
            self.layoutSubviews()
        }
    }
    @IBInspectable var lineWidth: CGFloat = 2.0 {
        didSet {
            self.layoutSubviews()
        }
    }
    
    //will use to add in superview
    public var margin = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)

    private var lineView = UIView()
    
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.clear
        
        self.addSubview(lineView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        lineView.frame = CGRect(x: 0.0, y: self.height - lineWidth, width: self.width, height: lineWidth)
        setup()
    } // "layoutSubviews" is best
    
    func setup() {
        
        self.lineView.backgroundColor = strokeColor
        self.lineView.roundCorners(corners: [.topLeft, .topRight], radius: 5.0)
    }
    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        guard let context = UIGraphicsGetCurrentContext() else {
//            return
//        }
//        strokeColor.setStroke()
//        context.setLineWidth(lineWidth)
//        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
//        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
//        context.strokePath()
//    }
}
