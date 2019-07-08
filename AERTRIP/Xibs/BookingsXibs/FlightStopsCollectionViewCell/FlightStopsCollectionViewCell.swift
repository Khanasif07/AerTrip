//
//  FlightStopsCollectionViewCell.swift
//  AERTRIP
//
//  Created by Admin on 01/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class FlightStopsCollectionViewCell: UICollectionViewCell {
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dotView: UIView!
    
    //MARK:- LifeCycle
    //MARK:===========
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    //MARK:- Functions
    //MARK:===========
    private func configureUI() {
        self.dotView.makeCircular()
        self.dotView.backgroundColor = AppColors.themeGreen
    }
}
