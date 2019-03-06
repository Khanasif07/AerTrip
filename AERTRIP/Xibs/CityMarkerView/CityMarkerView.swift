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
        }
    }
    
    ///ConfigureUI
    private func configureUI() {
        
        backgroundView.backgroundColor = AppColors.themeOrange.withAlphaComponent(0.1)
        dotView.backgroundColor = AppColors.themeOrange
        
        backgroundView.cornerRadius = backgroundView.height / 2.0
        dotView.cornerRadius = dotView.height / 2.0
    }
}
