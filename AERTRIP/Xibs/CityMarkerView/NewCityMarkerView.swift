//
//  NewCityMarkerView.swift
//  AERTRIP
//
//  Created by Apple  on 26.02.20.
//  Copyright © 2020 Pramod Kumar. All rights reserved.
//

import UIKit

class NewCityMarkerView: UIView {
    
    //Mark:- IBOutlets
    //================
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var dotHeightConstraint: NSLayoutConstraint!
    
    private var pulsAnimation = PKPulseAnimation()
    private var shouldAddRippel: Bool = false
    //Mark:- LifeCycle
    //================
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(frame: CGRect, shouldAddRippel: Bool) {
        super.init(frame: frame)
        
        self.shouldAddRippel = shouldAddRippel
        self.initialSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    
    //Mark:- PrivateFunctions
    //=======================
    //.InitialSetUp
    func initialSetUp() {
        self.setNeedsLayout()
        configureUI()
    }
    
   
    
    ///ConfigureUI
    private func configureUI() {
        backgroundView.backgroundColor = shouldAddRippel ? AppColors.clear : AppColors.themeOrange.withAlphaComponent(0.1)//AppColors.themeOrange.withAlphaComponent(0.1)
        dotView.backgroundColor = AppColors.themeOrange
        backgroundView.cornerRadius = 31.0
        dotView.cornerRadius = 6.5
    }
}
