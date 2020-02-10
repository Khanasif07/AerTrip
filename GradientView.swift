//
//  GradientView.swift
//  AERTRIP
//
//  Created by Nimish Sharma on 07/02/20.
//  Copyright © 2020 Appinventiv Technologies. All rights reserved.

import UIKit

class GradientView: UIView {
    
    var colors: [UIColor] = [UIColor.black.withAlphaComponent(0),
                             UIColor.black.withAlphaComponent(0.1),
                             UIColor.white.withAlphaComponent(0.4),
                             UIColor.white.withAlphaComponent(0.9),
                             UIColor.white] { didSet { self.setNeedsDisplay()} }
    
    private var gradientLayer: CAGradientLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.createGradientLayer()
    }
    
    override var bounds: CGRect {
        didSet {
            self.createGradientLayer()
        }
    }
    
    

    
    ///draw gradient on the top layer
    func createGradientLayer() {
        for layer in layer.sublayers ?? [] {
            if layer is CAGradientLayer {
                layer.removeFromSuperlayer()
            }
        }
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map({$0.cgColor})
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        self.layer.addSublayer(gradientLayer)
    }
}

