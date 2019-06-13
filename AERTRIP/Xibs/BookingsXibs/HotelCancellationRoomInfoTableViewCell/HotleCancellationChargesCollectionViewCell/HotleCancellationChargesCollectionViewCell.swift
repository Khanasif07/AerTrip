//
//  HotleCancellationChargesCollectionViewCell.swift
//  AERTRIP
//
//  Created by Admin on 05/06/19.
//  Copyright © 2019 Pramod Kumar. All rights reserved.
//

import UIKit

class HotleCancellationChargesCollectionViewCell: UICollectionViewCell {
    
    //MARK:- Variables
    //MARK:===========
    
    
    //MARK:- IBOutlets
    //MARK:===========
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var chargeNameLabel: UILabel!
    @IBOutlet weak var chargeAmountLabel: UILabel!
    
    //MARK:- LifeCycle
    //MARK:===========
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureUI()
    }
    
    //MARK:- Functions
    //MARK:===========
    private func configureUI() {
        //Font
        self.chargeNameLabel.font = AppFonts.Regular.withSize(16.0)
        self.chargeAmountLabel.font = AppFonts.Regular.withSize(16.0)
        
        //Colors
        self.chargeNameLabel.textColor = AppColors.themeGray40
        self.chargeAmountLabel.textColor = AppColors.themeGray40
    }
    
    internal func configureCell(chargeName: String, chargeAmount: String) {
        self.chargeNameLabel.text = chargeName
        self.chargeAmountLabel.text = chargeAmount
    }
    
}