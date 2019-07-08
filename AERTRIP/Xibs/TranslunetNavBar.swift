//
//  TranslunetNavBar.swift
//  AERTRIP
//
//  Created by Admin on 20/02/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class TranslunetNavBar: UIView {

    //Mark:- Variables
    //================
    
    
    //Mark:- IBOutlets
    //================
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //Mark:- Functions
    //================
    private func viewSetUp() {
        
    }
    
    private func configUI() {
        let attributedString = NSMutableAttributedString()
        let blackAttribute = [NSAttributedString.Key.font: AppFonts.SemiBold.withSize(22.0), NSAttributedString.Key.foregroundColor: AppColors.themeBlack] as [NSAttributedString.Key : Any]
        let greyAttributedString = NSAttributedString(string: "title", attributes: blackAttribute)
        attributedString.append(greyAttributedString)
    }
    
    
}
