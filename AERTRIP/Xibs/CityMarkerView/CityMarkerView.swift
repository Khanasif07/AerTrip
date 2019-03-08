//
//  CheckInCheckOutView.swift
//  AERTRIP
//
//  Created by RAJAN SINGH on 21/01/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class CityMarkerView: UIView {
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var dotView: UIView!
    
    private var pulsAnimation = PKPulseAnimation()
    //Mark:- LifeCycle
    //================
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialSetUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        self.pulsAnimation.position = CGPoint(x: self.backgroundView.frame.width/2.0, y: self.backgroundView.frame.height/2.0)
    }

    
    //Mark:- PrivateFunctions
    //=======================
    //.InitialSetUp
    private func initialSetUp() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CityMarkerView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        delay(seconds: 0.2) { [weak self] in
            guard let sSelf = self else {return}
            sSelf.configureUI()
            sSelf.addRippel()
        }
    }
    
    private func addRippel() {
        self.pulsAnimation.numPulse = 3
        self.pulsAnimation.radius = backgroundView.height
        self.pulsAnimation.currentAnimation = .opacity
        self.pulsAnimation.backgroundColor = AppColors.themeOrange.cgColor
        self.backgroundView.layer.insertSublayer(self.pulsAnimation, below: self.dotView.layer)
        self.pulsAnimation.position = CGPoint(x: self.backgroundView.frame.width/2.0, y: self.backgroundView.frame.height/2.0)
        self.pulsAnimation.start()
    }
    
    ///ConfigureUI
    private func configureUI() {
        
        backgroundView.backgroundColor = AppColors.clear//AppColors.themeOrange.withAlphaComponent(0.1)
        dotView.backgroundColor = AppColors.themeOrange
        
        backgroundView.cornerRadius = backgroundView.height / 2.0
        dotView.cornerRadius = dotView.height / 2.0
    }
}
