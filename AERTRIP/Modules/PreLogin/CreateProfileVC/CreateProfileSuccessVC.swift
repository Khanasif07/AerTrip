//
//  CreateProfileSuccessVC.swift
//  AERTRIP
//
//  Created by Aakash Srivastav on 21/12/18.
//  Copyright © 2018 Pramod Kumar. All rights reserved.
//

import UIKit
import TransitionButton

class CreateProfileSuccessVC: BaseVC {
    
    //MARK:- Properties
    //MARK:-
    private var shadowLayer: CAShapeLayer!
    private var gradientLayer: CAGradientLayer!
    var shadowColor: UIColor = AppColors.themeGreen {
        didSet {
            self.successButton.layoutSubviews()
        }
    }
    var gradientColors: [UIColor] = [AppColors.shadowBlue, AppColors.themeGreen] {
        didSet {
            self.successButton.layoutSubviews()
        }
    }
    
    //MARK:- IBOutlets
    //MARK:-
    @IBOutlet weak var successButton: TransitionButton!
    
    //MARK:- ViewLifeCycle
    //MARK:-
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetups()
        self.addShadowLayer()
        self.addGradientLayer()
    }
    
    //MARK:- Methods
    //MARK:- Private
    private func initialSetups() {
        
    }
    
    //MARK:- Public
    private func addShadowLayer() {
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            self.successButton.layer.insertSublayer(shadowLayer, at: 0)
        }
        
        shadowLayer.path = UIBezierPath(roundedRect: self.successButton.bounds, cornerRadius: self.successButton.height/2).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowPath  = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 7.0)
        shadowLayer.shadowOpacity = 0.4
        shadowLayer.shadowRadius = 5.0
    }
    
    private func addGradientLayer() {
        if gradientLayer == nil {
            
            gradientLayer = CAGradientLayer()
            self.successButton.layer.insertSublayer(gradientLayer, at: 1)
        }
        
        gradientLayer.frame = self.successButton.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        gradientLayer.cornerRadius = self.successButton.height/2
        gradientLayer.masksToBounds = true
        gradientLayer.colors = gradientColors.map { (clr) -> CGColor in
            clr.cgColor
        }
    }
    //MARK:- Action
    @IBAction func successButtonAction(_ sender: TransitionButton) {
        
        UIView.animate(withDuration: 6, animations: {
            
            sender.startAnimation()
        }, completion: { animation in
            sender.stopAnimation(animationStyle: .expand, revertAfterDelay: 0, completion: {
                
                AppFlowManager.default.goToDashboard()
            })
        })
    }
}
